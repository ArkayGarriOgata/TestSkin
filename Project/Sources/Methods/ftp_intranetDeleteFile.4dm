//%attributes = {}
// Method: ftp_intranetDeleteFile () -> 

// ----------------------------------------------------

// by: mel: 12/11/03, 09:43:25

// ----------------------------------------------------

// Description:

//deletes a document to intranet, resolves paths

C_LONGINT:C283(ftpID; $err; $0)
C_TEXT:C284($1; $directory)

$err:=FTP_Delete(ftpID; $1)
If ($err=0)
	$err:=FTP_PrintDir(ftpID; $directory)
	zwStatusMsg("FTP"; $1+" deleted from "+$directory)
Else 
	zwStatusMsg("FTP"; " Remove failed. Error: "+String:C10($err))
End if 
$0:=$err
