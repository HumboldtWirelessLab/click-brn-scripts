#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

nodes=input()
starttime=input()
duration=input()
intervall=input()

print("#TIME NODE(S)   DEVICE  MODE    ELEMENT HANDLER  VALUE")

for i in range(1,nodes+1):
	print(str(starttime+((i-1)*(duration+intervall))/1000)+"    sk"+str(i)+" DEV0    write   sf      add_flow sk"+str(i)+":eth FF-FF-FF-FF-FF-FF "+str(intervall)+" 100 0 "+str(duration)+" true")

print(str(starttime+(nodes*(duration+intervall))/1000)+"     FIRSTNODE DEV0    read   unicastsf stats")
print(str(starttime+(nodes*(duration+intervall))/1000)+"     LASTNODE  DEV0    read   unicastsf stats")
