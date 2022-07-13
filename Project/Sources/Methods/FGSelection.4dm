//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 03/25/13, 20:16:01
// ----------------------------------------------------
// Method: FGSelection
// ----------------------------------------------------

//correct bug last release 03-28-2019

QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=atProdCode{abFGLB})
CREATE SET:C116([Finished_Goods:26]; "clickedIncludeRecord")


If (Form event code:C388=On Double Clicked:K2:5)
	app_OpenDoubleClickedRecord(->[Finished_Goods:26]; iMode)
End if 