include { callMetaspades } from '../modules/spades'
include { callMegahit } from '../modules/megahit'
include { callMetaquast } from '../modules/metaquast'

workflow ASSEMBLY {
  take:
  ch_fastq_filtered

  main:
  //Call Metaspades
  if(params.callMetaspades.do_metaspades){
    callMetaspades(params.callMetaspades.phred_offset,
            params.callMetaspades.kmer_sizes,
            ch_fastq_filtered
  )
    ch_spades_output = callMetaspades.out
        //.view{"Metaspades output: $it"}
  }else{
    ch_spades_output = Channel.from([])

  }

  //Call Megahit
  if(params.callMegahit.do_megahit){
    callMegahit(params.callMegahit.memory_prop,
            params.callMegahit.options,
            ch_fastq_filtered
  )
    ch_megahit_output = callMegahit.out
        //.view{"Megahit output: $it"}
  }else{
    ch_megahit_output = Channel.from([])
  }
  
    //Call Metaquast
  if(params.callMetaquast.do_metaquast){
    metaquast_in  = ch_spades_output.map{it -> tuple(it[0], "metaspades", it[1]) }
    if(params.callMegahit.do_megahit){
      metaquast_in=metaquast_in.concat(
        ch_megahit_output.map{it -> tuple(it[0], "megahit", it[1]) }
      )//.view{"MetaQUAST input: $it"}
    }
    callMetaquast(params.callMetaquast.min_length,
            params.callMetaquast.options,
            metaquast_in)
    ch_metaquast_output = callMetaquast.out
        //.view{"Metaquast output: $it"}
  }else{
    ch_metaquast_output = Channel.from([])
  }

  emit:
  ch_spades_output
  ch_megahit_output
  ch_metaquast_output
}