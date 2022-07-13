//%attributes = {}
// Method: Invoice_sendCustToAcctAdv () -> 
// ----------------------------------------------------
// by: mel: 03/01/05, 13:24:46
// ----------------------------------------------------
// Description:
// 
//based on PM: Invoice_sendCustToFlexWare() -> 
//@author mlb - 8/1/01  14:22
C_TIME:C306($docCust; $1)
If (Count parameters:C259>0)
	$docCust:=$1
Else 
	$docCust:=Create document:C266("test4.cust")
End if 

C_TEXT:C284($custUpdate; $temp)
$custUpdate:=""
$temp:=""
C_LONGINT:C283($numAddresses; $i)
C_TEXT:C284($t)
C_TEXT:C284($cr)
$t:=Char:C90(9)
$cr:=Char:C90(13)

$custUpdate:=""
$numAddresses:=Records in selection:C76([Addresses:30])
FIRST RECORD:C50([Addresses:30])

READ ONLY:C145([Customers:16])
For ($i; 1; $numAddresses)
	If (Length:C16($custUpdate)>28000)
		SEND PACKET:C103($docCust; $custUpdate)
		$custUpdate:=""
	End if 
	
	$custUpdate:=$custUpdate+Invoice_CustomerMapping([Addresses:30]ID:1)+$t  //$aCustid{$i};
	$custUpdate:=$custUpdate+txt_ReplaceString(Substring:C12([Addresses:30]Name:2; 1; 28); 142; 101)+$t
	$custUpdate:=$custUpdate+[Addresses:30]AttentionOf:14+$t
	$custUpdate:=$custUpdate+Substring:C12([Addresses:30]Address1:3; 1; 28)+$t
	$custUpdate:=$custUpdate+Substring:C12([Addresses:30]Address2:4; 1; 28)+$t
	$custUpdate:=$custUpdate+""+$t
	$custUpdate:=$custUpdate+Substring:C12([Addresses:30]City:6; 1; 28)+$t
	$custUpdate:=$custUpdate+Substring:C12([Addresses:30]State:7; 1; 2)+$t
	$custUpdate:=$custUpdate+Substring:C12(Replace string:C233([Addresses:30]Zip:8; "-"; ""); 1; 9)+$t
	$custUpdate:=$custUpdate+Substring:C12([Addresses:30]Country:9; 1; 28)+$t
	
	$temp:=Replace string:C233([Addresses:30]Phone:10; "("; "")  //•6/07/99  MLB
	$temp:=Replace string:C233($temp; ")"; "")
	$temp:=Replace string:C233($temp; "-"; "")
	$custUpdate:=$custUpdate+$temp+$t
	
	$custUpdate:=$custUpdate+""+$t  //pm phone
	
	$temp:=Replace string:C233([Addresses:30]Fax:11; "("; "")  //•6/07/99  MLB
	$temp:=Replace string:C233($temp; ")"; "")
	$temp:=Replace string:C233($temp; "-"; "")
	$custUpdate:=$custUpdate+$temp+$t
	
	
	QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustAddrID:2=[Addresses:30]ID:1)
	RELATE ONE:C42([Customers_Addresses:31]CustID:1)
	
	$custUpdate:=$custUpdate+[Customers:16]CustomerType:54+$t
	$custUpdate:=$custUpdate+String:C10([Customers:16]CreditLimit:12)+$t
	
	$custUpdate:=$custUpdate+""+$t  //tax exempt#
	
	$custUpdate:=$custUpdate+String:C10(4D_Current_date; System date short:K1:1)+$t  //tax exempt#
	
	$custUpdate:=$custUpdate+""+$t  //warehouse
	
	$custUpdate:=$custUpdate+Substring:C12([Customers:16]SalesmanID:3; 1; 3)+$t
	
	$custUpdate:=$custUpdate+""+$t  //relation
	$custUpdate:=$custUpdate+""+$t  //ex credit
	$custUpdate:=$custUpdate+""+$t  //po req
	
	$custUpdate:=$custUpdate+String:C10([Customers:16]NetDaysDue:44)+$t
	
	$custUpdate:=$custUpdate+((""+$t)*54)
	$custUpdate:=$custUpdate+""+$cr
	
	[Addresses:30]UpdateDynamics:35:=0  //*mark as sent
	SAVE RECORD:C53([Addresses:30])
	NEXT RECORD:C51([Addresses:30])
End for 

SEND PACKET:C103($docCust; $custUpdate)
$custUpdate:=""

If (Count parameters:C259=0)
	CLOSE DOCUMENT:C267($docCust)
End if 
//