package examples;

import java.lang.reflect.Field;
import java.net.URI;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Properties;

import lemurproject.indri.ParsedDocument;
import lemurproject.indri.ParsedDocument.TermExtent;
import lemurproject.indri.QueryAnnotation;
import lemurproject.indri.QueryEnvironment;
import lemurproject.indri.ScoredExtentResult;

import org.json.JSONArray;
import org.json.JSONObject;

public class TestQuery {
	static QueryEnvironment env = null;
	static {
		try {
			// System.setProperty("java.library.path","/Users/ntson/Downloads/lemur-installed/lib");
			System.setProperty("java.library.path", "lemur-installed/lib");

			// System.setProperty("java.library.path","/Users/nguyenson/Programs/lemur-installed/lib");
			// System.setProperty("java.library.path","Z:\\lemur\\services\\lemur-installed\\lib");
			Field fieldSysPath = ClassLoader.class
					.getDeclaredField("sys_paths");
			fieldSysPath.setAccessible(true);
			fieldSysPath.set(null, null);

			Properties props = System.getProperties();
			System.out.println("java.library.path="
					+ props.get("java.library.path"));
		} catch (Exception e) {

		}

		try {
			env = new QueryEnvironment();
			Config config = new Config("config.json");
			JSONArray indexs = config.getIndexPaths();
			for (int i = 0; i < indexs.length(); i++) {
				env.addIndex(indexs.getString(i));
				// env.addIndex("/Volumes/i1501/s1520203/lemur/legal_lrec_index");
				// env.addIndex("/Volumes/i1501/s1520203/lemur/civilcode-index");
				// env.addIndex("Z:\\lemur\\civilcode-index");
			}

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public static void main(String[] args) throws Exception {
		// Config config = new Config("config.json");
		// System.out.println(config.getAtribute("indexs"));

		//Test 1
		System.out.println(TestQuery.query("this Section shall"));
		
		//Test 2
		JSONObject o = new JSONObject();
		o.put("query", "this Section shall");
		o.put("n", 20);
		TestQuery.query2(o.toString());
	}

	public static String query(String queryString) throws Exception {
		// TODO Auto-generated method stub
		// QueryEnvironment env = new QueryEnvironment();

		// env.addIndex("/Users/ntson/Downloads/000lemur-index");

		String[] stopWords = { "this", "a" };
		env.setStopwords(stopWords);
		// String[] rules =
		// {"method:linear,collectionLambda:0.40,documentLambda:0.00"};
		// env.setScoringRules(rules);
		QueryAnnotation results = env.runAnnotatedQuery(queryString, 10);
		// System.out.println(results.);

		ScoredExtentResult[] scored = results.getResults();

		String[] names;
		ParsedDocument[] documents = null;

		try {
			names = env.documentMetadata(scored, "docno");
			documents = env.documents(scored);
			System.out.println("COUNT " + env.documentCount());
		} catch (Exception exc1) {
			// no titles, something bad happened.
			names = new String[scored.length];
			// error(exc.toString());
		}
		JSONObject result = new JSONObject();
		JSONArray docs = new JSONArray();

		for (int i = 0; i < names.length; i++) {
			System.out.println("DOC " + i);
			JSONObject doc = new JSONObject();
			ParsedDocument adoc = documents[i];
			try {
				doc.put("text", adoc.text.substring(0, 100));

			} catch (Exception ee) {
				doc.put("text", "");
			}

			String termText = "";

			// System.out.println();
			// System.out.println(adoc.positions.length);
			// TermExtent[] terms = adoc.positions;
			//
			// for(int j=0; j < terms.length;j++)
			// {
			// System.out.println(terms[j].begin + "\t" + terms[j].end);
			// }
			//
			// for(int j=0; j < adoc.terms.length;j++)
			// {
			// termText += adoc.terms[j] + " ";
			// System.out.println(adoc.terms[j]);
			// }

			doc.put("terms", termText);
			doc.put("path", names[i]);
			doc.put("score", scored[i].score);
			System.out.println(names[i] + "\t" + scored[i].score);

			// docs.put(names[i]);
			docs.put(doc);
		}
		result.put("result", docs);
		return result.toString();
		// return Arrays.toString(names);
	}

	public static String query2(String jsonString) throws Exception {

		JSONObject param = new JSONObject(jsonString);
		String queryString = param.getString("query");
		int nResult = param.getInt("n"); 
		String fileName = "stop-word-list.txt";		
		List<String> list = Files.readAllLines(Paths.get(fileName), Charset.defaultCharset());
		String[] stopWords = list.toArray(new String[list.size()]);
		env.setStopwords(stopWords);
		
		QueryAnnotation results = env.runAnnotatedQuery(queryString, nResult);
		ScoredExtentResult[] scored = results.getResults();

		String[] names;
		ParsedDocument[] documents = null;

		try {
			names = env.documentMetadata(scored, "docno");
			documents = env.documents(scored);
			System.out.println("COUNT " + env.documentCount());
		} catch (Exception exc1) {
			// no titles, something bad happened.
			names = new String[scored.length];
			// error(exc.toString());
		}
		JSONObject result = new JSONObject();
		JSONArray docs = new JSONArray();

		for (int i = 0; i < names.length; i++) {
			System.out.println("DOC " + i);
			JSONObject doc = new JSONObject();
			ParsedDocument adoc = documents[i];
			doc.put("text", adoc.text);			

			String termText = "";
			
			doc.put("terms", termText);
	
			doc.put("path", names[i]);
			doc.put("score", scored[i].score);
			System.out.println(names[i] + "\t" + scored[i].score);

			// docs.put(names[i]);
			docs.put(doc);
		}
		result.put("result", docs);
		return result.toString();
	}

}
