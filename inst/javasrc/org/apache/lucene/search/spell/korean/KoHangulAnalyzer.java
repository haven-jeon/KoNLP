package org.apache.lucene.search.spell.korean;

import java.io.Reader;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.LengthFilter;
import org.apache.lucene.analysis.TokenStream;

public class KoHangulAnalyzer extends Analyzer {

	@Override
	public TokenStream tokenStream(String fieldName, Reader reader) {
		LengthFilter lenFilter = new LengthFilter(new KoHangulSepllTokenizer(reader), 2, 126);
		return lenFilter;
	}

}
