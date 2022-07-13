//%attributes = {}
// -------
// Method: Invoice_sendCustToOpenAccounts   ( ) ->
// By: Mel Bohince @ 07/13/17, 15:37:11
// Description
// 
// ----------------------------------------------------

C_TIME:C306($docRef)
C_TEXT:C284($docName)
$docName:="cust_from_ams_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
$docRef:=util_putFileName(->$docName)

If ($docRef#?00:00:00?)
	C_TEXT:C284($custUpdate; $temp)
	$custUpdate:=""
	$temp:=""
	C_LONGINT:C283($numAddresses; $i)
	C_TEXT:C284($t)
	C_TEXT:C284($crlf)
	$t:=","
	$crlf:=Char:C90(Carriage return:K15:38)+Char:C90(Line feed:K15:40)
	
	$custUpdate:=",AR Customers,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"+$crlf
	$custUpdate:=$custUpdate+",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"+$crlf
	$custUpdate:=$custUpdate+"Record Type ,Company,Customer,Name,Short Name,Ledger,Account Currency,Address,Address,Address,Address,Address,Address,Post Code,Contact,Phone,Fax,e-mail.,Payment Terms Code,Payment Method,Bank Sort Code,Bank Account No.,IBAN No.,BIC Code,Analysis Code"+" 1,Analysis Code 2,Analysis Code 3,Analysis Code 4,Cost Code,Expense Code,Company Reg No.,Country Code,Tax Registration,Tax Code,MM Dunning e-mail,MM Dunning Output,MM Invoice e-mail,MM Invoice Output,MM Statement e-mail,MM Statement Output"+$crlf
	$custUpdate:=$custUpdate+",Mandatory,Mandatory,Mandatory,Mandatory,Mandatory,Mandatory,Optional,Optional,Optional,Optional,Optional,Optional,Optional,Optional,Optional,Optional,Optional,Mandatory,Mandatory,Mandatory If ,Mandatory,Optional,Optional,Mandatory if used,Mandatory i"+"f used,Mandatory if used,Mandatory if used,Optional,Optional,Optional,Optional,Optional,Optional,Optional,Optional,Optional,Optional,Optional,Optional"+$crlf
	$custUpdate:=$custUpdate+",,15 Characters,40 Characters,15 Characters,,,30 Characters,30 Characters,30 Characters,30 Characters,30 Characters,30 Characters,,40 Characters,,,,,,Payment Method B,Payment Method B,,,,,,,,,,,,,,,,,,"+$crlf
	
	$numAddresses:=Records in selection:C76([Addresses:30])
	FIRST RECORD:C50([Addresses:30])
	
	READ ONLY:C145([Customers:16])
	For ($i; 1; $numAddresses)
		QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustAddrID:2=[Addresses:30]ID:1)
		RELATE ONE:C42([Customers_Addresses:31]CustID:1)
		
		
		$custUpdate:=$custUpdate+"M"+$t+<>OpenAcctsCompany+$t+Invoice_CustomerMapping([Addresses:30]ID:1)+$t  //$aCustid{$i};
		$name:=Replace string:C233([Addresses:30]Name:2; ","; " ")
		$custUpdate:=$custUpdate+Substring:C12($name; 1; 40)+$t
		$short:=Replace string:C233([Customers:16]ShortName:57; ","; " ")
		If (Length:C16($short)>0)
			$custUpdate:=$custUpdate+Substring:C12($short; 1; 15)+$t
		Else 
			$custUpdate:=$custUpdate+Substring:C12($name; 1; 15)+$t
		End if 
		$custUpdate:=$custUpdate+"AR"+$t+"USD"+$t
		$address:=Replace string:C233([Addresses:30]Address1:3; ","; " ")
		$custUpdate:=$custUpdate+Substring:C12($address; 1; 30)+$t
		$address:=Replace string:C233([Addresses:30]Address2:4; ","; " ")
		$custUpdate:=$custUpdate+Substring:C12($address; 1; 30)+$t
		$custUpdate:=$custUpdate+Substring:C12([Addresses:30]City:6; 1; 30)+$t
		$custUpdate:=$custUpdate+Substring:C12([Addresses:30]State:7; 1; 30)+$t
		$custUpdate:=$custUpdate+Substring:C12([Addresses:30]Country:9; 1; 30)+$t+""+$t
		$custUpdate:=$custUpdate+Substring:C12(Replace string:C233([Addresses:30]Zip:8; "-"; ""); 1; 9)+$t
		$address:=Replace string:C233([Addresses:30]AttentionOf:14; ","; " ")
		$custUpdate:=$custUpdate+Substring:C12($address; 1; 40)+$t
		
		$temp:=Replace string:C233([Addresses:30]Phone:10; "("; "")  //•6/07/99  MLB
		$temp:=Replace string:C233($temp; ")"; "")
		$temp:=Replace string:C233($temp; "-"; "")
		$custUpdate:=$custUpdate+$temp+$t
		
		$temp:=Replace string:C233([Addresses:30]Fax:11; "("; "")  //•6/07/99  MLB
		$temp:=Replace string:C233($temp; ")"; "")
		$temp:=Replace string:C233($temp; "-"; "")
		$custUpdate:=$custUpdate+$temp+$t
		
		$custUpdate:=$custUpdate+""+$t  //email
		
		$terms:=Replace string:C233([Customers:16]Std_Terms:13; ","; " ")
		$custUpdate:=$custUpdate+$terms+$crlf
		
		
		[Addresses:30]UpdateDynamics:35:=0  //*mark as sent
		SAVE RECORD:C53([Addresses:30])
		NEXT RECORD:C51([Addresses:30])
	End for 
	
	SEND PACKET:C103($docRef; $custUpdate)
	$custUpdate:=""
	
	
	CLOSE DOCUMENT:C267($docRef)
	
	
Else 
	uConfirm("Bill-to updates could not be saved to file."; "Ok"; "Help")
End if 
//