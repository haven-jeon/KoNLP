package kr.pe.freesearch.jhannanum.comm;
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
import java.text.Normalizer;

import kr.ac.kaist.swrc.jhannanum.comm.Eojeol;
import kr.ac.kaist.swrc.jhannanum.comm.Sentence;
import kr.ac.kaist.swrc.jhannanum.hannanum.Workflow;
import kr.ac.kaist.swrc.jhannanum.plugin.MajorPlugin.MorphAnalyzer.ChartMorphAnalyzer.KoNLPChartMorphAnalyzer;
import kr.ac.kaist.swrc.jhannanum.plugin.MajorPlugin.PosTagger.HmmPosTagger.KoNLPHMMTagger;
import kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.MorphemeProcessor.UnknownMorphProcessor.UnknownProcessor;
import kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.PlainTextProcessor.Spacing;
import kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.PlainTextProcessor.InformalSentenceFilter.InformalSentenceFilter;
import kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.PlainTextProcessor.SentenceSegmentor2.SentenceSegmentor2;
import kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.PosProcessor.NounExtractor.NounExtractor;
import kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.PosProcessor.SimplePOSResult09.SimplePOSResult09;
import kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.PosProcessor.SimplePOSResult22.SimplePOSResult22;

public class HannanumInterface {
	private static Workflow wf = null;

	public void reloadAllDic() {
		if(wf != null){
			wf.clear();
			wf = null;
		}

		System.gc();
	}

	public int reloadUserDic(String dicPath, String work) throws IOException{
		if(work.equals("extractNoun")){
			if(wf != null){
				wf.reloadUserDic(dicPath);
				return 0;
			}
			return -1;
		}else if(work.equals("SimplePos09")){
			if(wf != null){
				wf.reloadUserDic(dicPath);
				return 0;
			}
			return -1;
		}else if(work.equals("SimplePos22")){
			if(wf != null){
				wf.reloadUserDic(dicPath);
				return 0;
			}
			return -1;
		}else if(work.equals("MorphAnalyzer")){
			if(wf != null){
				wf.reloadUserDic(dicPath);
				return 0;
			}
			return -1;
		}
		return -2;
	}
	
	public void reloadUserDic(String dicPath) throws IOException{
		if(wf != null){
			wf.reloadUserDic(dicPath);
		}
		
		System.gc();
	}
	
	//This function is not for dictionary updating.plz use reloadUserDic functions.
	// TODO : added force apply user inputted noun to output 
	public String[] extractNoun(String basedir, String sentence, String userDicFile, boolean isSpacing) {
		String ctx = "extractNoun";
		if(isSpacing == true){
			ctx = ctx + "_sp";
		}

		if(wf != null){
			if(!wf.getCtx().equals(ctx)){
				wf.clear();
				wf = null;
			}
		}
		
		
		if (wf == null) {
			wf = new Workflow(basedir, ctx);
			wf.appendPlainTextProcessor(new SentenceSegmentor2(), null);
			if(ctx.equals("extractNoun_sp") ){
				wf.appendPlainTextProcessor(new Spacing(), "");
			}
			wf.appendPlainTextProcessor(new InformalSentenceFilter(), null);
			//wf.appendPlainTextProcessor(new InformalEojeolSentenceFilter(), null);
			
			wf.setMorphAnalyzer(new KoNLPChartMorphAnalyzer(),
					"conf/plugin/MajorPlugin/MorphAnalyzer/ChartMorphAnalyzer.json");
			wf.setMorphUserDic(userDicFile);
			
			wf.appendMorphemeProcessor(new UnknownProcessor(), null);

			wf.setPosTagger(new KoNLPHMMTagger(),
					"conf/plugin/MajorPlugin/PosTagger/HmmPosTagger.json");
			wf.appendPosProcessor(new NounExtractor(), null);
			try {
				wf.activateWorkflow(false);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				wf.close();
				wf = null;
				return null;
			}
		}
		// Workflow workflow =
		// WorkflowFactory.getPredefinedWorkflow(WorkflowFactory.WORKFLOW_NOUN_EXTRACTOR);
		List<String> list = null;
		try {
			/* Activate the work flow in the thread mode */

			/* Analysis using the work flow */
			String n_sentence = Normalizer.normalize(sentence, Normalizer.Form.NFKC);
			wf.analyze(n_sentence);

			LinkedList<Sentence> resultList = wf
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

		} catch (Exception e) {
			e.printStackTrace();
			wf.close();
			return null;
		}

		/* Shutdown the work flow */
		wf.close();
		//wf.close();
		return list.toArray(new String[0]);
	}

	/**
	 * @param args
	 */

