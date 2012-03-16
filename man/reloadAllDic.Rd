\name{reloadAllDic}
\alias{reloadAllDic}
\title{reload all Hannanum analyzer dictionary}
\usage{
  reloadAllDic()
}
\description{
  Mainly, user dictionary reloading for Hannanum Analyzer.
  If you want to update user dictionary on
  KoNLP_pkg_dir/inst/dics/data/kE/dic_user.txt, need to
  execute this function after editing dic.
}
\examples{
\dontrun{dicpath <- paste(system.file(package="KoNLP"), "/dics/data/kE/dic_user2.txt", sep="")
newdic <- read.table(dicpath, sep="\\t")
mergeUserDic(newdic)
## backup merged new dictionary
backupUsrDic(ask=FALSE)
## restore from backup directory
restoreUsrDic(ask=FALSE)
## reloading new dictionary
reloadAllDic()}
}

