rule mosdepth:
    input:
        bam="analysis_output/{sample}/star/{sample}_{type}.Aligned.sortedByCoord.out.bam",
        bai="analysis_output/{sample}/star/{sample}_{type}.Aligned.sortedByCoord.out.bam.bai",
        bed=config["mosdepth"]["bed"],
    output:
        "analysis_output/{sample}/mosdepth/{sample}_{type}.mosdepth.global.dist.txt",
        "analysis_output/{sample}/mosdepth/{sample}_{type}.mosdepth.region.dist.txt",
        "analysis_output/{sample}/mosdepth/{sample}_{type}.mosdepth.summary.txt",
        "analysis_output/{sample}/mosdepth/{sample}_{type}.regions.bed.gz",
        "analysis_output/{sample}/mosdepth/{sample}_{type}.regions.bed.gz.csi",
    log:
        "analysis_output/{sample}/mosdepth/{sample}_{type}.log",
    container:
        config.get("tools", {}).get("mosdepth", "docker://marrip/mosdepth:0.3.2")
    threads: 4
    message:
        "{rule}: Calculating coverage for {wildcards.sample}_{wildcards.type} using mosdepth"
    shell:
        """
        mosdepth \
        -n \
        -x \
        -t {threads} \
        --by {input.bed} \
        analysis_output/{wildcards.sample}/mosdepth/{wildcards.sample}_{wildcards.type} \
        {input.bam} &> {log}
        """
