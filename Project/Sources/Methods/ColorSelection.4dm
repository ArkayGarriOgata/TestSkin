//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 03/26/13, 11:04:07
// ----------------------------------------------------
// Method: ColorSelection
// ----------------------------------------------------

//correct bug last release 03-28-2019

QUERY:C277([Finished_Goods_Color_SpecMaster:128]; [Finished_Goods_Color_SpecMaster:128]id:1=atID{abColorLB})
CREATE SET:C116([Finished_Goods_Color_SpecMaster:128]; "clickedIncludeRecord")


If (Form event code:C388=On Double Clicked:K2:5)
	app_OpenDoubleClickedRecord(->[Finished_Goods_Color_SpecMaster:128]; iMode)
End if 