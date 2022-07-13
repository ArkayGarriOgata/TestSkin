//Script: bPU()  092795  MLB
//•092795  MLB  UPR 1729

C_TEXT:C284(<>POnum)
C_LONGINT:C283($state)

If (Records in set:C195("Customers_Order_Line")>0)
	CUT NAMED SELECTION:C334([Customers_Order_Lines:41]; "hold")
	USE SET:C118("Customers_Order_Line")
	
	If ([Customers_Order_Lines:41]ProductCode:5=sCPN)
		<>POnum:=[Customers_Order_Lines:41]PONumber:21
		UNLOAD RECORD:C212([Customers_Order_Lines:41])
	Else 
		<>POnum:=""
	End if 
	
	If (BillingId=0)
		BillingId:=uSpawnProcess("doBillPayU"; 0; "Bill a Pay-U"; True:C214; False:C215)
		
	Else 
		$state:=Process state:C330(BillingId)
		Case of 
			: ($State<0)  //process doesn't exist anymore
				BillingId:=uSpawnProcess("doBillPayU"; 0; "Bill a Pay-U"; True:C214; False:C215)
				
			: ($State=5)  //process is currently paused
				RESUME PROCESS:C320(BillingId)
				POST OUTSIDE CALL:C329(BillingId)
				
			Else   //process exists, so just resend current info
				POST OUTSIDE CALL:C329(BillingId)
		End case 
		
	End if 
	
	USE NAMED SELECTION:C332("hold")
	
Else 
	uConfirm("You Must Select a Orderline first."; "OK"; "Help")
End if 

If (False:C215)
	doBillPayU
End if 