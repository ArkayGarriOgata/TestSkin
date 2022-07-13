//11/3/94
// 3/27/95
//• 6/17/97 cs allow odd locations from payuse to pass (they include a '#')
//C_BOOLEAN($Continue)
//C_TEXT($Save)
//  //• 6/17/97 cs start
//$Save:=Self->
//$Continue:=sVerifyLocation (sCriterion3)
qtyBeforeAdj:=0

If (sJobit#"")
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2=sCriterion3; *)
	QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Jobit:33=sJobit)
	$numLoc:=Records in selection:C76([Finished_Goods_Locations:35])
	
	Case of 
		: ($numLoc=1)  //nice
			qtyBeforeAdj:=[Finished_Goods_Locations:35]QtyOH:9
			GOTO OBJECT:C206(rReal1)
			
		: ($numLoc=0)  //maybe create
			If (sVerifyLocation(->sCriterion3))
				GOTO OBJECT:C206(rReal1)
			Else 
				ALERT:C41("Location "+sCriterion3+" is not allowed."; "Ok")
				sCriterion3:=""
				GOTO OBJECT:C206(sCriterion3)
			End if 
			
		Else   //: ($numLoc>1)
			ALERT:C41("Location+Jobit not unique, try using the Skid option"; "Ok")
			sCriterion3:=""
			sJobit:=""
			GOTO OBJECT:C206(tSkidNumber)
	End case 
	
Else   //
	//
	ALERT:C41("Enter a jobit first.")
	sCriterion3:=""
	sJobit:=""
	tSkidNumber:=""
	GOTO OBJECT:C206(sJobit)
	
End if 
