Case of 
	: (Form event code:C388=On Load:K2:1)
		OBJECT SET ENABLED:C1123(bInvoice; False:C215)
		iitotal1:=0
		If (Size of array:C274(PickListBox)=0)  // Added by: Mark Zinke (11/21/12)
			OBJECT SET ENABLED:C1123(bPrintTop; False:C215)
		End if 
		OBJECT SET ENABLED:C1123(bPrintDetail; False:C215)  // Added by: Mark Zinke (11/21/12)
		
	: (Form event code:C388=On Outside Call:K2:11)
		$hit:=Find in array:C230(aGCAST; <>rama_cpn)
		If ($hit>-1) & ($hit<=LISTBOX Get number of rows:C915(PickListBox))
			LISTBOX SELECT ROW:C912(PickListBox; $hit; lk replace selection:K53:1)
			OBJECT SET SCROLL POSITION:C906(PickListBox; $hit)
			
		Else 
			LISTBOX SELECT ROW:C912(PickListBox; 0; lk replace selection:K53:1)
		End if 
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
		
End case 