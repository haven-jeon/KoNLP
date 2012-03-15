\name{backupUsrDic}
\alias{backupUsrDic}
\title{use for backup current dic_user.txt}
\usage{
  backupUsrDic()
}
\description{
  Utility function for backup dic_user.txt file to backup
  directory.
}
\examples{
\dontrun{dicpath <- paste(system.file(package="KoNLP"), "/dics/data/kE/dic_user2.txt", sep="")
newdic <- read.table(dicpath, sep="\\t")
mergeUserDic(newdic)
## backup merged new dictionary
backupUsrDic()
## restore from backup directory
restoreUsrDic()
## reloading new dictionary
reloadAllDic()}
}

