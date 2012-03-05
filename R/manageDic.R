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


#' reload all Hannanum analyzer dictionary 
#'
#' Mainly, user dictionary reloading for Hannanum Analyzer. 
#' If you want to update user dictionary on KoNLP_pkg_dir/inst/dics/data/kE/dic_user.txt, need to execute this function after editing dic.
#'
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





#' "dic_usr.txt" editor function
#'
#'  merging or replacing current dic_user.txt file.
#'
#' @param newUserDic new user dictionary as data.frame
#' @param append append or replacing 
#' @param verbose see detail error logs
#' @export
buildUserDic <- function(newUserDic, append=TRUE, verbose=FALSE){
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
  oldUserDic <- read.table(UserDicPath, sep="\t")
  names(newUserDic) <- c("V1", "V2")
  if(append){
    newestUserDic <- rbind(oldUserDic, newUserDic)
  }else{
    newestUserDic <- newUserDic
  }
  write.table(newestUserDic,file=UserDicPath,quote=F,row.names=F)
  #copy current new dic to backup dir
  ret <- file.copy(UserDicPath, get("backupUserDic", KoNLP:::.KoNLPEnv), overwrite=T)
  if(ret != T){
    warning("Could not copy user_dic.txt to backup directory!\n")
  }
}








