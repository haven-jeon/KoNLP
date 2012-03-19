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
#along with JHanNanum.  If not, see <http://www.gnu.org/licenses/>



# additional noun dictionary from Sejong project
#
# This dictionary extracted from 21th centry Sejong project. Dictionary can be merged with current user dictionary(dic_user.txt), but it requires a lot more total memory to safy use in KoNLP. 
#
# @name extra_dic
# @docType data
# @author Heewon Jeon \email{madjakarta@@gmail.com}
# @references \url{www.sejong.or.kr}
# @keywords dictionary



#' reload all Hannanum analyzer dictionary 
#'
#' Mainly, user dictionary reloading for Hannanum Analyzer. 
#' If you want to update user dictionary on KoNLP_pkg_dir/inst/dics/data/kE/dic_user.txt, need to execute this function after editing dic.
#'
#' @examples
#' \dontrun{
#' ## This codes can not be run if you don't have encoding system which can en/decode Hangul(ex) CP949, EUC-KR, UTF-8). 
#' dicpath <- paste(system.file(package="KoNLP"), "/dics/data/kE/dic_user2.txt", sep="")
#' newdic <- read.table(dicpath, sep="\t", header=FALSE, fileEncoding="UTF-8", stringsAsFactors=FALSE)
#' mergeUserDic(newdic)
#' ## backup merged new dictionary
#' backupUsrDic(ask=FALSE)
#' ## restore from backup directory
#' restoreUsrDic(ask=FALSE)
#' ## reloading new dictionary
#' reloadAllDic()}
#' @export
reloadAllDic <- function(){
  if(!exists("HannanumObj", envir=KoNLP:::.KoNLPEnv)){
    assign("HannanumObj",.jnew("HannanumInterface"),KoNLP:::.KoNLPEnv)
  }
  .jcall(get("HannanumObj",envir=KoNLP:::.KoNLPEnv), , "reloadAllDic")
}


#' tag name converter
#' 
#' only suppport tag convertion between KAIST and Sejong tag set.
#' 
#' @param fromTag tag set name to convert from
#' @param toTag desired tag set name 
#' @param tag tag name to search  
convertTag <-function(fromTag, toTag, tag){
  if(fromTag == toTag || (!any(c("K","S") == fromTag) || 
      !any(c("K","S") == toTag))){
    stop("check input parameter!")
  }
  dicname <- paste(fromTag,"to" ,toTag, sep="")
  return(get(dicname)[tag])
}




#' use for backup current dic_user.txt
#'  
#' Utility function for backup dic_user.txt file to backup directory.
#'
#' @examples
#' \dontrun{
#' ## This codes can not be run if you don't have encoding system which can en/decode Hangul(ex) CP949, EUC-KR, UTF-8). 
#' dicpath <- paste(system.file(package="KoNLP"), "/dics/data/kE/dic_user2.txt", sep="")
#' newdic <- read.table(dicpath, sep="\t", header=FALSE, fileEncoding="UTF-8", stringsAsFactors=FALSE)
#' mergeUserDic(newdic)
#' ## backup merged new dictionary
#' backupUsrDic(ask=FALSE)
#' ## restore from backup directory
#' restoreUsrDic(ask=FALSE)
#' ## reloading new dictionary
#' reloadAllDic()}
#' @param ask ask to confirm backup
#' @export
backupUsrDic <- function(ask=TRUE){
  UserDicPath <- get("UserDic",envir=KoNLP:::.KoNLPEnv)
  alteredUserDicPath <- get("backupUserDic", KoNLP:::.KoNLPEnv)
  response <- "Y"
  if(ask){
    response <- readline("Would you backup your current 'dic_user.txt' file to backup directory? (Y/n): ")
  }
  if(substr(response,1,1) == "Y"){
    dicpath <- get("backupUserDicPath",KoNLP:::.KoNLPEnv)
    ret1 <- TRUE
    if(!file.exists(dicpath)){
      ret1 <- dir.create(dicpath)
    }
    ret2 <- file.copy(UserDicPath, alteredUserDicPath,overwrite=T)
    if(ret1 && ret2){
      cat("finidhed backup!\n")  
    }else{
      warning(sprintf("Could not copy %s\n", UserDicPath))
      assign("CopyedUserDic", FALSE, KoNLP:::.KoNLPEnv)
    }
  }
}



