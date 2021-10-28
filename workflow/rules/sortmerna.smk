rule sortmerna:
    input:
        fwd="analysis_output/{sample}/combine_fq/{sample}_{type}_R1.fq.gz",
        rev="analysis_output/{sample}/combine_fq/{sample}_{type}_R2.fq.gz",
        ref=config["sortmerna"]["fasta"],
        idx=config["sortmerna"]["index"],
    output:
        "analysis_output/{sample}/sortmerna/{sample}_{type}.rrna.fq.gz",
        "analysis_output/{sample}/sortmerna/{sample}_{type}.fq.gz",
    params:
        ref=get_sortmerna_ref_fmt,
        e=0.000001,
    log:
        "analysis_output/{sample}/sortmerna/{sample}_{type}.log",
    container:
        config.get("tools", {}).get("sortmerna", "docker://marrip/sortmerna:4.3.4")
    threads: 2
    message:
        "{rule}: Identify rRNA reads in sample {wildcards.sample}_{wildcards.type}"
    shell:
        """
        sortmerna \
        --fastx \
        -e {params.e} \
        --threads {threads} \
        --ref {params.ref} \
        --idx-dir {input.idx} \
        --reads {input.fwd} \
        --reads {input.rev} \
        --workdir analysis_output/{wildcards.sample}/sortmerna \
        --aligned analysis_output/{wildcards.sample}/sortmerna/{wildcards.sample}_{wildcards.type}.rrna \
        --other analysis_output/{wildcards.sample}/sortmerna/{wildcards.sample}_{wildcards.type} &> {log}
        """
