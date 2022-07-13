//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 04/02/10, 09:50:26
// ----------------------------------------------------
// Method: Ink_get_cost
// Description
// return the [Raw_Materials]ActCost if the sap vendor code is specified
// sap numbers are 7-4 like 1234567-1234
// ----------------------------------------------------

C_TEXT:C284($rm_code; $1)
C_BOOLEAN:C305($searched)
C_REAL:C285($0)

$searched:=False:C215
$0:=0

If (Length:C16($1)>0) & (<>Use_SAP_ink_price)  //don't activate yet
	If ([Raw_Materials:21]Raw_Matl_Code:1#$1)
		READ ONLY:C145([Raw_Materials:21])
		QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=$1)
		$searched:=True:C214
	End if   //not already current rm
	
	If (Records in selection:C76([Raw_Materials:21])>0)
		If ([Raw_Materials:21]ActCost:45#0)
			//look for sap style #######-####  (7 hyphen 4)
			If (Length:C16([Raw_Materials:21]VendorPartNum:3)=12) & (Position:C15("-"; [Raw_Materials:21]VendorPartNum:3)=8)
				$0:=[Raw_Materials:21]ActCost:45
			End if 
		End if 
	End if 
	
	If ($searched)
		REDUCE SELECTION:C351([Raw_Materials:21]; 0)
	End if 
End if 