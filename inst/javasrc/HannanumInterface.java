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


import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

import kr.ac.kaist.swrc.jhannanum.comm.Eojeol;
import kr.ac.kaist.swrc.jhannanum.comm.Sentence;
import kr.ac.kaist.swrc.jhannanum.hannanum.Workflow;
import kr.ac.kaist.swrc.jhannanum.plugin.MajorPlugin.MorphAnalyzer.ChartMorphAnalyzer.ChartMorphAnalyzer;
import kr.ac.kaist.swrc.jhannanum.plugin.MajorPlugin.PosTagger.HmmPosTagger.HMMTagger;
import kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.MorphemeProcessor.UnknownMorphProcessor.UnknownProcessor;
import kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.PlainTextProcessor.InformalSentenceFilter.InformalSentenceFilter;
import kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.PlainTextProcessor.SentenceSegmentor.SentenceSegmentor;
import kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.PosProcessor.NounExtractor.NounExtractor;
import kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.PosProcessor.SimplePOSResult09.SimplePOSResult09;
import kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.PosProcessor.SimplePOSResult22.SimplePOSResult22;

public class HannanumInterface {
	private Workflow wfNoun = null;
	private Workflow wfMorphAnalyzer = null;
	private Workflow wf22 = null;
	private Workflow wf09 = null;

	public void reloadAllDic() {
		wfNoun = null;
		wfMorphAnalyzer = null;
		wf22 = null;
		wf09 = null;
	}

	public String[] extractNoun(String basedir, String sentence) {
		if (wfNoun == null) {
			wfNoun = new Workflow(basedir);
			wfNoun.appendPlainTextProcessor(new SentenceSegmentor(), null);
			wfNoun.appendPlainTextProcessor(new InformalSentenceFilter(), null);
			wfNoun.setMorphAnalyzer(new ChartMorphAnalyzer(),
					"conf/plugin/MajorPlugin/MorphAnalyzer/ChartMorphAnalyzer.json");
			wfNoun.appendMorphemeProcessor(new UnknownProcessor(), null);

			wfNoun.setPosTagger(new HMMTagger(),
					"conf/plugin/MajorPlugin/PosTagger/HmmPosTagger.json");
			wfNoun.appendPosProcessor(new NounExtractor(), null);
			try {
				wfNoun.activateWorkflow(false);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				wfNoun.close();
				wfNoun = null;
				return null;
			}
		}
		// Workflow workflow =
		// WorkflowFactory.getPredefinedWorkflow(WorkflowFactory.WORKFLOW_NOUN_EXTRACTOR);
		List<String> list = null;
		try {
			/* Activate the work flow in the thread mode */

			/* Analysis using the work flow */
			wfNoun.analyze(sentence);

			LinkedList<Sentence> resultList = wfNoun
					.getResultOfDocument(new Sentence(0, 0, false));
			list = new ArrayList<String>();
			for (Sentence s : resultList) {
				Eojeol[] eojeolArray = s.getEojeols();
				for (int i = 0; i < eojeolArray.length; i++) {
					if (eojeolArray[i].length > 0) {
						String[] morphemes = eojeolArray[i].getMorphemes();
						for (int j = 0; j < morphemes.length; j++) {
							list.add(morphemes[j]);
						}
					}
				}
			}
			wfNoun.close();

		} catch (Exception e) {
			e.printStackTrace();
			wfNoun.close();
			return null;
		}

		/* Shutdown the work flow */
		wfNoun.close();
		return list.toArray(new String[0]);
	}

	/**
	 * @param args
	 */

	public String MorphAnalyzer(String basedir, String sentence) {
		if (wfMorphAnalyzer == null) {
			wfMorphAnalyzer = new Workflow(basedir);
			wfMorphAnalyzer.appendPlainTextProcessor(new SentenceSegmentor(),
					null);
			wfMorphAnalyzer.appendPlainTextProcessor(
					new InformalSentenceFilter(), null);

			wfMorphAnalyzer
					.setMorphAnalyzer(new ChartMorphAnalyzer(),
							"conf/plugin/MajorPlugin/MorphAnalyzer/ChartMorphAnalyzer.json");
			wfMorphAnalyzer.appendMorphemeProcessor(new UnknownProcessor(),
					null);
			// Workflow workflow =
			// WorkflowFactory.getPredefinedWorkflow(WorkflowFactory.WORKFLOW_MORPH_ANALYZER);
			try {
				wfMorphAnalyzer.activateWorkflow(false);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				wfMorphAnalyzer.close();
				wfMorphAnalyzer = null;
				return null;
			}
		}
		String morphs = null;
		try {
			wfMorphAnalyzer.analyze(sentence);
			morphs = wfMorphAnalyzer.getResultOfDocument();
			wfMorphAnalyzer.close();

		} catch (Exception e) {
			e.printStackTrace();
			wfMorphAnalyzer.close();
			return null;
		}

		return morphs;
	}

