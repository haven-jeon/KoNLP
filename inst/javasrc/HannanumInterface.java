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


import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

import kr.ac.kaist.swrc.jhannanum.comm.Eojeol;
import kr.ac.kaist.swrc.jhannanum.comm.Sentence;
import kr.ac.kaist.swrc.jhannanum.hannanum.Workflow;
import kr.ac.kaist.swrc.jhannanum.plugin.MajorPlugin.MorphAnalyzer.ChartMorphAnalyzer.KoNLPChartMorphAnalyzer;
import kr.ac.kaist.swrc.jhannanum.plugin.MajorPlugin.PosTagger.HmmPosTagger.KoNLPHMMTagger;
import kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.MorphemeProcessor.UnknownMorphProcessor.UnknownProcessor;
import kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.PlainTextProcessor.InformalSentenceFilter.InformalSentenceFilter;
import kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.PlainTextProcessor.SentenceSegmentor.SentenceSegmentor;
import kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.PosProcessor.NounExtractor.NounExtractor;
import kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.PosProcessor.SimplePOSResult09.SimplePOSResult09;
import kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.PosProcessor.SimplePOSResult22.SimplePOSResult22;
import kr.pe.freesearch.KoNLP.KoNLPUtil;

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

	public int reloadUserDic(String dicPath, String work) throws IOException{
		if(work.equals("extractNoun")){
			if(wfNoun != null){
				wfNoun.reloadUserDic(dicPath);
				return 0;
			}
			return -1;
		}else if(work.equals("SimplePos09")){
			if(wf09 != null){
				wf09.reloadUserDic(dicPath);
				return 0;
			}
			return -1;
		}else if(work.equals("SimplePos22")){
			if(wf22 != null){
				wf22.reloadUserDic(dicPath);
				return 0;
			}
			return -1;
		}else if(work.equals("MorphAnalyzer")){
			if(wfMorphAnalyzer != null){
				wfMorphAnalyzer.reloadUserDic(dicPath);
				return 0;
			}
			return -1;
		}
		return -2;
	}
	
	public void reloadUserDic(String dicPath) throws IOException{
		if(wfNoun != null){
			wfNoun.reloadUserDic(dicPath);
		}
		if(wf09 != null){
			wf09.reloadUserDic(dicPath);
		}
		if(wf22 != null){
			wf22.reloadUserDic(dicPath);
		}
		if(wfMorphAnalyzer != null){
			wfMorphAnalyzer.reloadUserDic(dicPath);
		}
	}
	
	//This function is not for dictionary updating.plz use reloadUserDic functions.
	public String[] extractNoun(String basedir, String sentence, String userDicFile) {
		if (wfNoun == null) {
			wfNoun = new Workflow(basedir);
			wfNoun.appendPlainTextProcessor(new SentenceSegmentor(), null);
			wfNoun.appendPlainTextProcessor(new InformalSentenceFilter(), null);
			wfNoun.setMorphAnalyzer(new KoNLPChartMorphAnalyzer(),
					"conf/plugin/MajorPlugin/MorphAnalyzer/ChartMorphAnalyzer.json");
			wfNoun.setMorphUserDic(userDicFile);
			
			wfNoun.appendMorphemeProcessor(new UnknownProcessor(), null);

			wfNoun.setPosTagger(new KoNLPHMMTagger(),
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

	public String MorphAnalyzer(String basedir, String sentence, String userDicFile) {
		if (wfMorphAnalyzer == null) {
			wfMorphAnalyzer = new Workflow(basedir);
			wfMorphAnalyzer.appendPlainTextProcessor(new SentenceSegmentor(),
					null);
			wfMorphAnalyzer.appendPlainTextProcessor(
					new InformalSentenceFilter(), null);

			wfMorphAnalyzer
					.setMorphAnalyzer(new KoNLPChartMorphAnalyzer(),
							"conf/plugin/MajorPlugin/MorphAnalyzer/ChartMorphAnalyzer.json");
			wfMorphAnalyzer.setMorphUserDic(userDicFile);
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

	public String SimplePos22(String basedir, String sentence, String userDicFile) {
		if (wf22 == null) {
			wf22 = new Workflow(basedir);
			wf22.appendPlainTextProcessor(new SentenceSegmentor(), null);
			wf22.appendPlainTextProcessor(new InformalSentenceFilter(), null);

			wf22.setMorphAnalyzer(new KoNLPChartMorphAnalyzer(),
					"conf/plugin/MajorPlugin/MorphAnalyzer/ChartMorphAnalyzer.json");
			wf22.setMorphUserDic(userDicFile);
			wf22.appendMorphemeProcessor(new UnknownProcessor(), null);

			wf22.setPosTagger(new KoNLPHMMTagger(),
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

	public String SimplePos09(String basedir, String sentence, String userDicFile) {
		if (wf09 == null) {
			wf09 = new Workflow(basedir);
			wf09.appendPlainTextProcessor(new SentenceSegmentor(), null);
			wf09.appendPlainTextProcessor(new InformalSentenceFilter(), null);

			wf09.setMorphAnalyzer(new KoNLPChartMorphAnalyzer(),
					"conf/plugin/MajorPlugin/MorphAnalyzer/ChartMorphAnalyzer.json");
			wf09.setMorphUserDic(userDicFile);
			wf09.appendMorphemeProcessor(new UnknownProcessor(), null);

			wf09.setPosTagger(new KoNLPHMMTagger(),
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

	public static void main(String[] args) throws IOException {
		/*HannanumInterface hi = new HannanumInterface();
		String[] ret = hi.extractNoun("C:/R/R-2.15.1/library/Sejong/dics/handics.zip", "성긴털제비꽃은 근무중이다.","D:/opensource/Sejong/inst/dics/handics/data/kE/dic_user2.txt");
		for(int i= 0; i < ret.length; i++){
			System.out.println(ret[i]);
		}
		
		
		System.out.println(hi.SimplePos22("D:/opensource/Sejong/inst/dics/handics.zip","죽어도 못 보내 버스 타요....장미 컵", "D:/opensource/Sejong/inst/dics/handics/data/kE/dic_user2.txt"));
		
		
		System.out.println(hi.SimplePos09("D:/opensource/Sejong/inst/dics/handics.zip","죽어도 못 보내 버스 타요....장미 컵", "D:/opensource/Sejong/inst/dics/handics/data/kE/dic_user2.txt"));
	
		int i = hi.reloadUserDic("D:/opensource/Sejong/inst/dics/handics/data/kE/dic_user.txt", "extractNoun");
		System.out.println(String.valueOf(i));
		
		System.out.println("end");
		
		String[] ret1 = hi.extractNoun("C:/R/R-2.15.1/library/Sejong/dics/handics.zip", "성긴털제비꽃은 근무중이다.", "D:/opensource/Sejong/inst/dics/handics/data/kE/dic_user.txt");
		for(int i1= 0; i1 < ret1.length; i1++){
			System.out.println(ret1[i1]);
		}*/
		String[] ret1 = KoNLPUtil.readZipDic("C:/R/R-2.15.1/library/Sejong/dics/handics.zip", "data/kE/dic_user2.txt");
		for(int i1= 0; i1 < ret1.length; i1++){
			System.out.println(ret1[i1]);
		}
		
		System.out.println("adsd".matches("[a-zA-Z]+"));
		
	}
	
	
}
