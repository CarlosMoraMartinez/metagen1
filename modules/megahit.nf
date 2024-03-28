process callMegahit{
  label 'mg21_megahit'
  conda params.callMegahit.conda
  cpus params.resources.callMegahit.cpus
  memory params.resources.callMegahit.mem
  queue params.resources.callMegahit.queue
  clusterOptions params.resources.callMegahit.clusterOptions
  errorStrategy { task.exitStatus in 1..2 ? 'retry' : 'ignore' }
  maxRetries 10
  publishDir "$results_dir/mg21_megahit", mode: 'symlink'
  input:
  val memory_prop
  val options
  tuple(val(illumina_id), path(fastq))

  output:
  tuple(val(illumina_id), path("*fasta.gz"), path("*_megahit_result"), path("*.log"), path("*.err"))
  

  shell:
  '''
  outdir=!{illumina_id}_megahit_result
  logfile=!{illumina_id}.megahit.log
  errfile=!{illumina_id}.megahit.err
  outfile=!{illumina_id}.megahit.fasta

  megahit -t !{params.resources.callMetaspades.cpus} \
                -m !{memory_prop} !{options}\
                -1 !{fastq[0]} -2 !{fastq[1]} \
                -o $outdir >$logfile 2> $errfile
  
  mv $outdir/final.contigs.fa $outfile
  gzip $outfile
  '''
}