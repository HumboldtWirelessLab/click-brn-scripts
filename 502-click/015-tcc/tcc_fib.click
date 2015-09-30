Idle()
-> tcc::TCC(DEBUG 2)
-> Discard;

Script(
  write tcc.add int fib int,
  write tcc.compile

  int fib(int n) {
    if (n <= 2) return 1;
    else return fib(n-1) + fib(n-2);
  }
  ,
  write tcc.call fib 1,
  read  tcc.result,
  write tcc.call fib 2,
  read  tcc.result,
  write tcc.call fib 3,
  read  tcc.result,
  write tcc.call fib 4,
  read  tcc.result,
  write tcc.call fib 5,
  read  tcc.result,
  write tcc.call fib 6,
  read  tcc.result,
  write tcc.call fib 7,
  read  tcc.result,
  wait 1,
  stop
);