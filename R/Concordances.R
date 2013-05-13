#' concordance for input text vector
#' 
#' returns concordance text for input pattern and span.
#' 
#' @author Heewon Jeon
#' @param string input text as character vector or single character
#' @param pattern patterns of central words
#' @param span how many character will be produced around input pattern
#' @import stringr
#' @export
concordance_str <- function(string, pattern, span=5){
  str_match(string, sprintf(".{0,%d}%s.{0,%d}", span, pattern, span))
}


#' concordance for input text file
#' 
#' returns concordance text for input file.
#' 
#' @author Heewon Jeon
#' @param filename file name
#' @param pattern patterns of central words
#' @param span how many character will be produced around input pattern
#' @param encoding filename's encoding
#' @export
concordance_file <- function(filename, pattern, encoding=getOption('encoding'), span=5){
  f = file(filename, "r",encoding=encoding); on.exit(close(f), add = TRUE)
  while(TRUE) {
    next_line = readLines(f, n = 1, warn=FALSE)
    if(length(next_line) == 0) {
      break
    }
    ret <- concordance_str(next_line, pattern, span)
    if(!is.na(ret)){
      if(exists("retu")){
        retu <- rbind(retu, ret)
      }else{
        retu <- ret
      }
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


