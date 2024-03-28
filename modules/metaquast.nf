process callMetaquast{
  label 'mg22_metaquast'
  conda params.callMetaquast.conda
  cpus params.resources.callMetaquast.cpus
  memory params.resources.callMetaquast.mem
  queue params.resources.callMetaquast.queue
  clusterOptions params.resources.callMetaquast.clusterOptions
  errorStrategy { task.exitStatus in 1..2 ? 'retry' : 'ignore' }
  maxRetries 10
  publishDir "$results_dir/mg22_metaquast", mode: 'symlink'
  input:
  val min_length
  val options
  tuple(val(illumina_id), val(tool), path(fasta))

  output:
  tuple(val(illumina_id), val(tool), path("*metaquast_result"), path("*metaquast_report.tsv"))
  
  shell:
  '''
  outdir=!{illumina_id}_!{tool}_metaquast_result
  logfile=!{illumina_id}_!{tool}_metaquast.log
  errfile=!{illumina_id}_!{tool}_metaquast.err
  resfile=!{illumina_id}_!{tool}_metaquast_report.tsv


  metaquast.py !{fasta} -t !{params.resources.callMetaquast.cpus} -m !{min_length} !{options} -o $outdir > $logfile 2> $errfile
  cp $outdir/report.tsv $resfile

  '''
}