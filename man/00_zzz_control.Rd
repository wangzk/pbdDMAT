\name{pbdDMAT Control}
\alias{.BLDIM}
\alias{.ICTXT}
\docType{data}
\title{Some default parameters for pbdDMAT.}
\description{
  This set of controls is used to provide default values in this package.
}
\format{
  Objects contain several parameters for communicators and methods.
}
\details{
  The default blocking \code{.BLDIM} is \code{c(4,4)}, which results 
  in a 4 by 4 blocking dimension for distributed matrices.  
  Any time a function takes the \code{bldim=} argument, it will 
  default to this value unless the user specifies an alternative.
  
  The default ICTXT is 0.  This is the full 2-dimensional processor grid.
}
