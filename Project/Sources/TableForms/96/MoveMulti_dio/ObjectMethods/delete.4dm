// ----------------------------------------------------
// Method: [WMS_SerializedShippingLabels].MoveMulti_dio.delete   ( ) ->
// By: Mel Bohince @ 04/07/16, 10:39:39
// Description
// 
// ----------------------------------------------------



uConfirm("Are you sure you want to skip the selected cases?"; "Delete"; "Cancel")
If (ok=1)
	
	
	For ($i; 1; Size of array:C274(ListBox1))
		If (ListBox1{$i})  //selected
			rft_Case{$i}:=(" "*18)+"SKIP"
		End if 
	End for 
	
	
End if 

OBJECT SET ENABLED:C1123(*; "delete"; False:C215)
