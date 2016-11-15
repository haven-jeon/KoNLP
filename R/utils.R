


#' scala_library_install
#'
#' @param ver which scala version to install
#' @importFrom utils download.file unzip
scala_library_install <- function(ver = '2.11.8') {
  
  when_error_warn <- function(cond){
    message(cond)
    if(file.exists(destfile)) file.remove(destfile)
    url <- sprintf("http://downloads.lightbend.com/scala/%s/scala-%s.zip", ver, ver)
    destfilez <- file.path(installPath,basename(url))
    tempfilez <- tempfile()
    result <- download.file(url,tempfilez, mode='wb', method='internal')
    if ( result != 0 | file.exists(tempfilez) == FALSE  | file.size(tempfilez) <= 3072  ) return(invisible(result))
    file.rename(tempfilez, destfilez)
    result <- unzip(destfilez, files=file.path(sprintf('scala-%s', ver),'lib', 'scala-library.jar'), 
                    exdir=installPath)
    file.copy(file.path(installPath,file.path(sprintf('scala-%s', ver),'lib', 'scala-library.jar' )), 
              file.path(installPath, sprintf("scala-library-%s.jar", ver)))
    unlink(file.path(installPath,sprintf('scala-%s', ver)), recursive = T)
    unlink(destfilez)
    unlink(tempfilez)
    return(0)
  }
  
  installPath <- file.path(system.file(package="KoNLP"),"java")
  url <- sprintf("http://central.maven.org/maven2/org/scala-lang/scala-library/%s/scala-library-%s.jar", ver, ver)
  ret <- tryCatch(
    {
      destfile <- file.path(installPath,basename(url))
      tempf <- tempfile()
      result <- download.file(url,tempf, mode='wb', method='internal')
      if ( result != 0  | file.exists(tempf) == FALSE  | file.size(tempf) <= 3072){
        warning(sprintf("unable to locate %s", destfile))
      }
      file.copy(tempf, destfile)
      unlink(tempf)
      return(0)
    }, 
    error  =when_error_warn, 
    warning=when_error_warn, 
    finally={
      if ( file.exists(destfile) & file.size(destfile) >= 3072) {
        cat("Successfully installed Scala runtime library in ",
            destfile,"\n",sep="")
        return(0)
      }else{
        if(file.exists(destfile)) file.remove(destfile)
        message(sprintf('Fail to install scala-library-%s.jar. Recommand to install library manually in %s', ver, installPath))
        return(1)
      }    
    }
  )
  invisible(ret)
}




