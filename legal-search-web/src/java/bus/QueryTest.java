/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package bus;

import java.io.File;
import java.lang.reflect.Field;
import java.util.Arrays;
import java.util.Properties;
//import lemurproject.indri.QueryAnnotation;
//import lemurproject.indri.QueryEnvironment;
//import lemurproject.indri.ScoredExtentResult;

/**
 *
 * @author ntson
 */
public class QueryTest {

    static {
        try {
            System.setProperty("java.library.path", "/Users/ntson/Downloads/lemur-installed/lib");
            Field fieldSysPath = ClassLoader.class.getDeclaredField("sys_paths");
            fieldSysPath.setAccessible(true);
            fieldSysPath.set(null, null);

            Properties props = System.getProperties();
            System.out.println("java.library.path=" + props.get("java.library.path"));
        } catch (Exception e) {

        }
    }

//    public static String query() throws Exception {
////            Field field = ClassLoader.class.getDeclaredField("usr_paths");
////            field.setAccessible(true);
////        
////            String s = "/Users/ntson/Downloads/lemur-installed/lib";
////            System.setProperty("java.library.path", System.getProperty("java.library.path") + File.pathSeparator + s);
//
//            //System.setProperty("java.library.path", "/Users/ntson/Downloads/lemur-installed/lib");
//        //Field fieldSysPath = ClassLoader.class.getDeclaredField( "sys_paths" );
//        //fieldSysPath.setAccessible( true );
//        //fieldSysPath.set( null, null );  
//        QueryEnvironment env = new QueryEnvironment();
//        env.addIndex("/Users/ntson/Downloads/000lemur-index");
//
//        QueryAnnotation results = env.runAnnotatedQuery("This code", 10);
//        //System.out.println(results.);
//
//        ScoredExtentResult[] scored = results.getResults();
//        System.out.println(scored[0].document);
//
//        String[] names;
//        try {
//            names = env.documentMetadata(scored, "docno");
//        } catch (Exception exc1) {
//            // no titles, something bad happened.
//            names = new String[scored.length];
//            //			    error(exc.toString());
//
//        }
//        return Arrays.toString(names);
//    }
//    
//        public static String query2() throws Exception {
//        // TODO code application logic here
//        String s = bus.QueryTest.query();
//        return s;
//    }
    
}
