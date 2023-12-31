% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Enrich.R
\name{reStrColorGene}
\alias{reStrColorGene}
\title{Restructure the list of color attributed to the genes in every dimenssion for every studies}
\usage{
reStrColorGene(df)
}
\arguments{
\item{df}{data frame with colors attributed to the genes}
}
\value{
Hierarchical color attribute: gene > color
}
\description{
Restructure the list of color attributed to the genes in every dimenssion for every studies
}
\examples{
\dontrun{
cgds <- CGDS("http://www.cbioportal.org/")
geneList <- whichGeneList("73")
ProfData <- getProfileData.CGDS(cgds,
 geneList, "gbm_tcga_pub_mrna", "gbm_tcga_pub_all")
rownames(ProfData) <- NULL
ls <- reStrColorGene(ProfData)
}
}
