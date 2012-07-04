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


preprocessing <- function(inputs){
  newInput <- gsub("[[:space:]]", " ", inputs)
  if(nchar(newInput) > 20 & length(strsplit(newInput, " ")[[1]]) <= 3){ 
    stop(sprintf("It's not kind of right sentence : '%s'", inputs))
  }
  return(newInput)
}


checkEncoding <- function(inputs){
  if(Encoding(inputs) == "unknown"){
    expectenc <- detectInputEncoding(inputs)
    if(is.null(expectenc)){
      return(F)
    }
    if(expectenc != localeToCharset()[1]){
      stop("Please check input encoding!")
    }
  }  
  return(T)
}



#' morphlogical analysis function for Hangul
#' 
#' morphlogical analyze the sentence uses lucene korean analyzer.
#' Example will be shown in \href{https://github.com/haven-jeon/KoNLP/wiki}{github wiki}.
#' 
#' @param sentence input
#' @return stem of sentence
#'
#' @export
doKoMorph <- function(sentence){
  if(!checkEncoding(sentence)){
    return(sentence)
  }
  if(!is.character(sentence) | nchar(sentence) == 0) {
    stop("Input must be legitimate character!")
  }else{
    if(!exists("KoMorphObj", envir=KoNLP:::.KoNLPEnv)){
      assign("KoMorphObj",.jnew("Ko"),KoNLP:::.KoNLPEnv)
    }
    out <- .jcall(get("KoMorphObj",envir=KoNLP:::.KoNLPEnv), "[S", "KoAnalyze", sentence)
    Encoding(out) <- "UTF-8"
    return(out)
  }
}

#' Noun extractor for Hangul
#' 
#' extract Nouns from Korean sentence uses Hannanum analyzer.
#' see detail in \href{http://semanticweb.kaist.ac.kr/home/index.php/HanNanum}{Hannanum}. 
#' Example will be shown in \href{https://github.com/haven-jeon/KoNLP/wiki}{github wiki}.
#' 
#' @param sentence input
#' @return Noun of sentence
#' @import "rJava"
#' @export
extractNoun <- function(sentence){
  if(!checkEncoding(sentence)){
    return(sentence)
  }
  if(!is.character(sentence) | nchar(sentence) == 0) {
    stop("Input must be legitimate character!")
  }else{
    sentence <- preprocessing(sentence)
    if(!exists("HannanumObj", envir=KoNLP:::.KoNLPEnv)){
      assign("HannanumObj",.jnew("HannanumInterface"), KoNLP:::.KoNLPEnv)
    }
	  out <- .jcall(get("HannanumObj",envir=KoNLP:::.KoNLPEnv), 
                  "[S", "extractNoun",get("DicConfPath", envir=KoNLP:::.KoNLPEnv),sentence)
    Encoding(out) <- "UTF-8"
    return(out)
  } 
}

#' Hannanum morphological analyzer interface function
#' 
#' Do the morphological analysis, not doing pos tagging uses Hannanum analyzer.
#' see details in \href{http://semanticweb.kaist.ac.kr/home/index.php/HanNanum}{Hannanum}. 
#' Example will be shown in \href{https://github.com/haven-jeon/KoNLP/wiki}{github wiki}.
#' 
#' @param sentence input
#' @return result of analysis
#'
#' @export
MorphAnalyzer <- function(sentence){
  if(!checkEncoding(sentence)){
    return(sentence)
  } 
  if(!is.character(sentence) | nchar(sentence) == 0) {
    stop("Input must be legitimate character!")
  }else{
    sentence <- preprocessing(sentence)
    if(!exists("HannanumObj", envir=KoNLP:::.KoNLPEnv)){
      assign("HannanumObj",.jnew("HannanumInterface"), KoNLP:::.KoNLPEnv)
    }
	  out <- .jcall(get("HannanumObj",envir=KoNLP:::.KoNLPEnv),
                  "S", "MorphAnalyzer", get("DicConfPath", envir=KoNLP:::.KoNLPEnv),sentence)
    Encoding(out) <- "UTF-8"
    return(makeTagList(out))
  } 
}
#' POS tagging by using 22 KAIST tags
#' 
#' Do POS tagging using 22 tags uses Hannanum analyzer.
#' see details in \href{http://semanticweb.kaist.ac.kr/home/index.php/HanNanum}{Hannanum}. 
#' Example will be shown in \href{https://github.com/haven-jeon/KoNLP/wiki}{github wiki}.
#' 
#' @param sentence input
#' @return result of analysis
#' @export
SimplePos22 <- function(sentence){
  if(!checkEncoding(sentence)){
    return(sentence)
  }
  if(!is.character(sentence) | nchar(sentence) == 0) {
    stop("Input must be legitimate character!")
  }else{
    sentence <- preprocessing(sentence)
    if(!exists("HannanumObj", envir=KoNLP:::.KoNLPEnv)){
      assign("HannanumObj",.jnew("HannanumInterface"), KoNLP:::.KoNLPEnv)
    }
	  out <- .jcall(get("HannanumObj",envir=KoNLP:::.KoNLPEnv), 
                  "S", "SimplePos22",get("DicConfPath", envir=KoNLP:::.KoNLPEnv),sentence)
    Encoding(out) <- "UTF-8"
    return(makeTagList(out))
  }
}

