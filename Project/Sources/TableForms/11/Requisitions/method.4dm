//(lp) [Purchase orders]Requisitions
//• 8/20/97 cs stop ability to delete

Case of 
	: (Form event code:C388=On Load:K2:1)
		beforePOasRequisition
		
	: (Form event code:C388=On Timer:K2:25)
		Case of 
			: (FORM Get current page:C276=2)
				$numSubRecs:=util_getTheSelectedRecordInList(->[Purchase_Orders_Items:12]; ->bOpenAddress; "Item"; "Items")
				If ($numSubRecs>0) & (iMode<=2)
					OBJECT SET ENABLED:C1123(bdelRel1; True:C214)
				End if 
		End case 
		
	: (Form event code:C388=On Close Box:K2:21)
		bDone:=1
		CANCEL:C270
		
	: (Form event code:C388=On Validate:K2:3)
		AfterPO
		
	: (Form event code:C388=On Unload:K2:2)
		POEntryCleanUp
		
End case 
//EOLP