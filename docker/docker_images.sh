sudo docker pull nanozoo/bowtie2:latest
sudo docker pull phinguyen2000/trimmomatic-v0.39:v0.2.0
sudo docker pull staphb/kraken2:latest
sudo docker pull staphb/bracken:latest
sudo docker pull nanozoo/krakentools:1.2--13d5ba5
sudo docker pull staphb/fastqc:latest
#sudo docker pull bytesco/pigz:latest # Doesnt work
sudo docker pull nsheff/pigz:latest
sudo docker pull staphb/samtools:latest
sudo docker pull staphb/seqkit:latest
sudo docker pull nanozoo/krona:latest
sudo docker pull staphb/multiqc:latest
sudo docker pull staphb/trimmomatic:latest
sudo docker pull staphb/samtools:latest
sudo docker pull staphb/spades:latest
sudo docker pull nanozoo/megahit:latest
sudo docker pull staphb/quast:latest
sudo docker pull john2117/metabat2:latest
sudo docker pull staphb/metaphlan:latest
# Install metaphlan database in permanent location:
# sudo docker run -ti --mount type=bind,source=/home,target=/home --entrypoint /bin/bash staphb/metaphlan
# metaphlan --install --bowtie2db /home/ccarlos/data/resources/metaphlan