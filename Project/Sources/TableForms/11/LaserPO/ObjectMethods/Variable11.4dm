//(s) t3
//If (In header) & (Level=0)
Case of 
	: ([Purchase_Orders:11]ExpeditingNote:40#"") & ([Purchase_Orders:11]ShipInstruct:20#"")
		Self:C308->:="Shipping Instructions and Notes:     "+[Purchase_Orders:11]ShipInstruct:20+Char:C90(13)+[Purchase_Orders:11]ExpeditingNote:40  //spacing with opt + space
		
	: ([Purchase_Orders:11]ShipInstruct:20#"")
		Self:C308->:="Shipping Instructions:     "+[Purchase_Orders:11]ShipInstruct:20  //spacing with opt + space
		
	: ([Purchase_Orders:11]ExpeditingNote:40#"")
		Self:C308->:="Notes:     "+[Purchase_Orders:11]ExpeditingNote:40  //spacing with opt + space
	Else 
		Self:C308->:=""
End case 
//End if 
//