//%attributes = {"publishedWeb":true}
//(p)  RM_validBinLocation: Check for Valid Bin Number and Raw Material Cade.

QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=sRMCode; *)
QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]Location:2=sBinNO)

If (Records in selection:C76([Raw_Materials_Locations:25])>0)
	SetObjectProperties(""; ->sPONo; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/9/13)
	sBinPO:=""
	rQty:=0
	
Else 
	If (<>fRestrictRM) & (<>fRestrictJO)
		BEEP:C151
		ALERT:C41("Bin "+sBinNO+" does not exist for this Raw Material. "+<>sCR+<>sCR+"Enter a Bin No. from Bin Table.")
		sBinNo:=""
		GOTO OBJECT:C206(sBinNO)
		
	Else 
		BEEP:C151
		ALERT:C41("Bin "+sBinNO+" not on file for this Raw Material!"+<>sCR+<>sCR+"Please verify.")
		SetObjectProperties(""; ->sPONo; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/9/13)
	End if 
End if 