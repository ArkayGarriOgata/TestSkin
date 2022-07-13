//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 03/20/13, 14:59:17
// ----------------------------------------------------
// Method: ArtSelection
// ----------------------------------------------------
// Modified by: Mel Bohince (4/18/13) replace line 15 with 16 so stay on art tab when done

//correct bug last release 03-28-2019

QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ControlNumber:2=atCtrlNum{abArtLB})
CREATE SET:C116([Finished_Goods_Specifications:98]; "clickedIncludeRecord")


If (Form event code:C388=On Double Clicked:K2:5)
	//app_OpenDoubleClickedRecord (->[Finished_Goods_Specifications];iMode)// 
	app_OpenSelectedIncludeRecords(->[Finished_Goods_Specifications:98]ControlNumber:2)
End if 
UNLOAD RECORD:C212([Finished_Goods_Specifications:98])