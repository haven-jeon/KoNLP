package org.apache.lucene.search.spell.korean;


import java.util.ArrayList;


public class KoAutomata {
	private boolean wordValid;
	private char choSung;
	private char jwungSung;
	private char jongSung;
	private ArrayList<Character> HangulBuffer = new ArrayList<Character>();
	private ArrayList<Character> Syllables = new ArrayList<Character>();
	private ArrayList<Character> rawChar = new ArrayList<Character>();
	private boolean forceConvert;

	private void clearComp() {
		choSung = 0;
		jwungSung = 0;
		jongSung = 0;
	}

	private void pushcomp() {
		if (!(choSung != 0 && jwungSung != 0)) {
			wordValid = false;
		}
		char jamos[] = { choSung, jwungSung, jongSung };
		Syllables.add(KoHangul.convertJamosToHangulSyllable(jamos));
		clearComp();
	}

	private int finalization() {
		int r = 0;
		ArrayList<Character> rjio = new ArrayList<Character>();
		if (choSung != 0 || jwungSung != 0 || jongSung != 0) {
			pushcomp();
		}
		if (forceConvert) {
			wordValid = true;
		}
		if (!rawChar.isEmpty() || !Syllables.isEmpty()) {
			if (wordValid) {
				rjio.addAll(Syllables);
				r = 0;
			} else {
				wordValid = true;
				rjio.addAll(rawChar);
				r = 1;
			}

			rawChar.clear();
			Syllables.clear();

			if (!rjio.isEmpty()) {
				HangulBuffer.addAll(rjio);
				return r;
			}
		}
		return 0;
	}

	private void feed(char ch){
		char[] arrCh = {ch};
		String strCh = new String(arrCh);
		rawChar.add(ch);
		if(KoHangul.isInKeyCode(strCh)){
			char code = KoHangul.getCodefromKey(strCh);
			if(KoHangul.isJaeum(code)){ // JAEUM
				if(choSung == 0){ // chosung 0
					if(jwungSung !=0 || jongSung != 0){
						if(forceConvert){
							pushcomp();
							choSung = code;
						}else{
							wordValid = false;
						}
					}else{
						  choSung = code;
					}
				}else if(jwungSung == 0){ //chosung 1 jwungsung 0
					  if(jongSung != 0){
						  wordValid = false;
					  }else{
						  pushcomp();
						  choSung = code;
					  }	
				}else if(jongSung == 0){ //chosung 1 jungsung 1 jongsung 0
					if(KoHangul.getJongsungIdx(code) == -1){
						pushcomp();
						choSung = code;
					}else{
						jongSung = code;
					}
				}else{ // full
					String jong = KoHangul.getKeyfromCode(jongSung);
					int len = jong.length();
					//assert(len == 1);
					if(len == 1){
						char trymul[] = new char[10];
						trymul[0] = jong.charAt(0);
						trymul[1] = ch;
						trymul[2] = '\0';
						if(KoHangul.isInKeyCode(new String(trymul))){
							jongSung = KoHangul.getCodefromKey(new String(trymul)); // can be multi jongsung
						}else{
							pushcomp();
							choSung = code;
						}	
					}else if(len == 2){
						pushcomp();
						choSung = code;
					}else{
						assert(false);
					}
				}
			}else{// MOEUM
				if(jongSung == 0){ // jongsung 0
					if(jwungSung == 0){ //jwungsung 0
						jwungSung = code;
					}else{ // jongsung 0 jwungsung 1
						char trymul[] = new char[10];
						String jwung = KoHangul.getKeyfromCode(jwungSung);
						System.arraycopy(jwung.toCharArray(), 0, trymul, 0, jwung.length());
						trymul[jwung.length()] = ch;
						trymul[jwung.length() + 1] = '\0';
						if(KoHangul.isInKeyCode(new String(trymul))){ // multi jwungsung
							jwungSung = KoHangul.getCodefromKey(new String(trymul));
						}else{
							pushcomp();
							jwungSung = code;
						}
					}
				}else{ // jongsung 1
					String jong = KoHangul.getKeyfromCode(jongSung);
					int jongLen = jong.length();
					assert((jongLen) > 0 && (jongLen < 3) ); // must be 1 or 2 char
					if(jongLen > 1){
						final char strF[] = { jong.charAt(0), '\0' };
						char ojong = KoHangul.getCodefromKey(new String(strF)); //ㄴㅎ -> ㄴ ㅎ
						final char strS[] = { KoHangul.getKeyfromCode(jongSung).charAt(1), '\0'};
						char ncho = KoHangul.getCodefromKey(new String(strS));
						jongSung = ojong;
						pushcomp();
						choSung = ncho;
						jwungSung = code;
					}else{
						char njong = jongSung;
						jongSung = 0;
						pushcomp();
						choSung = njong;
						jwungSung = code;
					}
				}
			}
		}else{ // invalid key code
			if(finalization() == 0){
				HangulBuffer.add(ch);
			}
		}
	}

	public KoAutomata(boolean force) {
		wordValid = true;
		choSung = 0;
		jwungSung = 0;
		jongSung = 0;
		forceConvert = force;
		// need to add
	}

	public void clear() {
		HangulBuffer.clear();
		rawChar.clear();
		Syllables.clear();
		wordValid = true;
		clearComp();
	}

	public void setForceConvert(boolean force) {
		forceConvert = force;
	}

	public String convert(final String strKeyStroke) {
		clear();
		for (int i = 0; i < strKeyStroke.length(); i++) {
			feed(strKeyStroke.charAt(i));
		}

		finalization();

		Character[] hb = HangulBuffer.toArray(new Character[0]);
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < hb.length; i++) {
			sb.append(hb[i]);
		}
		return sb.toString();
	}

}
