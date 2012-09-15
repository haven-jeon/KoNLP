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
\dontrun{
## This codes can not be run if you don't have encoding system which can en/decode Hangul(ex) CP949, EUC-KR, UTF-8).
dicpath <- file.path(system.file(package="Sejong"), "dics", "handic.zip")
conn <- unz(dicpath, file.path("data","kE","dic_user2.txt"))
newdic <- read.table(conn, sep="\\t", header=FALSE, fileEncoding="UTF-8", stringsAsFactors=FALSE)
mergeUserDic(newdic)
## backup merged new dictionary
backupUsrDic(ask=FALSE)
## restore from backup directory
restoreUsrDic(ask=FALSE)
## reloading new dictionary
reloadAllDic()}
}

