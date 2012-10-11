\name{statDic}
\alias{statDic}
\title{summary of dictionaries}
\usage{
  statDic(which = "current", n = 6)
}
\arguments{
  \item{which}{"current" or "backup" dictionary}

  \item{n}{a single integer. Size for the resulting object
  to view}
}
\description{
  show summary, head and tail of current or backup
  dictionaries
}
\examples{
## show current dictionary's summary, head, tail
statDic("current", 10)
}

