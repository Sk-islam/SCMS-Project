package scm.pack;

import java.io.Serializable;

public class AdminBean implements Serializable
{
	private String UNAME,PWD;

	public String getUNAME() 
	{
		return UNAME;
	}

	public void setUNAME(String uNAME) 
	{
		UNAME = uNAME;
	}

	public String getPWD() 
	{
		return PWD;
	}

	public void setPWD(String pWD) 
	{
		PWD = pWD;
	}
	
	public AdminBean()
	{
		
	}

}
