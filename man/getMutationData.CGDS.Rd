% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cgdsr.R
\name{getMutationData.CGDS}
\alias{getMutationData.CGDS}
\title{S3 method to ge Mutation Data}
\usage{
\method{getMutationData}{CGDS}(x, caseList, geneticProfile, genes, ...)
}
\arguments{
\item{x}{connection object}

\item{caseList}{A case list ID}

\item{geneticProfile}{A genetic profile ID with mutation data}

\item{genes}{A vector of genes list}

\item{...}{not used}
}
\description{
S3 method to ge Mutation Data
}
\examples{
#Create CGDS object
mycgds <- CGDS("http://www.cbioportal.org/")
# Get Extended Mutation Data for EGFR and PTEN in TCGA GBM
myMutationData <- getMutationData.CGDS(mycgds,"gbm_tcga_all","gbm_tcga_mutations", c('EGFR','PTEN'))

}
