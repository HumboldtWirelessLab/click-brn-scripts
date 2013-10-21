#include <cstdlib>
#include <cstdio>
#include <iostream>
#include <sstream>

using namespace std;

int main() {
  stringstream s;
  while(!feof(stdin)) {
    char akt;
    scanf("%c",&akt);
    if (akt=='.') {
      while (akt!=' '&&akt!='\n'&&!feof(stdin)) {
	scanf("%c",&akt);
      }
    }
    if (akt=='\n') {
      s << " -1";
    }
    s << akt;
  }
  while (!s.eof()) {
    bool stop=false;
    int akt;
    s >> akt;
    if (akt==-1) {
      printf("%d\n",-1);
      while (akt==-1) {
	s >> akt;
	if (s.eof()) {
	  stop=true;
	  break;
	}
      }
    }
    if(!stop) printf("%d ",akt);
  }
  return 0;
}