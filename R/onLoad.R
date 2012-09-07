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
  tryCatch(.jinit(parameters=c("-Dfile.encoding=UTF-8", "-Xmx1024m")), 
    error=function(e){
      .jinit(parameters=c("-Dfile.encoding=UTF-8", "-Xmx512m"))
      packageStartupMessage("Your system doesn't have much memory to run KoNLP.\nTherefore, some dictionary managing functions will not work appropreately.")
    },finally=packageStartupMessage("Java initialized.\n"))
  .jpackage(pkgname, lib.loc = libname)
}



.onAttach <- function(libname, pkgname){
  DicConfPath <- paste(system.file(package=.DicPkgName),"/dics", sep="")
  dics <- paste(DicConfPath,"/handic.zip", sep="")
  DicUser <- "dic_user.txt"
  UserDic <- paste("data/kE/", DicUser, sep="")

  CurrentUserDicPath <- paste(system.file(package=pkgname), "/../KoNLP_dic/current", sep="")
  backupUserDicPath <- paste(system.file(package=pkgname), "/../KoNLP_dic/backup", sep="")
  currentUserDic <- paste(CurrentUserDicPath,"/",DicUser, sep="")
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
  assign("backupUserDic", paste(backupUserDicPath,"/", DicUser, sep=""), KoNLP:::.KoNLPEnv)

  if(all((localeToCharset()[1] == c("UTF-8", "CP949", "EUC-KR")) == FALSE)){
    packageStartupMessage("This R shell doesn't contain any Hangul encoding.\nFor fully use, any of 'UTF-8', 'CP949', 'EUC-KR' needs to be used for R shell encoding.")
  }
}





