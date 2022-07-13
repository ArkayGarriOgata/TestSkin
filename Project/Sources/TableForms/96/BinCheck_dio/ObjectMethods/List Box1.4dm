// Method: [WMS_SerializedShippingLabels].BinCheck_dio.List Box1
// Modified by: Mel Bohince (12/9/15) tidy up the enable on the bDelete
$selected:=""
$numSelected:=0
For ($i; 1; Size of array:C274(ListBox1))
	If (ListBox1{$i})
		$selected:=$selected+String:C10($i)+", "
		$numSelected:=$numSelected+1
	End if 
End for 

rft_error_log:=String:C10($numSelected)+" cases selected"
zwStatusMsg("CLICKED"; $selected)

If ($numSelected>0)
	If (User in group:C338(Current user:C182; "Physical Inv Manager"))
		OBJECT SET ENABLED:C1123(*; "delete"; True:C214)
	Else 
		OBJECT SET ENABLED:C1123(*; "delete"; False:C215)
	End if 
	
	SetObjectProperties(""; ->rft_error_log; True:C214; ""; False:C215)
	
Else 
	OBJECT SET ENABLED:C1123(*; "delete"; False:C215)
	SetObjectProperties(""; ->rft_error_log; False:C215)
End if 