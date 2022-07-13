//%attributes = {}
// Method: ftp_intranetSendFile (source;destination) -> 

// ----------------------------------------------------

// by: mel: 12/11/03, 09:26:49

// ----------------------------------------------------

// Description:

//sends a document to intranet, resolves paths

C_LONGINT:C283(ftpID; $err; $0)
C_TEXT:C284($1; $2; $directory)

$err:=FTP_Send(ftpID; $1; $2; 1)
If ($err=0)
	$err:=FTP_PrintDir(ftpID; $directory)
	zwStatusMsg("FTP"; $1+" uploaded to "+$directory)
Else 
	zwStatusMsg("FTP"; " Uploaded failed. Error: "+String:C10($err))
End if 
$0:=$err
