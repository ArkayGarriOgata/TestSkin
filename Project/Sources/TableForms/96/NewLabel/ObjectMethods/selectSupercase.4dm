If (cbSuperCase=1)
	If (Length:C16(wms_bin_id)=0)
		wms_bin_id:="BNRCC"
	End if 
	SetObjectProperties("supercase@"; -><>NULL; True:C214)
	
	cbReceiveAMS:=0
	
Else 
	wms_bin_id:=""
	SetObjectProperties("supercase@"; -><>NULL; False:C215)
End if 