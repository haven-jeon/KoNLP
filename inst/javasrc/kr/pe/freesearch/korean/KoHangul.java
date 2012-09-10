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

import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;

public class KoHangul {

	static final int MAX_KEYSTROKE_SIZE = 100;
	static final int HANGUL_SYLLABLE_START = 0xAC00;
	static final int HANGUL_SYLLABLE_END = 0xD7A3;

	static final char DIVIDER = '｜';
	static final char ASCII_DIVIDER = '|';

	static final int KO_HANGUL_SUCCESS = 1;
	static final int KO_HANGUL_ERROR = -1;
	static final int KO_HANGUL_NOT_ENOUGH_SPACE = -2;
	static final int KO_HANGUL_CONTAIN_ASCII = -3;
	static final int KO_HANGUL_NOT_CONVERTIBLE = -4;

	static final int JAMO_LEN_PER_SYLLABLE = 3;

	public static boolean isHangul(char ch) {
		return ((HANGUL_SYLLABLE_START <= (int) ch && (int) ch <= HANGUL_SYLLABLE_END) || isJamo(ch));
	}
	
	public static boolean isHangulString(String str){
		if(str.length() == 0){
			return false;
		}
		char[] strchar = str.toCharArray();
		for(int i = 0; i < strchar.length;i++){
			if(!isHangul(strchar[i])) {
				return false;
			}
		}
		return true;
	}

	public static boolean isJamo(char ch) {
		return (isJaeum(ch) || isMoeum(ch));
	}

	public static boolean isJamoString(String str){
		if(str.length() == 0){
			return false;
		}
		char[] strchar = str.toCharArray();
		for(int i = 0; i < strchar.length;i++){
			if(!isJamo(strchar[i])) {
				return false;
			}
		}
		return true;
	}
	
	
	public static char convertHalfwidthToFullwidth(char ch) {
		return (char) (((int) ch - 0x41) + 0xFF21);
	}

	// define Jamo mapping table
	// code to Keystrokes
	private static final HashMap<Character, String> codeKeyMap_ = new HashMap<Character, String>() {
		{
			put((char) 0x3131, "r");
			put((char) 0x3132, "R");
			put((char) 0x3133, "rt");
			put((char) 0x3134, "s");
			put((char) 0x3135, "sw");
			put((char) 0x3136, "sg");
			put((char) 0x3137, "e");
			put((char) 0x3138, "E");
			put((char) 0x3139, "f");
			put((char) 0x313a, "fr");
			put((char) 0x313b, "fa");
			put((char) 0x313c, "fq");
			put((char) 0x313d, "ft");
			put((char) 0x313e, "fx");
			put((char) 0x313f, "fv");
			put((char) 0x3140, "fg");
			put((char) 0x3141, "a");
			put((char) 0x3142, "q");
			put((char) 0x3143, "Q");
			put((char) 0x3144, "qt");
			put((char) 0x3145, "t");
			put((char) 0x3146, "T");
			put((char) 0x3147, "d");
			put((char) 0x3148, "w");
			put((char) 0x3149, "W");
			put((char) 0x314a, "c");
			put((char) 0x314b, "z");
			put((char) 0x314c, "x");
			put((char) 0x314d, "v");
			put((char) 0x314e, "g");
			put((char) 0x314f, "k");
			put((char) 0x3150, "o");
			put((char) 0x3151, "i");
			put((char) 0x3152, "O");
			put((char) 0x3153, "j");
			put((char) 0x3154, "p");
			put((char) 0x3155, "u");
			put((char) 0x3156, "P");
			put((char) 0x3157, "h");
			put((char) 0x3158, "hk");
			put((char) 0x3159, "ho");
			put((char) 0x315a, "hl");
			put((char) 0x315b, "y");
			put((char) 0x315c, "n");
			put((char) 0x315d, "nj");
			put((char) 0x315e, "np");
			put((char) 0x315f, "nl");
			put((char) 0x3160, "b");
			put((char) 0x3161, "m");
			put((char) 0x3162, "ml");
			put((char) 0x3163, "l");
			put((char) 0, "");
		}
	};

