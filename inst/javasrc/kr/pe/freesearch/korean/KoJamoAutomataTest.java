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

import org.junit.Test;

/**
 * @author gogamza
 *
 */
public class KoJamoAutomataTest {

    /**
     * Test method for {@link kr.pe.freesearch.korean.KoHangulAutomata#convert(java.lang.String)}.
     */
    @Test
    public void testConvert() {
    	KoHangulAutomata auto = new KoJamoAutomata(false);
    	String expect = auto.convert("ㄱㅗㄱㅏㅁㅈㅏ");
    	System.out.println(expect + "ㅁㄴ");
    	String actual = "고감자";
    	assertTrue(actual.equals(expect));
    	auto.clear();
    	auto.setForceConvert(true);
    	String expect1 = auto.convert("ㅈㅓㄴㅎㅢㅣㅇㅝㄴ");
    	String actual1 = "전희ㅣ원";
    	assertTrue(actual1.equals(expect1));
    }

}
