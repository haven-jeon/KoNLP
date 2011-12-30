import java.io.CharArrayReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.lucene.analysis.TokenStream;
import org.apache.lucene.analysis.kr.KoreanAnalyzer;
import org.apache.lucene.analysis.tokenattributes.TermAttribute;

public class Ko {

	KoreanAnalyzer KoAnalyzer = null;

	public Ko() {
		KoAnalyzer = new KoreanAnalyzer();
	}

	public Ko(String[] stopwords) {
		KoAnalyzer = new KoreanAnalyzer(stopwords);
	}

	public String[] KoAnalyze(String sentence) {
		TokenStream stream = KoAnalyzer.tokenStream("null",
				new CharArrayReader(sentence.toCharArray()));
		// OffsetAttribute offsetAttribute = (OffsetAttribute)
		// stream.getAttribute(OffsetAttribute.class);
		// int startOffset = offsetAttribute.startOffset();
		// int endOffset = offsetAttribute.endOffset();
		List<String> list = new ArrayList<String>();
		TermAttribute termAttribute = (TermAttribute) stream
				.getAttribute(TermAttribute.class);
		try {
			stream.reset();
			while (stream.incrementToken()) {
				// startOffset = offsetAttribute.startOffset();
				// endOffset = offsetAttribute.endOffset();
				list.add(termAttribute.toString());
				// buffer[i++] = termAttribute.toString();
			}

			stream.end();
			stream.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}

		return list.toArray(new String[0]);
	}

	/**
	 * @param args
	 */

	public static void main(String[] args) {
		Ko ko = new Ko();
		String[] res = ko.KoAnalyze("검색");
		System.out.println(res[0]);
	}

}
