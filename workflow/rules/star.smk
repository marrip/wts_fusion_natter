rule star:
    input:
        fwd="analysis_output/{sample}/combine_fq/{sample}_{type}_R1.fq",
        rev="analysis_output/{sample}/combine_fq/{sample}_{type}_R2.fq",
        dir=config["star"]["genome_dir"],
    output:
        "analysis_output/{sample}/star/{sample}_{type}.Aligned.sortedByCoord.out.bam",
    log:
        "analysis_output/{sample}/star/{sample}_{type}.log",
    container:
        config.get("tools", {}).get("star", "docker://marrip/star:2.7.9a")
    threads: 2
    message:
        "{rule}: Map reads for {wildcards.sample}_{wildcards.type}"
    shell:
        """
        STAR \
        --runThreadN {threads} \
        --genomeDir {input.dir} \
        --readFilesIn {input.fwd} {input.rev} \
        --outSAMtype BAM SortedByCoordinate \
        --outFileNamePrefix analysis_output/{wildcards.sample}/star/{wildcards.sample}_{wildcards.type}. ?> {log}
        """
