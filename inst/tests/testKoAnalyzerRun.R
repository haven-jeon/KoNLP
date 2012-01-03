context("test KoAnalyzerRun.R")


test_that("HangulAutomata test", {
          expect_equal(HangulAutomata("ㅂㅐㅍㅗ ㅈㅗㄱㅓㄴㅇㅢ ㅅㅏㅇㅅㅔㅎㅏㄴㄱㅓㅅㅇㅔ ㄷㅐㅎㅐㅅㅓㄴㅡㄴ 'license()'",F,F),
            "배포 조건의 상세한것에 대해서는 'license()'")
          expect_equal(HangulAutomata("ㅂㅐㅍㅗ ㅈㅗㄱㅓㄴㅇㅢ ㅅㅏㅇㅅㅔㅎㅏㄴㄱㅓㅅㅇㅔㅔ ㄷㅐㅎㅐㅅㅓㄴㅡㄴ 'license()'",F,T),
            "배포 조건의 상세한것에ㅔ 대해서는 'license()'")
          expect_equal(HangulAutomata("rhrkawk",T,F), "고감자")
          expect_equal(HangulAutomata("abcd"), "abcd")
          expect_equal(HangulAutomata("rjatordpswls",T,F), "검색엔진")
          expect_equal(HangulAutomata("rjatordpswlls",T,T), "검색엔지ㅣㄴ")
          expect_equal(HangulAutomata("ㅈㅓㄴㅎㅡㅣㅇㅜㅓㄴ"), "전희원")
          expect_equal(HangulAutomata("ㄷㅏㄹㅁㅇㅡㄴㄲㅗㄹ"), "닮은꼴")
          })

#test_that("convertto",{})


