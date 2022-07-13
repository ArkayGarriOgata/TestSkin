//%attributes = {}
// Method: ftp_EsteeLauder (document to send) -> 0 if successful, negative otherwise
// ----------------------------------------------------
// by: mel: 02/19/04, 09:20:54
// ----------------------------------------------------
// Description:
// send a doc to estee lauder, used by invoicing module
// see Invoice_sendToEsteeLauder
// ----------------------------------------------------

C_LONGINT:C283($ftpID; $0; $oldTimeout; $err)
C_TEXT:C284($host; $user; $pswd; $welcomeText; $directory; $destinationName; $srcPath; $1)
C_TIME:C306($docRef)

$0:=-101
$srcPath:=""
If (Count parameters:C259=1)
	$srcPath:=$1
Else 
	$docRef:=Open document:C264("")
	If (OK=1)
		$srcPath:=Document
		CLOSE DOCUMENT:C267($docRef)
	End if 
End if 

If (Length:C16($srcPath)>0)
	$destinationName:="ArkayInvoices.CSV"
	
	$err:=IT_GetTimeOut($oldTimeout)
	$err:=IT_SetTimeOut(120)  //their ftp is really slow behind the firewall
	
	C_BOOLEAN:C305($testing)
	$testing:=False:C215
	If (Not:C34($testing))  //production
		$host:="ext1.estee.com"
		$user:="VeNd1012000"
		$pswd:="D!eN#101V"
		$directory:="/ftpusers/VeNd1012000"
		
	Else   //testing
		$host:="192.168.1.24"  //"intranet.arkay.com"
		$user:="mel"
		$pswd:="1147"
		$directory:="ams/"
	End if 
	
	$ftpID:=0
	$welcomeText:=""
	zwStatusMsg("FTP"; "Logging into "+$host+" as "+$user)
	
	Case of 
		: (FTP_Login($host; $user; $pswd; $ftpID; $welcomeText)#0)
			zwStatusMsg("FTP"; "Login failed")
			$0:=-1
		: ($ftpID=0)
			zwStatusMsg("FTP"; "Login failed, no session id")
			$0:=-2
		Else 
			zwStatusMsg("FTP"; "Connected to "+$host+" as "+$user)
			$err:=FTP_GetFileInfo($ftpID; $destinationName; $size; $modDate)
			If ($err=0) & ($size>0)  //must already exist, so append
				zwStatusMsg("FTP"; "Connected to "+$host+" as "+$user+" Appending file")
				$err:=FTP_Append($ftpID; $srcPath; $destinationName; 1)
				If ($err=0)
					zwStatusMsg("FTP"; " session="+String:C10($ftpID)+" was successful! "+$srcPath)
					$0:=0
				Else 
					zwStatusMsg("FTP"; $srcPath+" Uploaded to '"+$directory+"' failed")
					$0:=-5
				End if 
			Else   //they already got
				
				zwStatusMsg("FTP"; "Connected to "+$host+" as "+$user+" Sending file")
				$err:=FTP_Send($ftpID; $srcPath; $destinationName; 1)
				If ($err=0)
					zwStatusMsg("FTP"; " session="+String:C10($ftpID)+" was successful! "+$srcPath)
					$0:=0
				Else 
					zwStatusMsg("FTP"; $srcPath+" Uploaded to '"+$directory+"' failed")
					$0:=-5
				End if 
			End if 
			
			Case of 
				: (FTP_Logout($ftpID)#0)
					zwStatusMsg("FTP"; $srcPath+" Logout failed")
					$0:=-6
				Else 
					zwStatusMsg("FTP"; " session="+String:C10($ftpID)+" was successful! "+$srcPath)
					$0:=0
			End case 
	End case 
	$ftpID:=0
	$err:=IT_SetTimeOut($oldTimeout)
	
	If ($0#0)
		BEEP:C151
	End if 
End if 