	public String MorphAnalyzer(String basedir, String sentence, String userDicFile, boolean isSpacing) {
		String ctx = "MorphAnalyzer";
		if(isSpacing == true){
			ctx = ctx + "_sp";
		}

		if(wf != null){
			if(!wf.getCtx().equals(ctx)){
				wf.clear();
				wf = null;
			}
		}
		
	
		
		if (wf == null) {
			wf = new Workflow(basedir, ctx);
			wf.appendPlainTextProcessor(new SentenceSegmentor2(),null);
			if(ctx.equals("MorphAnalyzer_sp") ){
				wf.appendPlainTextProcessor(new Spacing(), "");
			}
			wf.appendPlainTextProcessor(new InformalSentenceFilter(), null);
			//wf.appendPlainTextProcessor(new Spacing(), "");
			
			//wf.appendPlainTextProcessor(new InformalEojeolSentenceFilter(), null);
			wf.setMorphAnalyzer(new KoNLPChartMorphAnalyzer(),
							"conf/plugin/MajorPlugin/MorphAnalyzer/ChartMorphAnalyzer.json");
			wf.setMorphUserDic(userDicFile);
			wf.appendMorphemeProcessor(new UnknownProcessor(),
					null);
			// Workflow workflow =
			// WorkflowFactory.getPredefinedWorkflow(WorkflowFactory.WORKFLOW_MORPH_ANALYZER);
			try {
				wf.activateWorkflow(false);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				wf.close();
				wf = null;
				return null;
			}
		}
		String morphs = null;
		try {
			String n_sentence = Normalizer.normalize(sentence, Normalizer.Form.NFKC);
			wf.analyze(n_sentence);
			morphs = wf.getResultOfDocument();
			wf.close();

		} catch (Exception e) {
			e.printStackTrace();
			wf.close();
			return null;
		}
		wf.close();
		return morphs;
	}

	public String SimplePos22(String basedir, String sentence, String userDicFile, boolean isSpacing) {
		String ctx = "SimplePos22";
		if(isSpacing == true){
			ctx = ctx + "_sp";
		}
		
		
		if(wf != null){
			if(!wf.getCtx().equals(ctx)){
				wf.clear();
				wf = null;
			}
		}
		
		
		if (wf == null) {
			wf = new Workflow(basedir, ctx);
			wf.appendPlainTextProcessor(new SentenceSegmentor2(), null);
			if(ctx.equals("SimplePos22_sp") ){
				wf.appendPlainTextProcessor(new Spacing(), "");
			}
			wf.appendPlainTextProcessor(new InformalSentenceFilter(), null);
			//wf.appendPlainTextProcessor(new InformalEojeolSentenceFilter(), null);
			
			wf.setMorphAnalyzer(new KoNLPChartMorphAnalyzer(),
					"conf/plugin/MajorPlugin/MorphAnalyzer/ChartMorphAnalyzer.json");
			wf.setMorphUserDic(userDicFile);
			wf.appendMorphemeProcessor(new UnknownProcessor(), null);

			wf.setPosTagger(new KoNLPHMMTagger(),
					"conf/plugin/MajorPlugin/PosTagger/HmmPosTagger.json");
			wf.appendPosProcessor(new SimplePOSResult22(), null);
			try {
				wf.activateWorkflow(false);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				wf.close();
				wf = null;
				return null;
			}
			// Workflow workflow =
			// WorkflowFactory.getPredefinedWorkflow(WorkflowFactory.WORKFLOW_POS_SIMPLE_22);
		}
		String morphs = null;
		try {
			String n_sentence = Normalizer.normalize(sentence, Normalizer.Form.NFKC);
			wf.analyze(n_sentence);

			morphs = wf.getResultOfDocument();

		} catch (Exception e) {
			e.printStackTrace();
			wf.close();
			return null;
		}

		/* Shutdown the work flow */
		wf.close();
		return morphs;
	}

	public String SimplePos09(String basedir, String sentence, String userDicFile, boolean isSpacing) {
		String ctx = "SimplePos09";
		if(isSpacing == true){
			ctx = ctx + "_sp";
		}
		 
		if(wf != null){
			if(!wf.getCtx().equals(ctx)){
				wf.clear();
				wf = null;
			}
		}
		
		if (wf == null) {
			wf = new Workflow(basedir, ctx);
			wf.appendPlainTextProcessor(new SentenceSegmentor2(), null);
			if(ctx.equals("SimplePos09_sp") ){
				wf.appendPlainTextProcessor(new Spacing(), "");
			}
			wf.appendPlainTextProcessor(new InformalSentenceFilter(), null);
			//wf.appendPlainTextProcessor(new InformalEojeolSentenceFilter(), null);

			wf.setMorphAnalyzer(new KoNLPChartMorphAnalyzer(),
					"conf/plugin/MajorPlugin/MorphAnalyzer/ChartMorphAnalyzer.json");
			wf.setMorphUserDic(userDicFile);
			wf.appendMorphemeProcessor(new UnknownProcessor(), null);

			wf.setPosTagger(new KoNLPHMMTagger(),
					"conf/plugin/MajorPlugin/PosTagger/HmmPosTagger.json");
			wf.appendPosProcessor(new SimplePOSResult09(), null);
			// Workflow workflow =
			// WorkflowFactory.getPredefinedWorkflow(WorkflowFactory.WORKFLOW_POS_SIMPLE_09);
			try {
				wf.activateWorkflow(false);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				wf.close();
				wf = null;
				return null;
			}
		}
		String morphs = null;
		try {
			/* Analysis using the work flow */
			String n_sentence = Normalizer.normalize(sentence, Normalizer.Form.NFKC);
			wf.analyze(n_sentence);
			morphs = wf.getResultOfDocument();
		} catch (Exception e) {
			e.printStackTrace();
			wf.close();
			return null;
		}

		/* Shutdown the work flow */
		wf.close();
		return morphs;
	}

