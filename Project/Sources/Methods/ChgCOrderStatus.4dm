//%attributes = {"publishedWeb":true}
//ChgCOrderStatus 
//2/14/95 upr 1326
//•043096  MLB  add date to close short routine.
//•050196  MLB  add choice list for close short.
//•061797  mBohince allow orderline to be reopened
//• 3/6/98 cs make sure that closed date is set

If (Count parameters:C259<1)  //via order line
	uConfirm("Error called by ChgCOrderStatus, parameter expected."; "OK"; "Help")
	$oldStat:=Old:C35([Customers_Orders:40]Status:10)
Else 
	$oldStat:=$1
End if 

If (Count parameters:C259=2)  //via order line
	C_BOOLEAN:C305($continue)
	$continue:=True:C214
	
	If (([Customers_Order_Lines:41]Qty_Open:11>0) & ([Customers_Order_Lines:41]Status:9="Closed"))
		ARRAY TEXT:C222(aText; 0)  //•050196  MLB 
		LIST TO ARRAY:C288("ReasonForClose"; aText)
		aText:=0
		//NewWindow (220;185;6;1;"Reason for close")
		$winRef:=OpenSheetWindow(->[Customers_Order_Lines:41]; "ReasonForClose")
		DIALOG:C40([Customers_Order_Lines:41]; "ReasonForClose")
		CLOSE WINDOW:C154
		
		If (OK=0)
			$continue:=False:C215
		Else 
			[Customers_Order_Lines:41]ReasonForClose:46:=aText{aText}
			[Customers_Order_Lines:41]DateCompleted:12:=4D_Current_date  //•043096  MLB  
		End if 
		ARRAY TEXT:C222(aText; 0)
	End if 
	
	If ($continue)
		If (fCOrderRules4($oldStat; ->[Customers_Order_Lines:41]Status:9))  //2/14/95 upr 1326
			[Customers_Order_Lines:41]Status:9:=[Customers_Order_Lines:41]Status:9
			
			If ($oldStat="Closed")  //•061797  mBohince 
				[Customers_Order_Lines:41]ReasonForClose:46:="Reopened"
				[Customers_Order_Lines:41]DateCompleted:12:=!00-00-00!
			End if 
			
		Else 
			[Customers_Order_Lines:41]Status:9:=$oldStat
		End if   //change not allowed 
		
	Else 
		[Customers_Order_Lines:41]Status:9:=$oldStat
	End if 
	
Else 
	If (fCOrderRules4($oldStat; ->[Customers_Orders:40]Status:10))
		[Customers_Orders:40]Status:10:=[Customers_Orders:40]Status:10
		
		If ([Customers_Orders:40]Status:10="Closed")  //• 3/6/98 cs make sure that closed date is set
			[Customers_Orders:40]DateClosed:49:=4D_Current_date
		End if 
		[Customers_Orders:40]ApprovedBy:14:=<>zResp
		
	Else 
		[Customers_Orders:40]Status:10:=$oldStat
	End if   //change not allowed  
End if 