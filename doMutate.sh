indir="/home/fady//GenoBucket/test_git/S_lycopersicum"
i=0		 
s=$(find $indir/ -name '*.fa'  | shuf -n 1000|sed 's/:.*//');
i=0
for j in $s; do
		echo "$i of 1000    mutating $j ..."
			python mutate.py $j  0.10 > temp.fa && mv temp.fa $j
let "i=i+1"
done
