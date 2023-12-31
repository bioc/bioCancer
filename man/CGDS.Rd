% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cgdsr.R
\name{CGDS}
\alias{CGDS}
\title{CGDS  connect object to cBioPortal}
\usage{
CGDS(url,verbose=FALSE,ploterrormsg='',token=NULL)
}
\arguments{
\item{url}{A CGDS URL (required).}

\item{verbose}{A boolean variable specifying verbose output (default FALSE)}

\item{ploterrormsg}{An optional message to display in plots if an error occurs (default ”)}

\item{token}{An optional 'Authorization: Bearer' token to connect to cBioPortal instances that require authentication (default NULL)}
}
\description{
Creates a CGDS connection object from a CGDS endpoint URL. This object must be passed on to the methods which query the server.
}
