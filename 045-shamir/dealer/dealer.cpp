#include "dealer.hh"
#include <iostream>
#include <openssl/rsa.h>
#include <openssl/bn.h>

#define e 65537
#define threshold 3
#define num_nodes 5
#define message 1337

using namespace std;

BN_CTX *bn_ctx;

Poly::Poly(unsigned int deg, const BIGNUM *mod):deg(deg), modulus(NULL){

    coeffs = new BIGNUM *[deg];
    modulus = BN_dup(mod);
    for (unsigned int i=0; i<=deg; i++) {
        coeffs[i] = BN_new();
        BN_rand_range(coeffs[i], modulus);
    }
    return;
}

Poly::~Poly() {
    BN_free(modulus);
    for (unsigned int i=0; i<deg; i++) {
        BN_free(coeffs[i]);
    }
    delete[] coeffs;
}

BIGNUM * Poly::eval(unsigned long x) {
    BN_CTX *bn_ctx = NULL;
    BIGNUM *res = NULL;
    BIGNUM *xval = NULL;
    BIGNUM *tmp = NULL;
    BIGNUM *tmp2 = NULL;

    bn_ctx = BN_CTX_new();
    BN_CTX_init(bn_ctx);
    res = BN_new();
    xval = BN_new();
    BN_zero(res);
    BN_set_word(xval, x);
    tmp = BN_new();
    tmp2 = BN_new();

    if (!tmp || !bn_ctx || !res || !xval)
        cout << "Fuck" << endl; //FIXME: Throw an Exception

    /* For all coeffiecients a compute a*x^i */
    for (unsigned int i=0; i<=deg; i++) {
        BN_set_word(tmp, i);
        BN_mod_exp(tmp2, xval, tmp, modulus, bn_ctx);
        BN_mod_mul(tmp, coeffs[i], tmp2, modulus, bn_ctx);
        BN_mod_add(tmp2, res, tmp, modulus, bn_ctx);
        BN_swap(tmp2, res);
    }

    BN_CTX_free(bn_ctx);
    return res;
}

void Poly::set_coeff(unsigned int i, const BIGNUM *coeff) {
    if (i > deg)
        return;

    BN_free(coeffs[i]);
    coeffs[i] = BN_dup(coeff);

    return;
}

void Poly::print() {

    for (unsigned int i=0; i<=deg; i++) {
        cout << BN_bn2hex(coeffs[i]) << " x^" << i;
        if (i != deg)
            cout << " + ";
        else
            cout << " mod " << BN_bn2hex(modulus);
    }

    cout << endl;
}

Share::Share(unsigned int _id, const BIGNUM *_value, const BIGNUM *_modulus): id(_id) {
    value = BN_dup(_value);
    modulus = BN_dup(_modulus);
}

Share::~Share() {
    BN_free(value);
    BN_free(modulus);
}

int main() {
    BIGNUM *tmp = NULL;
    BIGNUM *p = NULL, *q = NULL, *N = NULL, *e_value = NULL, *d = NULL;
    BIGNUM *r0=NULL,*r1=NULL,*r2=NULL;

    bn_ctx = BN_CTX_new();
    BN_CTX_init(bn_ctx);
    BN_CTX_start(bn_ctx);

    /* Generate RSA key using safe primes */
    p = BN_CTX_get(bn_ctx);
    BN_generate_prime_ex(p, 1024, 1, NULL, NULL, NULL);
    q = BN_CTX_get(bn_ctx);
    BN_generate_prime_ex(q, 1024, 1, NULL, NULL, NULL);
    N = BN_CTX_get(bn_ctx);
    BN_mul(N, p, q, bn_ctx);
    r0 = BN_CTX_get(bn_ctx);
    r1 = BN_CTX_get(bn_ctx);
    r2 = BN_CTX_get(bn_ctx);
    e_value = BN_new();
    d = BN_CTX_get(bn_ctx);
    BN_set_word(e_value, e);

    /* calculate d */
    BN_sub(r1,p,BN_value_one());    /* p-1 */
    BN_sub(r2,q,BN_value_one());    /* q-1 */
    BN_mul(r0,r1,r2,bn_ctx);   /* (p-1)(q-1) */
    BN_mod_inverse(d,e_value,N,bn_ctx);  /* d */

    Poly *poly = new Poly(threshold-1, N);

    /* Extract secret exponent */
    poly->set_coeff(0, d);

    /* Output modulus and public exponent */
    cout << BN_bn2hex(N) << endl;
    cout << BN_bn2hex(e_value) << endl;

    for (int i=0; i<num_nodes; i++) {
        tmp = poly->eval(i + 1);
        /* Output secret share */
        cout << BN_bn2hex(tmp) << endl;
    }

    delete poly;
    BN_CTX_end(bn_ctx);     
    BN_CTX_free(bn_ctx);
    return 0;
}
