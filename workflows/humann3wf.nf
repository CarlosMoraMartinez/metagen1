include { concatFastq } from '../modules/concatfastq'
include { doHumann3 } from '../modules/humann3'
include { mergeHumann } from '../modules/merge_humann'
include { translateHumann } from '../modules/translate_humann'
include { doMetaphlan } from '../modules/metaphlan'
include { mergeMetaphlan } from '../modules/merge_metaphlan'

workflow HUMANN3 {
take:
ch_fastq_filtered

main:
//ch_fastq_filtered.view{ "Humann3 input: $it" }
concatFastq(ch_fastq_filtered)
ch_concat_fastq = concatFastq.out
    //.view{ "concat fastq output: $it" }

doMetaphlan(
        params.doMetaphlan.bowtie2db,
        params.doMetaphlan.metaphlan_index, 
        ch_concat_fastq
)
ch_metaphlan = doMetaphlan.out
    .view{ "Metaphlan output: $it" }

ch_metaphlan_join = ch_metaphlan
    .map{it -> tuple( it[1])}
    .flatten()
    .collect()
    .view{ "Metaphlan output join: $it" }
mergeMetaphlan(ch_metaphlan_join)
ch_metaphlan_merged = mergeMetaphlan.out
    .view{ "Metaphlan merged output: $it" }


if(params.resources.doHumann3.do_humann){
    doHumann3(
            params.doHumann3.bowtie2db,
            params.doHumann3.metaphlan_index, 
            ch_concat_fastq
    )
    ch_humann3 = doHumann3.out
        //.view{ "Humann3 output: $it" }
        .flatten()
        .collect()
        //.view{ "Humann3 output flat: $it" }

    mergeHumann(ch_humann3)
    ch_humann3_merged = mergeHumann.out
        //.view{ "Humann3 output merged: $it" }

    translateHumann(ch_humann3_merged, params.translateHumann3.cazy_db)
    ch_humann3_translated = translateHumann.out
        //.view{ "Humann3 output translated: $it" }
}else{
    ch_humann3 = Channel.from([])
    ch_humann3_merged = Channel.from([])
    ch_humann3_translated = Channel.from([])
}
emit:
ch_metaphlan
ch_metaphlan_merged
ch_humann3
ch_humann3_merged
ch_humann3_translated
}