//show all delfor since forecsts have unreliable refer
<>PO:="!"+[Finished_Goods:26]ProductCode:1
If (<>pid_forecast_viewer=0)
	<>pid_forecast_viewer:=New process:C317("edi_forecast_view"; <>lMinMemPart; "Forecast Viewer")
	If (False:C215)
		edi_forecast_view
	End if 
	
Else 
	POST OUTSIDE CALL:C329(<>pid_forecast_viewer)
End if 

