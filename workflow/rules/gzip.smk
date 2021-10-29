rule gunzip:
    input:
        "{file}.gz",
    output:
        "{file}",
    log:
        "{file}.log"
    container:
        config.get("tools", {}).get("common", "docker://marrip/common:1.1.1")
    message:
        "{rule}: Gunzip {wildcards.file}.gz"
    shell:
        """
        gunzip {input} &> {log}
        """
