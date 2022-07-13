//show all delfor since forecsts have unreliable refer
<>PO:=[Customers_ReleaseSchedules:46]ProductCode:11  //replace string([Customers_ReleaseSchedules]CustomerRefer;".001";"")

If (<>pid_forecast_viewer=0)
	<>pid_forecast_viewer:=New process:C317("edi_forecast_view"; <>lMinMemPart; "Forecast Viewer")
	If (False:C215)
		edi_forecast_view
	End if 
Else 
	POST OUTSIDE CALL:C329(<>pid_forecast_viewer)
End if 

//QUERY([Finished_Goods_DeliveryForcasts];[Finished_Goods_DeliveryForcasts]cpn=[Customers_ReleaseSchedules]ProductCode)
//patternPassThru (->[Finished_Goods_DeliveryForcasts])
//ViewSetter (3;->[Finished_Goods_DeliveryForcasts])
//ORDER BY([Finished_Goods_DeliveryForcasts];[Finished_Goods_DeliveryForcasts]asOf;<;[Finished_Goods_DeliveryForcasts]DateDock;>)
//C_TEXT($message)
//$message:=""
//C_TEXT($r)
//$r:=Char(13)
//C_LONGINT($i)
//$current_asof:=""
//For ($i;1;Records in selection([Finished_Goods_DeliveryForcasts]))
//If ([Finished_Goods_DeliveryForcasts]asOf#$current_asof)
//$message:=$message+$r+$r+"As of: "+[Finished_Goods_DeliveryForcasts]asOf+$r
//$current_asof:=[Finished_Goods_DeliveryForcasts]asOf
//End if 
//$message:=$message+"         "+String([Finished_Goods_DeliveryForcasts]QtyOpen;"###,###,##0")+" dock on "+String([Finished_Goods_DeliveryForcasts]DateDock;Short )+" "+" to "+[Finished_Goods_DeliveryForcasts]ShipTo+" "+("Obsolete!"*Num([Finished_Goods_DeliveryForcasts]Is_Obsolete))+$r
//NEXT RECORD([Finished_Goods_DeliveryForcasts])
//End for 
//util_FloatingAlert ($message)