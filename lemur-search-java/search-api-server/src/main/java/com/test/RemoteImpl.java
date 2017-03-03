package com.test;

import java.lang.reflect.Field;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.util.Arrays;
import java.util.Properties;

import org.json.JSONArray;
import org.json.JSONObject;

import lemurproject.indri.ParsedDocument;
import lemurproject.indri.QueryAnnotation;
import lemurproject.indri.QueryEnvironment;
import lemurproject.indri.ScoredExtentResult;

import com.interf.test.TestRemote;

import examples.TestQuery;



//import model.nn_composition.DocSimplifiedLSTM123Main;

public class RemoteImpl extends UnicastRemoteObject implements TestRemote{
	
//	static {
//		try
//		{
//		System.setProperty("java.library.path", "/Users/ntson/Downloads/lemur-installed/lib");
//		Field fieldSysPath = ClassLoader.class.getDeclaredField( "sys_paths" );
//		 fieldSysPath.setAccessible( true );
//		 fieldSysPath.set( null, null );
//		 
//		Properties props = System.getProperties();
//        System.out.println("java.library.path="+props.get("java.library.path"));
//		}
//		catch (Exception e)
//		{
//			
//		}
//    }
	
	protected RemoteImpl() throws RemoteException {
		super();		
		try {
			Class.forName("examples.TestQuery");
		} catch (ClassNotFoundException e) {
			
			throw new RemoteException(e.getMessage());
		}
		// TODO Auto-generated constructor stub
	}

	private static final long serialversionUID = 1L;

	public boolean isLoginValid(String username) throws Exception {
		System.out.println(username);
		int t = 1;//DocSimplifiedLSTM123Main.p_predict(username);
		if(t==2)
		{			
			return false;
		}
		
		return true;
	}
	
	
	public String query(String queryString) throws Exception {
		return TestQuery.query(queryString);
	}
	
	public String query2(String parameters) 
			throws Exception {
		return TestQuery.query2(parameters);
	}

}
