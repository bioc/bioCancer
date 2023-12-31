% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Reactome.R
\name{Node_obj_Met_ProfData}
\alias{Node_obj_Met_ProfData}
\title{Attribute gene Methylation to Nodes}
\usage{
Node_obj_Met_ProfData(list, type, threshold)
}
\arguments{
\item{list}{a list of data frame with methylation data}

\item{type}{HM450 or HM27}

\item{threshold}{the Rate cases (patients) that have a silencing genes by methylation}
}
\value{
a data frame with node shape attributes
}
\description{
Attribute gene Methylation to Nodes
}
\examples{
\dontrun{
cgds <- CGDS("http://www.cbioportal.org/")
GeneList <- whichGeneList("DNA_damage_Response")
ProfDataMET <- getProfileData(cgds,GeneList, "gbm_tcga_pub_methylation","gbm_tcga_pub_all")
ListProfDataMET <- list(ls1=ProfDataMET, ls2=ProfDataMET)
nodeObj <- Node_obj_Met_ProfData(ListProfDataMET, "HM450",0.1)
}

}
