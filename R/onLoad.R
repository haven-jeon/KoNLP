#Copyright 2011 Heewon Jeon(madjakarta@gmail.com)
#
#This file is part of KoNLP.
#
#KoNLP is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.

#KoNLP is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with KoNLP.  If not, see <http://www.gnu.org/licenses/>



.KoNLPEnv <- new.env()

.DicPkgName <- "Sejong"


.onLoad <- function(libname, pkgname) {
  initopt <- c("-Xmx512m", "-Dfile.encoding=UTF-8")
  jopt <- getOption("java.parameters")
  if(is.null(jopt)){
    options(java.parameters = initopt)
  }else{
    if(rJava:::.jniInitialized & !any(grepl("-Dfile\\.encoding=UTF-8", jopt, ignore.case=TRUE))){
      warning("Please reload KoNLP first than any other packages based on rJava.\n
              You can't use some functions if you don't.")
    }
    memjopt <- jopt[which(grepl("^-Xmx",jopt))]
    if(length(memjopt) > 0){
      options(java.parameters=c(memjopt, initopt[2]))
    }else{
      options(java.parameters=c(jopt, initopt))
    }
  }
  .jpackage(pkgname, lib.loc = libname)
}



.onAttach <- function(libname, pkgname){
  DicConfPath <- file.path(system.file(package=.DicPkgName),"dics")
  dics <- file.path(DicConfPath,"handic.zip")
  DicUser <- "dic_user.txt"
  UserDic <- file.path("data","kE", DicUser)

  CurrentUserDicPath <- file.path(system.file(package=pkgname), "..","KoNLP_dic","current")
  backupUserDicPath <- file.path(system.file(package=pkgname), "..","KoNLP_dic","backup")
  currentUserDic <- file.path(CurrentUserDicPath,DicUser)
  #checking process for user defined dictionary
  if(!file.exists(currentUserDic)){
    packageStartupMessage("Building dictionary structures.\n")
    ret <- TRUE
    ret2 <- TRUE
    if(!file.exists(CurrentUserDicPath)){
      ret <- dir.create(CurrentUserDicPath,recursive = TRUE)
      ret2 <- dir.create(backupUserDicPath,recursive = TRUE)
    }
    write.table(readZipDic(dics, UserDic), 
                file=currentUserDic, quote=F, sep="\t", row.names=F, col.names=F, fileEncoding="UTF-8")

    if(ret != T && ret2 != T){
      warning(sprintf("Could not create %s\n", DicUser))
      assign("CopyedUserDic", FALSE, KoNLP:::.KoNLPEnv)
    }
    assign("CopyedUserDic", TRUE, KoNLP:::.KoNLPEnv)
  }else{
    packageStartupMessage("Checking user defined dictionary!\n")
    assign("CopyedUserDic", TRUE, KoNLP:::.KoNLPEnv)
  }
  assign("DicRelPath", UserDic, KoNLP:::.KoNLPEnv)
  assign("SejongDicPath", DicConfPath, KoNLP:::.KoNLPEnv)
  assign("UserDicPathinSejongZip", UserDic, KoNLP:::.KoNLPEnv)
  assign("CurrentUserDic", currentUserDic, KoNLP:::.KoNLPEnv)
  assign("CurrentUserDicPath", CurrentUserDicPath, KoNLP:::.KoNLPEnv)
  assign("SejongDicsZip", dics, KoNLP:::.KoNLPEnv)
  assign("backupUserDicPath", backupUserDicPath, KoNLP:::.KoNLPEnv)
  assign("backupUserDic", file.path(backupUserDicPath,DicUser), KoNLP:::.KoNLPEnv)

  if(all((localeToCharset()[1] == c("UTF-8", "CP949", "EUC-KR")) == FALSE)){
    packageStartupMessage("This R shell doesn't contain any Hangul encoding.\nFor fully use, any of 'UTF-8', 'CP949', 'EUC-KR' needs to be used for R shell encoding.")
  }
}





