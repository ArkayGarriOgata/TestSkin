//%attributes = {}
// -------
// Method: Invoice_ZeroFiFoCoGS   ( ) ->
// By: Mel Bohince @ 03/21/17, 15:18:09
// Description
// verify and warn if cogs fifo is zero
// ----------------------------------------------------

C_DATE:C307($date; $1)

If (Count parameters:C259>0)
	$date:=$1
	ok:=1
Else 
	$date:=Date:C102(Request:C163("What date?"; String:C10(Current date:C33; Internal date short special:K1:4); "Ok"; "Cancel"))
End if 

If (ok=1)
	READ ONLY:C145([Customers_Invoices:88])
	QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]Invoice_Date:7=$date)
	SELECTION TO ARRAY:C260([Customers_Invoices:88]InvoiceNumber:1; $aInvoNum; [Customers_Invoices:88]ProductCode:14; $aCPN; [Customers_Invoices:88]CustomerID:6; $aCust; [Customers_Invoices:88]ExtendedPrice:19; $aAmount; [Customers_Invoices:88]CoGS_FiFo:38; $aCOGS; [Customers_Invoices:88]Invoice_Date:7; $aDocDate)
	$numInvoices:=Size of array:C274($aInvoNum)
	
	// Modified by: Mel Bohince (3/10/17) 
	$numMissingCost:=0
	$subject:="Invoice Posted without FiFO Cost"
	$prehead:=$subject
	$tBody:=""
	$b:="<tr style=\"background-color:#fff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
	$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
	$r:="</td></tr>"+Char:C90(13)
	
	$tBody:=$tBody+$b+"Customer"+$t+"Invoice"+$t+"Dated"+$t+"ProductCode"+$t+"ExtendedPrice"+$r
	
	$b:="<tr style=\"background-color:#fff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
	$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
	
	For ($i; 1; $numInvoices)
		If ($aCOGS{$i}=0) & ($aAmount{$i}>0)  // Modified by: Mel Bohince (3/21/17) don't check credits
			$numJIC:=0
			If (True:C214)
				SET QUERY DESTINATION:C396(Into variable:K19:4; $numJIC)
				QUERY:C277([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]FG_Key:13=$aCust{$i}+":"+$aCPN{$i}; *)
				QUERY:C277([Job_Forms_Items_Costs:92];  & ; [Job_Forms_Items_Costs:92]RemainingQuantity:15>0)
				SET QUERY DESTINATION:C396(Into current selection:K19:1)
			Else 
				$numJIC:=qryJIC(""; $aCust{$i}+":"+$aCPN{$i})
			End if 
			
			If ($numJIC>0)
				$numMissingCost:=$numMissingCost+1
				$aCust{$i}:=CUST_getName($aCust{$i}; "elc")
				$tBody:=$tBody+$b+$aCust{$i}+$t+String:C10($aInvoNum{$i})+$t+String:C10($aDocDate{$i}; Internal date short special:K1:4)+$t+$aCPN{$i}+$t+String:C10($aAmount{$i})+$r
			End if 
		End if 
	End for 
	
	If ($numMissingCost>0)
		$distributionList:=Batch_GetDistributionList(""; "ACCTG")
		Email_html_table($subject; $prehead; $tBody; 960; $distributionList)
	End if 
	// Modified by: Mel Bohince (3/10/17) end of change
End if   //ok
