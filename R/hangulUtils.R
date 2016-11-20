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


# if unable to process, this will return FALSE
# this function will be removed because InformalSentenceFilter will do this job.
preprocessing <- function(inputs){
  if(!is.character(inputs)) {
    warning("Input must be legitimate character!")
    return(FALSE)
  }
  newInput <- gsub("[[:space:]]", " ", inputs)
  newInput <- gsub("[[:space:]]+$", "", newInput)
  newInput <- gsub("^[[:space:]]+", "", newInput)
  # if((nchar(newInput) == 0) |  
  #         (nchar(newInput) > 20 & length(strsplit(newInput, " ")[[1]]) <= 1)){ 
  #   warning(sprintf("It's not kind of right sentence : '%s'", inputs))
  #   return(FALSE)
  # }
  return(newInput)
}



#checkEncoding <- function(inputs){
#  if(Encoding(inputs) == "unknown"){
#    expectenc <- detectInputEncoding(inputs)
#    if(is.null(expectenc)){
#      return(F)
#    }
#    if(expectenc != localeToCharset()[1]){
#      stop("Please check input encoding!")
#    }
#  }
#  return(T)
#}



# Rough UTF-8 checking function.
#
# function to be used for charactor vector encoding detection. This is for internal use.
#  
# @param sentenceU8 charactor vector
# @return TRUE or FALSE
is.utf8 <- function (sentenceU8) {
  if(!(Encoding(sentenceU8) == "UTF-8" | 
    (localeToCharset()[1] == "UTF-8" & Encoding(sentenceU8) == "unknown" ))){
    return(FALSE)
  }else{
    return(TRUE)
  }
}



#' check if sentence is all Hangul
#' 
#' Function checks if each charactor is Hangul or Jamo. 
#' Example will be shown in \href{https://github.com/haven-jeon/KoNLP/wiki}{github wiki}.
#'
#' @param sentence input charactors
#' @return TRUE or FALSE 
#' 
#' @export
is.hangul <- function(sentence){
  if(!is.character(sentence) | any(nchar(sentence) == 0)) {
    stop("Input must be legitimate character!")
  }else{
     isHangulString <- function(x){
      .jcall("kr/pe/freesearch/korean/KoHangul", "Z", "isHangulString", x)
     }
     res <- sapply(sentence, isHangulString, USE.NAMES = FALSE)
     return(res)
  }
  return(FALSE)  
}



#' check if sentence is all Jamo
#' 
#' Function checks with each charactor is Jamo. 
#' Example will be shown in \href{https://github.com/haven-jeon/KoNLP/wiki}{github wiki}.
#'
#' @param sentence input charactors
#' @return TRUE or FALSE 
#' 
#' @export
is.jamo <- function(sentence){
  if(!is.character(sentence) | any(nchar(sentence) == 0)) {
    stop("Input must be legitimate character!")
  }else{
    isJamoString <- function(x){
      .jcall("kr/pe/freesearch/korean/KoHangul", "Z", "isJamoString", x)
    }
    res <- sapply(sentence, isJamoString, USE.NAMES = FALSE)
    return(res)
  }
  return(FALSE)   
}

#' check if sentence is all Jaeum
#' 
#' Function checks with each charactor is Jaeum 
#'
#' @param sentence input charactors
#' @return TRUE or FALSE 
#' 
#' @export
is.jaeum <- function(sentence){
  if(!is.character(sentence) | any(nchar(sentence) == 0)) {
    stop("Input must be legitimate character!")
  }else{
    isJaeumString <- function(x){
      .jcall("kr/pe/freesearch/korean/KoHangul", "Z", "isJaeumString", x)
    }
    res <- sapply(sentence, isJaeumString, USE.NAMES = FALSE) 
    return(res)
  }
  return(FALSE)  
}


