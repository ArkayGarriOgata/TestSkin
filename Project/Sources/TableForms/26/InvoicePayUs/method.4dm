//Layout Proc.: InvoicePayUs()  092895  MLB
//•101095  MLB add date & cust reference
//•101295  MLB 
Case of 
	: (Form event code:C388=On Load:K2:1)
		iQty:=0
		iTotal:=0
		t3:="Shipped previously on consignment. Usage date was "+String:C10(4D_Current_date; <>SHORTDATE)
		
		If (sPOnum2="")
			sCPN:=""
			sBreakText:=""  //•101095  MLB 
			iRelNumber:=0
			ARRAY TEXT:C222(asBin; 0)
			ARRAY LONGINT:C221(aQty; 0)
			ARRAY LONGINT:C221(aRel; 0)
			ARRAY LONGINT:C221(aBinRecNum; 0)
		Else 
			If (Size of array:C274(asBin)>0)
				asBin:=1
				aQty:=1
				aRel:=1
				aBinRecNum:=1
			End if 
			GOTO OBJECT:C206(iQty)
		End if 
		
	: (Form event code:C388=On Outside Call:K2:11)  //from AskMe
		If (<>POnum#"")
			sPONum2:=<>POnum
			<>POnum:=""
			BRING TO FRONT:C326(Current process:C322)
			sPayUPO
			
		End if 
		
End case 
//