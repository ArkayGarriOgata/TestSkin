//%attributes = {}
//Method: RMLc_Dialog_Pick
//Description:  This method allows the user to pick Raw Materials to report

//This allows Raw Material cycle counts to be filtered out

//  Count         Commodity Code    UOM
//  Cold Foil     09                Roll
//  Roll Stock    01                Lf
//  Sheeted       01                Each and Sht
//  Plastic       20                Each and Sht

//  All           No filter

If (True:C214)  //Initialize
	
	C_COLLECTION:C1488($cCommdityKey; $cUOM)
	
	C_LONGINT:C283($nWindowReference)
	
	C_OBJECT:C1216($oWindow; $oFilter)
	C_OBJECT:C1216($esRawMaterialsLocations)
	
	C_TEXT:C284($tTableName)
	
	$cCommdityKey:=New collection:C1472()
	$cUOM:=New collection:C1472()
	
	$oWindow:=New object:C1471()
	$oFilter:=New object:C1471()
	$esRawMaterialsLocations:=New object:C1471()
	
	$oWindow.tFormName:="RMLc_Pick"
	$oWindow.nWindowType:=Movable dialog box:K34:7
	
	$tTableName:=Table name:C256(->[Raw_Materials_Locations:25])
	
End if   //Done initializing

$nWindowReference:=Core_Window_OpenRelativeToN($oWindow)

DIALOG:C40($oWindow.tFormName; $oFilter)

CLOSE WINDOW:C154($nWindowReference)

Case of   //Filter
		
	: (OK=0)  //Cancel
		
	: ($oFilter.nAll=1)  //All
		
	Else   //Select filter
		
		If ($oFilter.nColdFoil=1)
			
			$cCommdityKey.push("09-@")
			$cUOM.push("Roll")
			
		End if 
		
		If ($oFilter.nRollStock=1)
			
			$cCommdityKey.push("01-@")
			$cUOM.push("Lf")
			
		End if 
		
		If ($oFilter.nSheeted=1)
			
			$cCommdityKey.push("01-@")
			$cUOM.push("Each"; "Sht")
			
		End if 
		
		If ($oFilter.nPlastic=1)
			
			$cCommdityKey.push("20-@")
			$cUOM.push("Each"; "Sht")
			
		End if 
		
		$cCommdityKey:=$cCommdityKey.distinct()
		$cUOM:=$cUOM.distinct()
		
End case   //Done filter

Case of   //Query
		
	: (OK=0)  //Cancel
		
	: ($oFilter.nAll=1)  //All
		
		$esRawMaterialsLocations:=ds:C1482[$tTablename].all()
		
		USE ENTITY SELECTION:C1513($esRawMaterialsLocations)
		
	Else   //Filter
		
		$esRawMaterialsLocations:=ds:C1482[$tTablename].query("Commodity_Key in :1 And RAW_MATERIAL.ReceiptUOM in :2"; $cCommdityKey; $cUOM)
		
		USE ENTITY SELECTION:C1513($esRawMaterialsLocations)
		
End case   //Done query
