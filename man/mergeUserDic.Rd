\name{mergeUserDic}
\alias{mergeUserDic}
\title{"dic_usr.txt" editor function}
\usage{
  mergeUserDic(newUserDic, append = TRUE, verbose = FALSE)
}
\arguments{
  \item{newUserDic}{new user dictionary as data.frame}

  \item{append}{append or replacing}

  \item{verbose}{see detail error logs}
}
\description{
  merging with current dic_user.txt and new dictionary.
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

