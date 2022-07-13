//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 10/22/09, 16:41:25
// ----------------------------------------------------
// Method: ELC_Liabilities_Search
// ----------------------------------------------------

vAskMePID:=0
windowTitle:="Liabilities Search"
$winRef:=OpenFormWindow(->[Finished_Goods_DeliveryForcasts:145]; "liabilities_dio"; ->windowTitle; windowTitle)
FORM SET INPUT:C55([Finished_Goods_DeliveryForcasts:145]; "liabilities_dio")
SET MENU BAR:C67(<>DefaultMenu)
sCPN:=""

sCriterion7:=""
sCriterion8:=""
sCriterion9:=""

ADD RECORD:C56([Finished_Goods_DeliveryForcasts:145]; *)  //not going to save this puppy

CLOSE WINDOW:C154($winRef)
FORM SET INPUT:C55([Finished_Goods_DeliveryForcasts:145]; "input")
ARRAY TEXT:C222(aCPN; 0)