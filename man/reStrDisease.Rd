% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Enrich.R
\name{reStrDisease}
\alias{reStrDisease}
\title{Restructure the list of color attributed to the genes in every disease}
\usage{
reStrDisease(List)
}
\arguments{
\item{List}{of data frame with color attributes}
}
\value{
Hierarchy of dimensions in the same study: dimensions > gene > color
}
\description{
Restructure the list of color attributed to the genes in every disease
}
\examples{
cgds <- cBioPortal(
hostname = "www.cbioportal.org",
protocol = "https",
api = "/api/v2/api-docs"
)
\dontrun{
getDataByGenes( api =  cgds,
studyId = "gbm_tcga_pub",
genes = c("NF1", "TP53", "ABL1"),
by = "hugoGeneSymbol",
molecularProfileIds = "gbm_tcga_pub_mrna"
)
}
}