#' POS tagging by using 9 KAIST tags
#' 
#' Do pos tagging using 9 tags uses Hannanum analyzer.
#' see details in \href{http://semanticweb.kaist.ac.kr/home/index.php/HanNanum}{Hannanum}. 
#' Example will be shown in \href{https://github.com/haven-jeon/KoNLP/wiki}{github wiki}.
#' 
#' @param sentence input
#' @return Noun of sentence
#'
#' @export
SimplePos09 <- function(sentence){
  if(!checkEncoding(sentence)){
    return(sentence)
  } 
  if(!is.character(sentence) | nchar(sentence) == 0) {
    stop("Input must be legitimate character!")
  }else{
    sentence <- preprocessing(sentence)
    if(!exists("HannanumObj", envir=KoNLP:::.KoNLPEnv)){
      assign("HannanumObj",.jnew("HannanumInterface"), KoNLP:::.KoNLPEnv)
    }
	  out <- .jcall(get("HannanumObj",envir=KoNLP:::.KoNLPEnv), 
                  "S", "SimplePos09",get("DicConfPath", envir=KoNLP:::.KoNLPEnv),sentence)
    Encoding(out) <- "UTF-8"
	  return(makeTagList(out))
  }
}


#' check if sentence is all Hangul
#' 
#' Function checks if each charactor is Hangul or Jamo. 
#' Example will be shown in \href{https://github.com/haven-jeon/KoNLP/wiki}{github wiki}.
#'
#' @param sentenceU8 input charactors(must be UTF-8)
#' @return TRUE or FALSE 
#' 
#' @export
is.hangul <- function(sentenceU8){
  if(!(Encoding(sentenceU8) == "UTF-8" | 
    (localeToCharset()[1] == "UTF-8" & Encoding(sentenceU8) == "unknown" ))){
    stop("Input must be 'UTF-8' encoding!")
  }
  intVec <- unlist(lapply(sentenceU8,utf8ToInt)) 
  res <- sapply(intVec, function(ch){
        .jcall("org/apache/lucene/search/spell/korean/KoHangul", "Z", "isHangul", .jchar(ch))
  })
  return(all(res))  
}



#' check if sentence is all Jamo
#' 
#' Function checks with each charactor is Jamo. 
#' Example will be shown in \href{https://github.com/haven-jeon/KoNLP/wiki}{github wiki}.
#'
#' @param sentenceU8 input charactors(must be UTF-8)
#' @return TRUE or FALSE 
#' 
#' @export
is.jamo <- function(sentenceU8){
  if(!(Encoding(sentenceU8) == "UTF-8" | 
    (localeToCharset()[1] == "UTF-8" & Encoding(sentenceU8) == "unknown" ))){
    stop("Input must be 'UTF-8' encoding!")
  }
  intVec <- unlist(lapply(sentenceU8,utf8ToInt)) 
  res <- sapply(intVec, function(ch){
        .jcall("org/apache/lucene/search/spell/korean/KoHangul", "Z", "isJamo", .jchar(ch))
  })
  return(all(res))
}


#' convertion function  Hangul string to Jamos
#'
#' convert Hangul sentence to Jamos.
#' Example will be shown in \href{https://github.com/haven-jeon/KoNLP/wiki}{github wiki}.
#'
#' @param hangul hangul string
#' @return Jamo sequences 
#' @export
convertHangulStringToJamos <- function(hangul){
  if(!checkEncoding(hangul)){
    return(hangul)
  }
  if(!is.character(hangul) | nchar(hangul) == 0){
    stop("Input must be legitimate character!")
  }else{
    jamos <- .jcall("org/apache/lucene/search/spell/korean/KoHangul", "S","convertHangulStringToJamos",hangul,TRUE)
	  Encoding(jamos) <- "UTF-8" 
    return(unlist(strsplit(jamos,intToUtf8(0xFF5C))))
  }
}

