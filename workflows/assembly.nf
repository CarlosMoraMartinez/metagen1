include { callMetaspades } from '../modules/spades'
include { callMegahit } from '../modules/megahit'

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
  
  emit:
  ch_spades_output
  ch_megahit_output
}