context("test KoNLP")


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

test_that("convertHangulStringToKeyStrokes test",{
          expect_equal(convertHangulStringToKeyStrokes("전희원"), c("ｗｊｓ" , "ｇｍｌ" , "ｄｎｊｓ"))
          expect_equal(convertHangulStringToKeyStrokes("전희원",F), c("wjs",  "gml",  "dnjs"))
          expect_warning(convertHangulStringToKeyStrokes("abc"))
          #below can be error in R CMD check, because testthat reguard this source code is not UTF-8.
          #expect_equal(convertHangulStringToKeyStrokes("저"), "ｗｊ")
          })

test_that("convertHangulStringToJamos test", {
         expect_equal(convertHangulStringToJamos("닮은꼴고감자희"), c("ㄷㅏㄻ","ㅇㅡㄴ","ㄲㅗㄹ","ㄱㅗ","ㄱㅏㅁ","ㅈㅏ","ㅎㅢ"))
         expect_warning(convertHangulStringToJamos("abc"))
         })


test_that("is.jamo is.hangul test", {
         expect_equal(is.hangul("나보기가역겨워가신다면은"), TRUE)
         expect_equal(is.hangul("사뿐히즈려밟고"), TRUE)
         expect_equal(is.hangul("ㅈㅏㅁㅗ자모"), TRUE)
         expect_equal(is.hangul("abcd"), FALSE)
         expect_equal(is.hangul(" "), FALSE)
         expect_equal(is.jamo("ㅈㅏㅁㅗ"), T)
         expect_equal(is.jamo("자모"), F)
         expect_equal(is.jamo("abc%##"), F)
         })

test_that("Hannanum test", {
        expect_warning(extractNoun("굉장히긴문장을넣었을때에러를내놓아야된다."))
        expect_warning(SimplePos09("굉장히긴문장을넣었을때에러를내놓아야된다."))
        expect_warning(SimplePos22("굉장히긴문장을넣었을때에러를내놓아야된다."))

        expect_equal(extractNoun("슈퍼마켓이 판매하고 있는 흑마늘 양념 치킨이 논란이 되고 있다."), 
                    c("슈퍼마켓","판매","흑마늘","양념","치킨","논란"))
         })

test_that("dictionary function test", {
        expect_that(useSejongDic(), prints_text("words were added to dic_user.txt"))
        expect_that(useSystemDic(), prints_text("words were added to dic_user.txt"))
         })






