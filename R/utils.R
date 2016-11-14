


#' scala_library_install
#'
#' @param ver which scala version to install
scala_library_install <- function(ver = '2.11.8') {
  
  when_error_warn <- function(cond){
    message(cond)
    url <- sprintf("http://downloads.lightbend.com/scala/%s/scala-%s.zip", ver, ver)
    destfile <- file.path(installPath,basename(url))
    result <- download.file(url,destfile)
    if ( result != 0 | file.exists(destfile) == FALSE  | file.size(destfile) <= 1024  ) return(invisible(result))
    result <- unzip(destfile, files=sprintf('scala-%s/lib/scala-library.jar', ver), exdir=installPath)
    file.copy(file.path(installPath,sprintf('scala-%s/lib/scala-library.jar', ver)), 
              file.path(installPath, sprintf("scala-library-%s", ver)))
    unlink(file.path(installPath,sprintf('scala-%s', ver)), recursive = T)
    unlink(destfile)
    return(NULL)
  }
  
  installPath <- file.path(system.file(package="KoNLP"),"java")
  url <- sprintf("http://central.maven.org/maven2/org/scala-lang/scala-library/%s/scala-library-%s.jar", ver, ver)
  ret <- tryCatch(
    {
      destfile <- file.path(installPath,basename(url))
      result <- download.file(url,destfile)
      if ( result != 0  | file.exists(destfile) == FALSE  | file.size(destfile) <= 1024) return(invisible(result))
    }, 
    error  =when_error_warn, 
    warning=when_error_warn, 
    finally={
      if ( file.exists(destfile) & file.size(destfile) >= 1024) {
        cat("Successfully installed Scala runtime library in ",
            destfile,"\n",sep="")
      }else{
        message(sprintf('Fail to install scala-library-%s.jar. Recommand to install library manually in %s', ver, installPath))
      }    
    }
  )
  invisible(ret)
}