	public String SimplePos22(String basedir, String sentence) {
		if (wf22 == null) {
			wf22 = new Workflow(basedir);
			wf22.appendPlainTextProcessor(new SentenceSegmentor(), null);
			wf22.appendPlainTextProcessor(new InformalSentenceFilter(), null);

			wf22.setMorphAnalyzer(new ChartMorphAnalyzer(),
					"conf/plugin/MajorPlugin/MorphAnalyzer/ChartMorphAnalyzer.json");
			wf22.appendMorphemeProcessor(new UnknownProcessor(), null);

			wf22.setPosTagger(new HMMTagger(),
					"conf/plugin/MajorPlugin/PosTagger/HmmPosTagger.json");
			wf22.appendPosProcessor(new SimplePOSResult22(), null);
			try {
				wf22.activateWorkflow(false);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				wf22.close();
				wf22 = null;
				return null;
			}
			// Workflow workflow =
			// WorkflowFactory.getPredefinedWorkflow(WorkflowFactory.WORKFLOW_POS_SIMPLE_22);
		}
		String morphs = null;
		try {
			wf22.analyze(sentence);

			morphs = wf22.getResultOfSentence();

		} catch (Exception e) {
			e.printStackTrace();
			wf22.close();
			return null;
		}

		/* Shutdown the work flow */
		wf22.close();
		return morphs;
	}

	public String SimplePos09(String basedir, String sentence) {
		if (wf09 == null) {
			wf09 = new Workflow(basedir);
			wf09.appendPlainTextProcessor(new SentenceSegmentor(), null);
			wf09.appendPlainTextProcessor(new InformalSentenceFilter(), null);

			wf09.setMorphAnalyzer(new ChartMorphAnalyzer(),
					"conf/plugin/MajorPlugin/MorphAnalyzer/ChartMorphAnalyzer.json");
			wf09.appendMorphemeProcessor(new UnknownProcessor(), null);

			wf09.setPosTagger(new HMMTagger(),
					"conf/plugin/MajorPlugin/PosTagger/HmmPosTagger.json");
			wf09.appendPosProcessor(new SimplePOSResult09(), null);
			// Workflow workflow =
			// WorkflowFactory.getPredefinedWorkflow(WorkflowFactory.WORKFLOW_POS_SIMPLE_09);
			try {
				wf09.activateWorkflow(false);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				wf09.close();
				wf09 = null;
				return null;
			}
		}
		String morphs = null;
		try {
			/* Analysis using the work flow */
			wf09.analyze(sentence);
			morphs = wf09.getResultOfSentence();
		} catch (Exception e) {
			e.printStackTrace();
			wf09.close();
			return null;
		}

		/* Shutdown the work flow */
		wf09.close();
		return morphs;
	}

	public static void main(String[] args) {
		/*
		 * HannanumInterface hi = new HannanumInterface(); String[] ret =
		 * hi.extractNoun
		 * ("C:/Users/haven/Documents/R/win-library/2.14/KoNLP/dics"
		 * ,"죽어도 못 보내 버스 타요....장미 컵 "); for(int i = 0; i < ret.length; i++)
		 * System.out.println(ret[i]); String[] ret2 =
		 * hi.extractNoun("C:/Users/haven/Documents/R/win-library/2.14/KoNLP/dics"
		 * ,"넥스알 데이터 분석팀"); for(int i = 0; i < ret2.length; i++)
		 * System.out.println(ret2[i]); hi.reloadAllDic();
		 */
		char[] a = new char[10];
		a[0] = 'q';
		a[1] = '1';
		a[2] = '\0';
		a[3] = 'c';
		System.out.println(a);
	}
}
