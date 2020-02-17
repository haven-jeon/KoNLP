


#' scala_library_install
#'
#' @param ver which scala version to install
#' @importFrom utils download.file unzip
scala_library_install <- function(ver = '2.11.8') {
  
  when_error_warn <- function(cond){
    message(cond)
    if(file.exists(destfile)) file.remove(destfile)
    url <- sprintf("https://downloads.lightbend.com/scala/%s/scala-%s.zip", ver, ver)
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
  url <- sprintf("https://repo1.maven.org/maven2/org/scala-lang/scala-library/%s/scala-library-%s.jar", ver, ver)
  ret <- tryCatch(
    {
      destfile <- file.path(installPath,basename(url))
      print("DEBUG start")
      print(destfile) # DEBUG
      tempf <- tempfile()

      # DEBUG
      # - https scheme is not supported by 'internal' method. 
      # - method='auto' may resolve the issue. 
      #   If method="autho" is chosen (by default)
      #     On a UNIX-like method, "libcurl" is used except "internal" for file:// scheme.
      #     On a Windows the "wininet" method is used apart from for ftps:// scheme. 

      #result <- download.file(url,tempf, mode='wb', method='internal')
      # Method 1. Simple, but consistency is not guaranteed.
      #result <- download.file(url,tempf,mode='wb',method='auto')
      
      # Method 2: Reference https://support.rstudio.com/hc/en-us/articles/206827897-Secure-Package-Downloads-for-R
      if(getRversion() > '3.2.0') {
        print("My R is over 3.2.0")
        # Method 2 for R 3.2+.
        if(.Platform$OS.type == "windows") {
          opt_method = 'wininet'
          #result <- download.file(url,tempf,mode='wb',method='wininet')
        } else {
          opt_method = 'libcurl'
          #result <- download.file(url,tempf,mode='wb',method='libcurl')
        }
        
      } else {
        # Method 2 for R 3.1 and earlier.
        if(.Platform$OS.type == "windows") {
          # Windows
          utils::setInternet2(TRUE)
          opt_method = 'internal'
        } else if (.Platform$OS.type == "unix" && grepl("^darwin", R.version$os)) { #FIXEDME: any better expr?
          # MacOS
          opt_method = 'curl'
        } else if (.Platform$OS.type == "unix" && grepl("^linux-gnu", R.version$os)) { #FIXEDME: any better expr?
          # Linux
          opt_method = 'wget'
        }
      }

      # DEBUG
      print(paste("scala-library target url:",url,sep=" "))
      print(paste("'method' parameter for download.file() function in your R: ",opt_method,sep=" "))
      result <- download.file(url,tempf,mode='wb',method=opt_method)

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
      
      print(file.exists(destfile)) # FALSE
      print(file.size(destfile)) # NA

      if ( file.exists(destfile) & file.size(destfile) >= 3072) {
        cat("Successfully installed Scala runtime library in ",
            destfile,"\n",sep="")
        return(0)
      }else{
        if(file.exists(destfile)) file.remove(destfile)
        message(sprintf("\nFail to locate 'scala-library-%s.jar'. Recommand to locate 'scala-library-%s.jar' manually on %s", ver, ver, installPath))
        return(1)
      }    
    }
  )
  invisible(ret)
}




