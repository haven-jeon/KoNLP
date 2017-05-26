#Copyright 2011 Heewon Jeon(madjakarta@gmail.com)
#
#This file is part of KoNLP.
#
#KoNLP is free software: you can redistribute it and/or modify it under the
#terms of the GNU General Public License as published by the Free Software
#Foundation, either version 3 of the License, or (at your option) any later
#version.

#KoNLP is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with KoNLP.  If not, see <http://www.gnu.org/licenses/>



# additional noun dictionary from Sejong project
#
# This dictionary extracted from 21th centry Sejong project. Dictionary can be merged with current user dictionary(dic_user.txt), but it requires a lot more total memory to safy use in KoNLP. 
#
# @name extra_dic
# @docType data
# @author Heewon Jeon \email{madjakarta@@gmail.com}
# @references \url{www.sejong.or.kr}
# @keywords dictionary

.SystemDicRec <- 283949

#' reload all Hannanum analyzer dictionary 
#'
#' Mainly, user dictionary reloading for Hannanum Analyzer. 
#' If you want to update user dictionary on KoNLP_dic/current/dic_user.txt, need to execute this function after editing dictionary.
#'
#' @examples
#' \dontrun{
#' ## This codes can not be run if you don't have encoding system 
#' ## which can en/decode Hangul(ex) CP949, EUC-KR, UTF-8).  
#' dicpath <- file.path(system.file(package="Sejong"), "dics", "handic.zip")
#' conn <- unz(dicpath, file.path("data","kE","dic_user2.txt"))
#' newdic <- read.csv(conn, sep="\t", header=FALSE, fileEncoding="UTF-8", stringsAsFactors=FALSE)
#' mergeUserDic(newdic)
#' ## backup merged new dictionary
#' backupUsrDic(ask=FALSE)
#' ## restore from backup directory
#' restoreUsrDic(ask=FALSE)
#' ## reloading new dictionary
#' reloadAllDic()}
#' @export
reloadAllDic <- function(){
  if(!exists("HannanumObj", envir=.KoNLPEnv)){
    assign("HannanumObj",.jnew("kr/pe/freesearch/jhannanum/comm/HannanumInterface"),.KoNLPEnv)
  }
  .jcall(get("HannanumObj",envir=.KoNLPEnv), "V", "reloadAllDic")
}



