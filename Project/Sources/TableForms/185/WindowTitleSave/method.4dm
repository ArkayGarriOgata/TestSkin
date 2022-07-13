// ----------------------------------------------------
// Form Method: [WindowSets].WindowTitleSave
// SetObjectProperties, Mark Zinke (5/17/13)
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		C_BOOLEAN:C305(bSaveFunction)
		
		If ((bSaveFunction))
			SetObjectProperties("SaveFunction@"; -><>NULL; True:C214)
			SetObjectProperties(""; ->bRestoreFunction; False:C215)
			LISTBOX SET COLUMN WIDTH:C833(*; "atWindowSets"; 277)
			
		Else 
			SetObjectProperties("RestoreFunction@"; -><>NULL; True:C214)
			LISTBOX DELETE COLUMN:C830(bWindowNames; 1)
			LISTBOX SET COLUMN WIDTH:C833(*; "atWindowSets"; 337)
			
		End if 
		
		SORT ARRAY:C229(atWindowSets; abDefault; asUUID; >)
		OBJECT SET ENABLED:C1123(bOK; False:C215)
		LISTBOX SELECT ROW:C912(bWindowNames; 0; lk remove from selection:K53:3)
End case 