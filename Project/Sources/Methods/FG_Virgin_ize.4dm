//%attributes = {}
// Method: FG_Virgin_ize () -> 
// ----------------------------------------------------
// by: mel: 03/21/05, 16:44:59
// ----------------------------------------------------
// Description:
// make sure duplicated fg's have certain fields initialize
// Updates:
// • mel (4/13/05, 13:31:57) clear some launch fields
// ----------------------------------------------------

C_TEXT:C284($1)  //option to skip some things

[Finished_Goods:26]HaveDisk:52:=False:C215
[Finished_Goods:26]HaveBnW:53:=False:C215
[Finished_Goods:26]HaveSpecSht:55:=False:C215
[Finished_Goods:26]HaveArt:51:=False:C215
[Finished_Goods:26]HaveSnS:54:=False:C215
[Finished_Goods:26]PrepDoneDate:58:=!00-00-00!
[Finished_Goods:26]DateArtApproved:46:=!00-00-00!
[Finished_Goods:26]PressDate:64:=!00-00-00!
[Finished_Goods:26]DateClosingMet:80:=!00-00-00!
[Finished_Goods:26]LastJobNo:16:=""
[Finished_Goods:26]LastRecdDate:17:=!00-00-00!
[Finished_Goods:26]LastOrderNo:18:=0
[Finished_Goods:26]LastShipDate:19:=!00-00-00!
[Finished_Goods:26]LastPrice:27:=0
[Finished_Goods:26]LastCost:26:=0
[Finished_Goods:26]HaveArt:51:=False:C215
$priorControlNumber:=[Finished_Goods:26]ControlNumber:61
[Finished_Goods:26]ControlNumber:61:=""
[Finished_Goods:26]OutLine_Num:4:=""
[Finished_Goods:26]Preflight:66:=False:C215
[Finished_Goods:26]PreflightBy:67:=""
[Finished_Goods:26]PreflightAt:74:=0
[Finished_Goods:26]PreflightDate:72:=!00-00-00!
[Finished_Goods:26]Status:14:="New"
[Finished_Goods:26]OriginalOrRepeat:71:="Original"
[Finished_Goods:26]DateFirstShipped:95:=!00-00-00!
[Finished_Goods:26]PrepInvoiceNumber:96:=0
[Finished_Goods:26]Bill_and_Hold_Qty:108:=0
// • mel (4/13/05, 13:31:50)

[Finished_Goods:26]GlueDirection:104:="Regular"
// deleted 5/15/20: gns_ams_clear_sync_fields(->[Finished_Goods]z_SYNC_ID;->[Finished_Goods]z_SYNC_DATA)

If (Count parameters:C259=0)  //making a brand new clone, not just a revision
	[Finished_Goods:26]pk_id:116:=Generate UUID:C1066
	[Finished_Goods:26]UPC:37:=""  //11/11/08 mlb
	[Finished_Goods:26]ArtReceivedDate:56:=!00-00-00!
	[Finished_Goods:26]DateSnSReceived:57:=!00-00-00!
	[Finished_Goods:26]DateLaunchApproved:85:=!00-00-00!
	[Finished_Goods:26]DateLaunchSubmitted:93:=!00-00-00!
	[Finished_Goods:26]WarehouseProgram:75:=False:C215
	[Finished_Goods:26]InventoryNow:73:=0
	[Finished_Goods:26]FRCST_NPV:70:=0
	[Finished_Goods:26]FRCST_NumberOfReleases:69:=0
	[Finished_Goods:26]ArtWorkNotes:60:="\r+++dup of "+$priorControlNumber+"+++\r"+[Finished_Goods:26]ArtWorkNotes:60
	
	[Finished_Goods:26]ArtWorkNotes:60:=FG_ArtProPath("clear")
	//$hit:=Position("<ArtPro>";[Finished_Goods]ArtWorkNotes)  //slice out the reference
	//If ($hit>0)
	//$start:=$hit
	//$hit:=Position("</ArtPro>";[Finished_Goods]ArtWorkNotes)
	//If ($hit>0)
	//$end:=$hit+9
	//$path:=Substring([Finished_Goods]ArtWorkNotes;$start;$end)
	//[Finished_Goods]ArtWorkNotes:=Substring([Finished_Goods]ArtWorkNotes;1;$start-1)+Substring([Finished_Goods]ArtWorkNotes;$end)
	//If (False)
	//$path:=FG_ArtProPath ("set";"")
	//End if 
	//End if 
	//End if 
End if 