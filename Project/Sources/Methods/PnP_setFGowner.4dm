//%attributes = {}
// Method: PnP_setFGowner () -> 
// ----------------------------------------------------
// by: mel: 06/18/05, 14:14:44
// ----------------------------------------------------
// Description:
// Set the shipto id and city into the fg records
// ----------------------------------------------------

C_LONGINT:C283($i; $numRecs)
C_BOOLEAN:C305($break)

READ ONLY:C145([Finished_Goods_DeliveryForcasts:145])
READ ONLY:C145([Customers_ReleaseSchedules:46])
READ WRITE:C146([Finished_Goods:26])

QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]CustID:2="00199"; *)
QUERY:C277([Finished_Goods:26];  & ; [Finished_Goods:26]GSR:79="")

$break:=False:C215
$numRecs:=Records in selection:C76([Finished_Goods:26])

uThermoInit($numRecs; "Updating Records")
For ($i; 1; $numRecs)
	If ($break)
		$i:=$i+$numRecs
	End if 
	
	QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]ProductCode:2=[Finished_Goods:26]ProductCode:1)
	If (Records in selection:C76([Finished_Goods_DeliveryForcasts:145])>0)
		[Finished_Goods:26]GSR:79:=[Finished_Goods_DeliveryForcasts:145]ShipTo:8
		[Finished_Goods:26]Developer:78:=ADDR_getCity([Customers_ReleaseSchedules:46]Shipto:10)
		SAVE RECORD:C53([Finished_Goods:26])
		
	Else 
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=[Finished_Goods:26]ProductCode:1; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Shipto:10#"")
		If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
			[Finished_Goods:26]GSR:79:=[Customers_ReleaseSchedules:46]Shipto:10  //+"*"
			[Finished_Goods:26]Developer:78:=ADDR_getCity([Customers_ReleaseSchedules:46]Shipto:10)
			SAVE RECORD:C53([Finished_Goods:26])
		End if 
	End if 
	NEXT RECORD:C51([Finished_Goods:26])
	uThermoUpdate($i)
End for 
uThermoClose

REDUCE SELECTION:C351([Finished_Goods_DeliveryForcasts:145]; 0)
REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
REDUCE SELECTION:C351([Finished_Goods:26]; 0)