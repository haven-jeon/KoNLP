## Test environments
* OS X 10.11.6, R 3.3.2
* ubuntu 12.04 (on travis-ci), R 3.3.2
* Windows 10, R 3.3.2

## R CMD check results
There were no ERRORs or WARNINGs. 

There was 1 NOTE:

* checking installed package size ... NOTE
  installed size is  6.7Mb
  sub-directories of 1Mb or more:
    java   6.3Mb

  inst/java/org.scala-lang-library_2.11.8.jar

## Downstream dependencies
I have also run R CMD check on downstream dependencies of httr 
(https://github.com/wch/checkresults/blob/master/httr/r-release). 
All packages that I could install passed except:

* Ecoengine: this appears to be a failure related to config on 
  that machine. I couldn't reproduce it locally, and it doesn't 
  seem to be related to changes in httr (the same problem exists 
  with httr 0.4).