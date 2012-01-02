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
along with JHanNanum.  If not, see <http://www.gnu.org/licenses/>   
*/

package org.apache.lucene.search.spell.korean;

public class KoKeystrokeAutomata extends KoHangulAutomata {

	public KoKeystrokeAutomata(boolean force) {
		super(force);
		// TODO Auto-generated constructor stub
	}

	protected void feed(char ch) {
		char[] arrCh = { ch };
		String strCh = new String(arrCh);
		rawChar.add(ch);
		if (KoHangul.isInKeyCode(strCh)) {
			char code = KoHangul.getCodefromKey(strCh);
			if (KoHangul.isJaeum(code)) { // JAEUM
				if (choSung == 0) { // chosung 0
					if (jwungSung != 0 || jongSung != 0) {
						if (forceConvert) {
							pushcomp();
							choSung = code;
						} else {
							wordValid = 0;
						}
					} else {
						choSung = code;
					}
				} else if (jwungSung == 0) { // chosung 1 jwungsung 0
					if (jongSung != 0) {
						wordValid = 0;
					} else {
						pushcomp();
						choSung = code;
					}
				} else if (jongSung == 0) { // chosung 1 jungsung 1 jongsung 0
					if (KoHangul.getJongsungIdx(code) == -1) {
						pushcomp();
						choSung = code;
					} else {
						jongSung = code;
					}
				} else { // full
					String jong = KoHangul.getKeyfromCode(jongSung);
					int len = jong.length();
					// assert(len == 1);
					if (len == 1) {
						char trymul[] = new char[10];
						trymul[0] = jong.charAt(0);
						trymul[1] = ch;
						trymul[2] = '\0';
						if (KoHangul.isInKeyCode(new String(trymul))) {
							jongSung = KoHangul.getCodefromKey(new String(
									trymul)); // can be multi jongsung
						} else {
							pushcomp();
							choSung = code;
						}
					} else if (len == 2) {
						pushcomp();
						choSung = code;
					} else {
						assert (false);
					}
				}
			} else {// MOEUM
				if (jongSung == 0) { // jongsung 0
					if (jwungSung == 0) { // jwungsung 0
						jwungSung = code;
					} else { // jongsung 0 jwungsung 1
						char trymul[] = new char[10];
						String jwung = KoHangul.getKeyfromCode(jwungSung);
						System.arraycopy(jwung.toCharArray(), 0, trymul, 0,
								jwung.length());
						trymul[jwung.length()] = ch;
						trymul[jwung.length() + 1] = '\0';
						if (KoHangul.isInKeyCode(new String(trymul))) { // multi
																		// jwungsung
							jwungSung = KoHangul.getCodefromKey(new String(
									trymul));
						} else {
							pushcomp();
							jwungSung = code;
						}
					}
				} else { // jongsung 1
					String jong = KoHangul.getKeyfromCode(jongSung);
					int jongLen = jong.length();
					assert ((jongLen) > 0 && (jongLen < 3)); // must be 1 or 2
																// char
					if (jongLen > 1) {
						final char strF[] = { jong.charAt(0), '\0' };
						char ojong = KoHangul.getCodefromKey(new String(strF)); // ㄴㅎ
																				// ->
																				// ㄴ
																				// ㅎ
						final char strS[] = { jong.charAt(1), '\0' };
						char ncho = KoHangul.getCodefromKey(new String(strS));
						jongSung = ojong;
						pushcomp();
						choSung = ncho;
						jwungSung = code;
					} else {
						char njong = jongSung;
						jongSung = 0;
						pushcomp();
						choSung = njong;
						jwungSung = code;
					}
				}
			}
		} else { // invalid key code
			int isUncompleted =  finalization();
			if (isUncompleted == 0 || isUncompleted == 2 ) {
				HangulBuffer.add(ch);
			}
		}
	}

	public static void main(String[] args) {
		KoHangulAutomata am = new KoKeystrokeAutomata(false);
		System.out.println(am.convert("rjatordpswls"));
		am.clear();
		System.out.println(am.convert("sksms wjdakf glaemfdj"));
	}

}
