#' pkgKoNLP
#'
#' global variable for internaly used 
pkgKoNLP <- ""

#' DicConPath
#'
#' dic and conf path for Hannanum analyzer 
DicConfPath <- ""

#' .onLoad
#' 
#' package loader
#'
#' @rdname onLoad
#' @import "rJava"
.onLoad <- function(libname, pkgname) {
  .jinit(parameters="-Dfile.encoding=UTF-8")
  .jpackage(pkgname, lib.loc = libname)
  pkgKoNLP <<- pkgname
  DicConfPath <<- paste(system.file(package=pkgKoNLP),"/dics", sep="")
}

