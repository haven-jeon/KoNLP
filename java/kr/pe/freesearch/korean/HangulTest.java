/*  Copyright 2011 Heewon Jeon(madjakarta@gmail.com)

This file is part of KoNLP.

KoNLP is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

KoNLP is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with KoNLP.  If not, see <http://www.gnu.org/licenses/>   
*/

package kr.pe.freesearch.korean;

import static org.junit.Assert.*;

import java.io.IOException;
import java.io.StringReader;

import org.junit.Test;

public class HangulTest {
	@Test
	public void testKoHangul() throws HangulException {
		char test1 = '전';
		char[] ret = KoHangul.convertHangulSyllableToJamo(test1);
		char test1Res = KoHangul.convertJamosToHangulSyllable(ret);
		// System.out.println(ret);
		// System.out.println(test1Res);
		assertTrue(test1Res == test1);

		char test2 = '꿚';
		char[] ret2 = KoHangul.convertHangulSyllableToJamo(test2);
		char test2Res = KoHangul.convertJamosToHangulSyllable(ret2);
		// System.out.println(ret2);
		// System.out.println(test1Res);
		assertTrue(test2Res == test2);
	}

	@Test
	public void testConvertHangulStringToJamos() throws HangulException {
		String jamos = KoHangul.convertHangulStringToJamos("전 희원asd", true);
		String expected = "ㅈㅓㄴ｜ ｜ㅎㅢ｜ㅇㅝㄴ｜a｜s｜d｜";
		System.out.println(jamos);
		// System.out.println(expected);
		assertTrue(jamos.equals(expected));
	}

	@Test
	public void testConvertHangulStringToKeyStrokes() {
		// ｒｊａｔｏｒｄｐｓｗｌｓ1234abcdfr
		// ｒｊａｔｏｒｄｐｓｄｋｗｌｓ1234abcdfr
		String ret = KoHangul.convertHangulStringToKeyStrokes(
				"검색엔ㅇㅏ진1 234abcdfrA", true, false);
		System.out.println(ret);
		assertTrue(true);
	}

	

}