	// Keystroke to code
	private static final HashMap<String, Character> keyCodeMap_ = new HashMap<String, Character>() {
		{
			put("r", (char) 0x3131);
			put("R", (char) 0x3132);
			put("rt", (char) 0x3133);
			put("s", (char) 0x3134);
			put("sw", (char) 0x3135);
			put("sg", (char) 0x3136);
			put("e", (char) 0x3137);
			put("E", (char) 0x3138);
			put("f", (char) 0x3139);
			put("fr", (char) 0x313a);
			put("fa", (char) 0x313b);
			put("fq", (char) 0x313c);
			put("ft", (char) 0x313d);
			put("fx", (char) 0x313e);
			put("fv", (char) 0x313f);
			put("fg", (char) 0x3140);
			put("a", (char) 0x3141);
			put("q", (char) 0x3142);
			put("Q", (char) 0x3143);
			put("qt", (char) 0x3144);
			put("t", (char) 0x3145);
			put("T", (char) 0x3146);
			put("d", (char) 0x3147);
			put("w", (char) 0x3148);
			put("W", (char) 0x3149);
			put("c", (char) 0x314a);
			put("z", (char) 0x314b);
			put("x", (char) 0x314c);
			put("v", (char) 0x314d);
			put("g", (char) 0x314e);
			put("k", (char) 0x314f);
			put("o", (char) 0x3150);
			put("i", (char) 0x3151);
			put("O", (char) 0x3152);
			put("j", (char) 0x3153);
			put("p", (char) 0x3154);
			put("u", (char) 0x3155);
			put("P", (char) 0x3156);
			put("h", (char) 0x3157);
			put("hk", (char) 0x3158);
			put("ho", (char) 0x3159);
			put("hl", (char) 0x315a);
			put("y", (char) 0x315b);
			put("n", (char) 0x315c);
			put("nj", (char) 0x315d);
			put("np", (char) 0x315e);
			put("nl", (char) 0x315f);
			put("b", (char) 0x3160);
			put("m", (char) 0x3161);
			put("ml", (char) 0x3162);
			put("l", (char) 0x3163);
			put("", (char) 0);
		}
	};

	// multi jwung,jongsung to code
	private static final HashMap<String, Character> multiJamoCodeMap_ = new HashMap<String, Character>() {
		{
			put("ㄱㅅ", (char) 0x3133);
			put("ㄴㅈ", (char) 0x3135);
			put("ㄴㅎ", (char) 0x3136);
			put("ㄹㄱ", (char) 0x313a);
			put("ㄹㅁ", (char) 0x313b);
			put("ㄹㅂ", (char) 0x313c);
			put("ㄹㅅ", (char) 0x313d);
			put("ㄹㅌ", (char) 0x313e);
			put("ㄹㅍ", (char) 0x313f);
			put("ㄹㅎ", (char) 0x3140);
			put("ㅂㅅ", (char) 0x3144);
			put("ㅗㅏ", (char) 0x3158);
			put("ㅗㅐ", (char) 0x3159);
			put("ㅗㅣ", (char) 0x315a);
			put("ㅜㅓ", (char) 0x315d);
			put("ㅜㅔ", (char) 0x315e);
			put("ㅜㅣ", (char) 0x315f);
			put("ㅡㅣ", (char) 0x3162);
			put("", (char) 0);
		}
	};

	// ㄱ ㄲ ㄴ ㄷ ㄸ ㄹ ㅁ ㅂ ㅃ ㅅ ㅆ ㅇ ㅈ ㅉ ㅊ ㅋ ㅌ ㅍ ㅎ
	private static final Character chosung_[] = { 0x3131, 0x3132, 0x3134,
			0x3137, 0x3138, 0x3139, 0x3141, 0x3142, 0x3143, 0x3145, 0x3146,
			0x3147, 0x3148, 0x3149, 0x314a, 0x314b, 0x314c, 0x314d, 0x314e };

	private static final HashMap<Character, Integer> chosungIdx_ = new HashMap<Character, Integer>() {
		{
			put((char) 0x3131, 0);
			put((char) 0x3132, 1);
			put((char) 0x3134, 2);
			put((char) 0x3137, 3);
			put((char) 0x3138, 4);
			put((char) 0x3139, 5);
			put((char) 0x3141, 6);
			put((char) 0x3142, 7);
			put((char) 0x3143, 8);
			put((char) 0x3145, 9);
			put((char) 0x3146, 10);
			put((char) 0x3147, 11);
			put((char) 0x3148, 12);
			put((char) 0x3149, 13);
			put((char) 0x314a, 14);
			put((char) 0x314b, 15);
			put((char) 0x314c, 16);
			put((char) 0x314d, 17);
			put((char) 0x314e, 18);
		}
	};

	// ㅏ ㅐ ㅑ ㅒ ㅓ ㅔ ㅕ ㅖ ㅗ ㅘ ㅙ ㅚ ㅛ ㅜ ㅝ ㅞ ㅟ ㅠ ㅡ ㅢ ㅣ
	private static final Character jwungsung_[] = { 0x314f, 0x3150, 0x3151,
			0x3152, 0x3153, 0x3154, 0x3155, 0x3156, 0x3157, 0x3158, 0x3159,
			0x315a, 0x315b, 0x315c, 0x315d, 0x315e, 0x315f, 0x3160, 0x3161,
			0x3162, 0x3163 };

