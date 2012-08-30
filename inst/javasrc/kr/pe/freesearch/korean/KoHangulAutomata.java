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

import java.util.ArrayList;

public abstract class KoHangulAutomata {
	//0, 1,2 can be value
	//0 mean truly false
	//1 mean truly true
	//2 mean act as if true
	protected short wordValid;
	protected char choSung;
	protected char jwungSung;
	protected char jongSung;
	protected ArrayList<Character> HangulBuffer = new ArrayList<Character>();
	protected ArrayList<Character> Syllables = new ArrayList<Character>();
	protected ArrayList<Character> rawChar = new ArrayList<Character>();
	protected boolean forceConvert;

	protected void clearComp() {
		choSung = 0;
		jwungSung = 0;
		jongSung = 0;
	}

	protected void pushcomp() {
		if (!(choSung != 0 && jwungSung != 0)) {
			wordValid = 0;
		}
		char jamos[] = { choSung, jwungSung, jongSung };
		Syllables.add(KoHangul.convertJamosToHangulSyllable(jamos));
		clearComp();
	}

	protected int finalization() {
		int r = 0;
		ArrayList<Character> rjio = new ArrayList<Character>();
		if (choSung != 0 || jwungSung != 0 || jongSung != 0) {
			pushcomp();
		}
		if(forceConvert){
			wordValid = 2;
		}

		if (!rawChar.isEmpty() || !Syllables.isEmpty()) {
			if (wordValid == 1) {
				rjio.addAll(Syllables);
				r = 0;
			} else if(wordValid == 2){
				rjio.addAll(Syllables);
				r = 2;
			} else {
				rjio.addAll(rawChar);
				r = 1;
			}
			wordValid = 1;
			rawChar.clear();
			Syllables.clear();

			if (!rjio.isEmpty()) {
				HangulBuffer.addAll(rjio);
				return r;
			}
		}
		return 0;
	}

	public KoHangulAutomata(boolean force) {
		wordValid = 1;
		choSung = 0;
		jwungSung = 0;
		jongSung = 0;
		forceConvert = force;
	}

	public void clear() {
		HangulBuffer.clear();
		rawChar.clear();
		Syllables.clear();
		wordValid = 1;
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
		
		int isUncompleted = finalization();
		if(isUncompleted == 1 && !forceConvert){
			return strKeyStroke;
		}
			
		Character[] hb = HangulBuffer.toArray(new Character[0]);
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < hb.length; i++) {
			sb.append(hb[i]);
		}
		return sb.toString();
	}

	abstract protected void feed(char ch);
}