#' use for restoring backuped dic_user.txt
#' 
#' Utility function for restoring dic_user.txt file to dictionary directory.
#'
#' @examples
#' \dontrun{
#' ## This codes can not be run if you don't have encoding system which can en/decode Hangul(ex) CP949, EUC-KR, UTF-8). 
#' dicpath <- paste(system.file(package="KoNLP"), "/dics/data/kE/dic_user2.txt", sep="")
#' newdic <- read.table(dicpath, sep="\t", header=FALSE, fileEncoding="UTF-8", stringsAsFactors=FALSE)
#' mergeUserDic(newdic)
#' ## backup merged new dictionary
#' backupUsrDic(ask=FALSE)
#' ## restore from backup directory
#' restoreUsrDic(ask=FALSE)
#' ## reloading new dictionary
#' reloadAllDic()}
#' @param ask ask to confirm backup
#' @export
restoreUsrDic <- function(ask=TRUE){
  if(!get("CopyedUserDic", KoNLP:::.KoNLPEnv)){
    stop("There is no backuped dic_user.txt!\n")
  }
  if(!file.exists(get("backupUserDic", KoNLP:::.KoNLPEnv))){
    stop("There is no backuped dic_user.txt to restore!\n")
  }
  UserDicPath <- get("UserDic",envir=KoNLP:::.KoNLPEnv)
  alteredUserDicPath <- get("backupUserDic", KoNLP:::.KoNLPEnv)
  response <- "Y"
  if(ask){
    response <- readline("Would you restore your backuped 'dic_user.txt' file to current dictionary directory? (Y/n): ")
  }
  if(substr(response,1,1) == "Y"){
    ret <- file.copy(alteredUserDicPath, UserDicPath, overwrite=T)
    if(ret){
      cat("finidhed restoring!\n")  
    }else{
      warning(sprintf("Could not copy %s\n", UserDicPath))
    }
  }
}


#' "dic_user.txt" merging function
#'
#' merging current dic_user.txt with new dictionary.
#'
#' @examples
#' \dontrun{
#' ## This codes can not be run if you don't have encoding system which can en/decode Hangul(ex) CP949, EUC-KR, UTF-8). 
#' dicpath <- paste(system.file(package="KoNLP"), "/dics/data/kE/dic_user2.txt", sep="")
#' newdic <- read.table(dicpath, sep="\t", header=FALSE, fileEncoding="UTF-8", stringsAsFactors=FALSE)
#' mergeUserDic(newdic)
#' ## backup merged new dictionary
#' backupUsrDic(ask=FALSE)
#' ## restore from backup directory
#' restoreUsrDic(ask=FALSE)
#' ## reloading new dictionary
#' reloadAllDic()}
#' @param newUserDic new user dictionary as data.frame
#' @param append append or replacing 
#' @param verbose see detail error logs
#' @export
mergeUserDic <- function(newUserDic, append=TRUE, verbose=FALSE){
  if(!is.data.frame(newUserDic)){
    stop("newUserDic must be data frame object!\n")
  }
  if(ncol(newUserDic)!= 2){
    stop("newUserDic must be 2 column data frame!\n")
  }
  #check all the tags 
  errorTags <- Filter(function(x){is.na(tags[x])}, newUserDic[,2])
  if(length(errorTags) > 0){
    if(verbose){
      cat(errorTags,"\n" ,sep="\t")
    }
    stop("Unsupported tag names!\n")
  }
  #combine with current dic_user.txt or replace them all.   
  UserDicPath <- get("UserDic",envir=KoNLP:::.KoNLPEnv)
  oldUserDic <- read.table(UserDicPath, sep="\t", header=F, fileEncoding="UTF-8", stringsAsFactors=F)

  newDicEnc <- unique(Encoding(newUserDic[,1]))
  if(length(newDicEnc) > 1){
    stop("check newUserDic encodings!\n")
  }
  #encoding problems 
  localCharset <- localeToCharset()[1]
  if(localCharset != "UTF-8"){
    if(newDicEnc != "UTF-8"){
      newUserDic <- as.data.frame(apply(newUserDic, 2, iconv, from=localCharset, to="UTF-8"))
    }
    oldUserDic <- as.data.frame(apply(oldUserDic, 2, iconv, from=localCharset, to="UTF-8"))
  }

  if(append){
    newestUserDic <- rbind(oldUserDic, newUserDic)
  }else{
    newestUserDic <- newUserDic
  }
  write.table(newestUserDic,file=UserDicPath,quote=F,row.names=F, sep="\t", col.names=F,fileEncoding="UTF-8")  
  cat(sprintf("%s words were added to dic_user.txt.\n", nrow(newUserDic)))
}








