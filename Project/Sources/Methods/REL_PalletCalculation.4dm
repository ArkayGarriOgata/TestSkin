//%attributes = {}
// _______
// Method: REL_PalletCalculation   ( ) ->
// By: Mel Bohince @ 04/28/21, 16:06:18
// Description
// based on EDI_DESADV_get_PO_Calloffs
// predict how consolidation will count pallets
// ----------------------------------------------------

C_COLLECTION:C1488($sortOrder_c; $shipTos_c)
C_TEXT:C284($shipto; consolidationType)
C_OBJECT:C1216($consolidatedRels_es; $relObj; $relEntSel)

C_BOOLEAN:C305($continueInteration)
$continueInteration:=True:C214

consolidationType:="PerShipto"
$pkSpec:=PK_getSpecByCPN

//build the sort order
$sortOrder_c:=New collection:C1472
$sortOrder_c.push(New object:C1471("propertyPath"; "Shipto"; "descending"; False:C215))
$sortOrder_c.push(New object:C1471("propertyPath"; "Sched_Date"; "descending"; False:C215))

If (Count parameters:C259>0)  //selected records
	$relEntSel:=$1
	
Else   //test
	$relEntSel:=ds:C1482.Customers_ReleaseSchedules.query("OpenQty > :1 and ediASNmsgID = :2"; 0; -1)
	$relEntSel:=$relEntSel.query("Shipto = :1 or Shipto = :2"; "00655"; "00728")
End if 

$relEntSel:=$relEntSel.orderBy($sortOrder_c)  //consolidating by shipto


//will need to consolidate by shipto
$shipTos_c:=$relEntSel.distinct("Shipto")

For each ($shipto; $shipTos_c) While ($continueInteration)
	
	$consolidatedRels_es:=$relEntSel.query("Shipto = :1"; $shipto).orderBy("OpenQty desc")
	
	$defaultCasesPerSkid:=24
	EDI_DESADV_Consolidation(New object:C1471("msg"; "init"; "lastRelease"; $consolidatedRels_es.last().ReleaseNumber; "casesPerPallet"; $defaultCasesPerSkid))
	
	For each ($relObj; $consolidatedRels_es)
		
		$casesPerSkid:=PK_getSpecByCPN($relObj.ProductCode)
		
		If ($relObj.FINISHED_GOOD#Null:C1517)
			
			If ($relObj.FINISHED_GOOD.PACKING_SPEC#Null:C1517)
				$qtyPerCase:=$relObj.FINISHED_GOOD.PACKING_SPEC.CaseCount  //PK_getCaseCount ($packingSpecID)PK_getCaseCount ($packingSpecID)
				//$numberOfCases:=Int($relObj.Sched_Qty/$qtyPerCase)
				$numberOfCases:=PK_getCaseCountByCalcOfQty($relObj.Sched_Qty; $qtyPerCase)  // Modified by: Mel Bohince (3/23/21) 
				
				
			End if   //pkspc !null
		End if   //fg !null
		
		EDI_DESADV_Consolidation(New object:C1471("msg"; "incrementCases"; "incrementCases"; $numberOfCases))
		// Modified by: Mel Bohince (4/13/21) User controlled number of pallets, added $consolidationDetail_o and call
		$consolidationDetail_o:=New object:C1471("po"; $relObj.CustomerRefer; "cpn"; $relObj.ProductCode; "numCases"; $numberOfCases; "caseSpaces"; $casesPerSkid)
		EDI_DESADV_Consolidation(New object:C1471("msg"; "addDetail"; "consolDetail"; $consolidationDetail_o))
		
		EDI_DESADV_Consolidation(New object:C1471("msg"; "close?"; "currentRelease"; $relObj.ReleaseNumber))
		
		
	End for each 
	
	
End for each 

EDI_DESADV_Consolidation(New object:C1471("msg"; "kill"))  // ("kill";0)  //cleanup