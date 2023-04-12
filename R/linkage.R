#' Calculate correlation
#' An auxiliary function used to calculate
#' the correlation coefficient and p-value
#'
#' @param dataOfRNA   data frame of RNA data
#' @param dataOfATAC   data frame of ATAC data
#' @param geneset     Gene vectors of interest
#' @param rho   Correlation coefficient threshold
#' @param p    p-value threshold
#'
#' @return A data frame. Include the following information
#'
#' hgnc_symbol,chrom ,chromStart,chromEnd,idx_gene,idx_peak,rho,p_value
#'
#' @export
#'
#' @examples
#' \dontrun{linkage(RNA,ATAC,RNA$hgnc_symbol[1:10])}
#'
linkage <- function(dataOfRNA,dataOfATAC,geneset,rho=0.3,p=0.1){  #该函数目前遇到基因集全部来自同一染色体时会报错


  # 创建一个空的结果数据框
  result <- data.frame(RNA_index = integer(), ATAC_index = integer())

  # 对于每个基因进行操作
  for (i in seq_along(geneset)) {
    gene <- geneset[i]
    # print(gene)
    # 找到该基因在RNA数据框中的行数
    gene_row <- match(gene, dataOfRNA$gene)
    # print(gene_row)

    # 如果该基因不在RNA数据框中，则跳过
    if (is.na(gene_row)) {
      next
    }

    # 找到该基因的位置信息
    chr <- dataOfRNA$chrom[gene_row]
    start_pos <- dataOfRNA$chromStart[gene_row]
    end_pos <- dataOfRNA$chromEnd[gene_row]

    # 找到所有满足条件的peak的行数
    peak_rows <- which(dataOfATAC$chrom == chr &
                         dataOfATAC$chromStart >= start_pos - 500000 &
                         dataOfATAC$chromEnd <= end_pos + 500000)

    # 将结果添加到结果数据框中
    for (j in peak_rows) {
      result <- rbind(result, data.frame(RNA_index = gene_row, ATAC_index = j))
    }
  }

  cor_p <- apply(result, 1, my_cor_test) %>% t()
  loc_cor <- (abs(cor_p[,1]) > rho & cor_p[,2] < p) %>% {cbind(result[.,],cor_p[.,])} %>% as.data.frame()
  loc_cor <- cbind(RNA[loc_cor[,1],2],ATAC[loc_cor[,2],1:3],loc_cor)
  colnames(loc_cor) <- c("gene", "chrom", "chromStart",  "chromEnd" ,"idx_gene","idx_peak","rho","p_value")
  loc_cor <<- loc_cor

}
