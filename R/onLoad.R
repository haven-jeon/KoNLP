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
  #uncompress Sejong Hannanum dictionary, if necessary
  dicpath <- paste(system.file(package=.DicPkgName),"/dics/", sep="")
  dics <- paste(dicpath,"handic.zip", sep="")
  if(file.exists(dics)){
    unzip(dics,exdir=dicpath,list=F, overwrite=T)
    file.remove(dics)
    packageStartupMessage("Successfully uncompressed Sejong package dictionaries.\n")
  }


  DicConfPath <- paste(system.file(package=.DicPkgName),"/dics", sep="")
  DicUser <- "dic_user.txt"
  UserDicPath <- paste(system.file(package=.DicPkgName),"/dics/data/kE/", sep="")
  UserDic <- paste(UserDicPath, DicUser, sep="")
  if(!file.exists(UserDic)){ 
    stop(sprintf("%s does not exist!\nRe-install KoNLP package.\n", UserDic))
  }
  alteredUserDicPath <- paste(system.file(package=pkgname), "/../KoNLP_dic", sep="")
  alteredUserDic <- paste(alteredUserDicPath,"/",DicUser, sep="")
  #checking process for user defined dictionary
  if(!file.exists(alteredUserDic)){
    packageStartupMessage(sprintf("Copying %s to backup directory!\n", DicUser))
    ret <- TRUE
    if(!file.exists(alteredUserDicPath)){
      ret <- dir.create(alteredUserDicPath)
    }
    ret2 <- file.copy(UserDic, alteredUserDicPath)
    if(ret != T && ret2 != T){
      warning(sprintf("Could not create %s\n", DicUser))
      assign("CopyedUserDic", FALSE, KoNLP:::.KoNLPEnv)
    }
    assign("CopyedUserDic", TRUE, KoNLP:::.KoNLPEnv)
  }else{
    packageStartupMessage("Checking user defined dictionary!\n")
    assign("CopyedUserDic", TRUE, KoNLP:::.KoNLPEnv)
  }
  assign("DicConfPath", DicConfPath, KoNLP:::.KoNLPEnv)
  assign("UserDic", UserDic, KoNLP:::.KoNLPEnv)
  assign("backupUserDic", alteredUserDic, KoNLP:::.KoNLPEnv)
  assign("backupUserDicPath", alteredUserDicPath, KoNLP:::.KoNLPEnv)
  if(all((localeToCharset()[1] == c("UTF-8", "CP949", "EUC-KR")) == FALSE)){
    packageStartupMessage("This R shell doesn't contain any Hangul encoding.\nFor fully use, any of 'UTF-8', 'CP949', 'EUC-KR' needs to be used for R shell encoding.")
  }
}





