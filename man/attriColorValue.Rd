% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Enrich.R
\name{attriColorValue}
\alias{attriColorValue}
\title{Attribute Color to Value}
\usage{
attriColorValue(Value, df, colors=c(a,b,c),feet)
}
\arguments{
\item{Value}{integer}

\item{df}{data frame with numeric values}

\item{colors}{a vector of 5 colors}

\item{feet}{the interval between two successive colors in the palette (0.1)}
}
\value{
Hex Color Code
}
\description{
Attribute Color to Value
}
\examples{
\dontrun{
cgds <- CGDS("http://www.cbioportal.org/")
geneList <- whichGeneList("73")
ProfData <- getProfileData.CGDS(cgds,
 geneList, "gbm_tcga_pub_mrna", "gbm_tcga_pub_all")
rownames(ProfData) <- NULL
clrRef <- attriColorValue(1.2,
ProfData,
 colors = c("blue3", "white","red"),
  feet=10)
}

}
