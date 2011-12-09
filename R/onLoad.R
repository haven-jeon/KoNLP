#' pkgKoNLP
#'
#' global variable for internaly used 
pkgKoNLP <- ""

#' DicConPath
#'
#' dic and conf path for Hannanum analyzer 
DicConfPath <- ""



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
  pkgKoNLP <<- pkgname
  DicConfPath <<- paste(system.file(package=pkgKoNLP),"/dics", sep="")
}

