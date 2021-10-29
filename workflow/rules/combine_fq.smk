rule combine_fq:
    input:
        unpack(get_sample_fastq),
    output:
        fwd="analysis_output/{sample}/combine_fq/{sample}_{type}_R1.fq.gz",
        rev="analysis_output/{sample}/combine_fq/{sample}_{type}_R2.fq.gz",
    log:
        "analysis_output/{sample}/combine_fq/{sample}_{type}.log",
    container:
        config.get("tools", {}).get("common", "docker://marrip/common:1.1.1")
    message:
        "{rule}: Combine fastq files of sample {wildcards.sample}_{wildcards.type}"
    shell:
        """
        cat {input.fwd} > {output.fwd} && \
        cat {input.rev} > {output.rev} | tee {log} \
        """
