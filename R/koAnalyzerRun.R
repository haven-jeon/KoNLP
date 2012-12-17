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
#    if(!exists("KoMorphObj", envir=KoNLP:::.KoNLPEnv)){
#      assign("KoMorphObj",.jnew("Ko"),KoNLP:::.KoNLPEnv)
#    }
#    out <- .jcall(get("KoMorphObj",envir=KoNLP:::.KoNLPEnv), "[S", "KoAnalyze", sentence)
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
#' @param sentence input
#' @return Noun of sentence
#' @references Sangwon Park et al(2010). A Plug-In Component-based Korean Morphological Analyzer
#' @import "rJava"
#' @export
extractNoun <- function(sentence){
  sentence_pre <- preprocessing(sentence)
  if(sentence_pre == FALSE){
    return(sentence)
  }
  if(!exists("HannanumObj", envir=KoNLP:::.KoNLPEnv)){
    assign("HannanumObj",.jnew("kr/pe/freesearch/jhannanum/comm/HannanumInterface"), KoNLP:::.KoNLPEnv)
  }
	out <- .jcall(get("HannanumObj",envir=KoNLP:::.KoNLPEnv), 
                "[S", "extractNoun",get("SejongDicsZip", envir=KoNLP:::.KoNLPEnv),sentence_pre,
                get("CurrentUserDic", envir=KoNLP:::.KoNLPEnv))
  Encoding(out) <- "UTF-8"
  return(out)
}

#' Hannanum morphological analyzer interface function
#' 
#' Do the morphological analysis, not doing pos tagging uses Hannanum analyzer.
#' see details in \href{http://semanticweb.kaist.ac.kr/home/index.php/HanNanum}{Hannanum}. 
#' Example will be shown in \href{https://github.com/haven-jeon/KoNLP/wiki}{github wiki}.
#' 
#' @param sentence input
#' @return result of analysis
#' @references Sangwon Park et al(2010). A Plug-In Component-based Korean Morphological Analyzer
#'
#' @export
MorphAnalyzer <- function(sentence){
  sentence_pre <- preprocessing(sentence)
  if(sentence_pre == FALSE){
    return(sentence)
  }
  if(!exists("HannanumObj", envir=KoNLP:::.KoNLPEnv)){
    assign("HannanumObj",.jnew("kr/pe/freesearch/jhannanum/comm/HannanumInterface"), KoNLP:::.KoNLPEnv)
  }
  out <- .jcall(get("HannanumObj",envir=KoNLP:::.KoNLPEnv),
                "S", "MorphAnalyzer", get("SejongDicsZip", envir=KoNLP:::.KoNLPEnv),sentence_pre,
                get("CurrentUserDic", envir=KoNLP:::.KoNLPEnv))
  Encoding(out) <- "UTF-8"
  return(makeTagList(out))
}
#' POS tagging by using 22 KAIST tags
#' 
#' Do POS tagging using 22 tags uses Hannanum analyzer.
#' see details in \href{http://semanticweb.kaist.ac.kr/home/index.php/HanNanum}{Hannanum}. 
#' Example will be shown in \href{https://github.com/haven-jeon/KoNLP/wiki}{github wiki}.
#' 
#' @param sentence input
#' @references Sangwon Park et al(2010). A Plug-In Component-based Korean Morphological Analyzer
#' @return results of tagged analysis
#' @export
SimplePos22 <- function(sentence){
  sentence_pre <- preprocessing(sentence)
  if(sentence_pre == FALSE){
    return(sentence)
  }
  if(!exists("HannanumObj", envir=KoNLP:::.KoNLPEnv)){
    assign("HannanumObj",.jnew("kr/pe/freesearch/jhannanum/comm/HannanumInterface"), KoNLP:::.KoNLPEnv)
  }
  out <- .jcall(get("HannanumObj",envir=KoNLP:::.KoNLPEnv), 
                "S", "SimplePos22",get("SejongDicsZip", envir=KoNLP:::.KoNLPEnv),sentence_pre,
                get("CurrentUserDic", envir=KoNLP:::.KoNLPEnv))
  Encoding(out) <- "UTF-8"
  return(makeTagList(out))
}

#' POS tagging by using 9 KAIST tags
#' 
#' Do pos tagging using 9 tags uses Hannanum analyzer.
#' see details in \href{http://semanticweb.kaist.ac.kr/home/index.php/HanNanum}{Hannanum}. 
#' Example will be shown in \href{https://github.com/haven-jeon/KoNLP/wiki}{github wiki}.
#' 
#' @param sentence input
#' @references Sangwon Park et al(2010). A Plug-In Component-based Korean Morphological Analyzer
#' @return results of tagged analysis
#'
#' @export
SimplePos09 <- function(sentence){
  sentence_pre <- preprocessing(sentence)
  if(sentence_pre == FALSE){
    return(sentence)
  }
  if(!exists("HannanumObj", envir=KoNLP:::.KoNLPEnv)){
    assign("HannanumObj",.jnew("kr/pe/freesearch/jhannanum/comm/HannanumInterface"), KoNLP:::.KoNLPEnv)
  }
  out <- .jcall(get("HannanumObj",envir=KoNLP:::.KoNLPEnv), 
                "S", "SimplePos09",get("SejongDicsZip", envir=KoNLP:::.KoNLPEnv),sentence_pre,
                get("CurrentUserDic", envir=KoNLP:::.KoNLPEnv))
  Encoding(out) <- "UTF-8"
  return(makeTagList(out))
}







