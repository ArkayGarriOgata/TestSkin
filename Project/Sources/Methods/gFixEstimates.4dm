//%attributes = {"publishedWeb":true}
//(p) fixestimates
//1/13/95
//• mlb - 6/27/01  16:36 try to stop dup pspecs

SET MENU BAR:C67(<>DefaultMenu)

READ WRITE:C146([Estimates:17])
READ ONLY:C145([Customers_Orders:40])  //1/13/95
READ ONLY:C145([Jobs:15])  //1/13/95

//*Get the Destination customer id
READ ONLY:C145([Customers:16])
ALL RECORDS:C47([Customers:16])
zwStatusMsg("Move Est"; "Loading Customers…")
SELECTION TO ARRAY:C260([Customers:16]Name:2; aCustName; [Customers:16]ID:1; aCustId)
SORT ARRAY:C229(aCustName; aCustID; >)
zwStatusMsg("Move Est"; "Pick a destination customer to move the estimates to")
sDlogTitle:="Select MOVE TO Customer"

$winRef:=Open form window:C675([zz_control:1]; "ChooseCustomer"; Sheet form window:K39:12)
DIALOG:C40([zz_control:1]; "ChooseCustomer")
CLOSE WINDOW:C154($winRef)

If (OK=1)
	$MovetoCust:=aCustId{aCustId}
	$MoveToName:=aCustName{aCustName}
	zwStatusMsg("Move Est"; "Pick a source customer to move the estimates from")
	sDlogTitle:="Select MOVE FROM Customer"
	$winRef:=Open form window:C675([zz_control:1]; "ChooseCustomer"; Sheet form window:K39:12)
	DIALOG:C40([zz_control:1]; "ChooseCustomer")
	CLOSE WINDOW:C154($winRef)
	If (OK=1)
		$FromCustId:=aCustId{aCustId}
		zwStatusMsg("Move Est"; "Moving the estimates from "+$FromCustId+" to customer "+$MovetoCust+" "+$MoveToName)
		
		QUERY:C277([Estimates:17]; [Estimates:17]Cust_ID:2=$FromCustId)
		
		SELECTION TO ARRAY:C260([Estimates:17]EstimateNo:1; aEstNo; [Estimates:17]Brand:3; aBrand; [Estimates:17]Sales_Rep:13; aRep)
		SORT ARRAY:C229(aEstNo; aBrand; aRep; >)
		sDlogTitle:="Choose Estimate to Move"
		
		Repeat 
			$winRef:=Open form window:C675([zz_control:1]; "ChooseEstimate"; Sheet form window:K39:12)
			DIALOG:C40([zz_control:1]; "ChooseEstimate")  //this command second time causes splash to display
			CLOSE WINDOW:C154($winRef)
			
			If (OK=1)
				$EstNo:=aEstNo{aEstNo}
				DELETE FROM ARRAY:C228(aEstNo; aEstNo)
				DELETE FROM ARRAY:C228(aRep; aEstNo)
				DELETE FROM ARRAY:C228(aBrand; aEstNo)
				QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=$EstNo)
				[Estimates:17]Cust_ID:2:=$MovetoCust
				[Estimates:17]CustomerName:47:=$MovetoName
				[Estimates:17]ProjectNumber:63:=""
				SAVE RECORD:C53([Estimates:17])
				
				QUERY:C277([Jobs:15]; [Jobs:15]EstimateNo:6=$EstNo)  //1/13/95
				If (Records in selection:C76([Jobs:15])>0)
					BEEP:C151
					ALERT:C41("WARNING: "+$EstNo+" is referenced by a job. The Custid will not be change there.")
				End if 
				
				QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]EstimateNo:3=$EstNo)  //1/13/95
				If (Records in selection:C76([Customers_Orders:40])>0)
					BEEP:C151
					ALERT:C41("WARNING: "+$EstNo+" is referenced by a Customer Order. The Custid will not be change there.")
				End if 
				
				RELATE MANY:C262([Estimates:17]EstimateNo:1)  //get the parts
				APPLY TO SELECTION:C70([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]CustID:6:=$MovetoCust)  //1/13/95
				RELATE ONE SELECTION:C349([Estimates_PSpecs:57]; [Process_Specs:18])
				QUERY SELECTION:C341([Process_Specs:18]; [Process_Specs:18]Cust_ID:4=$FromCustId)  //• mlb - 8/1/01  
				SELECTION TO ARRAY:C260([Process_Specs:18]; $aOldPspecRecNo; [Process_Specs:18]ID:1; $aPSpecName)
				
				//for each pspec, see if it exists for the new customer, if not, create it
				For ($i; 1; Size of array:C274($aPSpecName))
					GOTO RECORD:C242([Process_Specs:18]; $aOldPspecRecNo{$i})
					$newPspecRecNo:=PSPEC_Duplicate($MovetoCust; $aPSpecName{$i})
					// If ($newPspecRecNo>=0) `see commented out code at the end    `End if           
				End for 
				
				OK:=1
			End if 
			
		Until (OK=0)  //done selecting estimates
		CLEAR VARIABLE:C89(aEstNo)
		CLEAR VARIABLE:C89(aBrand)
		CLEAR VARIABLE:C89(aRep)
	End if 
End if 

CLEAR VARIABLE:C89(aCustId)
CLEAR VARIABLE:C89(aCustName)