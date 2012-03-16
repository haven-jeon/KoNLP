\name{backupUsrDic}
\alias{backupUsrDic}
\title{use for backup current dic_user.txt}
\usage{
  backupUsrDic(ask = TRUE)
}
\arguments{
  \item{ask}{ask to confirm backup}
}
\description{
  Utility function for backup dic_user.txt file to backup
  directory.
}
\examples{
dicpath <- paste(system.file(package="KoNLP"), "/dics/data/kE/dic_user2.txt", sep="")
newdic <- read.table(dicpath, sep="\\t", header=FALSE, fileEncoding="UTF-8", stringsAsFactors=FALSE)
mergeUserDic(newdic)
## backup merged new dictionary
backupUsrDic(ask=FALSE)
## restore from backup directory
restoreUsrDic(ask=FALSE)
## reloading new dictionary
reloadAllDic()
}

