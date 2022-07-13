//%attributes = {}
// Method: ftp_intranetLogin ({directory}) -> ftp handle

// ----------------------------------------------------

// by: mel: 12/11/03, 08:42:28

// ----------------------------------------------------

// Description:

// login to the arkay intranet server


C_TEXT:C284($host; $user; $pswd; $welcomeText; $directory)
C_LONGINT:C283(ftpID; $err; $0)

$host:="intranet.arkay.com"
$user:="mel"
$pswd:="1147"
ftpID:=0
$welcomeText:=""
If (Count parameters:C259>=1)
	$directory:="ams/"+$1+"/"
Else 
	$directory:="ams/"
End if 

zwStatusMsg("FTP"; "logging into "+$host+"/"+$directory)
$err:=FTP_Login($host; $user; $pswd; ftpID; $welcomeText)
If ($err=0) & (ftpID#0)
	$err:=FTP_ChangeDir(ftpID; $directory)
	$err:=FTP_PrintDir(ftpID; $directory)
	zwStatusMsg("FTP"; $host+"/"+$directory+" session="+String:C10(ftpID))
	$0:=ftpID
Else 
	zwStatusMsg("FTP"; "Login failed")
	$0:=ftpID
End if 
//