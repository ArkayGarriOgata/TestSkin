//%attributes = {"publishedWeb":true}
//gRMBinUpdate: Update Raw Material Bin
//mod 9/14/94
//10/13/94 delete if qty=0
//10/26/94 use fLockNLoad correctly
//$1 longint - index into arrays
//•1/13/97 upr 0235 -cs- some receiving records are not geting companyid correctly
//  $2 - (Optional) charge code
//•1/16/97 upr 0235 -cs-removed 2nd parameter, proccessing of extra
//•2/13/97 cs onsite allow user to change location with out change to company
//  parameter caused errors in company id assignments
//• 1/28/98 cs  try to stop NANs
//• mlb - 2/5/03  16:44 handle consignments

C_LONGINT:C283($1)
C_TEXT:C284($2; $3)  //•1/13/97 upr 0235 

fLockNLoad(->[Raw_Materials_Locations:25])
uCancelTran
If (Not:C34(fCnclTrn))
	aRMPOQty{$1}:=uNANCheck(aRMPOQty{$1})  //• 1/28/98 cs check value for a NAN
	
	If (aRMType{$1}="Receipt")
		//[RM_BINS]ActCost:=((aRMSTKQty{$1}*aRMStdPrice{$1})+([RM_BINS]QtyOH*[RM_BINS]ActC
		// /(aRMPOQty{$1}+[RM_BINS]QtyOH)` changed to last cost received `mod 9/14/94
		[Raw_Materials_Locations:25]ActCost:18:=uNANCheck(aRMStdPrice{$1})
		If (Not:C34([Purchase_Orders_Items:12]Consignment:49))  //• mlb - 2/5/03  16:18
			[Raw_Materials_Locations:25]QtyOH:9:=[Raw_Materials_Locations:25]QtyOH:9+aRMSTKQty{$1}  //+aRMPOQty{$1} was here `mod 9/14/94
			[Raw_Materials_Locations:25]QtyAvailable:13:=[Raw_Materials_Locations:25]QtyAvailable:13+aRMSTKQty{$1}
		Else 
			[Raw_Materials_Locations:25]ConsignmentQty:26:=[Raw_Materials_Locations:25]ConsignmentQty:26+aRMSTKQty{$1}
		End if 
		
	End if 
	
	If (aRMType{$1}="Issue")
		If (Not:C34([Purchase_Orders_Items:12]Consignment:49)) | (Records in selection:C76([Purchase_Orders_Items:12])=0)  //• mlb - 2/5/03  16:18
			[Raw_Materials_Locations:25]QtyOH:9:=[Raw_Materials_Locations:25]QtyOH:9-aRMPOQty{$1}
			[Raw_Materials_Locations:25]QtyAvailable:13:=[Raw_Materials_Locations:25]QtyAvailable:13-aRMPOQty{$1}
			[Raw_Materials_Locations:25]QtyCommitted:11:=[Raw_Materials_Locations:25]QtyCommitted:11+aRMPOQty{$1}
			
		Else 
			Case of 
				: ([Raw_Materials_Locations:25]QtyOH:9>=aRMPOQty{$1})
					[Raw_Materials_Locations:25]QtyOH:9:=[Raw_Materials_Locations:25]QtyOH:9-aRMPOQty{$1}
					[Raw_Materials_Locations:25]QtyAvailable:13:=[Raw_Materials_Locations:25]QtyAvailable:13-aRMPOQty{$1}
					[Raw_Materials_Locations:25]QtyCommitted:11:=[Raw_Materials_Locations:25]QtyCommitted:11+aRMPOQty{$1}
				: ([Raw_Materials_Locations:25]QtyOH:9>=0)
					$onHand:=[Raw_Materials_Locations:25]QtyOH:9
					[Raw_Materials_Locations:25]QtyOH:9:=0
					[Raw_Materials_Locations:25]ConsignmentQty:26:=[Raw_Materials_Locations:25]ConsignmentQty:26-(aRMPOQty{$1}-$onHand)
				Else 
					[Raw_Materials_Locations:25]ConsignmentQty:26:=[Raw_Materials_Locations:25]ConsignmentQty:26-aRMPOQty{$1}
			End case 
		End if 
	End if 
	
	[Raw_Materials_Locations:25]CompanyID:27:=ChrgCodeFrmLoc(aRMBinNo{$1})
	[Raw_Materials_Locations:25]ModDate:21:=4D_Current_date
	[Raw_Materials_Locations:25]ModWho:22:=<>zResp
	SAVE RECORD:C53([Raw_Materials_Locations:25])
	
	If ([Raw_Materials_Locations:25]QtyOH:9=0) & (Not:C34([Raw_Materials_Locations:25]PiDoNotDelete:24)) & ([Raw_Materials_Locations:25]ConsignmentQty:26=0)  //• mlb - 2/5/03  16:43
		DELETE RECORD:C58([Raw_Materials_Locations:25])
	Else 
		UNLOAD RECORD:C212([Raw_Materials_Locations:25])
	End if 
End if 