#' doKoMorph 
#' 
#' morphlogical analyze the sentence.
#' it uses lucene korean analyzer.
#' see details in \url{http://sourceforge.net/projects/lucenekorean/}
#' 
#' @param sentence input
#' @return stem of sentence
#'
#' @export
doKoMorph <- function(sentence){
  if(!is.character(sentence) | nchar(sentence) == 0) {
    warning("input must be character!")
    return(sentence)
  }else{
    if(!exists("KoMorphObj", envir=KoNLP:::.KoNLPEnv)){
      assign("KoMorphObj",.jnew("Ko"),KoNLP:::.KoNLPEnv)
    }
    out <- .jcall(get("KoMorphObj",envir=KoNLP:::.KoNLPEnv), "[S", "KoAnalyze", sentence)
    Encoding(out) <- "UTF-8"
    return(out)
  }
}

#' extractNoun 
#' 
#' extract Nouns from Korean sentence. 
#' it uses Hannanum analyzer.
#' see detail in \url{http://semanticweb.kaist.ac.kr/home/index.php/HanNanum}
#' 
#' @param sentence input
#' @return Noun of sentence
#'
#' @export
extractNoun <- function(sentence){
  if(!is.character(sentence) | nchar(sentence) == 0) {
    warning("input must be character!")
    return(sentence)
  }else{
    if(!exists("HannanumObj", envir=KoNLP:::.KoNLPEnv)){
      assign("HannanumObj",.jnew("HannanumInterface"), KoNLP:::.KoNLPEnv)
    }
	out <- .jcall(get("HannanumObj",envir=KoNLP:::.KoNLPEnv), "[S", "extractNoun",DicConfPath,sentence)
    Encoding(out) <- "UTF-8"
    return(out)
  } 
}

#' MorphAnalyzer
#' 
#' Do the morphological analysis, not doing pos tagging. 
#' it uses Hannanum analyzer.
#' see details in \url{http://semanticweb.kaist.ac.kr/home/index.php/HanNanum}
#' 
#' @param sentence input
#' @return result of analysis
#'
#' @export
MorphAnalyzer <- function(sentence){
  if(!is.character(sentence) | nchar(sentence) == 0) {
    warning("input must be character!")
    return(sentence)
  }else{
    if(!exists("HannanumObj", envir=KoNLP:::.KoNLPEnv)){
      assign("HannanumObj",.jnew("HannanumInterface"), KoNLP:::.KoNLPEnv)
    }
	out <- .jcall(get("HannanumObj",envir=KoNLP:::.KoNLPEnv), "S", "MorphAnalyzer",DicConfPath,sentence)
    Encoding(out) <- "UTF-8"
    return(makeTagList(out))
  } 
}
#' SimplePos22 
#' 
#' Do pos tagging using 22 tags. 
#' it uses Hannanum analyzer.
#' see details in \url{http://semanticweb.kaist.ac.kr/home/index.php/HanNanum}
#' 
#' @param sentence input
#' @return result of tags
#'
#' @export
SimplePos22 <- function(sentence){
  if(!is.character(sentence) | nchar(sentence) == 0) {
    warning("input must be character!")
    return(sentence)
  }else{
    if(!exists("HannanumObj", envir=KoNLP:::.KoNLPEnv)){
      assign("HannanumObj",.jnew("HannanumInterface"), KoNLP:::.KoNLPEnv)
    }
	out <- .jcall(get("HannanumObj",envir=KoNLP:::.KoNLPEnv), "S", "SimplePos22",DicConfPath,sentence)
    Encoding(out) <- "UTF-8"
    return(makeTagList(out))
  }
}

#' SimplePos09
#' 
#' Do pos tagging using 9 tags. 
#' it uses Hannanum analyzer.
#' see details in \url{http://semanticweb.kaist.ac.kr/home/index.php/HanNanum}
#' 
#' @param sentence input
#' @return Noun of sentence
#'
#' @export
SimplePos09 <- function(sentence){
  if(!is.character(sentence) | nchar(sentence) == 0) {
    warning("input must be character!")
    return(sentence)
  }else{
    if(!exists("HannanumObj", envir=KoNLP:::.KoNLPEnv)){
      assign("HannanumObj",.jnew("HannanumInterface"), KoNLP:::.KoNLPEnv)
    }
	out <- .jcall(get("HannanumObj",envir=KoNLP:::.KoNLPEnv), "S", "SimplePos09",DicConfPath,sentence)
    Encoding(out) <- "UTF-8"
	return(makeTagList(out))
  }
}


#' is.hangul
#' 
#' checking sentence is hangul or not
#'
#' @param sentence input charactor
#' @return TRUE or FALSE of sentence vector(s)
#' 
#' @export
is.hangul <- function(sentence){
  intVec <- sapply(sentence, utf8ToInt)
  all(intVec >= 0xAC00  & intVec <= 0xD7A3)
}

#' convertHangulStringToJamos
#'
#' convert Hangul sentence to Jamos(now on testing~)
#'
#' @param hangul hangul string
#' @return Jamo sequences 
convertHangulStringToJamos <- function(hangul){
  if(!is.character(hangul) | nchar(hangul) == 0){
    warning("must input char!")
    return(hangul)
  }else{
    jamos <- .jcall("org/apache/lucene/search/spell/korean/KoHangul", "S","convertHangulStringToJamos",hangul)
	  Encoding(jamos) <- "UTF-8" 
    return(unlist(strsplit(jamos,intToUtf8(0xFF5C))))
  }
}

#' convertHangulStringToKeyStrokes
#'
#' convert Hangul String to Keystrokes, each Hangul syllable can be dilimitered by \emph{OxFF5C}.
#'
#' @param hangul hangul sentence
#' @return Keystroke sequence 
#'
#' @export
convertHangulStringToKeyStrokes <- function(hangul){
  if(!is.character(hangul) | nchar(hangul) == 0){
    warning("must input char!")
    return(hangul)
  }else{
    keystrokes <- .jcall("org/apache/lucene/search/spell/korean/KoHangul", "S","convertHangulStringToKeyStrokes",hangul)
    Encoding(keystrokes) <- "UTF-8"
    return(keystrokes)
  } 
}

#' makeTagList
#'
#' internal function to make tag list
#'
#' @param tagstr pos tagging format from Hannanum analyzer
#' @return taglist list object 
makeTagList <- function(tagstr){
  if(!is.character(tagstr) | nchar(tagstr) == 0) {
    warning("input must be character!")
    return(list())
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


