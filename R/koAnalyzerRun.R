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




# morphlogical analysis function for Hangul
# 
# morphlogical analyze the sentence uses lucene korean analyzer.
# Example will be shown in \href{https://github.com/haven-jeon/KoNLP/wiki}{github wiki}.
# 
# @param sentence input
# @return stem of sentence
#
# @export
#doKoMorph <- function(sentence){
#  warning("This function will be deprecated.\n We suggest 'MorphAnalyzer()' to use.")
#  if(!is.character(sentence) | nchar(sentence) == 0) {
#    stop("Input must be legitimate character!")
#  }else{
#    if(!exists("KoMorphObj", envir=.KoNLPEnv)){
#      assign("KoMorphObj",.jnew("Ko"),.KoNLPEnv)
#    }
#    out <- .jcall(get("KoMorphObj",envir=.KoNLPEnv), "[S", "KoAnalyze", sentence)
#    Encoding(out) <- "UTF-8"
#    return(out)
#  }
#}

#' Noun extractor for Hangul
#' 
#' extract Nouns from Korean sentence uses Hannanum analyzer.
#' see detail in \href{http://semanticweb.kaist.ac.kr/home/index.php/HanNanum}{Hannanum}. 
#' Example will be shown in \href{https://github.com/haven-jeon/KoNLP/wiki}{github wiki}.
#' 
#' @param sentences input character vector
#' @param autoSpacing boolean dees it need to apply auto-spacing for input. defaul\code{FALSE}
#' @return Nouns of sentences, returns \code{list} if input is character vector of more than 2 sentences.
#' @references Sangwon Park et al(2010). A Plug-In Component-based Korean Morphological Analyzer
#' @import rJava
#' @export
extractNoun <- function(sentences, autoSpacing=FALSE){
  extractNoun_ <- function(sentence_, autoSpacing_) {
    sentence_pre <- preprocessing(sentence_)
    if(is.na(sentence_pre) || sentence_pre == FALSE || sentence_pre == ""){
      return(sentence_)
    }
    if(!exists("HannanumObj", envir=.KoNLPEnv)){
      assign("HannanumObj",.jnew("kr/pe/freesearch/jhannanum/comm/HannanumInterface"), .KoNLPEnv)
    }
    res <- tryCatch({
  	out <- .jcall(get("HannanumObj",envir=.KoNLPEnv), 
                  "[S", "extractNoun",get("SejongDicsZip", envir=.KoNLPEnv),sentence_pre,
                  get("CurrentUserDic", envir=.KoNLPEnv), autoSpacing_)
    Encoding(out) <- "UTF-8"
    out
    }, error = function(e) {
      warning(sprintf("can't processing '%s'.", sentence_))
      sentence_
      })
    return(res)
  }
  ress <- sapply(sentences, extractNoun_, autoSpacing_=autoSpacing, 
         simplify = FALSE, USE.NAMES = FALSE )
  if(length(ress) == 1){
    return(ress[[1]])
  }else{
    return(ress)
  }
}

