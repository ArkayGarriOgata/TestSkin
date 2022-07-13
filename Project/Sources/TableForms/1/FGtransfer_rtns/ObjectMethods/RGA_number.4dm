// Method: [zz_control].FGtransfer_rtns.RGA_number   ( ) ->
// User name (OS): MLB   05/14/13, 10:12:16
// Modified by: Mel Bohince (5/18/20) refactor, remove old non-RGA code

If (Substring:C12(sCriter12; 1; 1)="R")  //process by RGA#
	READ WRITE:C146([QA_Corrective_Actions:105])
	QUERY:C277([QA_Corrective_Actions:105]; [QA_Corrective_Actions:105]RGA:4=sCriter12)
	If (Records in selection:C76([QA_Corrective_Actions:105])=1) & (fLockNLoad(->[QA_Corrective_Actions:105]))
		tJobItNum:=[QA_Corrective_Actions:105]Jobit:9
		If (Length:C16(tJobItNum)=11)
			sCriterion5:=Substring:C12(tJobItNum; 1; 8)
			i1:=Num:C11(Substring:C12(tJobItNum; 10))
		Else 
			BEEP:C151
			sCriterion5:="00000.00"
			i1:=0
		End if 
		sCriterion1:=[QA_Corrective_Actions:105]ProductCode:7
		sCriterion2:=[QA_Corrective_Actions:105]Custid:5
		sCriterion7:="RGA#"+sCriter12
		sCriterion8:="CAR#"+[QA_Corrective_Actions:105]RequestNumber:1
		rReal1:=[QA_Corrective_Actions:105]QtyComplaint:23
		
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=sCriterion1; *)
		QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]PONumber:21=[QA_Corrective_Actions:105]CustomerPO:12)
		If (Records in selection:C76([Customers_Order_Lines:41])>=1)
			sCriterion6:=[Customers_Order_Lines:41]OrderLine:3
			
			If (rReal1>([Customers_Order_Lines:41]Qty_Shipped:10-[Customers_Order_Lines:41]Qty_Returned:35))  //verify the quantity
				BEEP:C151
				ALERT:C41("Quantity shipped is less than what you are trying to return.")
				GOTO OBJECT:C206(rReal1)
			End if 
			
			If (Records in selection:C76([Customers_Order_Lines:41])>1)
				BEEP:C151
				ALERT:C41("WARNING: Other orderlines share this PO and CPN.")
			End if 
			
		Else 
			BEEP:C151
			ALERT:C41("Orderline for PO= "+[QA_Corrective_Actions:105]CustomerPO:12+" and CPN= "+sCriterion1+" could not be found.")
		End if 
		
	Else 
		BEEP:C151
		ALERT:C41("That RGA number was not found.")
		sCriter12:=""
		tJobItNum:=""
		sCriterion1:=""
		sCriterion6:=""
	End if 
	
Else 
	//• mlb - 11/5/02  13:59 require RGA
	BEEP:C151
	ALERT:C41("Return Goods Authorization number required to proceed. \rBy the way, they begin with the letter 'R'.\rSee SOP 4.14")
	sCriter12:=""
	GOTO OBJECT:C206(sCriter12)
	
End if 