% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Enrich.R
\name{UnifyRowNames}
\alias{UnifyRowNames}
\title{Unify row names in data frame with the same order of gene list.}
\usage{
UnifyRowNames(x,geneList)
}
\arguments{
\item{x}{data frame with gene symbol in the row name}

\item{geneList}{a gene list}
}
\value{
a data frame having the gene in row name ordered as in gene list.
}
\description{
Unify row names in data frame with the same order of gene list.
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
