package com.test;

import java.lang.reflect.Field;
import java.rmi.AlreadyBoundException;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.util.Properties;

import com.interf.test.Constant;

import examples.Config;

//import model.nn_composition.DocSimplifiedLSTM123Main;

public class RMIServer {
	public static void main(String[] args) throws Exception
	{
		Config cfObject = new Config("config.json");
		RemoteImpl impl = new RemoteImpl();
		int rmiport = Integer.parseInt(cfObject.getAtribute("rmi-port"));
		Registry registry =  LocateRegistry.createRegistry(rmiport);
		registry.bind(cfObject.getAtribute("rmi-id"), impl);
		System.out.println("start is started");
	}
}
