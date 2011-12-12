.KoNLPEnv <- new.env()


#' .onLoad
#' 
#' package loader
#'
#' @param libname name of library
#' @param pkgname name of package 
#' @rdname onLoad
#' @import "rJava"
.onLoad <- function(libname, pkgname) {
  .jinit(parameters=c("-Dfile.encoding=UTF-8", "-Xmx512m"))
  .jpackage(pkgname, lib.loc = libname)
}



.onAttach <- function(libname, pkgname){
  DicConfPath <- paste(system.file(package=pkgname),"/dics", sep="")
  assign("DicConfPath", DicConfPath, KoNLP:::.KoNLPEnv)
}



