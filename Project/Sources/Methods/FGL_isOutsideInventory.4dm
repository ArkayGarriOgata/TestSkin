//%attributes = {}
// _______
// Method: FGL_isOutsideInventory   ( ) ->
// By: Mel Bohince @ 07/28/21, 08:54:45
// Description
// test if cpn has inventory at an outside service warehouse
// ----------------------------------------------------
C_TEXT:C284($0; $cpn; $1)


If (Count parameters:C259>0)
	$cpn:=$1
Else 
	$cpn:="P922-01-0112"  //"RK5E-01-0115"
End if 

If (showLaunchDetails)
	C_OBJECT:C1216($fgl_es)
	$fgl_es:=ds:C1482.Finished_Goods_Locations.query("ProductCode = :1"; $cpn)
	
	Case of 
		: ($fgl_es.length=0)  //no inventory
			$0:="ø"
			
		Else   //where is inventory?
			C_OBJECT:C1216($os_es)
			$os_es:=$fgl_es.query("Location = :1"; "@:OS@")
			
			If ($os_es.length>0)  //at an outside location
				$0:="@OS"
				
			Else   //in house
				$0:="@RK"
			End if 
	End case 
	
Else 
	$0:="Off"
End if 

