//%attributes = {}
// Method: FG_KillTickets () -> 
// ----------------------------------------------------
// by: mel: 07/28/05, 14:41:47
// ----------------------------------------------------
// see also: FG_KillReport and rptAgeFGdetail

$kill:=Num:C11(Request:C163("Which Kill Status?"; "1"; "Print"; "Cancel"))
If (OK=1)
	READ ONLY:C145([Finished_Goods_Locations:35])
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]KillStatus:30=$kill)
	SET WINDOW TITLE:C213(String:C10(Records in selection:C76([Finished_Goods_Locations:35]))+" Kill_Tickets")
	If (Records in selection:C76([Finished_Goods_Locations:35])>0)
		zwStatusMsg("KILL "+String:C10(Records in selection:C76([Finished_Goods_Locations:35])); "Refine the selection, e.g. Location = FG:R@")
		QUERY SELECTION:C341([Finished_Goods_Locations:35])
		SET WINDOW TITLE:C213(String:C10(Records in selection:C76([Finished_Goods_Locations:35]))+"_Kill_Tickets")
		ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2; >)
		util_PAGE_SETUP(->[Finished_Goods_Locations:35]; "KillTickets")
		FORM SET OUTPUT:C54([Finished_Goods_Locations:35]; "KillTickets")
		PRINT SELECTION:C60([Finished_Goods_Locations:35])
		FORM SET OUTPUT:C54([Finished_Goods_Locations:35]; "List")
	Else 
		BEEP:C151
		ALERT:C41("No Bins with Kill status "+String:C10($kill))
	End if 
End if 