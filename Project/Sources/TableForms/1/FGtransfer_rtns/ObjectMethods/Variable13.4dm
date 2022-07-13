//5/4/95
//091195
If (Position:C15(asFrom{asFrom}; Self:C308->)=0)
	Self:C308->:=asFrom{asFrom}+Self:C308->
End if 
If (sVerifyLocation(Self:C308))
	If (sCriterion3#"WIP")  //verify the from location
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]JobForm:19=sCriterion5; *)
		QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]ProductCode:1=sCriterion1; *)
		QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2=sCriterion3; *)
		QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]JobFormItem:32=i1)  //091195
		If (Records in selection:C76([Finished_Goods_Locations:35])=0)
			BEEP:C151
			ALERT:C41(sCriterion1+" was not found on job form "+sCriterion5+" in bin "+sCriterion3)
			GOTO OBJECT:C206(sCriterion3)
			
		Else 
			If (rReal1>[Finished_Goods_Locations:35]QtyOH:9)  //verify the quantity
				BEEP:C151
				ALERT:C41("Quantity on-hand in that location is less than what you are trying to move.")
				GOTO OBJECT:C206(rReal1)
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
