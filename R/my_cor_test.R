#' Calculate correlation
#' An auxiliary function used to calculate
#' the correlation coefficient and p-value
#'
#' @param pair Index Pairs of Genes and Peaks in Various Data Frames
#' @importFrom stats cor.test
#' @return  coefficient and p-value
#'
#'
my_cor_test <- function(pair){ #相关性检测       辅助函数    传入变量为基因和peak的位置对
  rna <- RNA[pair[1],]
  atac <- ATAC[pair[2],]
  r <- cor.test(as.numeric(rna[,-1:-5]),as.numeric(atac[,-1:-3]),method = "spearman",exact=FALSE)
  return(c(r$estimate,r$p.value))
}
