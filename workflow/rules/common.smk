import pandas as pd
from snakemake.utils import validate
from snakemake.utils import min_version


min_version("6.0.0")

### Set and validate config file


configfile: "config.yaml"


# validate(config, schema="../schemas/config.schema.yaml")


### Read and validate samples file

samples = pd.read_table(config["samples"], dtype=str).set_index("sample", drop=False)
# validate(samples, schema="../schemas/samples.schema.yaml")

### Read and validate units file

units = (
    pd.read_table(config["units"], dtype=str)
    .sort_values(["sample", "type"], ascending=False)
    .set_index(["sample", "type", "run", "lane"], drop=False)
)
# validate(units, schema="../schemas/units.schema.yaml")

### Set wildcard constraints


wildcard_constraints:
    sample="|".join(samples.index),


### Functions


def get_sample_fastq(wildcards):
    fastqs = units.loc[(wildcards.sample, wildcards.type), ["fq1", "fq2"]].dropna()
    return {"fwd": fastqs["fq1"].tolist(), "rev": fastqs["fq2"].tolist()}


def get_sortmerna_ref_fmt(wildcards):
    return " --ref ".join(config["sortmerna"]["fasta"])


def compile_output_list(wildcards):
    output_list = []
    files = {
        "mosdepth": [
            "mosdepth.global.dist.txt",
            "mosdepth.region.dist.txt",
            "mosdepth.summary.txt",
            "regions.bed.gz",
            "regions.bed.gz.csi",
        ],
        "sortmerna": [
            "rrna.fq.gz",
            "fq.gz",
        ],
    }
    for key in files.keys():
        output_list = output_list + expand(
            "analysis_output/{sample}/{tool}/{sample}_R.{ext}",
            sample=samples.index,
            tool=key,
            ext=files[key],
        )
    return output_list
