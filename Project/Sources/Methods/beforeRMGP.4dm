//%attributes = {"publishedWeb":true}
//(P) beforeRMGP: before phase processing for [RM_GROUP]

fRMGPMaint:=True:C214
wWindowTitle("push"; "Commodity "+[Raw_Materials_Groups:22]Commodity_Key:3)
sSetGrpFlex([Raw_Materials_Groups:22]Commodity_Code:1)
sRMGPAction:=fGetMode(iMode)
If (Record number:C243([Raw_Materials_Groups:22])=-3)
	[Raw_Materials_Groups:22]ModDate:6:=4D_Current_date
	[Raw_Materials_Groups:22]ModWho:7:=<>zResp
End if 
rbType1:=0
rbType2:=0
rbType3:=0
Case of 
	: ([Raw_Materials_Groups:22]ReceiptType:13=1)
		rbType1:=1
	: ([Raw_Materials_Groups:22]ReceiptType:13=2)
		rbType2:=1
	: ([Raw_Materials_Groups:22]ReceiptType:13=3)
		rbType3:=1
End case 
If (iMode#2)
	OBJECT SET ENABLED:C1123(bDelete; False:C215)
End if 
If (iMode=3)
	OBJECT SET ENABLED:C1123(bAcceptRec; False:C215)
	OBJECT SET ENABLED:C1123(rbType1; False:C215)
	OBJECT SET ENABLED:C1123(rbType2; False:C215)
	OBJECT SET ENABLED:C1123(rbType3; False:C215)
End if 

RELATE MANY:C262([Raw_Materials_Groups:22]Commodity_Key:3)
ORDER BY:C49([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1; >)
ORDER BY:C49([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]PoItemDate:40; <)