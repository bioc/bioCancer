% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getListProfData.R
\name{getListProfData}
\alias{getListProfData}
\title{get list of data frame with profiles data (CNA,mRNA, Methylation, Mutation...)}
\usage{
getListProfData(panel, geneListLabel)
}
\arguments{
\item{panel}{Panel name (string) in which Studies are selected. There are two panels ("Circomics" or "Reactome")}

\item{geneListLabel}{The label of GeneList. There are three cases:
 "Genes" user gene list,
 "Reactome_GeneList" GeneList plus genes from reactomeFI
"file name" from Examples}
}
\value{
A LIST of a list data frame. Each LIST is related to profiles data (CNA, mRNA, Methylation, Mutation, miRNA, RPPA).
        each list of data frame is related to studies.
}
\description{
get list of data frame with profiles data (CNA,mRNA, Methylation, Mutation...)
}
\examples{
cgds <- CGDS("http://www.cbioportal.org/public-portal/")
 \dontrun{
geneList <- whichGeneList("73")
r_data <- new.env()
MutData <- getMutationData(cgds,"gbm_tcga_pub_all",
 "gbm_tcga_pub_mutations", geneList )
FreqMut <- getFreqMutData(list(ls1=MutData, ls2=MutData), "73")
input <- NULL
input[['StudiesIDCircos']] <- c("luad_tcga_pub","blca_tcga_pub")

ListProfData <- getListProfData(panel= "Circomics","73")
}
}
