// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 05/13/13, 14:49:13
// ----------------------------------------------------
// Form Method: [Raw_Materials].POArray
// Description:
//• 1/13/97 upr 0235 modification to better select a default location
//•2/13/97 cs  on iste change to allow user to change locatio with out changing co
//• 12/10/97 cs setup to allow bar code label printing
//• 5/12/98 cs limmt acces to chnagin receipt date (AT ALL) to Cost Acct
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		oldway:=1
		
		If (startFresh)
			C_REAL:C285(<>RMPOICount)  //• 12/10/97 cs used for printing Bar code labels based on selected item
			C_TEXT:C284(<>RMBarCodePO)
			sType:="Receipt"
			gClrRMFields
			POI_ItemsToReceive(0)
			POI_ItemsToPost(0)
			
			OBJECT SET ENABLED:C1123(bPost; False:C215)
			OBJECT SET ENABLED:C1123(bRemove; False:C215)
			OBJECT SET ENABLED:C1123(bQuote; False:C215)
			dDate:=4D_Current_date
			
			If (User in group:C338(Current user:C182; "CostAcctDateAccess"))  //• 5/12/98 cs limmt acces to chnagin receipt date (AT ALL) to Cost Acct
				SetObjectProperties(""; ->dDate; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
			Else 
				SetObjectProperties(""; ->dDate; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
			End if 
			
			$bins:=SupplyChain_BinManager("collect-bins")
			
		Else 
			numToPost:=Size of array:C274(aRMPONum)
			If (numToPost>0)
				OBJECT SET ENABLED:C1123(bPost; True:C214)
				OBJECT SET ENABLED:C1123(bRemove; True:C214)
				OBJECT SET ENABLED:C1123(bQuote; True:C214)
				SetObjectProperties(""; ->bCancel; True:C214; "VOID RECEIPTS")  // Modified by: Mark Zinke (5/13/13)
			Else 
				OBJECT SET ENABLED:C1123(bPost; False:C215)
				OBJECT SET ENABLED:C1123(bRemove; False:C215)
				OBJECT SET ENABLED:C1123(bQuote; False:C215)
				SetObjectProperties(""; ->bCancel; True:C214; "Done")  // Modified by: Mark Zinke (5/13/13)
			End if 
		End if 
		
	: (Form event code:C388=On Close Box:K2:21)  //POI_ItemsToPost (aRMPONum;"Delete")
		startFresh:=True:C214
		$pendingReceipts:=Size of array:C274(aRMPONum)
		If ($pendingReceipts>0)
			uConfirm("Ignor the "+String:C10($pendingReceipts)+" items that are ready to Post?"; "Go Back"; "Ignor")
			If (OK=1)
				startFresh:=False:C215
				CANCEL:C270  //but stay in the loop with arrays intact
			Else 
				CANCEL:C270
				bCancel:=1
			End if 
			
		Else   //just bail
			CANCEL:C270
			bCancel:=1
		End if 
		
	: (Form event code:C388=On Unload:K2:2)
		If (startFresh)
			$pendingReceipts:=Size of array:C274(aRMPONum)
			For ($rcn; $pendingReceipts; 1; -1)
				POI_ItemsToPost($rcn; "Delete")
			End for 
			
			POI_ItemsToReceive(0)
			POI_ItemsToPost(0)  //redundant
			<>RMBarCodePO:=""
			<>RMPOICount:=0
			
		Else   //we're coming back
			//leave the arrays intact
		End if 
End case 