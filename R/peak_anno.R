#' annotation peak
#' Annotate peak and visualize
#'
#' @param peakmap peak map file
#'
#' @return Annotate peak and visualize
#' @export
#' @import ChIPseeker
#' @import TxDb.Hsapiens.UCSC.hg38.knownGene
#' @importFrom utils write.table
#' @examples
#' \dontrun{peak_anno(peakmap)}
#'
peak_anno <- function(peakmap){
  peakmap <- data.table::fread(peakmap,sep = "\t")
  peakmapbed <- peakmap[,3:6] #map文件3到6列包含bed文件的内容
  write.table(peakmapbed,file = "atac.bed",sep = "\t",quote = FALSE,row.names = FALSE,col.names = FALSE)

  #所需人类基因注释
  txdb  <-  TxDb.Hsapiens.UCSC.hg38.knownGene::TxDb.Hsapiens.UCSC.hg38.knownGene
  #注释peak
  x <- ChIPseeker::annotatePeak("atac.bed", tssRegion=c(-1000, 1000), TxDb=txdb,annoDb = "org.Hs.eg.db")
  PeakAnno <<- as.data.frame(x)  #保存为数据框，便于查看
  ChIPseeker::upsetplot(x, vennpie=TRUE)    #注释可视化
}
