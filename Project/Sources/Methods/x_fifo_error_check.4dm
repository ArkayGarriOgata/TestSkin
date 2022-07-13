//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 11/30/11, 11:01:49
// ----------------------------------------------------
// Method: x_fifo_error_check
// Description
// look for cases where lastest jobit has no inventory
//
// Parameters
// ----------------------------------------------------
//what product codes have inventory?
QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]FG_Key:34="@")
DISTINCT VALUES:C339([Finished_Goods_Locations:35]FG_Key:34; $acpn)
//for each productcode, check that latest jobit has inventory
For ($i; 1; Size of array:C274($acpn))
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=Substring:C12($acpn{$i}; 7); *)
	QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Glued:33#!00-00-00!; *)  //exclude planned
	QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Qty_Actual:11>5)  //exclude batch set
	DISTINCT VALUES:C339([Job_Forms_Items:44]Jobit:4; $allJobits)
	SORT ARRAY:C229($allJobits; <)  //latest job on top
	$numberToTest:=Size of array:C274($allJobits)
	
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]FG_Key:34=$acpn{$i})
	DISTINCT VALUES:C339([Finished_Goods_Locations:35]Jobit:33; $allinventory)
	SORT ARRAY:C229($allinventory; <)  //latest job on top
	
	$case:=1
	$continue:=True:C214
	While ($case<=$numberToTest) & ($continue)
		$hit:=Find in array:C230($allinventory; $allJobits{$case})
		If ($hit>-1)  // last jobit still has inventory, cool
			$continue:=False:C215
		Else 
			$cpn:=$acpn{$i}
			TRACE:C157
			$continue:=False:C215
		End if 
	End while 
	
End for 
BEEP:C151