	private static final HashMap<Character, Integer> jwungsungIdx_ = new HashMap<Character, Integer>() {
		{
			put((char) 0x314f, 0);
			put((char) 0x3150, 1);
			put((char) 0x3151, 2);
			put((char) 0x3152, 3);
			put((char) 0x3153, 4);
			put((char) 0x3154, 5);
			put((char) 0x3155, 6);
			put((char) 0x3156, 7);
			put((char) 0x3157, 8);
			put((char) 0x3158, 9);
			put((char) 0x3159, 10);
			put((char) 0x315a, 11);
			put((char) 0x315b, 12);
			put((char) 0x315c, 13);
			put((char) 0x315d, 14);
			put((char) 0x315e, 15);
			put((char) 0x315f, 16);
			put((char) 0x3160, 17);
			put((char) 0x3161, 18);
			put((char) 0x3162, 19);
			put((char) 0x3163, 20);
		}
	};

	// ㄱ ㄲ ㄳ ㄴ ㄵ ㄶ ㄷ ㄹ ㄺ ㄻ ㄼ ㄽ ㄾ ㄿ ㅀ ㅁ ㅂ ㅄ ㅅ ㅆ ㅇ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ
	private static final Character jongsung_[] = { 0, 0x3131, 0x3132, 0x3133,
			0x3134, 0x3135, 0x3136, 0x3137, 0x3139, 0x313a, 0x313b, 0x313c,
			0x313d, 0x313e, 0x313f, 0x3140, 0x3141, 0x3142, 0x3144, 0x3145,
			0x3146, 0x3147, 0x3148, 0x314a, 0x314b, 0x314c, 0x314d, 0x314e };

	private static final HashMap<Character, Integer> jongsungIdx_ = new HashMap<Character, Integer>() {
		{
			put((char) 0, 0);
			put((char) 0x3131, 1);
			put((char) 0x3132, 2);
			put((char) 0x3133, 3);
			put((char) 0x3134, 4);
			put((char) 0x3135, 5);
			put((char) 0x3136, 6);
			put((char) 0x3137, 7);
			put((char) 0x3139, 8);
			put((char) 0x313a, 9);
			put((char) 0x313b, 10);
			put((char) 0x313c, 11);
			put((char) 0x313d, 12);
			put((char) 0x313e, 13);
			put((char) 0x313f, 14);
			put((char) 0x3140, 15);
			put((char) 0x3141, 16);
			put((char) 0x3142, 17);
			put((char) 0x3144, 18);
			put((char) 0x3145, 19);
			put((char) 0x3146, 20);
			put((char) 0x3147, 21);
			put((char) 0x3148, 22);
			put((char) 0x314a, 23);
			put((char) 0x314b, 24);
			put((char) 0x314c, 25);
			put((char) 0x314d, 26);
			put((char) 0x314e, 27);
		}
	};

	private static final HashSet<Character> jaeum_ = new HashSet<Character>(
			Arrays.asList(new Character[] { 0x3131, 0x3132, 0x3133, 0x3134,
					0x3135, 0x3136,
					// G GG GS N NJ NH
					0x3137, 0x3138, 0x3139, 0x313a, 0x313b, 0x313c,
					// D DD L LG LM LB
					0x313d, 0x313e, 0x313f, 0x3140, 0x3141, 0x3142,
					// LS LT LP LH M B
					0x3143, 0x3144, 0x3145, 0x3146, 0x3147, 0x3148,
					// BB BS S SS NG J
					0x3149, 0x314a, 0x314b, 0x314c, 0x314d, 0x314e }));

	private static final HashSet<Character> moeum_ = new HashSet<Character>(
			Arrays.asList(jwungsung_));

	private KoHangul() {
	}

	public static boolean isInCodeKey(char code) {
		return codeKeyMap_.containsKey(code);
	}

	public static boolean isInKeyCode(String key) {
		return keyCodeMap_.containsKey(key);
	}

	public static char getCodefromKey(String key) {
		return keyCodeMap_.get(key);
	}

	public static boolean isInMultiJamo(String jamos) {
		return multiJamoCodeMap_.containsKey(jamos);
	}

	public static char getMultiJamo(String jamos) {
		return multiJamoCodeMap_.get(jamos);
	}

	public static String getKeyfromCode(char code) {
		return codeKeyMap_.get(code);
	}

	public static boolean isJaeum(char ch) {
		return jaeum_.contains(ch);
	}

	public static boolean isJaeumString(String str){
		if(str.length() == 0){
			return false;
		}
		char[] strchar = str.toCharArray();
		for(int i = 0; i < strchar.length;i++){
			if(!isJaeum(strchar[i])) {
				return false;
			}
		}
		return true;
	}
	
	public static boolean isAscii(char ch){
		return ch < 128;
	}
	
