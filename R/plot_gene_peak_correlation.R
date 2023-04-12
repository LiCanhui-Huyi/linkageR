#' Title
#'
#' @param loc_cor A row in the dataframe obtained by running the linkage function
#' @param RNA     data frame of RNA data
#' @param ATAC    data frame of ATAC data
#'
#' @return
#' The correlation between visualized gene expression
#' levels and peak expression levels
#' @export
#' @import ggplot2
#' @examples
#' \dontrun{plot_gene_peak_correlation(loc_cor[1,],RNA,ATAC)}
#'
plot_gene_peak_correlation<- function(loc_cor,RNA,ATAC){
  # merged_data <- rbind(RNA[location_pair[1,1],6:ncol(RNA)], ATAC[location_pair[1,2],4:ncol(ATAC)])
  # return(merged_data)

  gene_expr <- RNA[loc_cor[1,5],6:ncol(RNA)] %>% as.numeric()
  peak_data <- ATAC[loc_cor[1,6],4:ncol(ATAC)] %>% as.numeric()


  p <- ggplot2::ggplot(data.frame(gene_expr, peak_data), ggplot2::aes(x = gene_expr, y = peak_data)) +
    ggplot2::geom_point() + # 添加散点图
    ggplot2::stat_smooth(method = "lm", se = FALSE) + # 添加回归线
    ggplot2::theme_classic() + # 使用白色背景并去除网格线
    ggplot2::xlab("RNA-seq") + ggplot2::ylab("ATAC-seq") + # 添加X轴和Y轴标签
    ggplot2::ggtitle(loc_cor[1,1], paste(loc_cor[1,2],":",loc_cor[1,3],"-",loc_cor[1,4])) + # 添加标题和副标题
    ggplot2::annotate("text", x = min(gene_expr), y = max(peak_data), # 在左上角添加相关系数和FDR值
                      label = paste0("Corr =",round(as.numeric(loc_cor[1,7]), 4), "\np_value =", format.pval(as.numeric(loc_cor[1,8]))),
                      hjust = 0, vjust = 1, size = 3)

  # 显示图形
  print(p)
}
