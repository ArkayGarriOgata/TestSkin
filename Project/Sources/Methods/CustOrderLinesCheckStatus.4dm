//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 08/05/13, 09:50:06
// ----------------------------------------------------
// Method: CustOrderLinesCheckStatus
// Description:
// Checks the status of the currently selected [Customers_Order_Lines].
// If they are all "Accepted" set the status of [Customer_Orders]
// to "Accepted".
// $1 = Current status.
// ----------------------------------------------------

C_TEXT:C284($tCurrentStatus; $1)
C_BOOLEAN:C305($bOK)
C_LONGINT:C283($xlNum)

$tCurrentStatus:=$1  //Saved so we can go back to it if needed.
$bOK:=True:C214
$xlNum:=Records in selection:C76([Customers_Order_Lines:41])

If (($xlNum>0) & ($tCurrentStatus#"Accepted"))
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 GOTO SELECTED RECORD
		
		For ($i; 1; $xlNum)
			GOTO SELECTED RECORD:C245([Customers_Order_Lines:41]; $i)
			If ([Customers_Order_Lines:41]Status:9#"Accepted")
				$bOK:=False:C215
				$i:=$xlNum+1
			End if 
		End for 
		
	Else 
		
		ARRAY TEXT:C222($_Status; 0)
		ARRAY LONGINT:C221($_record_number; 0)
		SELECTION TO ARRAY:C260([Customers_Order_Lines:41]Status:9; $_Status; \
			[Customers_Order_Lines:41]; $_record_number)
		
		$Position:=1
		For ($i; 1; $xlNum; 1)
			$Position:=$i
			If ($_Status{$i}#"Accepted")
				$bOK:=False:C215
				$i:=$xlNum+1
			End if 
		End for 
		If ($Position<$xlNum)
			
			GOTO SELECTED RECORD:C245([Customers_Order_Lines:41]; $Position)
			
		End if 
	End if   // END 4D Professional Services : January 2019 query selection
	
	
	If ($bOK)
		[Customers_Orders:40]Status:10:="Accepted"
		ALERT:C41("All orderlines are "+util_Quote("Accepted")+" so this Customer Order will be set to "+util_Quote("Accepted")+".")
	Else 
		[Customers_Orders:40]Status:10:=$tCurrentStatus
	End if 
End if 