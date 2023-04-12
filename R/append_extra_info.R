#' append_extra_info
#'
#' Adding gene names and other information to RNA data,
#'  as well as integrating ATAC data
#'
#' @param fileOfRNA  RNA sequencing data file
#' @param fileOfATAC  ATAC sequencing data file
#' @param fileOfpeakMap  peak map file
#'
#' @importFrom data.table fread
#' @importFrom stringr str_sort
#' @import biomaRt
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



append_extra_info <- function(fileOfRNA,fileOfATAC,fileOfpeakMap){
  #读取数据文件
  rna <- data.table::fread(fileOfRNA,nrows = 1,header = FALSE)  #只读取第一行，包含样本名，用于筛选相同的样本
  atac <-data.table::fread(fileOfATAC,nrows = 1,header = FALSE)
  atacmap <<- data.table::fread(fileOfpeakMap,sep = "\t")   # 全局，用于peak注释

  #获取两个矩阵中相同的列名（样本）
  rnacol <- rna %in% atac; rnacol[1] <- TRUE; rnacol <-which(rnacol==TRUE)
  RNA_in_ATAC <- as.data.frame(data.table::fread(fileOfRNA,select = rnacol)) #用fread读取文件，数据格式不是简单的dataframe
  RNA_in_ATAC <- RNA_in_ATAC[stringr::str_sort(colnames(RNA_in_ATAC))] #进行排序
  geneid <- RNA_in_ATAC[,1];RNA_in_ATAC[,1]<- gsub("\\.\\d*","",geneid) #提取基因id

  #使用biomaRt获取基因ID对应的基因名
  while(! exists("my_newid")){
    try(my_mart <-biomaRt::useMart("ensembl"),silent = TRUE)#创建mart对象
    if(! exists("my_mart"))next #如果mymart对象不存在，进入下一次循环
    try(my_dataset <- biomaRt::useDataset("hsapiens_gene_ensembl",mart = my_mart) )#选择数据库
    try(my_newid <- biomaRt::getBM(attributes = c("hgnc_symbol","ensembl_gene_id","chromosome_name",'start_position','end_position'), #想要获得的数据类型
                                   filters = "ensembl_gene_id", #提供的数据类型
                                   values = RNA_in_ATAC[,1], #提供的数据类型对应数据
                                   mart = my_dataset))
  }
  #合并处理biomaRt获得的数据框
  RNA_in_ATAC <- merge(my_newid,RNA_in_ATAC,by.x = "ensembl_gene_id",by.y = "Ensembl_ID")
  RNA_in_ATAC[,3] <- paste0("chr",RNA_in_ATAC[,3])  #染色体名加上chr，与ATAC数据一致
  RNA <<-  RNA_in_ATAC  #创建全局变量RNA存储矩阵

  #获取两个矩阵中相同的列名（样本）
  ataccol <- atac %in% rna;ataccol[1] <- TRUE;ataccol <- which(ataccol==TRUE)
  ATAC_in_RNA <-as.data.frame(data.table::fread(fileOfATAC,select = ataccol))
  ATAC_in_RNA <- ATAC_in_RNA[stringr::str_sort(colnames(ATAC_in_RNA))]
  ATAC <<- as.data.frame(cbind(atacmap[,3:5],ATAC_in_RNA[,-1]))


}
