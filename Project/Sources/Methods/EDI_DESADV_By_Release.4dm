//%attributes = {}
// _______
// Method: EDI_DESADV_By_Release   ( ) -> outbox msg id if successful
// By: Mel Bohince @ 02/12/20, 14:59:35
// Description
// originally written to walk thru the BOL's manifest (EDI_DESADV)
// changed to work with existing release
// ----------------------------------------------------
//  // send an DESADV D.14A to the edi outbox for release
// if shipto requests asn's (see [Addresses]edi_Send_ASN)
// _______
// see also: EDI_DESADV(bol# ) ->
// Modified by: Mel Bohince (7/13/20) send fractional skids in 1/10th increments, as shipping price is per pallet, not weight
// Modified by: Mel Bohince (3/23/21) set $usePO_Qty:=True so qty isn't recalc by case count, which may include a partial case, so odd lots can be sent
//                   and use PK_getCaseCountByCalcOfQty
// Modified by: Mel Bohince (4/2/21) Deal with O/S inventory


C_BOOLEAN:C305($usePO_Qty; $roundUp)
$usePO_Qty:=True:C214  //False  //
$roundUp:=True:C214

C_LONGINT:C283($0; $edi_Outbox_id; $qtyPerCase; $weightPerCase; $casesPerSkid)  //$volumePerCase
C_OBJECT:C1216($1; $relObj; $orderInfoObj; $caseDimensions; $consolidation_o; $2)
$edi_Outbox_id:=-1
If (Count parameters:C259>0)
	$relObj:=$1
	If (Count parameters:C259>1)
		$consolidation_o:=$2
	Else 
		$consolidation_o:=Null:C1517
	End if 
	
Else   //test 4426450   4501545 (intl)  4535602 (dom)  4591006 (test)
	$relObj:=ds:C1482.Customers_ReleaseSchedules.query("ReleaseNumber = :1"; 4426450).first()
	$consolidation_o:=Null:C1517
End if 

If ($relObj.SHIPTO_ADDR#Null:C1517)
	If ($relObj.SHIPTO_ADDR.edi_Send_ASN)  //assert that this destination want an ASN
		
		//simulate pulling from a BOL manifest so EDI_DESADV_Map will still work, the manifest object has attributess
		$manifestObj:=New object:C1471("releaseInfo"; $relObj)  //start the next release
		
		//Gather all the data needed by the DESADV asn message not already on the release
		If ($relObj.FINISHED_GOOD#Null:C1517)
			If ($relObj.FINISHED_GOOD.PACKING_SPEC#Null:C1517)
				//numCases and weight are estimated from packing spec since not entered directly into BOL
				$qtyPerCase:=$relObj.FINISHED_GOOD.PACKING_SPEC.CaseCount  //PK_getCaseCount ($packingSpecID)
				$casesPerSkid:=$relObj.FINISHED_GOOD.PACKING_SPEC.CasesPerSkid  //PK_getCasesPerSkid ($packingSpecID))
				$weightPerCase:=$relObj.FINISHED_GOOD.PACKING_SPEC.WeightPerCase  //PK_getWeightPerCase ($packingSpecID)
				If ($weightPerCase=0)  //default 30 pounds
					$weightPerCase:=30
				End if 
				$caseDimensions:=PK_getCaseDimensions($relObj.FINISHED_GOOD.PACKING_SPEC.CaseSizeLWH)  //latest ELC spec asks for length/width/height
				//$volumePerCase:=$caseDimensions.length*$caseDimensions.width*$caseDimensions.height  //PK_getVolumePerCase ($packingSpecID)
				
			Else   // packing spec missing
				$qtyPerCase:=$relObj.Sched_Qty
				$casesPerSkid:=1
				$weightPerCase:=30
				$caseDimensions:=PK_getCaseDimensions("12 x 12 x 12")
				//$volumePerCase:=$caseDimensions.length*$caseDimensions.width*$caseDimensions.height
			End if 
			
		Else   //fg missing
			$qtyPerCase:=$relObj.Sched_Qty
			$casesPerSkid:=1
			$weightPerCase:=30
			$caseDimensions:=PK_getCaseDimensions("12 x 12 x 12")
			//$volumePerCase:=$caseDimensions.length*$caseDimensions.width*$caseDimensions.height
		End if 
		
		//below would have been typed into the BOL
		$manifestObj.bol:=""  //this is being created before staging so bol# is not known
		
		$manifestObj.casePack:=$qtyPerCase
		
		$manifestObj.numCases:=PK_getCaseCountByCalcOfQty($relObj.Sched_Qty; $qtyPerCase)  // Modified by: Mel Bohince (3/23/21) //Int($relObj.Sched_Qty/$qtyPerCase)
		//instead of:
		//If (($manifestObj.numCases*$qtyPerCase)<$relObj.Sched_Qty)  //don't get partial on me
		//If ($roundUp)
		//$manifestObj.numCases:=$manifestObj.numCases+1
		//End if 
		//End if 
		
		If ($usePO_Qty)  // Modified by: Mel Bohince (3/23/21) set to true so odd lots can be sent
			$manifestObj.qty:=$relObj.Sched_Qty
		Else 
			$manifestObj.qty:=$manifestObj.numCases*$qtyPerCase
		End if 
		
		// Modified by: Mel Bohince (7/13/20) send fractional skids in 1/10th increments, as shipping price is per pallet, not weight
		//$manifestObj.skids:=Int($manifestObj.numCases/$casesPerSkid)//this results in zero pallets if less than full pallet, not good
		If ($casesPerSkid<1)  //avoid div/0
			$casesPerSkid:=10  //use ten since minimum is going to be 0.1 anyway
		End if 
		
		If (consolidation_o#Null:C1517)
			$pallets:=0  //last release in consolidation will have total pallets
		Else 
			$pallets:=Round:C94($manifestObj.numCases/$casesPerSkid; 1)
			If ($pallets<0.1)
				$pallets:=0.1
			End if 
		End if 
		$manifestObj.skids:=$pallets
		
		$manifestObj.casesPerSkid:=$casesPerSkid
		$manifestObj.weight:=$weightPerCase  //*$manifestObj.numCases
		//$manifestObj.volume:=$volumePerCase  //*$manifestObj.numCases
		//total dimensions
		$manifestObj.length:=$caseDimensions.length  //*$manifestObj.numCases
		$manifestObj.width:=$caseDimensions.width  //*$manifestObj.numCases
		$manifestObj.height:=$caseDimensions.height  //*$manifestObj.numCases
		//$manifestObj.height:=$relObj.consolidation
		
		//$json:=JSON Stringify($manifestObj;*)
		//ALERT($json)
		
		$manifestObj.shipFromWarehouse:=FGL_whereIsInventory($relObj.ProductCode; "NAD")  // Modified by: Mel Bohince (4/2/21) Deal with O/S inventory
		
		//map and save to edi_outbox
		$edi_Outbox_id:=EDI_DESADV_Map($manifestObj)  //finish off the last release
		
		zwStatusMsg("DESADV"; String:C10($relObj.ReleaseNumber)+" release processed")
		
	Else   //asn not required
		$edi_Outbox_id:=-2
		BEEP:C151
	End if   //asn?
	
Else   //address not specified
	$edi_Outbox_id:=-3
	BEEP:C151
End if   //shipto address not null

$0:=$edi_Outbox_id