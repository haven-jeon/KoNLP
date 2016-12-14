## Test environments

* OS X 10.11.6, R 3.3.2
* Ubuntu 12.04, R 3.3.2
* Windows 10, R 3.3.2
* OS X 10.11.6, R-devel 3.4.0 Under development (unstable) (2016-10-26 r71594)

## R CMD check results

There were no ERRORs or WARNINGs. 

There was 1 NOTE:

* checking installed package size ... NOTE
  installed size is  6.4Mb
  sub-directories of 1Mb or more:
    java   6.0Mb

`java/scala-lang-library-2.11.8.jar`(5.8Mb) will be installed via internet during `.onLoad()` if necessary.

## Downstream dependencies

I have also run R CMD check on downstream dependencies of KoNLP. 
All packages that I could install passed.


