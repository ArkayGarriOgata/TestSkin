//%attributes = {}
//Methd:  RMTr_Rprt_Transaction(oParameter)
//Description:  This method will run the Raw Materials Transactions report

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oParameter)
	
	C_BOOLEAN:C305($bTitle)
	
	C_COLLECTION:C1488($cAttribute)
	
	C_DATE:C307($dStat; $dEnd)
	
	C_OBJECT:C1216($esRaw_Materials_Transactions)
	
	C_TEXT:C284($tViewProArea)
	
	C_TEXT:C284($tQuery)
	C_TEXT:C284($tTableName)
	
	ARRAY TEXT:C222($atAttribute; 0)
	
	$oParameter:=$1
	
	$dStart:=OB Get:C1224($oParameter; "Start Date")
	$dEnd:=OB Get:C1224($oParameter; "End Date")
	
	$bTitle:=True:C214
	
	$cAttribute:=New collection:C1472(\
		"XferDate"; \
		"Xfer_Type"; \
		"Commodity_Key"; \
		"Raw_Matl_Code"; \
		"POItemKey"; \
		"JobForm"; \
		"Qty"; \
		"ActExtCost"; \
		"CommodityCode"; \
		"ReceivingNum")
	
	$tViewProArea:="ViewProArea"
	
	$tQuery:="XferDate >= :1 AND XferDate <= :2"
	
	$tTableName:=Table name:C256(->[Raw_Materials_Transactions:23])
	
End if   //Done initialize

$esRaw_Materials_Transactions:=ds:C1482[$tTableName].query($tQuery; $dStart; $dEnd)\
.orderBy("XferDate ASC AND Commodity_Key ASC AND Raw_Matl_Code ASC AND Xfer_Type ASC")

VwPr_SetRow($tViewProArea; $cAttribute; $esRaw_Materials_Transactions; $bTitle)
