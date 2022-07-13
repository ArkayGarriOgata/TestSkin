//%attributes = {}
//Method:  RmTr_Foil_Remove(eRawMatlTrns)
//Description:  This method will remove the cold foil

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $eRawMatlTrns)
	
	C_OBJECT:C1216($eRawMatlTrnsSave)
	C_OBJECT:C1216($eRawMaterialsLocation)
	C_OBJECT:C1216($esRawMaterialsLocations)
	
	C_OBJECT:C1216($oRawMatlTrnsRemove)
	C_OBJECT:C1216($oAlertRawMtrlLctn)
	C_OBJECT:C1216($oAlertPurchaseOrder)
	C_OBJECT:C1216($oConfirm)
	
	C_TEXT:C284($tJobForm; $tLocation)
	C_TEXT:C284($tCost)
	C_TEXT:C284($tQuery; $tTableName)
	
	C_DATE:C307($dXferDate)
	C_REAL:C285($rQuantity)
	
	$eRawMatlTrnsSave:=ds:C1482.Raw_Materials_Transactions.new()
	$eRawMaterialsLocation:=New object:C1471()
	$esRawMaterialsLocations:=New object:C1471()
	
	$oRawMatlTrnsRemove:=New object:C1471()
	$oConfirm:=New object:C1471()
	$oAlertRawMtrlLctn:=New object:C1471()
	$oAlertPurchaseOrder:=New object:C1471()
	
	$eRawMatlTrns:=$1
	
	$tLocation:="Roanoke"
	$dXferDate:=4D_Current_date
	$rQuantity:=Abs:C99($eRawMatlTrns.Qty)
	
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
	$oAlertPurchaseOrder.tMessage:="The PO is not present please contact aMs User Support."
	
End if   //Done initialize

$esRawMaterialsLocations:=ds:C1482[$tTableName].query($tQuery)

Case of   //Remove
		
	: ($esRawMaterialsLocations.length<1)
		
		Core_Dialog_Alert($oAlertRawMtrlLctn)
		
	: (Not:C34(PO_RwMt_ExistsB($eRawMatlTrns.POItemKey)))  //PO Exists
		
		Core_Dialog_Alert($oAlertPurchaseOrder)
		
		[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=sCriterion1
		[Raw_Materials_Transactions:23]UnitPrice:7:=[Raw_Materials:21]LastPurCost:43
		[Raw_Materials_Transactions:23]ActCost:9:=uNANCheck([Raw_Materials:21]ActCost:45)
		//[RM_XFER]ActExtCost:=Round(rReal1*[RM_XFER]ActCost;2)`•3/4/97 cs upr 1858
		[Raw_Materials_Transactions:23]ActExtCost:10:=uNANCheck(Round:C94($AdjustQty*[Raw_Materials_Transactions:23]ActCost:9; 2))  //•3/4/97 cs upr 1858 use adjustment qty instead of entered value
		//• upr 0235 1/2/97
		[Raw_Materials_Transactions:23]Location:15:=sCriterion3
		[Raw_Materials_Transactions:23]DepartmentID:21:=[Raw_Materials:21]DepartmentID:28  //assumed (as above use Raw Mat with no PO_Item)
		[Raw_Materials_Transactions:23]ExpenseCode:26:=RMG_getExpenseCode([Raw_Materials:21]Commodity_Key:2; "hold")  //[Raw_Materials]Obsolete_ExpCode
		
		Case of 
			: ([Raw_Materials_Transactions:23]Location:15="R@")  //Roanoke
				[Raw_Materials_Transactions:23]CompanyID:20:="2"
			: ([Raw_Materials_Transactions:23]Location:15="L@")  //labels
				[Raw_Materials_Transactions:23]CompanyID:20:="3"
			Else   //arkay
				[Raw_Materials_Transactions:23]CompanyID:20:="1"
		End case 
		//end upr 0235
		
	: (Core_Dialog_ConfirmN($oConfirm)=CoreknCancel)
		
		$oRawMatlTrnsRemove:=$eRawMatlTrns.toObject()  //New
		
		$oRawMatlTrnsRemove.pk_id:=Generate UUID:C1066
		$oRawMatlTrnsRemove.Xfer_Type:="Issue"
		$oRawMatlTrnsRemove.XferDate:=$dXferDate
		$oRawMatlTrnsRemove.Sequence:=0
		$oRawMatlTrnsRemove.Location:=$tLocation
		$oRawMatlTrnsRemove.Qty:=$rQuantity
		$oRawMatlTrnsRemove.ActCost:=POIpriceToCost
		$oRawMatlTrnsRemove.ReferenceNo:="costed"
		$oRawMatlTrnsRemove.ActExtCost:=Round:C94($rQuantity*$oRawMatlTrnsRemove.ActCost; 2)
		$oRawMatlTrnsRemove.zCount:=-1
		$oRawMatlTrnsRemove.ModDate:=$dXferDate
		$oRawMatlTrnsRemove.ModWho:=<>zResp
		$oRawMatlTrnsRemove.Reason:="REVERSED"
		$oRawMatlTrnsRemove.consignment:=False:C215
		
		$eRawMaterialsLocation:=$esRawMaterialsLocations.first()
		
		$eRawMaterialsLocation.QtyOH:=$eRawMaterialsLocation.QtyOH+$oRawMatlTrnsRemove.Qty
		$eRawMaterialsLocation.QtyAvailable:=$eRawMaterialsLocation.QtyAvailable+$oRawMatlTrnsRemove.Qty
		$eRawMaterialsLocation.ModDate:=$dXferDate
		$eRawMaterialsLocation.ModWho:=<>zResp
		
		$eRawMatlTrnsSave.fromObject($oRawMatlTrnsRemove)
		
		$oSaveResult:=$eRawMatlTrnsSave.save()
		
		$oSaveResult:=$eRawMaterialsLocation.save()
		
End case   //Done remove
