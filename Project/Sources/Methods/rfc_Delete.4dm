//%attributes = {}
//Method:  rfc_Delete
// GO 02/28/20,
// Description
// 
// ----------------------------------------------------


//Description: Called from gValidDelete in the [Finished_Goods_SizeAndStyles];"Input" form

uConfirm("Delete "+[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1+"?"; "Delete"; "Cancel")

Case of   //Verify DateDone
	: (OK=0)  //They don't want to delete
	: ([Finished_Goods_SizeAndStyles:132]DateDone:6=!00-00-00!)  //It isn't done so no need to verify
	Else   //Its done make sure to verify
		
		uConfirm([Finished_Goods_SizeAndStyles:132]FileOutlineNum:1+" is marked as Done, are you sure?"; "Cancel"; "Delete")
		
		OK:=Num:C11(OK=0)  //Clicking Delete will set OK to 0 and we need it to be set to 1
		
End case   //Done verify DateDone

If (OK=1)  //Delete
	
	QUERY:C277([Finished_Goods_SnS_Additions:150]; [Finished_Goods_SnS_Additions:150]FileOutlineNum:1=[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1)
	
	DELETE SELECTION:C66([Finished_Goods_SnS_Additions:150])
	DELETE RECORD:C58([Finished_Goods_SizeAndStyles:132])
	
	CANCEL:C270
	
End if   //Done delete
