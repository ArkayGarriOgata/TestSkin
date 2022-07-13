//%attributes = {"publishedWeb":true}
//(P) beforeRMIS: before phase processing for [RM_XFER]

fRMISMaint:=True:C214
If ([Raw_Materials_Transactions:23]Raw_Matl_Code:1="")
	sRMISAction:="NEW"
	[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=[Raw_Materials:21]Raw_Matl_Code:1
	GOTO OBJECT:C206([Raw_Materials_Transactions:23]JobForm:12)
	ALERT:C41("Issue Records must be entered through Issue Button on Control Screen.")
	CANCEL:C270
Else 
	sRMISAction:=fGetMode(iMode)
End if 
If (iMode#2)
	OBJECT SET ENABLED:C1123(bDelete; False:C215)
End if 
If (iMode=3)
	OBJECT SET ENABLED:C1123(bAcceptRec; False:C215)
End if 