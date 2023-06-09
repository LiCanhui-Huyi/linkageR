#' append_extra_info
#'
#' Adding gene names and other information to RNA data,
#'  as well as integrating ATAC data
#'
#' @param fileOfRNA  RNA sequencing data file
#' @param fileOfATAC  ATAC sequencing data file
#' @param fileOfgeneMap  gene map file
#' @param fileOfpeakMap  peak map file
#'
#' @importFrom data.table fread
#' @importFrom stringr str_sort
#'
#' @return Two dataframes, one for RNA data and one for ATAC data
#' @export
#'
#' @examples
#' \dontrun{
#' rna <- "TCGA-BRCA.htseq_fpkm-uq.tsv"
#' atac <- "brca_brca_peak_Log2Counts_dedup.brca_brca_peak_log2counts_dedup"
#' peakmap <- "brca_brca_peak.probeMap"
#' append_extra_info(rna,atac,peakmap)
#' }



append_extra_info <- function(fileOfRNA,fileOfATAC,fileOfgeneMap,fileOfpeakMap){
  #读取数据文件
  rna <- data.table::fread(fileOfRNA,nrows = 1,header = FALSE)  #只读取第一行，包含样本名，用于筛选相同的样本
  atac <-data.table::fread(fileOfATAC,nrows = 1,header = FALSE)

  #获取两个矩阵中相同的列名（样本）
  rna_col <- rna %in% atac; rna_col[1] <- TRUE; rna_col <-which(rna_col==TRUE)
  RNA_in_ATAC <- as.data.frame(data.table::fread(fileOfRNA,select = rna_col))%>%
    {.[stringr::str_sort(colnames(.))]} #用fread读取文件，数据格式不是简单的dataframe，
  genemap <- data.table::fread(fileOfgeneMap,sep = "\t")
  RNA <<- merge(genemap[,-6],RNA_in_ATAC,by.x="id",by.y="Ensembl_ID")

  #获取两个矩阵中相同的列名（样本）
  ataccol <- atac %in% rna;ataccol[1] <- TRUE;ataccol <- which(ataccol==TRUE)
  ATAC_in_RNA <-as.data.frame(data.table::fread(fileOfATAC,select = ataccol)) %>%
    {.[stringr::str_sort(colnames(.))]}
  peakmap <- data.table::fread(fileOfpeakMap,sep = "\t")   # 全局，用于peak注释
  ATAC <<- as.data.frame(cbind(peakmap[,3:5],ATAC_in_RNA[,-1]))

}
