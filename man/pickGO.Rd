% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AnnotationFuncs.R
\name{pickGO}
\alias{pickGO}
\title{Cleans up result from org.Xx.egGO and returns specific GO identifiers}
\usage{
pickGO(l, evidence = NA, category = NA)
}
\arguments{
\item{l}{Character vector, or list of GO identifiers.}

\item{evidence}{Character vector, filters on which kind of evidence to return; for a larger list see \code{\link{getEvidenceCodes}}. \\*
 Evidence codes may be: \code{c('IMP','IGI','IPI','ISS','IDA','IEP','IEA','TAS','NAS','ND','IC')}. \\*
Leave as \code{NA} to ignore filtering on this part.}

\item{category}{Character vector, filters on which ontology to return: biological process (BP), cellular component (CC), or molecular function (MF). \\*
Leave as \code{NA} to ignore filtering on this part.}
}
\value{
List with only the picked elements.
}
\description{
Cleans up result from org.Xx.egGO and returns GO identifier for  either
biological process (BP), cellular component (CC), or molecular function (MF).
Can be used on list of GOs from \code{\link{translate}}, or a single list of GOs from an annotation package.
May reduce list, if the (sub)list does not contain the chosen class!
}
\examples{
library(org.Bt.eg.db)
genes <- c(280705, 280706, 100327208)
translate(genes, org.Bt.egSYMBOL)

symbols <- c("SERPINA1","KERA","CD5")
refseq <- translate(symbols, from=org.Bt.egSYMBOL2EG, to=org.Bt.egREFSEQ)
# Pick the proteins:
pickRefSeq(refseq, priorities=c('NP','XP'), reduce='all')

# If you wanted do do some further mapping on the result from
# translate, simply use lapply.

library(GO.db)
GO <- translate(genes, org.Bt.egGO)
# Get all biological processes:
\dontrun{
pickGO(GO, category='BP')
 # $`280705`
 # [1] "GO:0006826" "GO:0006879"
 # $`280706`
# [1] "GO:0006590" "GO:0007165" "GO:0042446"
# Get all ontologies with experimental evidence:
pickGO(GO, evidence=c('IMP','IGI','IPI','ISS','IDA','IEP','IEA'))
 # $`280705`
 # [1] "GO:0006826" "GO:0006879" "GO:0005615" "GO:0008199"
 # $`280706`
 # [1] "GO:0006590" "GO:0007165" "GO:0042446" "GO:0005615" "GO:0005179" "GO:0042393"
}
}
\seealso{
\code{\link{pickRefSeq}}, \code{\link{getEvidenceCodes}}, \code{\link{translate}}
}
\author{
Stefan McKinnon Edwards \email{stefan.hoj-edwards@agrsci.dk}
}
