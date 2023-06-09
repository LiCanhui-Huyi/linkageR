% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_gene_peak_correlation.R
\name{plot_gene_peak_correlation}
\alias{plot_gene_peak_correlation}
\title{Title}
\usage{
plot_gene_peak_correlation(loc_cor, RNA, ATAC)
}
\arguments{
\item{loc_cor}{A row in the dataframe obtained by running the linkage function}

\item{RNA}{data frame of RNA data}

\item{ATAC}{data frame of ATAC data}
}
\value{
The correlation between visualized gene expression
levels and peak expression levels
}
\description{
Title
}
\examples{
\dontrun{plot_gene_peak_correlation(loc_cor[1,],RNA,ATAC)}

}