	public static boolean isAsciiString(String str){
		if(str.length() == 0){
			return false;
		}
		char[] strchar = str.toCharArray();
		for(int i = 0; i < strchar.length;i++){
			if(!isAscii(strchar[i])) {
				return false;
			}
		}
		return true;
	}
	
	public static boolean isMoeum(char ch) {
		return moeum_.contains(ch);
	}

	public static boolean isMoeumString(String str){
		if(str.length() == 0){
			return false;
		}
		char[] strchar = str.toCharArray();
		for(int i = 0; i < strchar.length;i++){
			if(!isMoeum(strchar[i])) {
				return false;
			}
		}
		return true;
	}
	
	public static Integer getChosungIdx(char ch) {
		return chosungIdx_.get(ch);
	}

	public static Integer getJwungsungIdx(char ch) {
		return jwungsungIdx_.get(ch);
	}

	public static Integer getJongsungIdx(char ch) {
		return jongsungIdx_.get(ch);
	}

	// 가 = 0xAC00 + 0(ㄱ)*588 + 0(ㅏ)*28 + 0(none) = 0xAC00
	public static char convertJamosToHangulSyllable(final char[] jamos) {
		if (jamos.length != JAMO_LEN_PER_SYLLABLE) {
			return 0; // must be 3
		}
		if (jamos[0] == 0 || jamos[1] == 0) {
			return (jamos[0] != 0 ? jamos[0] : jamos[1]);
		}
		return ((char) (HANGUL_SYLLABLE_START + getChosungIdx(jamos[0]) * 588
				+ getJwungsungIdx(jamos[1]) * 28 + getJongsungIdx(jamos[2])));
	}

	// input must be Hangul
	protected static final char[] convertHangulSyllableToJamo(
			final char syllable) {
		int jamoBuf1, jamoBuf2, jamoBuf3;
		char jamos[] = new char[] { 0, 0, 0 };

		// only consider Hangul Syllable
		/*
		 * if(!isHangul(syllable)){ throw new HangulException(syllable +
		 * " is not convertible to Jamos!"); }
		 */
		if (isJaeum(syllable)) {
			jamos[0] = syllable;
			return jamos;
		}
		if (isMoeum(syllable)) {
			jamos[1] = syllable;
			return jamos;
		}

		jamoBuf3 = syllable - HANGUL_SYLLABLE_START;
		jamoBuf1 = jamoBuf3 / (21 * 28);
		jamoBuf3 = jamoBuf3 % (21 * 28);
		jamoBuf2 = jamoBuf3 / 28;
		jamoBuf3 = jamoBuf3 % 28;

		jamos[0] = chosung_[jamoBuf1];
		jamos[1] = jwungsung_[jamoBuf2];
		jamos[2] = jongsung_[jamoBuf3];
		return jamos;
	}

	protected static final String convertHangulStringToJamos(
			final String hangul, boolean div) throws HangulException {
		StringBuffer sb = new StringBuffer(hangul.length() * 6);
		// char jamos[] = new char[hangul.length() * 4];
		// int k = 0;
		for (int i = 0; i < hangul.length(); i++) {
			if (!isHangul(hangul.charAt(i))) {
				sb.append(hangul.charAt(i));
			} else {
				char jamo[] = convertHangulSyllableToJamo(hangul.charAt(i));
				assert (jamo.length == JAMO_LEN_PER_SYLLABLE);
				for (int j = 0; j < jamo.length; j++) {
					if ((int) jamo[j] == 0) {
						continue;
					}
					sb.append(jamo[j]);
				}
			}
			// insert divider at the end of each Syllable
			if (div)
				sb.append(DIVIDER);
		}
		return (new String(sb)).trim();
	}

	protected static final String convertHangulStringToKeyStrokes(
			final String origSyllables, boolean isFullwidth, boolean div) {
		char keystrokes[] = new char[origSyllables.length() * 6];
		int keyIdx = 0;
		for (int i = 0; i < origSyllables.length(); i++) {
			if (isHangul(origSyllables.charAt(i))) {
				char[] jamos = convertHangulSyllableToJamo(origSyllables.charAt(i));
				for (char jamo : jamos) {
					char keys[] = getKeyfromCode(jamo).toCharArray();
					char fwKeys[] = new char[keys.length];
					for (int j = 0; j < keys.length; j++) {
						if(isFullwidth){
							fwKeys[j] = convertHalfwidthToFullwidth(keys[j]);
						}else{
							fwKeys[j] = keys[j];
						}
					}
					System.arraycopy(fwKeys, 0, keystrokes, keyIdx,
							fwKeys.length);
					keyIdx += fwKeys.length;
				}
			} else {
				keystrokes[keyIdx++] = origSyllables.charAt(i);
			}
			if (div)
				keystrokes[keyIdx++] = DIVIDER;
		}
		return new String(keystrokes, 0, keyIdx);
	}
	

}
