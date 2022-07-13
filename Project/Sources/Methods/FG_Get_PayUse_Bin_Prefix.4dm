//%attributes = {"publishedWeb":true}
// Method: FG_Get_PayUse_Bin_Prefix
// was fGetAvonBin(shipToId)  092695  MLB
//•092695  MLB  UPR 1729

C_TEXT:C284($1)  //ship to ID
C_TEXT:C284($0)  // alpha destination

$0:="-"+$1  // always return somthing

If ([Addresses:30]ID:1#$1)
	READ ONLY:C145([Addresses:30])
	QUERY:C277([Addresses:30]; [Addresses:30]ID:1=$1)
End if 

If ([Addresses:30]WarehouseName:34#"")
	$0:="-"+[Addresses:30]WarehouseName:34
End if 