#' reload dictionaries for specific functions
#'
#' This function for reloading user dictionary for specific functions,
#' after you have updated user dictionary on KoNLP_dic/current/user_dic.txt.
#' 
#' @param whichDics character vector which can be "extractNoun", "SimplePos09", "SimplePos22", "SimplePos22"
#' @examples 
#' \dontrun{
#' reloadUserDic(c("extractNoun", "SimplePos22"))} 
#' @export
reloadUserDic <- function(whichDics){
  if(!exists("HannanumObj", envir=.KoNLPEnv)){
    assign("HannanumObj",.jnew("kr/pe/freesearch/jhannanum/comm/HannanumInterface"),.KoNLPEnv)
  }
  if(!is.character(whichDics)){
    stop("'whichDics' must be character!")
  }
  for(dic in whichDics){
    ret <- .jcall(get("HannanumObj",envir=.KoNLPEnv), 
                  "I", "reloadUserDic", get("CurrentUserDic", envir=.KoNLPEnv), dic)
    if(ret < 0){
      cat(sprintf("Dictionaries in %s was not reloaded\n", dic))
    }
  }
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


#' use Sejong noun dictionary
#'
#' Retrive Sejong dictionary to use in KoNLP
#' 
#' @param backup will backup current dictionary?
#' @references \url{http://www.sejong.or.kr/}
#' @export
useSejongDic <- function(backup=T){
  if(backup == T){
    backupUsrDic(ask=F)
  }
  buildDictionary(ext_dic="sejong")
}


# use Insighter dictionary
#
# @param backup will backup current working dictionary?
#
# @export
# useInsighterDic <- function(backup=T){
#   if(backup == T){
#     backupUsrDic(ask=F)
#   }
#   buildDictionary(ext_dic="insighter")
# }


# use Woorimalsam dictionary
#
# @param backup will backup current working dictionary?
#
# @export
# useWoorimalsamDic <- function(backup=T){
#   if(backup == T){
#     backupUsrDic(ask=F)
#   }
#   buildDictionary(ext_dic="woorimalsam")
# }




#' use Insighter and Woorimalsam dictionary
#'
#' @param backup boolean will backup current working dictionary?
#' @param which_dic character vectors. 'woorimalsam', 'insighter' can be apply.  
#' @param category_dic_nms character vectors. category dictionary will be used. default is 'all' which means all categories.
#'    \itemize{
#'  \item general
#'  \item chemical
#'  \item language
#'  \item music
#'  \item history
#'  \item education
#'  \item society in general
#'  \item life
#'  \item physical
#'  \item information and communication
#'  \item medicine
#'  \item earth
#'  \item construction
#'  \item veterinary science
#'  \item business
#'  \item law
#'  \item plant
#'  \item buddhism
#'  \item engineering general
#'  \item folk
#'  \item administration
#'  \item economic
#'  \item math
#'  \item korean medicine
#'  \item military
#'  \item literature
#'  \item clothes
#'  \item religion normal
#'  \item animal
#'  \item agriculture
#'  \item astronomy
#'  \item transport
#'  \item natural plain
#'  \item industry
#'  \item medium
#'  \item political
#'  \item geography
#'  \item mining
#'  \item hearing
#'  \item fishing
#'  \item machinery
#'  \item catholic
#'  \item book title
#'  \item named
#'  \item electrical and electronic
#'  \item pharmacy
#'  \item art, music and physical
#'  \item useless
#'  \item ocean
#'  \item forestry
#'  \item christian
#'  \item craft
#'  \item service
#'  \item sports
#'  \item food
#'  \item art
#'  \item environment
#'  \item video
#'  \item natural resources
#'  \item industry general
#'  \item smoke
#'  \item philosophy
#'  \item health general
#'  \item proper names general
#'  \item welfare
#'  \item material
#'  \item humanities general
#' }
#' @export
#' @examples
#' \dontrun{
#' useNIADic(which_dic=c('woorimalsam','insighter'), category_dic_nms=c('art', 'food'))
#' } 
useNIADic <- function(which_dic=c("woorimalsam", "insighter"), category_dic_nms='all', backup=T){
  if(backup == T){
    backupUsrDic(ask=F)
  }
  buildDictionary(ext_dic=which_dic,category_dic_nms = category_dic_nms)
}



# internal function to change dictionary
useDic <- function(dicname, backup=T){
  if(dicname == "Sejong"){
    #actually Sejong + System Dictionary 
    relpath <- file.path("data","kE","dic_user2.txt")
  }else if(dicname == "System"){
    #actually user dictionary 
    relpath <- file.path("data","kE","dic_user.txt") 
  }else{
    stop("wrong dictionary name!")
  }
  newdic <- readZipDic(get("SejongDicsZip", envir=.KoNLPEnv), relpath)
  if(backup == T){
    backupUsrDic(ask=F)
  }
  mergeUserDic(newdic,append=F)
}

#' use system default dictionary
#'
#' Retrive system default dictionary to use in KoNLP
#' 
#' @param backup will backup current dictionary?
#' @export
useSystemDic <- function(backup=T){
  if(backup == T){
    backupUsrDic(ask=F)
  }
  buildDictionary(ext_dic="")
}

#' use for backup current dic_user.txt
#'  
#' Utility function for backup dic_user.txt file to backup directory.
#'
#' @examples
#' \dontrun{
#' ## This codes can not be run if you don't have encoding system 
#' ## which can en/decode Hangul(ex) CP949, EUC-KR, UTF-8). 
#' dicpath <- file.path(system.file(package="Sejong"), "dics", "handic.zip")
#' conn <- unz(dicpath, file.path("data","kE","dic_user2.txt"))
#' newdic <- read.csv(conn, sep="\t", header=FALSE, fileEncoding="UTF-8", stringsAsFactors=FALSE)
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
  
  UserDic <- get("CurrentUserDic",envir=.KoNLPEnv)
  alteredUserDicPath <- get("backupUserDicPath", .KoNLPEnv)
  response <- "Y"
  if(ask){
    response <- readline("Would you backup your current 'dic_user.txt' file to backup directory? (Y/n): ")
  }
  if(substr(response,1,1) == "Y"){
    ret1 <- TRUE
    if(!file.exists(alteredUserDicPath)){
      ret1 <- dir.create(alteredUserDicPath)
    }
    ret2 <- file.copy(UserDic, alteredUserDicPath,overwrite=T)
    if(ret1 && ret2){
      cat("Backup was just finished!\n")  
    }else{
      warning(sprintf("Could not copy %s\n", UserDic))
      assign("CopyedUserDic", FALSE, .KoNLPEnv)
    }
  }
}



