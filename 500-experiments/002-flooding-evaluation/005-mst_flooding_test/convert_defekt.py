outstr=""
goout=True
while (True):
	tmp=int(raw_input())
	#try:
	#	tmp=input()
	#except:
	#	break
	print(tmp)
	if ((not goout) and tmp!=-1):
		goout=True
		print(outstr)
		outstr=""
	if (goout):
		outstr=outstr+str(tmp)+" "
	if (tmp==-1):
		goout=False
