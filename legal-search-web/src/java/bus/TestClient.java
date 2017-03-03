package bus;

import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

import com.interf.test.Constant;
import com.interf.test.TestRemote;

public class TestClient {

	public static void main(String[] args) throws Exception {
		String s = "HELO";
		String IP = "127.0.0.1";//args[0];
		Registry registry = LocateRegistry.getRegistry(IP,Constant.RMI_PORT);
		TestRemote remote = (TestRemote) registry.lookup(Constant.RMI_ID);
		System.out.println(remote.isLoginValid(s));
		
	}

}
