// _______
// Method: [Job_Forms].Input.FixedPrice   ( ) ->
// By: MelvinBohince @ 03/22/22, 08:45:35
// Description
// create a sales value to a job instead of pegging items to orderlines
// so JOB_SellingPrice, which expresses this as avg unit price,
// can convert the price entered into an avg unit price
// when JOB_SellingPrice detects FixedSalesValue>0, it uses that instead
// of orderlines
// ----------------------------------------------------

C_REAL:C285($priceForEntireJob)
$priceForEntireJob:=Num:C11(Request:C163("What is the total sales value of this job?"; ""; "Set Price"; "Cancel"))
If (ok=1)
	If ($priceForEntireJob>0)
		uConfirm("Set total sales value for this job at "+String:C10($priceForEntireJob; "$###,###,##0.00"); "Accept"; "Cancel")
		If (ok=1)
			[Job_Forms:42]FixedSalesValue:92:=$priceForEntireJob
			
		Else 
			[Job_Forms:42]FixedSalesValue:92:=0
		End if 
		
		
	Else   //invalid price
		uConfirm("Price not set."; "Ok"; "Help")
		[Job_Forms:42]FixedSalesValue:92:=0
	End if 
	
	SAVE RECORD:C53([Job_Forms:42])
End if 

If ([Job_Forms:42]FixedSalesValue:92>0)
	OBJECT SET VISIBLE:C603(*; "FixedPriceField"; True:C214)
Else 
	OBJECT SET VISIBLE:C603(*; "FixedPriceField"; False:C215)
End if 

zwStatusMsg("Fixed Price"; "Job value set to "+String:C10([Job_Forms:42]FixedSalesValue:92; "$###,###,##0.00"))


