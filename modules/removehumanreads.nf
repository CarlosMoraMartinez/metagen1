process removeHumanReads{
  label 'mg05_filtreads'
  conda params.removeHumanReads.conda
  cpus params.resources.removeHumanReads.cpus
  memory params.resources.removeHumanReads.mem
  queue params.resources.removeHumanReads.queue
  errorStrategy { task.exitStatus in 1..2 ? 'retry' : 'ignore' }
  maxRetries 10
  publishDir "$results_dir/mg05_filtreads", mode: 'symlink'
  input:
  tuple(val(illumina_id), path(bam), path(bai), val(fastq))
  
  output:
  tuple(val(illumina_id), path ('*.readids.txt'), path('*.filt.fastq.gz'))
  

  shell:
  '''
  # 1) Get the IDs of reads in bam file (reads mapping human)
  readsfile=$(basename -s .bam !{bam}).readids.txt
  samtools view !{bam} | cut -f 1 | sort -u > $readsfile

  # 2) Generate fastq 1 without human reads using seqkit, compress with pigz (parallel gzip)
  oname1=$(basename -s .fastq.gz !{fastq[0]}).filt.fastq.gz
  seqkit grep -v -f $readsfile !{fastq[0]} | pigz -p !{params.resources.removeHumanReads.cpus} > $oname1
  
  # 3) Generate fastq 2 without human reads using seqkit, compress with pigz (parallel gzip)
  oname2=$(basename -s .fastq.gz !{fastq[1]}).filt.fastq.gz
  seqkit grep -v -f $readsfile !{fastq[1]} | pigz -p !{params.resources.removeHumanReads.cpus} > $oname2
  '''
}