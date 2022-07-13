//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 11/05/09, 14:18:47
// ----------------------------------------------------
// Method: edi_forecast_view
// Description
// display a list of forecasts
// ----------------------------------------------------

C_LONGINT:C283($winRef)

FORM SET INPUT:C55([Finished_Goods_DeliveryForcasts:145]; "input")  //insure 
FORM SET OUTPUT:C54([Finished_Goods_DeliveryForcasts:145]; "list")  //insure that 'list' is always selected
SET MENU BAR:C67(<>DefaultMenu)  //Apple File Edit Window
READ ONLY:C145([Finished_Goods_DeliveryForcasts:145])

filePtr:=->[Finished_Goods_DeliveryForcasts:145]
zDefFilePtr:=filePtr
sFile:=Table name:C256(filePtr)
fileNum:=Table:C252(filePtr)
windowTitle:=" Reviewing forecasts"
iMode:=3
$winRef:=OpenFormWindow(filePtr; "*"; ->windowTitle)

If (Length:C16(<>PO)>0)
	If (Substring:C12(<>PO; 1; 1)="!")
		QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]ProductCode:2=Substring:C12(<>PO; 2))
	Else 
		QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]ProductCode:2=<>PO)
		If (Records in selection:C76([Finished_Goods_DeliveryForcasts:145])=0) & (Substring:C12(<>PO; 1; 2)="BR")
			$po:="BP"+Substring:C12(<>PO; 3)
			QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]refer:3=$po)
		End if 
	End if 
	CREATE SET:C116(filePtr->; "◊LastSelection"+String:C10(fileNum))
	<>PO:=""
	ORDER BY:C49([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]asOf:9; <; [Finished_Goods_DeliveryForcasts:145]DateDock:4; >)
	Repeat 
		DISPLAY SELECTION:C59([Finished_Goods_DeliveryForcasts:145]; Multiple selection:K50:3; False:C215; *)
	Until (bdone>=1)
End if 

CLOSE WINDOW:C154($winRef)
<>pid_forecast_viewer:=0