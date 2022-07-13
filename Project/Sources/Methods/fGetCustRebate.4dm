//%attributes = {"publishedWeb":true}
//Procedure: fGetCustRebate($custid{;brand})  061998  MLB
//get the rebate from the customer record, brand implemented later
// a three percent rebate should be entered as 0.03 in the customer record
//•062498  MLB  cache most recent hit
C_TEXT:C284($1; slastCustid)
C_TEXT:C284($2)
C_REAL:C285($0; rlastRebate)
$0:=0
If (Count parameters:C259=1)
	//TRACE
	Case of 
		: (slastCustid=$1)  //•062498  MLB  cache most recent
			$0:=rlastRebate
			
		: ([Customers:16]ID:1=$1)  //don't muck with readwrite or load state
			slastCustid:=$1
			rlastRebate:=[Customers:16]Rebate:52
			$0:=rlastRebate
			
		Else 
			QUERY:C277([Customers:16]; [Customers:16]ID:1=$1)
			If (Records in selection:C76([Customers:16])=1)
				slastCustid:=$1
				rlastRebate:=[Customers:16]Rebate:52
				$0:=rlastRebate
			End if 
			REDUCE SELECTION:C351([Customers:16]; 0)  //•062498  MLB  was just an unload
	End case 
	
Else   //get rebate by brand
	BEEP:C151
	ALERT:C41("Rebate by brand not yet implemented")
End if 
//