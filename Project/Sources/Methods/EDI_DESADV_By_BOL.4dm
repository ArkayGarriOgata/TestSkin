//%attributes = {}
// OBSOLETE_______
// OBSOLETE_______
// Method: EDI_DESADV_By_BOL(bol# ) ->
// By: Mel Bohince @ 11/12/19, 12:01:08
// Description
// ----------------------------------------------------
// Replaces: EDI_AdvanceShipNotice
// Description
// send an DESADV D.14A to the edi outbox for releases of parameter BOL
// if shipto requests asn's (see [Addresses]edi_Send_ASN)


C_LONGINT:C283($hit; $numberOfReleases; $shipment; $bol_number; $1; $0)
$numberOfReleases:=0

C_OBJECT:C1216($bols; $bol; $manifest; $item; $releaseObj; $orderInfoObj; $manifestObj; $relEntitySel)

If (Count parameters:C259>0)
	$bol_number:=$1
Else   //test
	$bol_number:=146188
End if 

$bols:=ds:C1482.Customers_Bills_of_Lading.query("ShippersNo = :1"; $bol_number)
If ($bols.length>0)  //have a valid BOL
	$bol:=$bols.first()  //grab the entity's handle
	
	If ($bol.ADDRESS_SHIPTO.edi_Send_ASN)  //does this destination want an ASN
		
		//load the manifest
		//$manifest:=ds.Customers_Bills_of_Lading_Manif.query("ShippersNo = :1";$bol_number)
		If ($bol.MANIFEST.length>0)
			$bol.MANIFEST.orderBy("Arkay_Release asc")  //going to consolidate by release
			//Gather all the data needed by the DESADV asn message
			$currentRelease:=0  //init
			$releaseObj:=New object:C1471
			$manifestObj:=New object:C1471("bol"; $bol_number; "weight"; 0; "volume"; 0; "numCases"; 0; "qty"; 0; "releaseInfo"; $releaseObj)
			//loop thru the manifest rolling up by release number
			For each ($item; $bol.MANIFEST)
				
				If ($item.Arkay_Release#$currentRelease)  //there could be alternate pack counts for a given release, shouldn't happen
					EDI_DESADV_Map($manifestObj)  //finish off the last release
					
					$numberOfReleases:=$numberOfReleases+1
					$currentRelease:=$item.Arkay_Release
					$relEntitySel:=ds:C1482.Customers_ReleaseSchedules.query("ReleaseNumber = :1"; $currentRelease)
					If ($relEntitySel.length>0)  //how could it not be?
						$releaseObj:=$relEntitySel.first()
					Else 
						$releaseObj:=New object:C1471("ReleaseNumber"; -1)
					End if 
					
					$manifestObj:=New object:C1471("bol"; $bol_number; "weight"; 0; "volume"; 0; "numCases"; 0; "qty"; 0; "releaseInfo"; $releaseObj)  //start the next release
					
					$volumePerCase:=PK_getVolumePerCase(FG_getOutline($item.CPN))  // in cubic inches, will convert to metric inside the map
				End if 
				//accumulators:
				//[Customers_Bills_of_Lading_Manif]NumCases  [Customers_Bills_of_Lading_Manif]Wt_PerCase  [Customers_Bills_of_Lading_Manif]Arkay_Release    [Customers_Bills_of_Lading_Manif]Total_Amt
				$manifestObj.qty:=$manifestObj.qty+$item.Total_Amt
				$manifestObj.numCases:=$manifestObj.numCases+$item.NumCases
				$manifestObj.weight:=$manifestObj.weight+($item.NumCases*$item.Wt_PerCase)
				$manifestObj.volume:=$manifestObj.volume+($item.NumCases*$volumePerCase)
			End for each 
			//send the last release
			EDI_DESADV_Map($manifestObj)  //finish off the last release
			
		Else   //no packing slip
			BEEP:C151
		End if   //manifest exists
		
	Else   //asn not required
		BEEP:C151
	End if   //asn required?
End if 

BEEP:C151
zwStatusMsg("DESADV"; String:C10($numberOfReleases)+" releases processed")
$0:=$numberOfReleases