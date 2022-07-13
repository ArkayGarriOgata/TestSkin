//%attributes = {}

// Method: RMSV_setRMCvpn (rm_code;vpn )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 03/03/15, 15:09:49
// ----------------------------------------------------
// Description
// 
//
// ----------------------------------------------------

If (Length:C16($1)>0)
	[Raw_Materials_Suggest_Vendors:173]Raw_Matl_Code:2:=$1
End if 
If (Length:C16($2)>0)
	[Raw_Materials_Suggest_Vendors:173]VendorPartNumber:3:=$2
End if 