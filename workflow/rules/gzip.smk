rule gunzip:
    input:
        "{file}.fq.gz",
    output:
        "{file}.fq",
    log:
        "{file}.log",
    container:
        config.get("tools", {}).get("common", "docker://marrip/common:1.1.1")
    message:
        "{rule}: Gunzip {wildcards.file}.fq.gz"
    shell:
        """
        gunzip -k {input} &> {log}
        """
