#' Title
#'
#' @param loacation A row in the dataframe obtained by running the linkage function
#' @param RNA     data frame of RNA data
#' @param ATAC    data frame of ATAC data
#'
#' @return
#' The correlation between visualized gene expression
#' levels and peak expression levels
#' @export
#' @import ggplot2
#' @examples
#' \dontrun{plot_gene_peak_correlation(loacation[1,],RNA,ATAC)}
#'
plot_gene_peak_correlation<- function(loacation,RNA,ATAC){


  gene_expr <- RNA[as.numeric(loacation[1,5]) ,6:ncol(RNA)] %>% as.numeric()
  peak_data <- ATAC[as.numeric(loacation[1,6]),4:ncol(ATAC)] %>% as.numeric()


  p <- ggplot2::ggplot(data.frame(gene_expr, peak_data), ggplot2::aes(x = gene_expr, y = peak_data)) +
    ggplot2::geom_point() + # 添加散点图
    ggplot2::stat_smooth(method = "lm", se = FALSE) + # 添加回归线
    ggplot2::theme_classic() + # 使用白色背景并去除网格线
    ggplot2::xlab("Gene Expression") + ggplot2::ylab("Peak Signal") + # 添加X轴和Y轴标签
    ggplot2::ggtitle(loacation[1,1], paste(loacation[1,2],":",loacation[1,3],"-",loacation[1,4])) + # 添加标题和副标题
    ggplot2::annotate("text", x = min(gene_expr), y = max(peak_data), # 在左上角添加相关系数和FDR值
                      label = paste0("Corr =",round(as.numeric(loacation[1,7]), 4), "\np_value =", format.pval(as.numeric(loacation[1,8]))),
                      hjust = 0, vjust = 1, size = 3)

  # 显示图形
  print(p)
}
