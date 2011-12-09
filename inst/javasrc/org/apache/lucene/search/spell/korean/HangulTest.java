package org.apache.lucene.search.spell.korean;

import static org.junit.Assert.*;

import java.io.IOException;
import java.io.StringReader;

import org.junit.Test;
import org.apache.lucene.analysis.*;
import org.apache.lucene.search.spell.KoLevensteinDistance;

public class HangulTest {
	@Test public void testKoHangul() throws HangulException{
		char test1 = '전';
		char[] ret = KoHangul.convertHangulSyllableToJamo(test1);
		char test1Res = KoHangul.convertJamosToHangulSyllable(ret);
		//System.out.println(ret);
		//System.out.println(test1Res);
		assertTrue(test1Res == test1);
		
		char test2 = '꿚';
		char[] ret2 = KoHangul.convertHangulSyllableToJamo(test2);
		char test2Res = KoHangul.convertJamosToHangulSyllable(ret2);
		//System.out.println(ret2);
		//System.out.println(test1Res);
		assertTrue(test2Res == test2);	
	}
	
	@Test public void testConvertHangulStringToJamos() throws HangulException {
		String jamos = KoHangul.convertHangulStringToJamos("전희원");
		String expected = "ㅈㅓㄴ｜ㅎㅢ｜ㅇㅝㄴ｜";
		//System.out.println(jamos);
		//System.out.println(expected);
		assertTrue(jamos.equals(expected));
	}
	
	@Test public void testConvertHangulStringToKeyStrokes(){
		//ｒｊａｔｏｒｄｐｓｗｌｓ1234abcdfr
		//ｒｊａｔｏｒｄｐｓｄｋｗｌｓ1234abcdfr
		String ret = KoHangul.convertHangulStringToKeyStrokes("검색엔ㅇㅏ진1234abcdfrA");
		System.out.println(ret);
		assertTrue(true);
	}
	
	@Test public void testStandardTokenizer() throws IOException{
		KoHangulSepllTokenizer  tokenizer = new KoHangulSepllTokenizer(new StringReader(";;;a123a4abcd검색엔진眞;;;+a122=="));
		Token nextTok = new Token();
		while(tokenizer.next(nextTok) != null){
			System.out.println(nextTok);
			nextTok.clear();
		}
	}
	
	@Test public void testKoLevensteinDistance(){
		KoLevensteinDistance dist = new KoLevensteinDistance();
		System.out.println(dist.getDistance("abcda", "abcd"));
	}
	
}
