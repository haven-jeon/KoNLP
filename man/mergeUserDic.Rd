\name{mergeUserDic}
\alias{mergeUserDic}
\title{"dic_user.txt" merging function}
\usage{
  mergeUserDic(newUserDic, append = TRUE, verbose = FALSE)
}
\arguments{
  \item{newUserDic}{new user dictionary as data.frame}

  \item{append}{append or replacing}

  \item{verbose}{see detail error logs}
}
\description{
  merging current dic_user.txt with new dictionary.
}
\examples{
\dontrun{
## This codes can not be run if you don't have encoding system which can en/decode Hangul(ex) CP949, EUC-KR, UTF-8).
dicpath <- paste(system.file(package="Sejong"), "/dics/handic.zip", sep="")
conn <- unz(dicpath, "data/kE/dic_user2.txt")
newdic <- read.table(conn, sep="\\t", header=FALSE, fileEncoding="UTF-8", stringsAsFactors=FALSE)
mergeUserDic(newdic)
## backup merged new dictionary
backupUsrDic(ask=FALSE)
## restore from backup directory
restoreUsrDic(ask=FALSE)
## reloading new dictionary
reloadAllDic()}
}

