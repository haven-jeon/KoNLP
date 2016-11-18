package kr.pe.freesearch.KoNLP;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

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

/**
 * @author gogamza
 *
 */
public class KoNLPUtil {

	public static String[] readZipDic(String zipPath, String dicPath) throws IOException {
		BufferedReader bin = null;
		ZipFile zip = null;
		List<String> list = null;
		try{
			zip = new ZipFile(zipPath);
			ZipEntry entry = zip.getEntry(dicPath);
			bin = new BufferedReader(new InputStreamReader(zip.getInputStream(entry)));
			String str ="";
			list = new ArrayList<String>();
			while((str = bin.readLine()) != null){
				String[] parsed = str.trim().split("\t");
				if(parsed.length != 2 || !parsed[1].matches("[a-zA-Z]+")) {
					continue;
				}
				for(String chunk : parsed){
					list.add(chunk);
				}
			}
		}catch (IOException e) {
			e.printStackTrace();
			if(bin != null) bin.close();
			if(zip != null) zip.close();
		}
		bin.close();
		zip.close();
		return list.toArray(new String[0]);
	}
	
	/**
	 * 
	 */
	private KoNLPUtil() {
		// TODO Auto-generated constructor stub
	}
	
}