#' Hannanum morphological analyzer interface function
#' 
#' Do the morphological analysis, not doing pos tagging uses Hannanum analyzer.
#' see details in \href{http://semanticweb.kaist.ac.kr/home/index.php/HanNanum}{Hannanum}. 
#' Example will be shown in \href{https://github.com/haven-jeon/KoNLP/wiki}{github wiki}.
#' 
#' @param sentences input character vector
#' @param autoSpacing boolean dees it need to apply auto-spacing for input. defaul\code{FALSE}
#' @return morphemes of sentences
#' @references Sangwon Park et al(2010). A Plug-In Component-based Korean Morphological Analyzer
#'
#' @export
MorphAnalyzer <- function(sentences, autoSpacing=FALSE){
  MorphAnalyzer_ <- function(sentence_, autoSpacing_){
    sentence_pre <- preprocessing(sentence_)
    if(is.na(sentence_pre) || sentence_pre == FALSE || sentence_pre == ""){
      ret_list <- list()
      ret_list[[sentence_]]=sentence_
      return(ret_list)
    }
    if(!exists("HannanumObj", envir=.KoNLPEnv)){
      assign("HannanumObj",.jnew("kr/pe/freesearch/jhannanum/comm/HannanumInterface"), .KoNLPEnv)
    }
    res <- tryCatch({
      out <- .jcall(get("HannanumObj",envir=.KoNLPEnv),
                  "S", "MorphAnalyzer", get("SejongDicsZip", envir=.KoNLPEnv),sentence_pre,
                  get("CurrentUserDic", envir=.KoNLPEnv), autoSpacing_)
      Encoding(out) <- "UTF-8"
      out
    },error = function(e) {
      warning(sprintf("can't processing '%s'.", sentence_))
      sentence_
      })
    return(makeTagList(res))
  }
  ress <- sapply(sentences, MorphAnalyzer_, autoSpacing_=autoSpacing, 
         simplify = FALSE, USE.NAMES = FALSE )
  if(length(ress) == 1){
    return(ress[[1]])
  }else{
    return(ress)
  }
}
#' POS tagging by using 22 KAIST tags
#' 
#' Do POS tagging using 22 tags uses Hannanum analyzer.
#' see details in \href{http://semanticweb.kaist.ac.kr/home/index.php/HanNanum}{Hannanum}. 
#' Example will be shown in \href{https://github.com/haven-jeon/KoNLP/wiki}{github wiki}.
#' 
#' @param sentences input character vector
#' @param autoSpacing boolean dees it need to apply auto-spacing for input. defaul\code{FALSE}
#' @references Sangwon Park et al(2010). A Plug-In Component-based Korean Morphological Analyzer
#' @return KAIST tags of input sentence
#' @export
SimplePos22 <- function(sentences, autoSpacing=FALSE){
  SimplePos22_ <- function(sentence_, autoSpacing_){
    sentence_pre <- preprocessing(sentence_)
    if(is.na(sentence_pre) || sentence_pre == FALSE || sentence_pre == ""){
      ret_list <- list()
      ret_list[[sentence_]]=sentence_
      return(ret_list)
    }
    if(!exists("HannanumObj", envir=.KoNLPEnv)){
      assign("HannanumObj",.jnew("kr/pe/freesearch/jhannanum/comm/HannanumInterface"), .KoNLPEnv)
    }
    res <- tryCatch({
      out <- .jcall(get("HannanumObj",envir=.KoNLPEnv), 
                    "S", "SimplePos22",get("SejongDicsZip", envir=.KoNLPEnv),sentence_pre,
                    get("CurrentUserDic", envir=.KoNLPEnv), autoSpacing_)
      Encoding(out) <- "UTF-8"
      out
    },error = function(e) {
      warning(sprintf("can't processing '%s'.", sentence_))
      sentence_
    })
    return(makeTagList(res))
  }
  ress <- sapply(sentences, SimplePos22_, autoSpacing_=autoSpacing, 
         simplify = FALSE, USE.NAMES = FALSE )
  if(length(ress) == 1){
    return(ress[[1]])
  }else{
    return(ress)
  }
}

#' POS tagging by using 9 KAIST tags
#' 
#' Do pos tagging using 9 tags uses Hannanum analyzer.
#' see details in \href{http://semanticweb.kaist.ac.kr/home/index.php/HanNanum}{Hannanum}. 
#' Example will be shown in \href{https://github.com/haven-jeon/KoNLP/wiki}{github wiki}.
#' 
#' @param sentences input character vector
#' @param autoSpacing boolean dees it need to apply auto-spacing for input. defaul\code{FALSE}
#' @references Sangwon Park et al(2010). A Plug-In Component-based Korean Morphological Analyzer
#' @return KAIST tags of input sentence
#'
#' @export
SimplePos09 <- function(sentences, autoSpacing=FALSE){
  SimplePos09_ <- function(sentence_, autoSpacing_){
    sentence_pre <- preprocessing(sentence_)
    if(is.na(sentence_pre) || sentence_pre == FALSE || sentence_pre == ""){
      ret_list <- list()
      ret_list[[sentence_]]=sentence_
      return(ret_list)
    }
    if(!exists("HannanumObj", envir=.KoNLPEnv)){
      assign("HannanumObj",.jnew("kr/pe/freesearch/jhannanum/comm/HannanumInterface"), .KoNLPEnv)
    }
    res <- tryCatch({
      out <- .jcall(get("HannanumObj",envir=.KoNLPEnv), 
                    "S", "SimplePos09",get("SejongDicsZip", envir=.KoNLPEnv),sentence_pre,
                    get("CurrentUserDic", envir=.KoNLPEnv), autoSpacing_)
      Encoding(out) <- "UTF-8"
      out
    },error = function(e) {
      warning(sprintf("can't processing '%s'.", sentence_))
      sentence_
    })
    return(makeTagList(res))
  }
  ress <- sapply(sentences, SimplePos09_, autoSpacing_=autoSpacing, 
         simplify = FALSE, USE.NAMES = FALSE )
  if(length(ress) == 1){
    return(ress[[1]])
  }else{
    return(ress)
  }
}