	public static void main(String[] args) throws IOException {
		HannanumInterface hi = new HannanumInterface();
		/*String[] ret = hi.extractNoun("C:/R/R-2.15.1/library/Sejong/dics/handic.zip", "성긴털제비꽃은 근무중이다.","D:/opensource/Sejong/inst/dics/handics/data/kE/dic_user2.txt");
		for(int i= 0; i < ret.length; i++){
			System.out.println(ret[i]);
		}*/
		
		String[] ret1 = hi.extractNoun("C:/R/R-3.3.2/library/Sejong/dics/handic.zip", 
				"공보관통상진흥국장전자공업국장무역조사실장제 1차관보.", 
				"C:/R/R-3.3.2/library/KoNLP/../KoNLP_dic/current/dic_user.txt", true);
		for(int i1= 0; i1 < ret1.length; i1++){
			System.out.println(ret1[i1]);
		}
		
		String[] ret2 = hi.extractNoun("C:/R/R-3.3.2/library/Sejong/dics/handic.zip", 
				"인터넷 소설이", 
				"C:/R/R-3.3.2/library/KoNLP/../KoNLP_dic/current/dic_user.txt", true);
		for(int i1= 0; i1 < ret2.length; i1++){
			System.out.println(ret2[i1]);
		}
//		
//		
//		
//		System.out.println("test");
//		System.out.println(hi.SimplePos22("C:/Users/gogamza/Documents/work/Sejong/inst/dics/handic.zip",
//				"'인터넷 소설이 등장하면서' 소설을 쓰는 사람들이 늘어나긴 했지만 \t\t\t", 
//				"C:/R/R-3.3.2/library/KoNLP/../KoNLP_dic/current/dic_user.txt"));
//		
//		
//		System.out.println(hi.SimplePos09("C:/Users/gogamza/Documents/work/Sejong/inst/dics/handic.zip",
//				"'인터넷 소설이 등장하면서' 소설을 쓰는 사람들이 늘어나긴 했지만, 소설을 읽는 사람이 줄어들면서 그들만의 세계가 되어 버렸다. 그러나 이후 국내 소설계에서 무시할 수 없는 비중을 차지하게 된 양판소와 귀여니류 연애소설은 불쏘시개 취급 받으며 시간때우기에 불과하다는 평가를 자주 받곤 하지만, 애초에 시간때우기 용이라는 말은 바꿔 말하면 시간을 때울 정도는 된다는 이야기다. 결국 아무리 까여도 보는 사람이 있기 때문에 쓰고 그것이 출판으로 이어지는 것이다. 특히 귀여니의 소설들은 인터넷 소설이 본격적으로 텍스트화, 즉 출판이 되는 시발점이 되었다는 점에서 여러모로 의의가 있다고 할 수 있다. 사실 문학계에서 온라인의 글이 이모티콘과 맞춤법.을 안 지키고 그대로. 활자화 된 것은 엄청난 혁명이라고 말할 수 있다. 까는거야 까여야 하는 거지만 일단 이런 의의가 있다는건 알아두자.  U.S. A. Introduction. I'm fine... 12.42", 
//				"C:/Users/gogamza/Documents/work/Sejong/inst/dics/handic/data/kE/dic_user2.txt"));
//	
//		//int i = hi.reloadUserDic("D:/opensource/Sejong/inst/dics/handics/data/kE/dic_user.txt", "extractNoun");
//		//System.out.println(String.valueOf(i));
//		
//		System.out.println("end");
//		
//
//		System.out.println("2 time\n");
//
//		String ret2 = hi.MorphAnalyzer("C:/R/R-3.3.2/library/Sejong/dics/handic.zip", 
//				"미국 싱크탱크 전략국제문제연구소(CSIS)의 빅터 차 한국석좌는 9일(현지시간) 미국의 제45대 대통령으로 당선된 도널드 트럼프가 전시작전통제권(전작권)을 한국에 조기에 넘길 가능성이 있다고 전망했다.", 
//				"C:/R/R-3.3.2/library/KoNLP/../KoNLP_dic/current/dic_user.txt");
//		System.out.println(ret2);
//		
//		//String[] ret2 = KoNLPUtil.readZipDic("C:/R/R-2.15.1/library/Sejong/dics/handic.zip", "data/kE/dic_user2.txt");
//		//for(int i1= 0; i1 < ret2.length; i1++){
//		//	System.out.println(ret2[i1]);
//		//}
//		
	}
	
	
}
