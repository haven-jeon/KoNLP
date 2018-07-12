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

public class KoJamoAutomata extends KoHangulAutomata {

	public KoJamoAutomata(boolean force) {
		super(force);
		// TODO Auto-generated constructor stub
	}

	// input will be jamo sequences
	@Override
	protected void feed(char ch) {
		rawChar.add(ch);
		if (KoHangul.isJamo(ch)) {
			if (KoHangul.isJaeum(ch)) { // JAEUM
				if (choSung == 0) { // chosung 0
					if (jwungSung != 0 || jongSung != 0) {
						if (forceConvert) {
							pushcomp();
							choSung = ch;
						} else {
							wordValid = 0;
						}
					} else {
						choSung = ch;
					}
				} else if (jwungSung == 0) { // chosung 1 jwungsung 0
					if (jongSung != 0) {
						wordValid = 0;
					} else {
						pushcomp();
						choSung = ch;
					}
				} else if (jongSung == 0) { // chosung 1 jungsung 1 jongsung 0
					if (KoHangul.getJongsungIdx(ch) == null) {
						pushcomp();
						choSung = ch;
					} else {
						jongSung = ch;
					}
				} else { // full
					String jong = KoHangul.getKeyfromCode(jongSung);
					int len = jong.length();
					// assert(len == 1);
					if (len == 1) {
						char trymul[] = new char[10];
						System.arraycopy(jong.toCharArray(), 0, trymul, 0, jong.length());
						trymul[0] = jong.charAt(0);
						String jong2nd = KoHangul.getKeyfromCode(ch);;
						System.arraycopy(jong2nd.toCharArray(), 0, trymul, jong.length(), jong2nd.length());
						String strTrymul = new String(trymul, 0, jong.length() + jong2nd.length());
						if (KoHangul.isInKeyCode(strTrymul)) {
							jongSung = KoHangul.getCodefromKey(strTrymul); // can be multi jongsung
						} else {
							pushcomp();
							choSung = ch;
						}
					} else if (len == 2) {
						pushcomp();
						choSung = ch;
					} else {
						assert (false);
					}
				}
			} else {// MOEUM
				if (jongSung == 0) { // jongsung 0
					if (jwungSung == 0) { // jwungsung 0
						jwungSung = ch;
					} else { // jongsung 0 jwungsung 1
						char trymul[] = new char[10];
						String jwung = KoHangul.getKeyfromCode(jwungSung);
						System.arraycopy(jwung.toCharArray(), 0, trymul, 0, jwung.length());
						String jwung2nd = KoHangul.getKeyfromCode(ch);
						System.arraycopy(jwung2nd.toCharArray(), 0, trymul,jwung.length(), jwung2nd.length());
						String strTrymul = new String(trymul, 0, jwung.length() + jwung2nd.length());
						if (KoHangul.isInKeyCode(strTrymul)) { // multi jwungsung
							jwungSung = KoHangul.getCodefromKey(strTrymul);
						} else {
							pushcomp();
							jwungSung = ch;
						}
					}
				} else { // jongsung 1
					String jong = KoHangul.getKeyfromCode(jongSung);
					int jongLen = jong.length();
					assert ((jongLen) > 0 && (jongLen < 3)); // must be 1 or 2
																// char
					if (jongLen > 1) {
						final char strF[] = { jong.charAt(0)};
						char ojong = KoHangul.getCodefromKey(new String(strF,0, 1)); 
						final char strS[] = { jong.charAt(1)};
						char ncho = KoHangul.getCodefromKey(new String(strS,0,1));
						jongSung = ojong;
						pushcomp();
						choSung = ncho;
						jwungSung = ch;
					} else {
						char njong = jongSung;
						jongSung = 0;
						pushcomp();
						choSung = njong;
						jwungSung = ch;
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
		KoHangulAutomata am = new KoJamoAutomata(false);
		System.out.println(am.convert("ㅈㅓㄴㅎㅡㅣㅇㅜㅓㄴ"));
		am.clear();
		System.out.println(am.convert("ㅇㅏㄹㅁ"));
		am.clear();
		System.out.println(am.convert("sksms wjdakf glaemfdj"));
	}

}
