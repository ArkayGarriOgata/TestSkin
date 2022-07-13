//5/4/95
//091195
//• 6/17/97 cs added code to allow wierd Pay use locations to be processed
C_BOOLEAN:C305($Continue)
C_TEXT:C284($Save)

//If (Position(Substring(asFrom{asFrom};1;2);Self->)=0)  //• mlb - 10/24/01  add substring
//Self->:=asFrom{asFrom}+Self->
//End if 
$Continue:=False:C215  //• 6/17/97 cs 
$Save:=Self:C308->

If (sVerifyLocation(Self:C308))
	//• 6/17/97 cs  start
	$Continue:=True:C214
Else 
	If (sCriterion6#"")  //there is an orderline
		Self:C308->:=$Save
		If ([Customers_Order_Lines:41]OrderLine:3#sCriterion6)  //if the orderline in memory is not the correct one
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=sCriterion6)  //get it
		End if 
		
		If ([Customers_Order_Lines:41]PayUse:47) & (Position:C15("#"; Self:C308->)>0)  //payuse & this location contains a '#', wierd pay use location
			uConfirm("This item is apparently a 'PAY-Use' with an odd location."+Char:C90(13)+"Is '"+Self:C308->+"' the correct FROM location?")
			
			If (OK=1)
				$Continue:=True:C214
			Else 
				$Continue:=False:C215
				Self:C308->:=""
			End if 
		End if 
	End if 
End if 

If ($Continue)
	//• 6/17/97 cs  end  
	If (sCriterion3#"WIP")  //verify the from location
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33=sJobit; *)
		QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2=sCriterion3)
		
		If (Records in selection:C76([Finished_Goods_Locations:35])=0)
			BEEP:C151
			ALERT:C41("Jobit "+sJobit+"was not found in bin "+sCriterion3)
			GOTO OBJECT:C206(sCriterion3)
		Else 
			
			If (rReal1>[Finished_Goods_Locations:35]QtyOH:9)  //verify the quantity
				BEEP:C151
				ALERT:C41("Quantity on-hand in that location is less than what you are trying to move.")
				rReal1:=[Finished_Goods_Locations:35]QtyOH:9
				GOTO OBJECT:C206(rReal1)
			End if 
			
			If (Substring:C12(sCriterion3; 1; 4)="FG:V")
				sCriterion4:=Replace string:C233(sCriterion3; ":V"; ":R")
			End if 
		End if   //too big of qty
		
	Else   //check the planned production qty
		LOAD RECORD:C52([Job_Forms_Items:44])
		
		If (([Job_Forms_Items:44]JobForm:1#sCriterion5) | ([Job_Forms_Items:44]ProductCode:3#sCriterion1))
			qryJMI(sCriterion5; i1)  //5/4/95      
		End if 
		
		If (([Job_Forms_Items:44]Qty_Actual:11+rReal1)>[Job_Forms_Items:44]Qty_Yield:9)
			BEEP:C151
			ALERT:C41("Warning: This quantity will exceed the yield for item "+String:C10([Job_Forms_Items:44]ItemNumber:7)+" on that form.")
		End if 
	End if 
End if 
//