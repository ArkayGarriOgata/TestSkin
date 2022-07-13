//%attributes = {"publishedWeb":true}
//(p) ReqAcceptScrpt
//• 6/11/97 cs 
//• 11/25/97 cs needed to flag after phase to get Status updated if production Req
//• 7/1/98 cs could save req with out a vendor

C_BOOLEAN:C305($0)

$0:=False:C215

If ([Purchase_Orders:11]Status:15="New Req")
	BEEP:C151
	uConfirm("Are you ready to submit this Requisition for approval?"; "Yes"; "No, Finish later")
	If (ok=1)
		If (User in group:C338(Current user:C182; "Roanoke"))
			[Purchase_Orders:11]Status:15:="Requisition"  //"PlantMgr"
		Else 
			[Purchase_Orders:11]Status:15:="Requisition"
		End if 
	End if 
End if 

Case of 
	: ([Purchase_Orders:11]Dept:7="")
		uConfirm("The Approving Department code is required."; "OK"; "Help")
		GOTO OBJECT:C206([Purchase_Orders:11]Dept:7)
		REJECT:C38
		
	: ((i1+i2+i3)=0)
		uConfirm("The Shipping option is required."; "OK"; "Help")
		GOTO OBJECT:C206(i1)
		REJECT:C38
		
	Else 
		fPOMaint:=False:C215  //bAcceptRec
		UNLOAD RECORD:C212([Purchase_Orders_Items:12])
		$0:=True:C214
End case 