#' check if sentence is all Moeum
#' 
#' Function checks with each charactor is Moeum 
#'
#' @param sentence input charactors
#' @return TRUE or FALSE 
#' 
#' @export
is.moeum <- function(sentence){
  if(!is.character(sentence) | any(nchar(sentence) == 0)) {
    stop("Input must be legitimate character!")
  }else{
    isMoeumString <- function(x){
      .jcall("kr/pe/freesearch/korean/KoHangul", "Z", "isMoeumString", x)
    }
    res <- sapply(sentence, isMoeumString, USE.NAMES = FALSE) 
    return(res)
  }
  return(FALSE) 
}


#' check if sentence is all ASCII
#' 
#' Function checks with each charactor is ASCII
#'
#' @param sentence input charactors
#' @return TRUE or FALSE 
#' 
#' @export
is.ascii <- function(sentence){
  if(!is.character(sentence) | any(nchar(sentence) == 0)) {
    stop("Input must be legitimate character!")
  }else{
    isAsciiString <- function(x){
      .jcall("kr/pe/freesearch/korean/KoHangul", "Z", "isAsciiString", x)
    }
    res <- sapply(sentence, isAsciiString, USE.NAMES = FALSE) 
    return(res)
  }
  return(FALSE)   
}

#' convertion function  Hangul string to Jamos
#'
#' convert Hangul sentence to Jamos.
#' Example will be shown in \href{https://github.com/haven-jeon/KoNLP/wiki}{github wiki}.
#'
#' @param hangul Hangul string
#' @return Jamo sequences 
#' @export
convertHangulStringToJamos <- function(hangul){
  if(!is.character(hangul) | nchar(hangul) == 0){
    stop("Input must be legitimate character!")
  }else{
    jamos <- .jcall("kr/pe/freesearch/korean/KoHangul", "S","convertHangulStringToJamos",hangul,TRUE)
	  Encoding(jamos) <- "UTF-8" 
    return(unlist(strsplit(jamos,intToUtf8(0xFF5C))))
  }
}

#' convertion function Hangul string to keyStrokes
#'
#' Function can convert Hangul string to Keystrokes. 
#' Example will be shown in \href{https://github.com/haven-jeon/KoNLP/wiki}{github wiki}.
#'
#' @param hangul Hangul sentence
#' @param isFullwidth specify returned character will be Fullwidth ASCII or Halfwidth ASCII
#' @return Keystroke sequence 
#'
#' @export
convertHangulStringToKeyStrokes <- function(hangul, isFullwidth=TRUE){
  if(!is.character(hangul) | nchar(hangul) == 0){
    stop("Input must be legitimate character!")
  }else{
    keystrokes <- .jcall("kr/pe/freesearch/korean/KoHangul", 
                         "S","convertHangulStringToKeyStrokes",hangul,isFullwidth,TRUE)
    Encoding(keystrokes) <- "UTF-8"
    return(unlist(strsplit(keystrokes,intToUtf8(0xFF5C))))
  } 
}

# makeTagList
#
# internal function to make tag list
#
# @param tagstr pos tagging format from Hannanum analyzer
# @return taglist list object 
makeTagList <- function(tagstr){
  if(!is.character(tagstr) | nchar(tagstr) == 0) {
    warning("Please check input encoding!")
    return("")
  }
  splittedtags <- strsplit(tagstr, split="\n",fixed=T)[[1]]
  tagset <- splittedtags[which(substr(splittedtags,1,1) != "")]
  taglist <- list()
  morphs <- c()
  h <- NULL
  for(i in 1:length(tagset)){
    if(substr(tagset[i],1,1) != "\t"){
      if(!is.null(h)){
        taglist[[length(taglist) + 1]] <- unique(unlist(sapply(morphs,function(x) substr(x,2,nchar(x)), USE.NAMES=F)))
        names(taglist)[length(taglist)] <- h
      }
      h <- tagset[i]
      morphs <- c()
    }else{
      morphs <- append(morphs, tagset[i])
    }
  }
  taglist[[length(taglist) + 1]] <- unique(unlist(sapply(morphs,function(x) substr(x,2,nchar(x)), USE.NAMES=F)))
  names(taglist)[length(taglist)] <- h
  return(taglist)
}


