package scm.pack;

import java.sql.Connection;
import java.sql.DriverManager;

public class Dbcon 
{
	private static Connection conn = null;
	
	static 
	{
		try
		{
			Class.forName(Dbinfo.driver);
			conn = DriverManager.getConnection(Dbinfo.dburl,Dbinfo.dbuname,Dbinfo.dbpwd);
		}
		catch(Exception e)
		{
			e.printStackTrace();		
		}
	}
	
	private static Connection getCon()
	{
		return conn;
	}
	
}
