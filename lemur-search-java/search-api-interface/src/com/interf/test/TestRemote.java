package com.interf.test;
import java.rmi.Remote;
import java.rmi.RemoteException;

import org.json.JSONObject;
public interface TestRemote extends Remote {
	public boolean isLoginValid(String username) throws RemoteException, Exception;
	public String query(String queryString) throws RemoteException, Exception;
	public String query2(String parameters) throws RemoteException, Exception;
}
