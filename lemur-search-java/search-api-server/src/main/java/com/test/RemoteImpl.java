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

import examples.Main;



//import model.nn_composition.DocSimplifiedLSTM123Main;

public class RemoteImpl extends UnicastRemoteObject implements TestRemote{
	
	protected RemoteImpl() throws RemoteException {
		super();		
		try {
			System.out.println("Main class: examples.Main");
			Class.forName("examples.Main");
		} catch (ClassNotFoundException e) {
			
			throw new RemoteException(e.getMessage());
		}
		// TODO Auto-generated constructor stub
	}

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
		return Main.query(queryString);
	}
	
	public String query2(String parameters) 
			throws Exception {
		return Main.query2(parameters);
	}

}
