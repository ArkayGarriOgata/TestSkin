// Method: Object Method: aPath () -> 

// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		If (aPath#0)  //selected something
			
			OBJECT SET ENABLED:C1123(*; "selected@"; True:C214)
			zwStatusMsg("OPEN"; aPath{aPath})
		Else 
			OBJECT SET ENABLED:C1123(*; "selected@"; False:C215)
			zwStatusMsg("SELECT"; "Click on a document to open.")
		End if 
		
	: (Form event code:C388=On Load:K2:1)
		If (Size of array:C274(aPath)>0)
			aPath:=1  //preselect the first element
			
			OBJECT SET ENABLED:C1123(*; "selected@"; True:C214)
			zwStatusMsg("OPEN"; aPath{aPath})
		Else 
			OBJECT SET ENABLED:C1123(*; "selected@"; False:C215)
			zwStatusMsg("LINK"; "Click the New button to link a document to this record.")
		End if 
End case 
