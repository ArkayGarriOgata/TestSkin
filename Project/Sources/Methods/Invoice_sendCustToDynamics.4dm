//%attributes = {"publishedWeb":true}
//PM: Invoice_sendCustToDynamics() -> 
//@author mlb - 8/2/01  10:22
C_TIME:C306($docCust; $1)
$docCust:=$1
C_TEXT:C284($custUpdate; $temp)
C_LONGINT:C283($numAddresses; $i)
C_TEXT:C284($t)
C_TEXT:C284($cr)
$t:=Char:C90(9)
$cr:=Char:C90(13)+Char:C90(10)

$custUpdate:="AccountId"+$t+"ShortName"+$t+"StatementName"+$t+"AttentionOf"+$t+"AddressCode"+$t+"Address1"+$t+"Address2"+$t+"City"+$t+"State"+$t+"Zip"+$t+"Country"+$t+"Phone1"+$t+"Phone2"+$t+"Fax"+$t+"SalesmanId"+$t+"Std_Terms"+$t+"UserDef1ParentCorp"+$cr
$numAddresses:=Records in selection:C76([Addresses:30])
For ($i; 1; $numAddresses)
	If (Length:C16($custUpdate)>32000)
		SEND PACKET:C103($docCust; $custUpdate)
		$custUpdate:=""
	End if 
	
	$custUpdate:=$custUpdate+Invoice_CustomerMapping([Addresses:30]ID:1)+$t  //$aCustid{$i};
	$custUpdate:=$custUpdate+txt_ReplaceString(Substring:C12([Addresses:30]Name:2; 1; 15); 142; 101)+$t  //•060799  mlb  UPr 236
	$custUpdate:=$custUpdate+txt_ReplaceString(Substring:C12([Addresses:30]Name:2; 1; 30); 142; 101)+$t
	$custUpdate:=$custUpdate+Substring:C12([Addresses:30]AttentionOf:14; 1; 30)+$t  //•6/07/99  MLB substring
	$custUpdate:=$custUpdate+"BILL TO"+$t  //•060399  mlb  
	$custUpdate:=$custUpdate+[Addresses:30]Address1:3+$t
	$custUpdate:=$custUpdate+[Addresses:30]Address2:4+$t
	$custUpdate:=$custUpdate+[Addresses:30]City:6+$t
	$custUpdate:=$custUpdate+Substring:C12([Addresses:30]State:7; 1; 2)+$t
	$custUpdate:=$custUpdate+[Addresses:30]Zip:8+$t
	$custUpdate:=$custUpdate+[Addresses:30]Country:9+$t
	$temp:=Replace string:C233([Addresses:30]Phone:10; "("; "")  //•6/07/99  MLB
	$temp:=Replace string:C233($temp; ")"; "")
	$temp:=Replace string:C233($temp; "-"; "")
	$custUpdate:=$custUpdate+$temp+$t
	$temp:=""  //Replace string([CUSTOMER]MainPhone;"(";"")  `•6/07/99  MLB
	//$temp:=Replace string($temp;")";"")
	//$temp:=Replace string($temp;"-";"")
	$custUpdate:=$custUpdate+$temp+$t
	$temp:=Replace string:C233([Addresses:30]Fax:11; "("; "")  //•6/07/99  MLB
	$temp:=Replace string:C233($temp; ")"; "")
	$temp:=Replace string:C233($temp; "-"; "")
	$custUpdate:=$custUpdate+$temp+$t
	$custUpdate:=$custUpdate+""+$t  //[CUSTOMER]SalesmanID+$t
	$custUpdate:=$custUpdate+""+$t  //[CUSTOMER]Std_Terms+$t
	$custUpdate:=$custUpdate+""+$cr  //txt_ReplaceString ([CUSTOMER]ParentCorp;142;101)+$cr
	
	[Addresses:30]UpdateDynamics:35:=0  //*mark as sent
	SAVE RECORD:C53([Addresses:30])
	NEXT RECORD:C51([Addresses:30])
End for 

SEND PACKET:C103($docCust; $custUpdate)
$custUpdate:=""