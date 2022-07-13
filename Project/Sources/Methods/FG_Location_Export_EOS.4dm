//%attributes = {"executedOnServer":true}
// _______
// Method: FG_Location_Export_EOS   ( ) ->
// By: MelvinBohince @ 01/15/22, 07:11:10
// Description
// create a csv of the inventory 
// ----------------------------------------------------

C_OBJECT:C1216($es; $entity; $filter_o; $1)
C_TEXT:C284($csvToExport; $fieldDelimitor; $recordDelimitor; $0)

$csvToExport:=""
$fieldDelimitor:=","
$recordDelimitor:="\r"
C_DATE:C307($glueDate)
C_LONGINT:C283($caseCount; $numberOfCases)

$es:=ds:C1482.Finished_Goods_Locations.all()
If (Count parameters:C259=1)
	$filter_o:=$1
	
	If ($filter_o.custID#Null:C1517)
		$es:=$es.query("CustID = :1"; $filter_o.custID)
	End if 
	
	If ($filter_o.productCode#Null:C1517)
		$es:=$es.query("ProductCode = :1"; $filter_o.productCode)
	End if 
	
	If ($filter_o.location#Null:C1517)
		$es:=$es.query("Location = :1"; $filter_o.location)
	End if 
End if 
$es:=$es.orderBy("CustID,ProductCode, Jobit, QtyOH desc")

C_COLLECTION:C1488($rows_c; $columns_c)
$rows_c:=New collection:C1472  //there will be a row for each invoice 
//start with the column headings
$columns_c:=New collection:C1472
$columns_c.push("CustID")
$columns_c.push("CustName")
$columns_c.push("ProductCode")
$columns_c.push("Jobit")
$columns_c.push("Location")
$columns_c.push("QtyOH")
$columns_c.push("skid_number")
$columns_c.push("Cases")
$columns_c.push("Glued")

$rows_c.push($columns_c.join($fieldDelimitor))  //add the headers

For each ($entity; $es)
	
	$columns_c:=New collection:C1472  //set up for the next row of date
	
	$columns_c.push($entity.CustID)
	$columns_c.push(CUST_getName($entity.CustID; "elc"))
	$columns_c.push(txt_ToCSV_attribute($entity; "ProductCode"))
	$columns_c.push($entity.Jobit)
	$columns_c.push(txt_ToCSV_attribute($entity; "Location"))
	$columns_c.push(txt_ToCSV_attribute($entity; "QtyOH"))
	If (Length:C16($entity.skid_number)>3)
		$columns_c.push("'"+$entity.skid_number)
	Else 
		$columns_c.push("'"+"case")
	End if 
	
	
	//$caseCount:=PK_getCaseCountByCPN ($entity.ProductCode)
	$caseCount:=0  // Modified by: MelvinBohince (1/15/22) 
	If ($entity.PRODUCT_CODE#Null:C1517)
		If ($entity.PRODUCT_CODE.PACKING_SPEC#Null:C1517)
			$caseCount:=$entity.PRODUCT_CODE.PACKING_SPEC.CaseCount
		End if 
	End if   //productcode
	
	If ($caseCount>0)
		$numberOfCases:=PK_getCaseCountByCalcOfQty($entity.QtyOH; $caseCount)
	Else 
		$numberOfCases:=-2
	End if 
	
	$columns_c.push(String:C10($numberOfCases))
	
	If ($entity.JOB_ITEM#Null:C1517)  // Modified by: MelvinBohince (1/15/22) 
		$glueDate:=$entity.JOB_ITEM.Glued
		If ($glueDate=!00-00-00!)
			$glueDate:=$entity.JOB_ITEM.Completed
		End if 
	Else 
		$glueDate:=!00-00-00!
	End if 
	
	$columns_c.push(String:C10($glueDate; Internal date short special:K1:4))
	
	$rows_c.push($columns_c.join($fieldDelimitor))  //add this row
	
End for each 

$csvToExport:=$rows_c.join($recordDelimitor)  //prep the text to send to file

$0:=$csvToExport
