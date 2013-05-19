\name{concordance_file}
\alias{concordance_file}
\title{concordance for input text file}
\usage{
  concordance_file(filename, pattern,
    encoding = getOption("encoding"), span = 5)
}
\arguments{
  \item{filename}{file name}

  \item{pattern}{patterns of central words}

  \item{span}{how many character will be produced around
  input pattern}

  \item{encoding}{filename's encoding}
}
\description{
  returns concordance text for input file.
}
\author{
  Heewon Jeon
}
\references{
  Church, K. W. and Mercer, R. L. (1993). Introduction to
  the special issue on computational linguistics using
  large corpora. Computational Linguistics, 19(1):1-24.
}

