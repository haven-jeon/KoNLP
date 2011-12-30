\name{HangulAutomata}
\alias{HangulAutomata}
\title{HangulAutomata}
\usage{
  HangulAutomata(input, isKeystroke = F, isForceConv = F)
}
\arguments{
  \item{input}{to be processed mostly Jamo sequences}

  \item{isKeystroke}{boolean parameter to check input is
  keystroke or Jamo sequences}

  \item{isForceConv}{boolean parameter to force converting
  if input is not valid Jamo or keystroke sequences.}
}
\value{
  complete Hangul syllable
}
\description{
  function to be used for converting to complete Hangul
  syllables from Jamo or Keystrokes
}

