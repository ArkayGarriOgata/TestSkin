//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 03/22/13, 10:30:14
// ----------------------------------------------------
// Method: SSSelection
// ----------------------------------------------------

//correct bug last release 03-28-2019

QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]FileOutlineNum:1=atFIleNum{abSandS})
CREATE SET:C116([Finished_Goods_SizeAndStyles:132]; "clickedIncludeRecord")


If (Form event code:C388=On Double Clicked:K2:5)
	app_OpenDoubleClickedRecord(->[Finished_Goods_SizeAndStyles:132]; iMode)
End if 