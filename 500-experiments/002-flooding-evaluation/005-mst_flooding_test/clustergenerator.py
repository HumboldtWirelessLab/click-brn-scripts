#!/usr/bin/python
# -*- coding: iso-8859-15 -*-
import random
import math

asy=True
normal=True
fobj = open("position.asy", "w")

node_x=[]
node_y=[]

n=input("Anzahl der Cluster: ") #Anzahl der Cluster
rng=input("Clusterrange: ")
bdense=input("Dichte auf der Brücke: ")
bwiggle=input("Variation auf der Brücke: ")

nodes=[]
radius=[]

for i in range(0,n):
	nodes.append(input("Anzahl der Knoten in Cluster "+str(i)+": "))
	radius.append(input("Radius von Cluster "+str(i)+": "))

bridge1=[]
bridge2=[]

bc=input("Anzahl der Brücken: ")

cluster_x=[]
cluster_y=[]

#Knoten in Cluster anordnen

for i in range(0,n):
	ta=random.randint(0, rng)
	tb=random.randint(0, rng)
	cluster_x.append(ta)
	cluster_y.append(tb)
	for k in range(0,nodes[i]):
		tta=-1000000;
		ttb=-1000000;
		while (((tta-ta)*(tta-ta)+(ttb-tb)*(ttb-tb))>radius[i]*radius[i]):
			tta=random.randint(ta-radius[i], ta+radius[i])
			ttb=random.randint(tb-radius[i], tb+radius[i])
		node_x.append(tta)
		node_y.append(ttb)

#Brücken erstellen

for i in range(0,bc):
	ta=random.randint(0, n-1);
	tb=random.randint(0, n-1);
	while (ta==tb):
		tb=random.randint(0, n-1)
	bridge1.append(ta)
	bridge2.append(tb)
	dist_x=cluster_x[ta]-cluster_x[tb]
	dist_y=cluster_y[ta]-cluster_y[tb]
	dist=math.sqrt(dist_x*dist_x+dist_y*dist_y)
	nodes=int(dist/bdense)+1
	for k in range(1,nodes):
		cx=int(cluster_x[tb]+(dist_x)/nodes*k)
		cy=int(cluster_y[tb]+(dist_y)/nodes*k)
		cx=random.randint(cx-bwiggle,cx+bwiggle)
		cy=random.randint(cy-bwiggle,cy+bwiggle)
		node_x.append(cx)
		node_y.append(cy)

if (asy):
	fobj.write("import graph;\n")
	for i in range(0,len(node_x)):
		fobj.write("draw(Circle(("+str(node_x[i])+","+str(node_y[i])+"),5));\n");

if (normal):
	for i in range(0,len(node_x)):
		print("sk"+str(i+1)+" "+str(node_x[i])+" "+str(node_y[i]))
		
