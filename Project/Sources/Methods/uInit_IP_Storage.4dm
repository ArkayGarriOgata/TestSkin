//%attributes = {}
// _______
// Method: uInit_IP_Storage   ( ) ->
// By: Mel Bohince @ 08/04/20, 11:35:33
// Description
// substitute Storage for IP variables

If (False:C215)  //like:
	//then to use, so <> needs replaced with 'Storage.IP.'
	
	//$bool:=Storage.IP.GNS_Doing_FillInSyncIDs
	//$text:=Storage.IP.sCR
	//$int:=Int(Storage.IP.lHCENTER))
	//$date:=Date(Storage.IP.MAGIC_DATE)
	
	//instead of like the current:
	
	//<>GNS_Doing_FillInSyncIDs:=False
	//<>sCR:=Char(13)
	//<>lHCENTER:=(Screen height/2)+20
	//<>MAGIC_DATE:=!2025-12-25! 
End if 
// ----------------------------------------------------

C_OBJECT:C1216($ipVariable_o)
$ipVariable_o:=New shared object:C1526
Use ($ipVariable_o)
	$ipVariable_o["GNS_Doing_FillInSyncIDs"]:=False:C215
	$ipVariable_o["sCR"]:=Char:C90(Carriage return:K15:38)
	$ipVariable_o["lHCENTER"]:=(Screen height:C188/2)+20
	$ipVariable_o["MAGIC_DATE"]:=!2025-12-25!
End use 

Use (Storage:C1525)  //save it for reuse on this machine
	Storage:C1525.IP:=$ipVariable_o
End use 










