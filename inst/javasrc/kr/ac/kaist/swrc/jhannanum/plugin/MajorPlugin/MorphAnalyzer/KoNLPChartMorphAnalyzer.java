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
package kr.ac.kaist.swrc.jhannanum.plugin.MajorPlugin.MorphAnalyzer;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.StringTokenizer;

import kr.ac.kaist.swrc.jhannanum.comm.Eojeol;
import kr.ac.kaist.swrc.jhannanum.comm.PlainSentence;
import kr.ac.kaist.swrc.jhannanum.comm.SetOfSentences;
import kr.ac.kaist.swrc.jhannanum.plugin.MajorPlugin.MorphAnalyzer.ChartMorphAnalyzer.AnalyzedDic;
import kr.ac.kaist.swrc.jhannanum.plugin.MajorPlugin.MorphAnalyzer.ChartMorphAnalyzer.ChartMorphAnalyzer;
import kr.ac.kaist.swrc.jhannanum.plugin.MajorPlugin.MorphAnalyzer.ChartMorphAnalyzer.Connection;
import kr.ac.kaist.swrc.jhannanum.plugin.MajorPlugin.MorphAnalyzer.ChartMorphAnalyzer.ConnectionNot;
import kr.ac.kaist.swrc.jhannanum.plugin.MajorPlugin.MorphAnalyzer.ChartMorphAnalyzer.MorphemeChart;
import kr.ac.kaist.swrc.jhannanum.plugin.MajorPlugin.MorphAnalyzer.ChartMorphAnalyzer.NumberDic;
import kr.ac.kaist.swrc.jhannanum.plugin.MajorPlugin.MorphAnalyzer.ChartMorphAnalyzer.PostProcessor;
import kr.ac.kaist.swrc.jhannanum.plugin.MajorPlugin.MorphAnalyzer.ChartMorphAnalyzer.Simti;
import kr.ac.kaist.swrc.jhannanum.plugin.MajorPlugin.MorphAnalyzer.ChartMorphAnalyzer.Trie;
import kr.ac.kaist.swrc.jhannanum.share.JSONReader;
import kr.ac.kaist.swrc.jhannanum.share.TagSet;

/**
 * @author heewon jeon
 *
 */
public class KoNLPChartMorphAnalyzer extends ChartMorphAnalyzer {
	/** Name of this plug-in. */
	final static private String PLUG_IN_NAME = "KoNLPMorphAnalyzer";

	/** Pre-analyzed dictionary. */
	private AnalyzedDic analyzedDic = null;
	
	/** Default morpheme dictionary. */
	private Trie systemDic = null;
	
	/** Additional morpheme dictionary that users can modify for their own purpose. */
	private Trie userDic = null;
	
	/** Number dictionary, which is actually a automata. */
	private NumberDic numDic = null;
	
	/** Morpheme tag set */
	private TagSet tagSet = null;
	
	/** Connection rules between morphemes. */
	private Connection connection = null;
	
	/** Impossible connection rules. */
	private ConnectionNot connectionNot = null;

	/** Lattice-style morpheme chart. */
	private MorphemeChart chart = null;
	
	/** SIMTI structure for reverse segment position. */
	private Simti simti = null;

	/** The file path for the impossible connection rules. */
	private String fileConnectionsNot = "";

	/** The file path for the connection rules. */
	private String fileConnections = "";

	/** The file path for the pre-analyzed dictionary. */
	private String fileDicAnalyzed = "";

	/** The file path for the default morpheme dictionary. */
	private String fileDicSystem = "";

	/** The file path for the user morpheme dictionary. */
	private String fileDicUser = "";

	/** The file path for the tag set. */
	private String fileTagSet = "";
	
	/** Eojeol list */
	private LinkedList<Eojeol> eojeolList = null;
	
	/** Post-processor to deal with some exceptions */
	private PostProcessor postProc = null;
	
	
	/**
	 * It processes the input plain eojeol by analyzing it or searching the pre-analyzed dictionary.
	 * @param plainEojeol - plain eojeol to analyze
	 * @return the morphologically analyzed eojeol list
	 */
	private Eojeol[] processEojeol(String plainEojeol) {
		String analysis = analyzedDic.get(plainEojeol);

		eojeolList.clear();
		
		if (analysis != null) {
			// the eojeol was registered in the pre-analyzed dictionary
			StringTokenizer st = new StringTokenizer(analysis, "^");
			while (st.hasMoreTokens()) {
				String analyzed = st.nextToken();
				String[] tokens = analyzed.split("\\+|/");
				
				String[] morphemes = new String[tokens.length / 2];
				String[] tags = new String[tokens.length / 2];
				
				for (int i = 0, j = 0; i < morphemes.length; i++) {
					morphemes[i] = tokens[j++];
					tags[i] = tokens[j++];
				}
				Eojeol eojeol = new Eojeol(morphemes, tags);
				eojeolList.add(eojeol);
			}
		} else {
			// analyze the input plain eojeol
			chart.init(plainEojeol);
			chart.analyze();
			chart.getResult();
		}
		
		return eojeolList.toArray(new Eojeol[0]);
	}



	/**
	 * Initializes the Chart-based Morphological Analyzer plug-in.
	 * @param baseDir - the path for base directory, which should have the 'conf' and 'data' directory
	 * @param configFile - the path for the configuration file (relative path to the base directory)
	 */
	@Override
	public void initialize(String baseDir, String configFile) throws Exception {
		JSONReader json = new JSONReader(configFile);
		
		fileDicSystem = baseDir + "/" + json.getValue("dic_system");
		fileDicUser = baseDir + "/" + json.getValue("dic_user");
		fileConnections = baseDir + "/" + json.getValue("connections");
		fileConnectionsNot = baseDir + "/" + json.getValue("connections_not");
		fileDicAnalyzed = baseDir + "/" + json.getValue("dic_analyzed");
		fileTagSet = baseDir + "/" + json.getValue("tagset");

		tagSet = new TagSet();
		tagSet.init(fileTagSet, TagSet.TAG_SET_KAIST);

		connection = new Connection();
		connection.init(fileConnections, tagSet.getTagCount(), tagSet);

		connectionNot = new ConnectionNot();
		connectionNot.init(fileConnectionsNot, tagSet);

		analyzedDic = new AnalyzedDic();
		analyzedDic.readDic(fileDicAnalyzed);

		systemDic = new Trie(Trie.DEFAULT_TRIE_BUF_SIZE_SYS);
		systemDic.read_dic(fileDicSystem, tagSet);
		//Why specific values are in Trie class? need to be modified..
		userDic = new Trie(Trie.DEFAULT_TRIE_BUF_SIZE_SYS);
		userDic.read_dic(fileDicUser, tagSet);

		numDic = new NumberDic();
		simti = new Simti();
		simti.init();
		eojeolList = new LinkedList<Eojeol>();
		
		chart = new MorphemeChart(tagSet, connection, systemDic, userDic, numDic, simti, eojeolList);
		
		postProc = new PostProcessor();
	}
}
