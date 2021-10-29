rule samtools_index:
    input:
        "{file}.bam",
    output:
        "{file}.bam.bai",
    log:
        "{file}.bam.bai.log",
    container:
        config.get("tools", {}).get("common", "docker://marrip/common:1.1.1")
    message:
        "{rule}: Index {wildcards.file}.bam"
    shell:
        """
        samtools index {input} &> {log}
        """
