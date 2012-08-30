KoNLP
---------------

This package lets you do text mining with Korean morphological analyzer on R. 

  - Interfacing with opensource [Hannanum analyzer](http://semanticweb.kaist.ac.kr/home/index.php/HanNanum).
  - Some twiks are applied on Hannanum analyzer for bigger user dictionary for [Sejong project](http://www.sejong.or.kr/). 
  - Many other functions for Korean text analysis like keystroke conversion, is.jamo, is.hangul, Hangul antomata...   

Some of Korean tutorials are on [my blog](http://freesearch.pe.kr), English pages are mainly on [wiki](https://github.com/haven-jeon/KoNLP/wiki).

To install from CRAN, use

    install.packages('KoNLP')

To install from GitHub, use

    install.packages('devtools')
    library(devtools)
    install_github('Sejong','haven-jeon')
    install_github('KoNLP', 'haven-jeon')





