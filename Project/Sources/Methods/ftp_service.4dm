//%attributes = {"publishedWeb":true}
//PM: ftp_service() -> result
//@author mlb - 12/10/02  14:59
//mlb 11-02-05 don't report reports or 997's
C_TEXT:C284($host; $user; $pswd; $welcomeText; $directory; $result; $0)
C_LONGINT:C283($ftpID; $err; $numRpt; $numMsg)
C_TEXT:C284($t; $cr)
$t:=Char:C90(9)
$cr:=Char:C90(13)
$numMsg:=0
$numRpt:=0
$host:="sciftp.commerce.stercomm.com"
$user:="SZLWXFTD"
$pswd:="1418595"
$ftpID:=0
$welcomeText:=""

$result:=""  //$cr
zwStatusMsg("FTP"; "logging into "+$host+" as "+$user)
$err:=FTP_Login($host; $user; $pswd; $ftpID; $welcomeText)
If ($err=0) & ($ftpID#0)
	zwStatusMsg("FTP"; $welcomeText+" pid="+String:C10($ftpID))
	$directory:=""  //"/SZLWXFTD"  ` message data directory
	ARRAY TEXT:C222($aDocument; 0)
	ARRAY LONGINT:C221($aSize; 0)
	ARRAY INTEGER:C220($aKind; 0)
	ARRAY DATE:C224($aModDate; 0)
	zwStatusMsg("FTP"; "Listing directory "+$directory)
	$err:=FTP_GetDirList($ftpID; $directory; $aDocument; $aSize; $aKind; $aModDate)
	If ($err=0)
		$numMsg:=Size of array:C274($aDocument)
		For ($i; 1; $numMsg)
			If (Position:C15("ACK997"; $aDocument{$i})=0)
				$result:=$result+$aDocument{$i}+$t+String:C10($aSize{$i})+$t+String:C10($aKind{$i})+$t+String:C10($aModDate{$i}; System date short:K1:1)+$cr
			End if 
		End for 
		
		If (Length:C16($result)>0)
			$result:="Listing for directory "+$directory+$cr+$result
		End if 
	Else 
		$result:=$result+"Failure to get listing of "+$directory+":"+String:C10($err)  //+$cr
	End if 
	
	zwStatusMsg("FTP"; "Checking Status")
	$err:=FTP_VerifyID($ftpID)
	If ($ftpID=0)
		zwStatusMsg("FTP"; "Connection is closed")
		$result:=$result+"Connection is closed"+":"+String:C10($err)+$cr
	Else 
		If (False:C215)  //ignor reports
			$directory:="/SZLWXFTR"  //report directory
			$err:=FTP_ChangeDir($ftpID; $directory)
			$err:=FTP_PrintDir($ftpID; $directory)
			ARRAY TEXT:C222($aDocument; 0)
			ARRAY LONGINT:C221($aSize; 0)
			ARRAY INTEGER:C220($aKind; 0)
			ARRAY DATE:C224($aModDate; 0)
			zwStatusMsg("FTP"; "Listing directory "+$directory)
			$err:=FTP_GetDirList($ftpID; $directory; $aDocument; $aSize; $aKind; $aModDate)
			If ($err=0)
				$result:=$result+$cr+"Listing for directory "+$directory+$cr
				$numRpt:=Size of array:C274($aDocument)
				For ($i; 1; Size of array:C274($aDocument))
					$result:=$result+$aDocument{$i}+$t+String:C10($aSize{$i})+$t+String:C10($aKind{$i})+$t+String:C10($aModDate{$i}; System date short:K1:1)+$cr
				End for 
			Else 
				$result:=$result+"Failure to get listing of "+$directory+":"+String:C10($err)+$cr
			End if 
		End if 
	End if 
	
	zwStatusMsg("FTP"; "Logging out")
	$err:=FTP_Logout($ftpID)
	If ($err=0)
		zwStatusMsg("FTP"; "Logged out")
		$ftpID:=0
	Else 
		zwStatusMsg("FTP"; "Log out failed")
		//$result:=$result+$cr+"FTP_Logout failed: "+String($err)+$cr
	End if 
	
Else 
	$result:=$result+"FTP_Login failed: "+String:C10($err)  //+$cr
End if 

If (($numMsg+$numRpt)>0)
	$0:=String:C10($numMsg+$numRpt)+" "+$result
Else 
	$0:=$result
End if 