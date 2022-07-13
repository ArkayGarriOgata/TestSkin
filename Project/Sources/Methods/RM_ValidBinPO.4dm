//%attributes = {"publishedWeb":true}
//RM_ValidBinPO: Check for Valid Bin Number and Raw Material Cade.

C_LONGINT:C283($j)

QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=sRMCode; *)
QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]Location:2=sBinNO; *)
QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]POItemKey:19=sPONo)

If (Records in selection:C76([Raw_Materials_Locations:25])>0)
	SetObjectProperties(""; ->rQty; True:C214; ""; True:C214)  // Added by: Mark Zinke (5/9/13)
	$j:=Find in array:C230(asBinPO; sBinNo+(" "*(10-Length:C16(sBinNo)))+sPONo)
	If ($j>0)
		If (asQty{$j}>0)
			rQty:=0  //Melissa wants it deflated to 0      
			//rQty:=asQty{$j}
		End if 
	End if 
	
Else 
	If (<>fRestrictRM) & (<>fRestrictJO)
		BEEP:C151
		ALERT:C41("PO "+sPONo+" does not exist for this Raw Material and Bin.")
		sPONo:=""
		GOTO OBJECT:C206(sPONo)
		
	Else 
		BEEP:C151
		ALERT:C41("PO "+sPONo+" not on file for this Raw Material and Bin!"+<>sCR+<>sCR+"Please verify.")
		SetObjectProperties(""; ->rQty; True:C214; ""; True:C214)  // Added by: Mark Zinke (5/9/13)
	End if 
End if 