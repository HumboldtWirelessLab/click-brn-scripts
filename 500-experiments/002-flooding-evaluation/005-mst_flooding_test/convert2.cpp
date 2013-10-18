#include <cstdlib>
#include <cstdio>
#include <iostream>

using namespace std;

int main () {
	int tmp;
	bool goout=true;
	cin >> tmp;
	//scanf("%d",&tmp);
	//printf("%d\n",EOF);
	while (!cin.eof()) {
		if (!goout&&tmp!=-1) {
			goout=true;
			printf("\n");
		}
		if (goout)
			printf("%d ",tmp);
		if (tmp==-1)
			goout=false;
		//scanf("%d",&tmp);
		cin >> tmp;
	}
	printf("\n");
}
