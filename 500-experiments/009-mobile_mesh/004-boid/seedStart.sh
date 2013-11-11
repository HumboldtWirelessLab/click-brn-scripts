#!/bin/bash

seed=2;
seedInit=2;

for i in {1..5}
do
	seed=$(($i*2));
	
	sed -i s/"SEED=$seedInit"/"SEED=$seed"/g boid.des;
	start.sh "Seed$seed"
	sed -i s/"SEED=$seed"/"SEED=$seedInit"/g boid.des;
	
done

