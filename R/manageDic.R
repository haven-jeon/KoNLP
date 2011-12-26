#' reloadAllDic
#'
#' Mainly, user dictionary reloading for Hannanum Analyzer. 
#' If you want to update uer dictionary on KoNLP_pkg_dir/inst/dics/data/kE/dic_user.txt, need to execute this function after editing dic.
#'
#' @export
reloadAllDic <- function(){
  if(!exists("HannanumObj", envir=KoNLP:::.KoNLPEnv)){
    assign("HannanumObj",.jnew("HannanumInterface"),KoNLP:::.KoNLPEnv)
  }
  .jcall(get("HannanumObj",envir=KoNLP:::.KoNLPEnv), , "reloadAllDic")
}




