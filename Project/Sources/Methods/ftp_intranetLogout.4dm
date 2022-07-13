//%attributes = {}
// Method: ftp_intranetLogout () -> 

// ----------------------------------------------------

// by: mel: 12/11/03, 09:03:07

// ----------------------------------------------------

// Description:

// closes connection to intranet server if it exists


C_LONGINT:C283($err; ftpID; $0)
If (ftpID#0)
	$err:=FTP_Logout(ftpID)
	If ($err=0)
		zwStatusMsg("FTP"; " session="+String:C10(ftpID)+" Connection Closed")
	Else 
		zwStatusMsg("FTP"; " session="+String:C10(ftpID)+" Logout failed.")
	End if 
	
Else 
	zwStatusMsg("FTP"; " No connection.")
End if 

$0:=ftpID