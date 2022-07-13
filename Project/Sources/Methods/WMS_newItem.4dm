//%attributes = {"publishedWeb":true}
//PM: WMS_newItem() -> 
//@author mlb - 4/30/03  16:43
C_LONGINT:C283($0; $id; $4)
C_TEXT:C284($1; $2; $3)
C_DATE:C307($5)

//$id:=WMS_getNextItemId (->[WMS_ItemMaster])
//If ($id#-1)
If (Length:C16($1)>0)
	CREATE RECORD:C68([WMS_ItemMasters:123])
	[WMS_ItemMasters:123]Skidid:1:=$1
	[WMS_ItemMasters:123]SKU:2:=$2
	[WMS_ItemMasters:123]LOT:3:=$3
	
	[WMS_ItemMasters:123]STATE:5:="NEW"
	//If ($1≤1≥#"s")
	[WMS_ItemMasters:123]UOM:6:="EACH"
	//Else 
	//[WMS_ItemMaster]UOM:="SKID"
	//End if 
	[WMS_ItemMasters:123]QTY:7:=$4
	[WMS_ItemMasters:123]DATE_MFG:8:=$5
	If (Count parameters:C259>=6)
		[WMS_ItemMasters:123]LOCATION:4:=$6
	Else 
		[WMS_ItemMasters:123]LOCATION:4:="WIP"
	End if 
	
	If (Count parameters:C259>=7)
		[WMS_ItemMasters:123]CUST:9:=$7
	Else 
		QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=(Num:C11(Substring:C12([WMS_ItemMasters:123]LOT:3; 1; 5))))
		[WMS_ItemMasters:123]CUST:9:=[Jobs:15]CustID:2
	End if 
	
	$case_count:=PK_getCaseCount(FG_getOutline([WMS_ItemMasters:123]SKU:2))
	If ($case_count>0)
		[WMS_ItemMasters:123]CASES:10:=Int:C8([WMS_ItemMasters:123]QTY:7/$case_count)
	Else 
		[WMS_ItemMasters:123]CASES:10:=0
	End if 
	
	SAVE RECORD:C53([WMS_ItemMasters:123])
	UNLOAD RECORD:C212([WMS_ItemMasters:123])
End if 

//Else 
// BEEP
//  ALERT("ID Generator busy, try again later.")
//End if 

//$0:=$id