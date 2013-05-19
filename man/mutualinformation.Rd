\name{mutualinformation}
\alias{mutualinformation}
\title{mutual information for input text}
\usage{
  mutualinformation(text, query = "",
    method = c("mutual", "tscores"))
}
\arguments{
  \item{text}{input character vector}

  \item{method}{for calculations(`mutual' or `t-scores')}

  \item{query}{term to get information}
}
\description{
  returns mutual information or t-scores for input text
}
\author{
  Heewon Jeon
}
\references{
  Church, K. W. and Hanks, P. (1990). Word association
  norms, mutual information,and lexicography.Computational
  Linguistics, 16(1):22-29.

  Church, K. W. and Mercer, R. L. (1993). Introduction to
  the special issue on computational linguistics using
  large corpora. Computational Linguistics, 19(1):1-24.
}

