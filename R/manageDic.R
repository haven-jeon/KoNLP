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
# This dictionary extracted from 21th centry Sejong project. Dictionary can be merged with current user dictionary(dic_usr.txt), but it requires a lot more total memory to safy use in KoNLP. 
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
#' \dontrun{dicpath <- paste(system.file(package="KoNLP"), "/dics/data/kE/dic_user2.txt", sep="")
#' newdic <- read.table(dicpath, sep="\t")
#' mergeUserDic(newdic)
#' ## backup merged new dictionary
#' backupUsrDic()
#' ## restore from backup directory
#' restoreUsrDic()
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
#' \dontrun{dicpath <- paste(system.file(package="KoNLP"), "/dics/data/kE/dic_user2.txt", sep="")
#' newdic <- read.table(dicpath, sep="\t")
#' mergeUserDic(newdic)
#' ## backup merged new dictionary
#' backupUsrDic()
#' ## restore from backup directory
#' restoreUsrDic()
#' ## reloading new dictionary
#' reloadAllDic()}
#' @export
backupUsrDic <- function(){
  UserDicPath <- get("UserDic",envir=KoNLP:::.KoNLPEnv)
  alteredUserDicPath <- get("backupUserDic", KoNLP:::.KoNLPEnv)
  
  cat("Would you backup your current 'dic_user.txt' file to backup directory? (Y/n): ")
  stdinf <- file("stdin")
  response <- readLines(stdinf,1)
  close(stdinf) 
  ret <- T
  if(response == "Y"){
    ret <- file.copy(UserDicPath, alteredUserDicPath,overwrite=T)
    if(ret){
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
#' \dontrun{dicpath <- paste(system.file(package="KoNLP"), "/dics/data/kE/dic_user2.txt", sep="")
#' newdic <- read.table(dicpath, sep="\t")
#' mergeUserDic(newdic)
#' ## backup merged new dictionary
#' backupUsrDic()
#' ## restore from backup directory
#' restoreUsrDic()
#' ## reloading new dictionary
#' reloadAllDic()}
#' @export
restoreUsrDic <- function(){
  if(!get("CopyedUserDic", KoNLP:::.KoNLPEnv)){
    stop("There is no backuped dic_user.txt!\n")
  }
  UserDicPath <- get("UserDic",envir=KoNLP:::.KoNLPEnv)
  alteredUserDicPath <- get("backupUserDic", KoNLP:::.KoNLPEnv)

  cat("Would you restore your backuped 'dic_user.txt' file to current dictionary directory? (Y/n): ")
  stdinf <- file("stdin")
  response <- readLines(stdinf,1)
  close(stdinf)
  ret <- T
  if(response == "Y"){
    ret <- file.copy(alteredUserDicPath, UserDicPath, overwrite=T)
    if(ret){
      cat("finidhed restoring!\n")  
    }else{
      warning(sprintf("Could not copy %s\n", UserDicPath))
    }
  }
}


#' "dic_usr.txt" merging function
#'
#' merging current dic_user.txt with new dictionary.
#'
#' @examples
#' \dontrun{dicpath <- paste(system.file(package="KoNLP"), "/dics/data/kE/dic_user2.txt", sep="")
#' newdic <- read.table(dicpath, sep="\t")
#' mergeUserDic(newdic)
#' ## backup merged new dictionary
#' backupUsrDic()
#' ## restore from backup directory
#' restoreUsrDic()
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
  oldUserDic <- read.table(UserDicPath, sep="\t", encoding="UTF-8")
  if(append){
    newestUserDic <- rbind(oldUserDic, newUserDic)
  }else{
    newestUserDic <- newUserDic
  }
  write.table(newestUserDic,file=UserDicPath,quote=F,row.names=F, sep="\t", col.names=F)
  cat(sprintf("%s words were added to dic_usr.txt.\n", nrow(newUserDic)))
}








