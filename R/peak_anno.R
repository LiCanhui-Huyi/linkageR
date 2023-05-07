#' annotation peak
#' Annotate peak and visualize
#'
#' @param peakMmap peak map file
#'
#' @return Annotate peak and visualize
#' @export
#' @import ChIPseeker
#' @import TxDb.Hsapiens.UCSC.hg38.knownGene
#' @importFrom utils write.table
#' @examples
#' \dontrun{
#' peak_anno(peakMap)
#' }
#'
peak_anno <- function(peakMap){
  peakmapbed <- data.table::fread(peakMap,sep = "\t" ,select = c(3:6))
  write.table(peakmapbed,file = "atac.bed",sep = "\t",quote = FALSE,row.names = FALSE,col.names = FALSE)

  #所需人类基因注释
  txdb  <-  TxDb.Hsapiens.UCSC.hg38.knownGene::TxDb.Hsapiens.UCSC.hg38.knownGene
  #注释peak
  x <- ChIPseeker::annotatePeak("atac.bed", tssRegion=c(-1000, 1000), TxDb=txdb,annoDb = "org.Hs.eg.db")
  PeakAnno <<- as.data.frame(x)  #保存为数据框，便于查看
  ChIPseeker::upsetplot(x, vennpie=TRUE)    #注释可视化
}
