//THIS IS NOT UP TO DATE WITH CURRENT PHY INV PRACTICES


uConfirm("Compare aMs to WMS"; "Yes"; "No")
If (ok=1)
	wms_compare_to_ams
	//wms_api_get_reconciliation 
End if 
