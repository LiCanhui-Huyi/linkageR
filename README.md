# linkageR

<!-- badges: start -->

<!-- badges: end -->

The goal of linkageR is to Potential regulatory sites of genes were identified by calculating the correlation coefficients between samples for ATAC SEQ and RNA SEQ data.

linkageR通过计算ATAC-seq和RNA-seq数据在样本之间的相关系数，识别基因潜在调控位点

## Installation

You can install linkageR like so:

安装linkageR：

``` r
# Load the devtools package, if not present, install it
if(!require("devtools"))install.packages("devtools")
# install linkageR
devtools::install_github("LiCanhui-Huyi/linkageR")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(linkageR)
## 将四个文件名存入变量
rna <- "/your/path/TCGA-BRCA.htseq_fpkm-uq.tsv"
atac <- "/your/path/brca_brca_peak_Log2Counts_dedup.brca_brca_peak_log2counts_dedup"
peakmap <- "/your/path/brca_brca_peak.probeMap"
genemap <- "/your/path/gencode.v22.annotation.gene.probeMap"

##调用append_extra_info函数，整合数据，会生成两个全局数据库：RNA、ATAC
append_extra_info(rna,atac,peakmap,genemap)

##可视化peak重叠注释
peak_anno(peakmap)
```

![](images/peak%E6%B3%A8%E9%87%8A.png)

## Data file

You can access the following website link to obtain sample files:

ATAC-seq - All peak signal:

<https://tcgaatacseq.s3.us-east-1.amazonaws.com/download/brca%2Fbrca_peak_Log2Counts_dedup>

peak map:

<https://tcgaatacseq.s3.us-east-1.amazonaws.com/download/brca%2Fbrca_peak.probeMap>

gene expression RNAseq - HTSeq - FPKM-UQ:

<https://gdc-hub.s3.us-east-1.amazonaws.com/download/TCGA-BRCA.htseq_fpkm-uq.tsv.gz>

gene map:

<https://gdc-hub.s3.us-east-1.amazonaws.com/download/gencode.v22.annotation.gene.probeMap>
