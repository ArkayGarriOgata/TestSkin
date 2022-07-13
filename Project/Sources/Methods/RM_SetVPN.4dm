//%attributes = {"publishedWeb":true}
//PM: RM_SetVPN() -> 
//@author mlb - 6/18/02  16:39

C_LONGINT:C283($1)
C_TEXT:C284($rmCode)

If (Count parameters:C259=0)
	$id:=New process:C317("RM_SetVPN"; <>lMinMemPart; "RM_SetVPN"; 2)
	If (False:C215)
		RM_SetVPN
	End if 
	
Else 
	$rmCode:=Request:C163("What is the Arkay Raw Material Code?")
	If (OK=1)
		READ WRITE:C146([Raw_Materials:21])
		QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=$rmCode)
		If (Records in selection:C76([Raw_Materials:21])=1)
			If (fLockNLoad(->[Raw_Materials:21]))
				zwStatusMsg("HINT"; "Enter the Vendor Part Number for Arkay's "+$rmCode+" Raw Material Code")
				$vpn:=Request:C163("What is the current VPN for "+$rmCode+"?")
				If (OK=1)
					[Raw_Materials:21]VendorPartNum:3:=fStripSpace("B"; $vpn)
					SAVE RECORD:C53([Raw_Materials:21])
					zwStatusMsg("Success"; "R/M: "+$rmCode+" VPN set to "+[Raw_Materials:21]VendorPartNum:3)
					REDUCE SELECTION:C351([Raw_Materials:21]; 0)
				End if 
			End if 
			
		Else 
			BEEP:C151
			ALERT:C41($rmCode+" was not found.")
		End if 
	End if 
End if 