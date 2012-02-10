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
          expect_warning(HangulAutomata("abc"))
          })

test_that("convertHangulStringToKeyStrokes",{
          expect_equal(convertHangulStringToKeyStrokes("전희원"), c("ｗｊｓ" , "ｇｍｌ" , "ｄｎｊｓ"))
          expect_equal(convertHangulStringToKeyStrokes("전희원",F), c("wjs",  "gml",  "dnjs"))
          expect_warning(convertHangulStringToKeyStrokes("abc"))
          #below can be error in R CMD check, because testthat reguard this source code is not UTF-8.
          #expect_equal(convertHangulStringToKeyStrokes("저"), "ｗｊ")
          })

test_that("convertHangulStringToJamos", {
         expect_equal(convertHangulStringToJamos("닮은꼴고감자희"), c("ㄷㅏㄻ","ㅇㅡㄴ","ㄲㅗㄹ","ㄱㅗ","ㄱㅏㅁ","ㅈㅏ","ㅎㅢ"))
         expect_warning(convertHangulStringToJamos("abc"))
         })


test_that("is.jamo is.hangul", {
         expect_equal(is.hangul("나보기가역겨워가신다면은"), TRUE)
         expect_equal(is.hangul("사뿐히즈려밟고"), TRUE)
         expect_equal(is.hangul("ㅈㅏㅁㅗ자모"), TRUE)
         expect_equal(is.hangul("abcd"), FALSE)
         expect_equal(is.hangul(" "), FALSE)
         expect_equal(is.jamo("ㅈㅏㅁㅗ"), T)
         expect_equal(is.jamo("자모"), F)
         expect_equal(is.jamo("abc%##"), F)
         })



