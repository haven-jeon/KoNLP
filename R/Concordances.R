#Copyright 2013 Heewon Jeon(madjakarta@gmail.com)
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




#' concordance for input text vector
#' 
#' returns concordance text for input pattern and span.
#' 
#' @author Heewon Jeon
#' @param string input text as character vector or single character
#' @param pattern patterns of central words
#' @param span how many character will be produced around input pattern
#' @references Church, K. W. and Mercer, R. L. (1993). Introduction to the special issue on computational linguistics using large corpora. Computational Linguistics, 19(1):1-24.
#' @importFrom stringr str_match_all regex
#' @export
concordance_str <- function(string, pattern, span=5){
  res <- str_match_all(string, regex(sprintf(".{0,%d}%s.{0,%d}", span, pattern, span),ignore_case=TRUE))
  return(Filter(function(x){length(x) != 0}, res))
}


#' concordance for input text file
#' 
#' returns concordance text for input file.
#' 
#' @author Heewon Jeon
#' @param filename file name
#' @param pattern patterns of central words
#' @param span how many character will be produced around input pattern
#' @references Church, K. W. and Mercer, R. L. (1993). Introduction to the special issue on computational linguistics using large corpora. Computational Linguistics, 19(1):1-24.
#' @param encoding filename's encoding
#' @export
concordance_file <- function(filename, pattern, encoding=getOption('encoding'), span=5){
  f = file(filename, "r",encoding=encoding); on.exit(close(f), add = TRUE)
  retu <- c()
  while(TRUE) {
    next_line = readLines(f, n = 1, warn=FALSE)
    if(length(next_line) == 0) {
      break
    }
    ret <- concordance_str(next_line, pattern, span)
    if(length(ret) != 0){
        retu <- c(retu, unlist(ret))
    }
  }
  return(retu)
}



#' mutual information for input text
#' 
#' returns mutual information or t-scores for input text 
#' 
#' @author Heewon Jeon
#' @param text input character vector 
#' @param method for calculations(`mutual' or `t-scores') 
#' @param query term to get information
#' @references Church, K. W. and Hanks, P. (1990). Word association norms, mutual information,and lexicography.Computational Linguistics, 16(1):22-29.
#' @references Church, K. W. and Mercer, R. L. (1993). Introduction to the special issue on computational linguistics using large corpora. Computational Linguistics, 19(1):1-24.
#' @import tau
#' @import hash
#' @export
mutualinformation <- function(text, query="", method=c("mutual", "tscores")){
  unigram <- hash(textcnt(text, method="string", n=1))
  bigram <- hash(textcnt(text, method="string", n=2))
  num_of_words <- sum(values(unigram))
  num_of_bigrams <- sum(values(bigram))
  
  method <- match.arg(method)
  bigram_names <- Filter(function(x) { query %in% unlist(strsplit(x, split=" ")) | query == "" },  
             names(bigram))
  if(method == "mutual"){
    #calc mutual_information
    sapply(bigram_names, function(x) {
      bi <- unlist(strsplit(x, split=" "))
      log( (bigram[[x]] * num_of_words)/(unigram[[bi[1]]] * unigram[[bi[2]]]) )
    }, USE.NAMES=TRUE)
  }else if(method == "tscores"){
    #calc tscores 
    sapply(bigram_names, function(x) {
      bi <- unlist(strsplit(x, split=" "))
      (bigram[[x]] - 1/num_of_words * unigram[[bi[1]]] * unigram[[bi[2]]]) / sqrt(bigram[[x]])
    }, USE.NAMES=TRUE)
  }
}