# Rough encoding detection function
#
# function to be used for file or raw vector encoding detection. This is for internal use.
#  
# @param charinput charactor vector
# @return encoding names of rawinpus.
# @import "bitops"
#detectInputEncoding <- function(charinput){
#  BOM <- charToRaw(charinput)
#  if(length(BOM) < 4){
#    warning("rawinput must be longer than 4 bytes.")
#    return(NULL)
#  }
#  if(bitAnd(BOM[1], 0xFF) == 0xEF && 
#     bitAnd(BOM[2], 0xFF) == 0xBB && 
#     bitAnd(BOM[3], 0xFF) == 0xBF){
#    return("UTF-8")
#  }
#  if(bitAnd(BOM[1], 0xFF) == 0xFE && 
#     bitAnd(BOM[2], 0xFF) == 0xFF){ 
#    return("UTF-16BE")
#  }
#  if(bitAnd(BOM[1], 0xFF) == 0xFF && 
#     bitAnd(BOM[2], 0xFF) == 0xFE){
#    return("UTF-16LE")
#  }
#  if(bitAnd(BOM[1], 0xFF) == 0x00 &&
#     bitAnd(BOM[2], 0xFF) == 0x00 &&
#     bitAnd(BOM[3], 0xFF) == 0xFE &&
#     bitAnd(BOM[4], 0xFF) == 0xFF){
#    return("UTF-32BE")
#  }
#  if(bitAnd(BOM[1], 0xFF) == 0xFF &&
#     bitAnd(BOM[2], 0xFF) == 0xFE &&
#     bitAnd(BOM[3], 0xFF) == 0x00 &&
#     bitAnd(BOM[4], 0xFF) == 0x00){
#    return("UTF-32LE")
#  }
#  return(localeToCharset()[1])
#}



#' do Hangul automata
#'
#' function to be used for converting to complete Hangul syllables from Jamo or Keystrokes.
#' Example will be shown in \href{https://github.com/haven-jeon/KoNLP/wiki}{github wiki}.
#'
#' @return complete Hangul syllable
#' @param input to be processed mostly Jamo sequences 
#' @param isKeystroke boolean parameter to check input is keystroke or Jamo sequences
#' @param isForceConv boolean parameter to force converting if input is not valid Jamo or keystroke sequences.
#' @export
HangulAutomata <- function(input, isKeystroke=F, isForceConv=F){
  if(!is.character(input) | nchar(input) == 0) {
    stop("Input must be legitimate character!")
  }
  
  #check whether keystroke input or Jamo
  if(isKeystroke){
    if(!exists("KoKeystrokeAutomata", envir=.KoNLPEnv)){
      assign("KoKeystrokeAutomata",.jnew("kr/pe/freesearch/korean/KoKeystrokeAutomata", isForceConv),
             .KoNLPEnv)
    }
    keyAuto <- get("KoKeystrokeAutomata",envir=.KoNLPEnv)
    KoHangulAuto <- .jcast(keyAuto, "kr/pe/freesearch/korean/KoHangulAutomata")
  }else{
    if(!exists("KoJamoAutomata", envir=.KoNLPEnv)){
      assign("KoJamoAutomata",.jnew("kr/pe/freesearch/korean/KoJamoAutomata", isForceConv),
             .KoNLPEnv)
    }
    JamoAuto <- get("KoJamoAutomata",envir=.KoNLPEnv)
    KoHangulAuto <- .jcast(JamoAuto, "kr/pe/freesearch/korean/KoHangulAutomata")
  }

  .jcall(KoHangulAuto, "V", "setForceConvert", isForceConv)
  
  out <- .jcall(KoHangulAuto, "S", "convert", input)
  
  #buffer clear for future use.
  .jcall(KoHangulAuto, "V", "clear")
  
  Encoding(out) <- "UTF-8"
  return(out)
}







