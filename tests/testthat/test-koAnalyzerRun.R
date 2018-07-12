context("test KoNLP")

print("Hannanum test")

useSystemDic()


test_that("Hannanum test", {
        expect_equal(length(SimplePos09("검색엔진 개발자 모임. 그룹 스터디 하자!")),8)
        expect_equal(extractNoun("굉장히긴문장을넣었을때에러를내놓아야된다."), "굉장히긴문장을넣었을때에러를내놓아야된다")
        expect_equal(length(SimplePos09("굉장히긴문장을넣었을때에러를내놓아야된다.")), 2)
        expect_equal(length(SimplePos22("굉장히긴문장을넣었을때에러를내놓아야된다.")), 2)
        expect_equal(extractNoun("슈퍼마켓이 판매하고 있는 흑마늘 양념 치킨이 논란이 되고 있다."), 
                    c("슈퍼마켓","판매","흑마늘","양념","치킨","논란"))
        expect_equal(extractNoun("          "), "          ")
        expect_equal(names(SimplePos09("  "))[1], "  ")
        expect_equal(names(SimplePos22("   \t\t\t\t\t\t\t    "))[1], "   \t\t\t\t\t\t\t    ")
        #expect_equal(length(SimplePos22("검색엔진 개발자 모임. 그룹 스터디 하자!")),8)
        #expect_equal(length(SimplePos22("검색엔진 개발자 모임. 그룹 스터디 하자!. 그런데 어머니께서 밥을 하셨는지 모르겠어.")), 14)
         })


print("HangulAutomata test")

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
          expect_equal(HangulAutomata("ㅇㅗㅃㅏ"), "오빠")
          #expect_warning(HangulAutomata("abc"))
          })

print("convertHangulStringToKeyStrokes test")

test_that("convertHangulStringToKeyStrokes test",{
          expect_equal(convertHangulStringToKeyStrokes("전희원"), c("ｗｊｓ" , "ｇｍｌ" , "ｄｎｊｓ"))
          expect_equal(convertHangulStringToKeyStrokes("전희원",F), c("wjs",  "gml",  "dnjs"))
          #expect_warning(convertHangulStringToKeyStrokes("abc"))
          #below can be error in R CMD check, because testthat reguard this source code is not UTF-8.
          #expect_equal(convertHangulStringToKeyStrokes("저"), "ｗｊ")
          })

print("convertHangulStringToJamos test")

test_that("convertHangulStringToJamos test", {
         expect_equal(convertHangulStringToJamos("닮은꼴고감자희"), c("ㄷㅏㄻ","ㅇㅡㄴ","ㄲㅗㄹ","ㄱㅗ","ㄱㅏㅁ","ㅈㅏ","ㅎㅢ"))
         #expect_warning(convertHangulStringToJamos("abc"))
         })

print("is.jamo is.hangul test")

test_that("is.jamo is.hangul test", {
         expect_equal(is.hangul("나보기가역겨워가신다면은"), TRUE)
         expect_equal(is.hangul("사뿐히즈려밟고"), TRUE)
         expect_equal(is.hangul("ㅈㅏㅁㅗ자모"), TRUE)
         expect_equal(is.hangul("abcd"), FALSE)
         expect_equal(is.hangul(" "), FALSE)
         expect_equal(is.hangul(c("as23", "검색엔진", "크레마1")), c(F,T,F))
         expect_equal(is.jamo("ㅈㅏㅁㅗ"), T)
         expect_equal(is.jamo("자모"), F)
         expect_equal(is.jamo("abc%##"), F)
         expect_equal(is.jamo(c("abc%##", "ㅈㅏㅁㅗ1", "ㅅㅅㅅㅅㅁㅈㄷㅇㄹ")), c(F, F, T))
         expect_equal(is.jaeum("ㄲㅂㅇ"), T)
         expect_equal(is.jaeum("ㄲㄹㅏ"), F)
         expect_equal(is.jaeum("고감자"), F)
         expect_equal(is.jaeum(c("고감자","ㅂㄱㅗ", "ㅓㅓㅅ")), c(F, F, F))
         expect_equal(is.moeum("ㅐ"), T)
         expect_equal(is.moeum("ㅐㅇㄴㅇㅑ"), F)
         expect_equal(is.moeum("고감자"), F)
         expect_equal(is.moeum(c("ㅐㅔㅐㅣㅏㅓㅡ", "ㅈㅂㄷㅈ", "12323")), c(T, F, F))
         expect_equal(is.ascii("asdad"), T)
         expect_equal(is.ascii("asdad$#$@#$$**"), T)
         expect_equal(is.ascii("전ㄴㅇㄴㅇ"), F)
         expect_equal(is.ascii(c("12323", "asdvdf", "ㅈㄷㅈㄱ", "ㄷㄳㄱ", "고감자")), c(T,T,F,F,F))
         })

print("dictionary function test")

test_that("dictionary function test", {
        expect_that(useSejongDic(), prints_text("words dictionary was built"))
        expect_that(useSystemDic(), prints_text("words dictionary was built"))
        expect_that(useNIADic(),    prints_text("words dictionary was built"))
        expect_that(buildDictionary(ext_dic = 'woorimalsam',category_dic_nms = 'life', user_dic = data.frame(term="apple", tag='ncn'), replace_usr_dic=F), prints_text("words dictionary was built"))
         })



print('concordance function test')

test_that('concordance function test', {
  expect_equal(concordance_str('apple orange grapes', "ran", span=1)[[1]][1],  "orang")
  })



