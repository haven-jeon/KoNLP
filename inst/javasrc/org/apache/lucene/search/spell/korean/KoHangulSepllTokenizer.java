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

import java.io.IOException;
import java.io.Reader;
import java.text.Normalizer;

import org.apache.lucene.analysis.Tokenizer;
import org.apache.lucene.analysis.tokenattributes.OffsetAttribute;
import org.apache.lucene.analysis.tokenattributes.TermAttribute;
import org.apache.lucene.analysis.tokenattributes.TypeAttribute;
import org.apache.lucene.util.AttributeSource;

public class KoHangulSepllTokenizer extends Tokenizer {

	public KoHangulSepllTokenizer(AttributeFactory factory, Reader input) {
		super(factory, input);
		offsetAtt = (OffsetAttribute) addAttribute(OffsetAttribute.class);
		termAtt = (TermAttribute) addAttribute(TermAttribute.class);
		typeAtt = (TypeAttribute) addAttribute(TypeAttribute.class);
		// TODO Auto-generated constructor stub
	}

	public KoHangulSepllTokenizer(AttributeSource source, Reader input) {
		super(source, input);
		offsetAtt = (OffsetAttribute) addAttribute(OffsetAttribute.class);
		termAtt = (TermAttribute) addAttribute(TermAttribute.class);
		typeAtt = (TypeAttribute) addAttribute(TypeAttribute.class);
		// TODO Auto-generated constructor stub
	}

	public KoHangulSepllTokenizer(Reader input) {
		super(input);
		offsetAtt = (OffsetAttribute) addAttribute(OffsetAttribute.class);
		termAtt = (TermAttribute) addAttribute(TermAttribute.class);
		typeAtt = (TypeAttribute) addAttribute(TypeAttribute.class);
		// TODO Auto-generated constructor stub
	}

	private int offset = 0, bufferIndex = 0, dataLen = 0;
	private final static int MAX_WORD_LEN = 255;
	private final static int IO_BUFFER_SIZE = 1024;
	private final char[] buffer = new char[MAX_WORD_LEN];
	private final char[] ioBuffer = new char[IO_BUFFER_SIZE];

	private enum chType {
		NUMBER, LETTER, HANGUL, START, DEFAULT, END
	};

	private chType prevChType = chType.START;

	private int length;
	private int start;

	private TermAttribute termAtt;
	private OffsetAttribute offsetAtt;
	private TypeAttribute typeAtt;

	private final void push(char c) {

		if (length == 0)
			start = offset - 1; // start of token
		// Normalizer.normalize(new String(), Normalizer.Form.NFKC);
		buffer[length++] = c; // buffer it
	}

	private final boolean flush(chType curType) {
		if (length > 0) {
			// System.out.println(new String(buffer, 0,
			// length));
			termAtt.setTermBuffer(buffer, 0, length);
			offsetAtt.setOffset(correctOffset(start), correctOffset(start
					+ length));
			typeAtt.setType(prevChType.name());
			prevChType = curType;
			return true;
		} else {
			prevChType = curType;
			return false;
		}
	}

	public boolean incrementToken() throws IOException {
		clearAttributes();

		length = 0;
		start = offset;

		while (true) {

			final char c;
			offset++;

			if (bufferIndex >= dataLen) {
				dataLen = input.read(ioBuffer);
				bufferIndex = 0;
			}

			if (dataLen == -1) {
				offset--;
				return flush(prevChType);
			} else
				c = ioBuffer[bufferIndex++];

			switch (Character.getType(c)) {
			case Character.UPPERCASE_LETTER:
			case Character.LOWERCASE_LETTER:
			case Character.TITLECASE_LETTER:
			case Character.MODIFIER_LETTER:
				if (processChr(chType.LETTER, c)) {
					return flush(chType.LETTER);
				} else
					prevChType = chType.LETTER;
				break;
			case Character.OTHER_LETTER: // for Hangul processing
				if (processChr(chType.HANGUL, c)) {
					return flush(chType.HANGUL);
				} else
					prevChType = chType.HANGUL;
				break;
			case Character.DECIMAL_DIGIT_NUMBER:
				if (processChr(chType.NUMBER, c)) {
					return flush(chType.NUMBER);
				} else
					prevChType = chType.NUMBER;
				break;
			default:
				if (length > 0)
					return flush(chType.START);
				else
					prevChType = chType.START;
				break;
			}

		}
	}

	// curType : type of curCh
	// return : decide whether run flush() or not.
	private final boolean processChr(chType curType, char curCh) {
		if (prevChType != curType && prevChType != chType.START) {
			if (length > 0) {
				bufferIndex--;
				offset--;
				return true; // run flush()
			}
			push(curCh);
			return true;
		} else {
			push(curCh);
			if (length == MAX_WORD_LEN)
				return true;
		}
		return false;
	}

	public final void end() {
		// set final offset
		final int finalOffset = correctOffset(offset);
		this.offsetAtt.setOffset(finalOffset, finalOffset);
	}

	public void reset() throws IOException {
		super.reset();
		offset = bufferIndex = dataLen = 0;
	}

	public void reset(Reader input) throws IOException {
		super.reset(input);
		reset();
	}

}
