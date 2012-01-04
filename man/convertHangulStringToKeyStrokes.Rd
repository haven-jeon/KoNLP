\name{convertHangulStringToKeyStrokes}
\alias{convertHangulStringToKeyStrokes}
\title{convertHangulStringToKeyStrokes}
\usage{
  convertHangulStringToKeyStrokes(hangul,
    isFullwidth = TRUE)
}
\arguments{
  \item{hangul}{hangul sentence}

  \item{isFullwidth}{specify returned character will be
  Fullwidth ASCII or Halfwidth ASCII}
}
\value{
  Keystroke sequence
}
\description{
  convert Hangul String to Keystrokes, each Hangul syllable
  can be dilimitered by \emph{OxFF5C}. Example will be
  shown in
  \href{https://github.com/haven-jeon/KoNLP/wiki}{github
  wiki}.
}

