include { concatFastq } from '../modules/concatfastq'
include { doHumann3 } from '../modules/humann3'


workflow HUMANN3 {
take:
ch_fastq_filtered

main:
//ch_fastq_filtered.view{ "Humann3 input: $it" }
concatFastq(ch_fastq_filtered)
ch_concat_fastq = concatFastq.out
    //.view{ "concat fastq output: $it" }
    doHumann3(
        params.doHumann3.bowtie2db,
        params.doHumann3.metaphlan_index, 
        ch_concat_fastq
    )
    ch_humann3 = doHumann3.out
        .view{ "Humann3 output: $it" }
emit:
ch_humann3
}