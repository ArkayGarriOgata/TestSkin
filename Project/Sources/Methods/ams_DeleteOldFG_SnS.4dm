//%attributes = {}
// -------
// Method: ams_DeleteOldFG_SnS   ( ) ->
// By: Mel Bohince @ 01/04/19, 15:34:23
// Description
// remove unreferenced outlines that are more than 2 years old
//subtract the set of used outlines from all the outlines, restrict by date, then delete
// ----------------------------------------------------

C_DATE:C307($cutoff)
$cutoff:=Add to date:C393(Current date:C33; -3; 0; 0)


READ WRITE:C146([Finished_Goods_SizeAndStyles:132])  //deleting from here
READ ONLY:C145([Finished_Goods:26])

ALL RECORDS:C47([Finished_Goods_SizeAndStyles:132])
CREATE SET:C116([Finished_Goods_SizeAndStyles:132]; "all")
REDUCE SELECTION:C351([Finished_Goods_SizeAndStyles:132]; 0)


ALL RECORDS:C47([Finished_Goods:26])
RELATE ONE SELECTION:C349([Finished_Goods:26]; [Finished_Goods_SizeAndStyles:132])
CREATE SET:C116([Finished_Goods_SizeAndStyles:132]; "needed")
DIFFERENCE:C122("all"; "needed"; "remove")
USE SET:C118("remove")

QUERY SELECTION:C341([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]DateCreated:3<$cutoff)  //;*)

BEEP:C151
ALERT:C41("Export, then delete.")
//stop here to export

//util_DeleteSelection (->[Finished_Goods_SizeAndStyles])

CLEAR SET:C117("remove")
CLEAR SET:C117("needed")
CLEAR SET:C117("all")