#' use for restoring backuped dic_user.txt
#' 
#' Utility function for restoring dic_user.txt file to dictionary directory.
#'
#' @examples
#' \dontrun{
#' ## This codes can not be run if you don't have encoding system 
#' ## which can en/decode Hangul(ex) CP949, EUC-KR, UTF-8). 
#' dicpath <- file.path(system.file(package="Sejong"), "dics", "handic.zip")
#' conn <- unz(dicpath, file.path("data","kE","dic_user2.txt"))
#' newdic <- read.csv(conn, sep="\t", header=FALSE, fileEncoding="UTF-8", stringsAsFactors=FALSE)
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
  
  if(!get("CopyedUserDic", .KoNLPEnv)){
    stop("There is no backuped dic_user.txt!\n")
  }
  if(!file.exists(get("backupUserDic", .KoNLPEnv))){
    stop("There is no backuped dic_user.txt to restore!\n")
  }
  UserDicPath <- get("CurrentUserDicPath",envir=.KoNLPEnv)
  alteredUserDicPath <- get("backupUserDic", .KoNLPEnv)
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
  reloadAllDic()
}


#' appending or replacing with new data.frame
#'
#' appending new dictionary to current dictionary.
#' replaceing current dictionary with new dictionary.
#'
#' @examples
#' \dontrun{
#' ## This codes can not be run if you don't have encoding system 
#' ## which can en/decode Hangul(ex) CP949, EUC-KR, UTF-8). 
#' dicpath <- file.path(system.file(package="Sejong"), "dics", "handic.zip")
#' conn <- unz(dicpath, file.path("data","kE","dic_user2.txt"))
#' newdic <- read.csv(conn, sep="\t", header=FALSE, fileEncoding="UTF-8", stringsAsFactors=FALSE)
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
#' @param ask ask to backup
#' @export
#' @importFrom utils read.csv write.table
mergeUserDic <- function(newUserDic, append=TRUE, verbose=FALSE, ask=FALSE){
  .Deprecated("buildDictionary()")
  if(is.data.frame(newUserDic) == FALSE | ncol(newUserDic) != 2 | nrow(newUserDic) == 0 ){
    stop("check 'newUserDic'.\n")
  }
  if(class(newUserDic[,2]) == "factor"){
    newUserDic[,2] <- as.character(newUserDic[,2])
  }
  if(class(newUserDic[,1]) == "factor"){
    newUserDic[,1] <- as.character(newUserDic[,1])
  }
  
  # checking belows are taking too much time.
  #if(all(sapply(newUserDic[,2], is.ascii)) == FALSE){
  #  stop("check 'newUserDic'.\n")
  #}

  response <- "n"
  if(ask){
    response <- readline("Would you backup your current 'dic_user.txt' file to backup directory? (Y/n/c): ")
  }
  if(substr(response,1,1) == "Y"){
    backupUsrDic(ask=F)
  }else if(substr(response,1,1) == "c"){
    return()
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
  UserDic <- get("CurrentUserDic",envir=.KoNLPEnv)
  oldUserDic <- read.csv(UserDic, sep="\t", header=F, fileEncoding="UTF-8", stringsAsFactors=F, comment.char="")

  newDicEnc <- unique(Encoding(newUserDic[,1]))
  if(length(newDicEnc) > 1){
    stop("check newUserDic encodings!\n")
  }
  #encoding problems 
  localCharset <- localeToCharset()[1]
  if(localCharset != "UTF-8"){
    if(newDicEnc != "UTF-8"){
      newUserDic[,1] <- iconv(newUserDic[,1],from=localCharset, to="UTF-8")
    }
    oldUserDic[,1] <- iconv(oldUserDic[,1], from=localCharset, to="UTF-8")
  }

  names(newUserDic) <- c("word","tag")
  names(oldUserDic) <- c("word","tag")

  if(append){
    newestUserDic <- rbind(oldUserDic, newUserDic)
  }else{
    newestUserDic <- newUserDic
  }
  write.table(newestUserDic,file=UserDic,quote=F,row.names=F, sep="\t", col.names=F,fileEncoding="UTF-8")  
  cat(sprintf("%s words were added to dic_user.txt.\n", nrow(newUserDic)))
  reloadAllDic()
}




readZipDic <- function(zipPath, dicPath){
  dicvector <- .jcall("kr/pe/freesearch/KoNLP/KoNLPUtil", 
                      "[S", "readZipDic", zipPath, dicPath)
  Encoding(dicvector) <- "UTF-8"
  return(as.data.frame(matrix(dicvector,ncol=2,byrow=T), stringsAsFactors=F))
}




#' summary of dictionaries
#' 
#' show summary, head and tail of current or backup dictionaries 
#' 
#' @examples 
#' \dontrun{
#' ## show current dictionary's summary, head, tail 
#' statDic("current", 10)
#' }
#' @param which "current" or "backup" dictionary
#' @param n a single integer. Size for the resulting object to view 
#' @export
statDic <- function(which="current", n=6){
  UserDic <- ""

  if(which == "current"){
    UserDic <- get("CurrentUserDic",envir=.KoNLPEnv)
  }else if(which == "backup"){
    UserDic <- get("backupUserDic", envir=.KoNLPEnv)
  }else{
    stop("No dictionary to summary!")    
  }
  
  if(!file.exists(UserDic)){
    stop("No dictionary to summary!\n Please check dictionary files.")
  }
    
  
  UserDicView <- read.csv(UserDic, sep="\t", header=F, fileEncoding="UTF-8", stringsAsFactors=F, comment.char="", colClasses='character')

  #encoding problems 
  localCharset <- localeToCharset()[1]
  if(localCharset != "UTF-8"){
    UserDicView[,1] <- iconv(UserDicView[,1], from=localCharset, to="UTF-8")
  }
  names(UserDicView) <- c("word","tag")
  UserDicView[,2] <- as.factor(UserDicView[,2])
  
  res <- list(summary=summary(UserDicView), head=head(UserDicView, n=n), tail=tail(UserDicView, n=n))
  
    return(res)
}  
  
  
  
  
#'   buildDictionary
#'  
#' @param ext_dic external dictionary character name which can be 'woorimalsam', 'insighter', 'sejong'.
#' @param category_dic_nms character vectors. category dictionary will be used. 'all' means all categories will be added.
#'    \itemize{
#'  \item all 
#'  \item general
#'  \item chemical
#'  \item language
#'  \item music
#'  \item history
#'  \item education
#'  \item society in general
#'  \item life
#'  \item physical
#'  \item information and communication
#'  \item medicine
#'  \item earth
#'  \item construction
#'  \item veterinary science
#'  \item business
#'  \item law
#'  \item plant
#'  \item buddhism
#'  \item engineering general
#'  \item folk
#'  \item administration
#'  \item economic
#'  \item math
#'  \item korean medicine
#'  \item military
#'  \item literature
#'  \item clothes
#'  \item religion normal
#'  \item animal
#'  \item agriculture
#'  \item astronomy
#'  \item transport
#'  \item natural plain
#'  \item industry
#'  \item medium
#'  \item political
#'  \item geography
#'  \item mining
#'  \item hearing
#'  \item fishing
#'  \item machinery
#'  \item catholic
#'  \item book title
#'  \item named
#'  \item electrical and electronic
#'  \item pharmacy
#'  \item art, music and physical
#'  \item useless
#'  \item ocean
#'  \item forestry
#'  \item christian
#'  \item craft
#'  \item service
#'  \item sports
#'  \item food
#'  \item art
#'  \item environment
#'  \item video
#'  \item natural resources
#'  \item industry general
#'  \item smoke
#'  \item philosophy
#'  \item health general
#'  \item proper names general
#'  \item welfare
#'  \item material
#'  \item humanities general
#' }
#' @param user_dic \code{data.frame} which include 'word' and 'tag(KAIST)' fields. User can add more user defined terms and tags.
#' @param replace_usr_dic A logical scala. Should user dictionary needs to be replaced with new user defined dictionary or appended.
#' @param verbose will print detail progress. default \code{FALSE}
#'
#' @export
#' @importFrom RSQLite dbConnect dbGetQuery dbWriteTable dbDisconnect SQLite 
#' @importFrom utils installed.packages
#' @examples 
#' \dontrun{
#' dics <- c('sejong','woorimalsam')
#' category <- c('sports')
#' user_d <- data.frame(term="apple", tag='ncn')
#' buildDictionary(ext_dic = dics,category_dic_nms = category, user_dic = user_d, replace_usr_dic=F)
#' #accumulate user dictionary only
#' buildDictionary(ext_dic= "", user_dic = user_d, replace_usr_dic=F)
#' #get user dictionary as data.frame
#' usr_words  <- get_dictionary('user_dic')
#' }
buildDictionary <- function(ext_dic='woorimalsam', category_dic_nms='', user_dic=data.frame(), replace_usr_dic=F, verbose=F){
  install_NIADic()     
  
  han_db_path <- file.path(system.file(package="NIADic"), "hangul.db")
  
  conn <- dbConnect(SQLite(), han_db_path)
  on.exit(dbDisconnect(conn))

  ext_dic_df <- data.frame()
  
  for(dic in unique(ext_dic)){
    switch(dic, 
           sejong={
              dic_df <- dbGetQuery(conn, "select term, tag,  'sejong' as dic from sejong")
              ext_dic_df <- rbind(ext_dic_df, dic_df)
             },
           insighter={
              dic_df <- dbGetQuery(conn, "select term, tag, 'insighter' as dic from insighter")
              ext_dic_df <- rbind(ext_dic_df, dic_df)
             },
           woorimalsam={
              dic_df <- dbGetQuery(conn, "select term, tag, 'woorimalsam' as dic from woorimalsam where eng_cate = 'general'")
              ext_dic_df <- rbind(ext_dic_df, dic_df)
             },
              {
              #stop(sprintf("No %s dictionary!", ext_dic))
            }
    )
  }
  cate_dic_df <- data.frame()
  
  not_in_cate <- category_dic_nms[!(category_dic_nms %in% dbGetQuery(conn, "select DISTINCT eng_cate from woorimalsam")$eng_cate)]
  
  not_in_cate <- Filter(function(x) {x != 'all'}, not_in_cate)
  
  if(length(not_in_cate) >= 1 & !(length(not_in_cate) & nchar(not_in_cate[1]) == 0)){
    warning(sprintf("%s are not on dictionary category. check '?buildDictionary'", paste0("'",not_in_cate,"'", collapse=',')))
  }
  
  if(is.character(category_dic_nms) & nchar(category_dic_nms[1]) > 0 & !any(category_dic_nms %in%  'all')){
    cate_dic_df <- dbGetQuery(conn, sprintf("select term, tag, eng_cate as dic from woorimalsam where eng_cate in (%s)",
                                            paste0("'",category_dic_nms,"'", collapse=',')))  
  }else if(is.character(category_dic_nms) & nchar(category_dic_nms[1]) > 0 &  any(category_dic_nms %in%  'all')){
    cate_dic_df <- dbGetQuery(conn, "select term, tag, eng_cate as dic from woorimalsam where eng_cate != 'general'")
  }

  user_dic_tot <- data.frame()
  
  #uer dic processing 
  if(is.data.frame(user_dic) == TRUE & ncol(user_dic) == 2 & nrow(user_dic) > 0 ){
    if(class(user_dic[,2]) == "factor"){
      user_dic[,2] <- as.character(user_dic[,2])
    }
    if(class(user_dic[,1]) == "factor"){
      user_dic[,1] <- as.character(user_dic[,1])
    }
    
    
    usrDicEnc <- unique(Encoding(user_dic[,1]))
    if(length(usrDicEnc) > 1){
      stop("check user_dic encodings!\n")
    }
    
    #encoding problems 
    localCharset <- localeToCharset()[1]
    if(localCharset != "UTF-8"){
      if(usrDicEnc != "UTF-8"){
        user_dic[,1] <- iconv(user_dic[,1],from=localCharset, to="UTF-8")
      }
    }
  
    
    #check tag is valid for user dic
    errorTags <- Filter(function(x){is.na(tags[x])}, user_dic[,2])
    if(length(errorTags) > 0){
      cat(errorTags,"\n" ,sep="\t")
      stop("Unsupported tag names on user_dic!\n")
    }
    
    names(user_dic) <- c("term","tag")
  
    dbWriteTable(conn, "user_dic", user_dic,append=!replace_usr_dic, overwrite=replace_usr_dic)
    
    user_dic_tot <- dbGetQuery(conn, "select *, 'user' as dic from user_dic")
      
  }
  
  result_dic <- rbind(ext_dic_df, cate_dic_df, user_dic_tot)
  
  #check tag is valid for user dic
  errorTags <- Filter(function(x){is.na(tags[x])}, result_dic[,2])
  if(length(errorTags) > 0){
    cat(errorTags,"\n" ,sep="\t")
    stop("Unsupported tag names on user_dic!\n")
  }
  
  if(nrow(result_dic) >= 1){
    Encoding(result_dic$term) <- 'UTF-8'
  }
 
  UserDic <- get("CurrentUserDic",envir=.KoNLPEnv)
  
  write.table(unique(result_dic[,c('term', 'tag')]),file=UserDic,quote=F,row.names=F, sep="\t", col.names=F,fileEncoding="UTF-8")  
  cat(sprintf("%s words dictionary was built.\n", nrow(result_dic) + .SystemDicRec))
  reloadAllDic()
}




#' @importFrom devtools install_url
install_NIADic <- function(){
  #check 'NIADic' package installed 
  #this code will remove after NIADic located on CRAN.
  
  if (!nzchar(system.file(package = 'NIADic'))){
    niadic_pkg_url <- "https://github.com/haven-jeon/NIADic/releases/download/0.0.1/NIADic_0.0.1.tar.gz"
    if(all(c('ggplot2', 'data.table', 'scales', 'rmarkdown', 'knitr') %in% installed.packages()[,1])){
      tryCatch({
        install_url(niadic_pkg_url, dependencies=TRUE, build_vignettes=TRUE)
      },
      #some case system doesn't have Pandoc or pandoc-citeproc
      error=function(cond){
        message(cond)
        install_url(niadic_pkg_url, dependencies=TRUE)
      },finally={
        if(!nzchar(system.file(package = 'NIADic'))){
          stop("can't install NIADic package!\n Please refer 'https://github.com/haven-jeon/NIADic' to install.")
        }
      })
    }else{
      install_url(niadic_pkg_url, dependencies=TRUE)
    }
    if(!nzchar(system.file(package = 'NIADic'))) stop("'NIADic' Package not found")
  }
}



#' Get Dictionary
#'
#' @param dic_name one of dictionary name(character), \strong{woorimalsam}, \strong{insighter}, \strong{sejong}, \strong{user_dic}
#'
#' @return The \code{data.frame} object contains tags and terms
#' @export
#'
#' @examples
#' \dontrun{
#'    dic_df <- get_dictionary('sejong')
#' }
#' @importFrom  RSQLite dbGetQuery SQLite dbDisconnect dbListTables
get_dictionary <- function(dic_name){
  #chaeck and install NIADic
  install_NIADic()
  
  dic_path <- file.path(system.file(package='NIADic'), "hangul.db")
  conn <- dbConnect(SQLite(), dic_path)
  on.exit({dbDisconnect(conn)})
  if(!(dic_name %in% dbListTables(conn))){
    stop(sprintf("NIADic does not contain '%s' dictionary!", dic_name))
  }
  dic <- dbGetQuery(conn, sprintf("select * from %s", dic_name))
  Encoding(dic$term) <- 'UTF-8'
  if(dic_name == 'woorimalsam'){
    Encoding(dic$category) <- 'UTF-8'
  }
  return(dic)
}



