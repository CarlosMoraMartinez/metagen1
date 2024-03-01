


for c in 01 05 1; do 
    for rl in 75 100 150; do 
        echo $c $rl; 
        cp run_samples_garnatxa_benchmark1.config 'run_samples_garnatxa_benchmark_c'$c'_rl'$rl.config; 
    done 
done
# now change parameters by hand

mkdir unif100 unif10 prop100 single50

for dd in prop100 unif10 single50 unif100; do 
    for i in $(ls *.config); do 
        echo $i; cp $i $dd/$(basename -s .config $i)'_'$dd.config; 
    done
done

cd unif100
sed -i "s/benchmark\/unif10/benchmark\/unif100/" *.config 

cd ../single50
sed -i "s/benchmark\/unif10/benchmark\/single50/" *.config 

cd ../prop100
sed -i "s/benchmark\/unif10/benchmark\/prop100/" *.config 