#' convertion function Hangul string to keyStrokes
#'
#' Function can convert Hangul string to Keystrokes. 
#' Example will be shown in \href{https://github.com/haven-jeon/KoNLP/wiki}{github wiki}.
#'
#' @param hangul hangul sentence
#' @param isFullwidth specify returned character will be Fullwidth ASCII or Halfwidth ASCII
#' @return Keystroke sequence 
#'
#' @export
convertHangulStringToKeyStrokes <- function(hangul, isFullwidth=TRUE){
  if(!checkEncoding(hangul)){
    return(hangul)
  }  
  if(!is.character(hangul) | nchar(hangul) == 0){
    stop("Input must be legitimate character!")
  }else{
    keystrokes <- .jcall("org/apache/lucene/search/spell/korean/KoHangul", 
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
        taglist[[length(taglist) + 1]] <- unlist(sapply(morphs,function(x) substr(x,2,nchar(x)), USE.NAMES=F))
        names(taglist)[length(taglist)] <- h
      }
      h <- tagset[i]
      morphs <- c()
    }else{
      morphs <- append(morphs, tagset[i])
    }
  }
  taglist[[length(taglist) + 1]] <- unlist(sapply(morphs,function(x) substr(x,2,nchar(x)), USE.NAMES=F))
  names(taglist)[length(taglist)] <- h
  return(taglist)
}


#' Rough encoding detection function
#'
#' function to be used for file or raw vector encodoing detection. This is for internal use.
#'  
#' @param charinput charvector
#' @return encoding names of rawinpus.
#' @import "bitops"
detectInputEncoding <- function(charinput){
  BOM <- charToRaw(charinput)
  if(length(BOM) < 4){
    warning("rawinput must be longer than 4 bytes.")
    return(NULL)
  }
  if(bitAnd(BOM[1], 0xFF) == 0xEF && 
     bitAnd(BOM[2], 0xFF) == 0xBB && 
     bitAnd(BOM[3], 0xFF) == 0xBF){
    return("UTF-8")
  }
  if(bitAnd(BOM[1], 0xFF) == 0xFE && 
     bitAnd(BOM[2], 0xFF) == 0xFF){ 
    return("UTF-16BE")
  }
  if(bitAnd(BOM[1], 0xFF) == 0xFF && 
     bitAnd(BOM[2], 0xFF) == 0xFE){
    return("UTF-16LE")
  }
  if(bitAnd(BOM[1], 0xFF) == 0x00 &&
     bitAnd(BOM[2], 0xFF) == 0x00 &&
     bitAnd(BOM[3], 0xFF) == 0xFE &&
     bitAnd(BOM[4], 0xFF) == 0xFF){
    return("UTF-32BE")
  }
  if(bitAnd(BOM[1], 0xFF) == 0xFF &&
     bitAnd(BOM[2], 0xFF) == 0xFE &&
     bitAnd(BOM[3], 0xFF) == 0x00 &&
     bitAnd(BOM[4], 0xFF) == 0x00){
    return("UTF-32LE")
  }
  return(localeToCharset()[1])
}



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
  if(!checkEncoding(input)){
    return(input)
  }  
  if(!is.character(input) | nchar(input) == 0) {
    stop("Input must be legitimate character!")
  }
  
  #check whether keystroke input or Jamo
  if(isKeystroke){
    if(!exists("KoKeystrokeAutomata", envir=KoNLP:::.KoNLPEnv)){
      assign("KoKeystrokeAutomata",.jnew("org/apache/lucene/search/spell/korean/KoKeystrokeAutomata", isForceConv),
             KoNLP:::.KoNLPEnv)
    }
    keyAuto <- get("KoKeystrokeAutomata",envir=KoNLP:::.KoNLPEnv)
    KoHangulAuto <- .jcast(keyAuto, "org/apache/lucene/search/spell/korean/KoHangulAutomata")
  }else{
    if(!exists("KoJamoAutomata", envir=KoNLP:::.KoNLPEnv)){
      assign("KoJamoAutomata",.jnew("org/apache/lucene/search/spell/korean/KoJamoAutomata", isForceConv),
             KoNLP:::.KoNLPEnv)
    }
    JamoAuto <- get("KoJamoAutomata",envir=KoNLP:::.KoNLPEnv)
    KoHangulAuto <- .jcast(JamoAuto, "org/apache/lucene/search/spell/korean/KoHangulAutomata")
  }

  .jcall(KoHangulAuto, "V", "setForceConvert", isForceConv)
  
  out <- .jcall(KoHangulAuto, "S", "convert", input)
  
  #buffer clear for future use.
  .jcall(KoHangulAuto, "V", "clear")
  
  Encoding(out) <- "UTF-8"
  return(out)
}





