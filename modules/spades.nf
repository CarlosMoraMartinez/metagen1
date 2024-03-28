process callMetaspades{
  label 'mg20_metaspades'
  conda params.callMetaspades.conda
  cpus params.resources.callMetaspades.cpus
  memory params.resources.callMetaspades.mem
  queue params.resources.callMetaspades.queue
  clusterOptions params.resources.callMetaspades.clusterOptions
  errorStrategy { task.exitStatus in 1..2 ? 'retry' : 'ignore' }
  maxRetries 10
  publishDir "$results_dir/mg20_metaspades", mode: 'symlink'
  input:
  val phred_offset
  val kmer_sizes
  tuple(val(illumina_id), path(fastq))

  output:
  tuple(val(illumina_id), path("*fasta.gz"), path("*metaspades_result"))
  

  shell:
  '''
  outdir=!{illumina_id}_metaspades_result
  logfile=!{illumina_id}.metaspades.log
  errfile=!{illumina_id}.metaspades.err
  outfile=!{illumina_id}.metaspades.fasta


  metaspades.py -t !{params.resources.callMetaspades.cpus} \
                --only-assembler \
                --phred-offset !{phred_offset} \
                -k !{kmer_sizes} \
                -1 !{fastq[0]} -2 !{fastq[1]} \
                -o $outdir >$logfile 2> $errfile
  
  mv $outdir/contigs.fasta $outfile
  gzip $outfile
  '''
}