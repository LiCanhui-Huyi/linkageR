# linkageR

linkageR通过计算ATAC-seq和RNA-seq数据在样本之间的相关系数，识别基因潜在调控位点

## Installation

安装linkageR：

``` r
# 加载devtools包，如果没有则安装。
if(!require("devtools"))install.packages("devtools")
# 安装linkageR
devtools::install_github("LiCanhui-Huyi/linkageR")
```

## Example

``` r
library(linkageR)
# 将四个文件名存入变量
rna <- "/your/path/TCGA-BRCA.htseq_fpkm-uq.tsv"
atac <- "/your/path/brca_brca_peak_Log2Counts_dedup.brca_brca_peak_log2counts_dedup"
peakmap <- "/your/path/brca_brca_peak.probeMap"
genemap <- "/your/path/gencode.v22.annotation.gene.probeMap"

#调用append_extra_info函数，整合数据，会生成两个全局数据框：RNA、ATAC
append_extra_info(rna,atac,peakmap,genemap)

#可视化peak重叠注释
peak_anno(peakmap)

#核心函数，输入感兴趣的基因集，得到与基因具有相关性的peak，会生成一个全局数据框loc_cor,
#改数据框包含：基因名，peak的染色体位置，基因和peak在RNA和ATAC矩阵的索引，以及相关性系数和p值
linkage(RNA,ATAC,geneset = RNA$gene[1:2],rho=0.3,p=0.1)



#最后可以选择loc_cor的任意一行，画出基因和peak表达量的相关性散点图。
plot_gene_peak_correlation(loc_cor[1,],RNA,ATAC)
```

## Data file

可以从以下链接下载四个示例文件:

ATAC-seq - All peak signal:

<https://tcgaatacseq.s3.us-east-1.amazonaws.com/download/brca%2Fbrca_peak_Log2Counts_dedup>

peak map:

<https://tcgaatacseq.s3.us-east-1.amazonaws.com/download/brca%2Fbrca_peak.probeMap>

gene expression RNAseq - HTSeq - FPKM-UQ:

<https://gdc-hub.s3.us-east-1.amazonaws.com/download/TCGA-BRCA.htseq_fpkm-uq.tsv.gz>

gene map:

<https://gdc-hub.s3.us-east-1.amazonaws.com/download/gencode.v22.annotation.gene.probeMap>
