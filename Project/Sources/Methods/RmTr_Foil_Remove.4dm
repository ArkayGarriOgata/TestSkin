//%attributes = {}
//Method:  RmTr_Foil_Remove(eRawMatlTrns)
//Description:  This method will remove the cold foil

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $eRawMatlTrns)
	
	C_BOOLEAN:C305($bEntity; $bRemove)
	
	C_OBJECT:C1216($eRawMaterialsLocation)
	C_OBJECT:C1216($esRawMaterialsLocations)
	
	C_OBJECT:C1216($oAlertEntity)
	C_OBJECT:C1216($oAlertRawMtrlLctn)
	C_OBJECT:C1216($oAlertPurchaseOrder)
	
	C_OBJECT:C1216($oConfirm)
	
	C_TEXT:C284($tJobForm; $tLocation)
	C_TEXT:C284($tCost)
	C_TEXT:C284($tQuery; $tTableName; $tPOItemKey)
	C_TEXT:C284($tpk_id)
	
	C_DATE:C307($dXferDate)
	C_REAL:C285($rQuantity)
	
	$bEntity:=Not:C34(OB Is empty:C1297($1))  //Added in case the button is enabled when it shouldn't be.
	
	$oAlertEntity:=New object:C1471()
	$oAlertEntity.tMessage:="Please select a cold foil to remove."
	
	If ($bEntity)  //Entity
		
		$eRawMaterialsLocation:=New object:C1471()
		$esRawMaterialsLocations:=New object:C1471()
		
		$oConfirm:=New object:C1471()
		$oAlertRawMtrlLctn:=New object:C1471()
		$oAlertPurchaseOrder:=New object:C1471()
		
		$eRawMatlTrns:=$1
		
		$tLocation:="Roanoke"
		$dXferDate:=4D_Current_date
		$rQuantity:=Abs:C99($eRawMatlTrns.Qty)
		$tpk_id:=$eRawMatlTrns.pk_id
		$tPOItemKey:=$eRawMatlTrns.POItemKey
		
		$tCost:=" with cost"
		
		$tTableName:=Table name:C256(->[Raw_Materials_Locations:25])
		
		$tQuery:=\
			"Location = "+$tLocation+" and "+\
			"POItemKey = "+$eRawMatlTrns.POItemKey+" and "+\
			"ActCost = "+String:C10($eRawMatlTrns.ActCost)
		
		$oConfirm.tMessage:="Do you want to remove the cold foil?"
		$oConfirm.tDefault:="No"
		$oConfirm.tCancel:="Remove"
		
		$oAlertRawMtrlLctn.tMessage:="No [Raw_Materials_Locations] record found."
		$oAlertPurchaseOrder.tMessage:="The PO and Raw Material is not present please contact aMs User Support."
		
		$bRemove:=False:C215
		
		If ((Core_Dialog_ConfirmN($oConfirm)=CoreknCancel))  //Query
			
			$esRawMaterialsLocations:=ds:C1482[$tTableName].query($tQuery)
			$bRemove:=True:C214
			
		End if   //Done query
		
	End if   //Done entity
	
End if   //Done initialize

Case of   //Remove
		
	: (Not:C34($bEntity))  //No entity
		
		Core_Dialog_Alert($oAlertEntity)
		
	: (Not:C34($bRemove))  //Cancelled remove
		
	: ($esRawMaterialsLocations.length#1)
		
		Core_Dialog_Alert($oAlertRawMtrlLctn)
		
	: (Not:C34(PO_RwMt_ExistsB(->$tPOItemKey; $eRawMatlTrns.Raw_Matl_Code)))  //PO and Raw_Matl_Code does not exist
		
		Core_Dialog_Alert($oAlertPurchaseOrder)
		
	: ($esRawMaterialsLocations.length=1)
		
		UNLOAD RECORD:C212([Raw_Materials_Transactions:23])
		
		$eRawMatlTrns:=ds:C1482.Raw_Materials_Transactions.query("pk_id = :1"; $tpk_id).first()
		
		$eRawMatlTrns.Xfer_Type:="ADJUST"
		$eRawMatlTrns.XferDate:=$dXferDate
		$eRawMatlTrns.Sequence:=0
		$eRawMatlTrns.Location:=$tLocation
		$eRawMatlTrns.Qty:=$rQuantity
		$eRawMatlTrns.ActCost:=POIpriceToCost
		$eRawMatlTrns.ReferenceNo:="costed"
		$eRawMatlTrns.ActExtCost:=Round:C94($rQuantity*$eRawMatlTrns.ActCost; 2)
		$eRawMatlTrns.zCount:=-1
		$eRawMatlTrns.ModDate:=$dXferDate
		$eRawMatlTrns.ModWho:=<>zResp
		$eRawMatlTrns.Reason:="REVERSED"
		$eRawMatlTrns.consignment:=False:C215
		
		$eRawMaterialsLocation:=$esRawMaterialsLocations.first()
		
		$eRawMaterialsLocation.QtyOH:=$eRawMaterialsLocation.QtyOH+$eRawMatlTrns.Qty
		$eRawMaterialsLocation.QtyAvailable:=$eRawMaterialsLocation.QtyAvailable+$eRawMatlTrns.Qty
		$eRawMaterialsLocation.ModDate:=$dXferDate
		$eRawMaterialsLocation.ModWho:=<>zResp
		
		$oSaveResult:=$eRawMatlTrns.save()
		
		$oSaveResult:=$eRawMaterialsLocation.save()
		
		RM_ColdFoilFill(CorektPhaseAssignVariable)
		
End case   //Done remove
