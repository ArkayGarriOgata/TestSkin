//%attributes = {"publishedWeb":true}
//Procedure uOlcalcRel_info()
//update an orderline's qty: shipped, open, and w/release based on
//release and payu info
//MLB 101895 
//•022197  MLB  get rid of neusonse messaves
C_LONGINT:C283($sched; $oldSched)  //switch control
C_TEXT:C284($1; $orderline)  //pass in teh orderline
Case of 
	: (Count parameters:C259=0)  //called by a new process command in rel afterphase
		$orderline:=<>OL
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$orderline)
		If (Records in selection:C76([Customers_Order_Lines:41])=1)
			If (fLockNLoad(->[Customers_Order_Lines:41]))
				uOLcalcRel_info($orderline)
			Else 
				BEEP:C151
				ALERT:C41("Orderline "+$orderline+" locked. Qty With Release has not been updated.")
			End if 
			
		End if 
		<>OL:=""
		
	: (Length:C16($1)<=10)  //via orderline before phase
		$orderline:=$1
		If ([Customers_Order_Lines:41]OrderLine:3#$orderline)
			READ WRITE:C146([Customers_Order_Lines:41])
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$orderline)
		End if 
		
		If ([Customers_Order_Lines:41]OrderLine:3=$orderline)
			If (Not:C34(Locked:C147([Customers_Order_Lines:41])))
				
				QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=$orderline)
				If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
					$sched:=Sum:C1([Customers_ReleaseSchedules:46]Sched_Qty:6)
				Else 
					$sched:=0
				End if 
				
				$oldSched:=[Customers_Order_Lines:41]QtyWithRel:20
				If ($sched#$oldSched)
					[Customers_Order_Lines:41]QtyWithRel:20:=$sched
					SAVE RECORD:C53([Customers_Order_Lines:41])
				End if 
				
			End if 
			
		End if 
		
End case 
//