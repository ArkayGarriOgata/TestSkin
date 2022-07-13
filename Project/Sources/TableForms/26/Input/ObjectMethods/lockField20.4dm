//(s) {finished goods]Input2'outliine_Num
//after entering a file number(outline number)
//locate any other FGs which have the same file no AND a SnS date
//if one (or more) is found set this record to the found date
//Alos locate a pcking qty too
//• 10/8/97 cs created
//•120997  MLB  UPR 1908, protect Finishing Depts entries
//021406 mlb no longer enterable, and switched to pak spec record
If ([Finished_Goods:26]OutLine_Num:4#"")
	CONFIRM:C162("Update other F/G record's Packing Qty if they have the same Outline Number?")  //•120997  MLB  UPR 1908
	If (ok=1)
		MESSAGES OFF:C175
		NewWindow(250; 50; 0; -720)
		MESSAGE:C88("Updating other FGs with same Outline...")
		C_LONGINT:C283($PckQty)
		
		
		$PckQty:=Self:C308->
		QryFgByOutline
		
		//Repeat `•120997  MLB  UPR 1908 could cause a deadlock
		APPLY TO SELECTION:C70([Finished_Goods:26]; [Finished_Goods:26]PackingQty:45:=$PckQty)
		//Until (uChkLockedSet (»[Finished_Goods]))
		
		USE SET:C118("Hold")
		CLEAR SET:C117("hold")
		POP RECORD:C177([Finished_Goods:26])
	End if 
	MESSAGES ON:C181
	//
	
End if 