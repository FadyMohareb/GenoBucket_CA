#Working folder:
indir="/home/fady/GenoBucket/Pepper_C.annum/resources/contigs"
contigFasta="/home/fady/GenoBucket/Pepper_C.annum/resources/contigs/PGA.contigs.fa"
prefix-"PGA"
echo indexing genome ...
# First build fasta index (to extract contigs later)
/opt/bix/samtools/1.2/samtools faidx $contigFasta
echo 'done indexing (1 of 4)'

# Create Scaffold folders with contigs inside
#Old way: (Corentin)
#cut -f 1,6 S_lycopersicum_scaffolds_from_contigs.2.31.agp > LOOKUP_Contigs_TO_Scaffolds.txt
awk '{ print $1 "\t" $6 "\t" $2 "\t" $3 "\t"  $9}' PGA.agp > LOOKUP_Contigs_TO_Scaffolds.txt
awk '$2 ~ "^PGA" { print }' LOOKUP_Contigs_TO_Scaffolds.txt  > LOOKUP_Contigs_TO_Scaffolds.txt2
mv LOOKUP_Contigs_TO_Scaffolds.txt2 LOOKUP_Contigs_TO_Scaffolds.txt

echo 'done creating lookup tables (2 of 4)'
totalLines=$(awk '{ print $1; }' LOOKUP_Contigs_TO_Scaffolds.txt | wc -l)
echo $totalLines
i=1
while read line; do 

scaffold=$(echo "${line}" | awk '{ print $1; }'); 
contig=$(echo "${line}" | awk '{ print $2; }'); 
newContig=${contig}
scaffold=${scaffold}

echo processing contig no ${i} ID ${newContig} of total $totalLines contigs...

mkdir -p ${scaffold};
cd ${scaffold};
/opt/bix/samtools/1.2/samtools faidx $contigFasta ${contig} > $newContig.fa
awk '/^>/ {gsub(/.fa(sta)?$/,"",FILENAME);printf(">%s\n",FILENAME);next;} {print}' ${newContig}.fa >temp && mv temp ${newContig}.fa

echo "${line}" | awk '{ print $2 "\t" $3 "\t" $4 "\t" $5; }' > "${newContig}.meta"
#sed "s/$prefix//g" "${newContig}.meta" >temp && mv temp ${newContig}.meta
cd ../;
let "i=i+1"
done < LOOKUP_Contigs_TO_Scaffolds.txt
echo 'done creating contig subfolders (3 of 4)'



# Create Chr folders with Scaffolds inside
#old (Corentin):
#cut -f 1,6 S_lycopersicum_chromosomes_from_scaffolds.2.31.agp > LOOKUP_SCAFFOLD_TO_CHR.txt

#' $1 "\tID:" $6 "\tSTART:" $2 "\tSTOP:" $3 "\tORIENTATION:"  $9'
#awk '{ print $1 "\t" $6 "\t" $2 "\t" $3 "\t"  $9}' PGA.agp > LOOKUP_SCAFFOLD_TO_CHR.txt
#awk '$2 != 100 { print }' LOOKUP_SCAFFOLD_TO_CHR.txt  > LOOKUP_SCAFFOLD_TO_CHR.txt2
#mv LOOKUP_SCAFFOLD_TO_CHR.txt2 LOOKUP_SCAFFOLD_TO_CHR.txt

#for chr in $(cut -f 1 LOOKUP_SCAFFOLD_TO_CHR.txt | uniq); do mkdir ${chr}; done

#while read line; do 
#chr=$(echo "${line}" | awk '{ print $1; }'); 
#chr=${chr#"SL2.30"}
#scaffold=$(echo "${line}" | awk '{ print $2; }'); 
#scaffold=${scaffold#$prefix}
#mkdir -p ${chr}; 
#cd ${chr}; 
#mv ../${scaffold} ./; 
#echo "${line}" | awk '{ print $2 "\t" $3 "\t" $4 "\t" $5; }' > ./"${scaffold}.meta" 
#sed "s/$prefix//g" "${scaffold}.meta" >temp && mv temp ${scaffold}.meta
#cd ../; 
#done < LOOKUP_SCAFFOLD_TO_CHR.txt
#echo 'done creating chromosomes and scaffolds arrangements (4 of 4)'
#echo 'Happy assembly!!'

