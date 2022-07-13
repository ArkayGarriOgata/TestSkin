//%attributes = {}
//Method:  CsBL_FixChainOfCustody
//Description:  This method will fix [Customers_Bills_of_Lading]ChainOfCustody field

If (True:C214)  //Initialize
	
	C_TEXT:C284($tTableName; $tQuery)
	C_TEXT:C284($tCOC)
	
	C_COLLECTION:C1488($cDistinctCOC)
	
	C_OBJECT:C1216($esCustomersBillsOfLading)
	
	$tTableName:=Table name:C256(->[Customers_Bills_of_Lading:49])
	
	$tQuery:="ChainOfCustody # ''"
	
	$esCustomersBillsOfLading:=New object:C1471()
	
	$tCOC:="FSC MIX CREDIT BV-COC-070906"
	
End if   //Done initialize

$esCustomersBillsOfLading:=ds:C1482[$tTableName].query($tQuery)

USE ENTITY SELECTION:C1513($esCustomersBillsOfLading)

APPLY TO SELECTION:C70([Customers_Bills_of_Lading:49]; [Customers_Bills_of_Lading:49]ChainOfCustody:30:=$tCOC)

$cDistinctCOC:=$esCustomersBillsOfLading.distinct("ChainOfCustody")

Core_Cltn_DocumentTo($cDistinctCOC)
