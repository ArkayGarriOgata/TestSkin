If (Form event code:C388=On Load:K2:1)
	OBJECT SET ENABLED:C1123(*; "btn@"; False:C215)
	
	If (User in group:C338(Current user:C182; "Addresses"))
		OBJECT SET ENABLED:C1123(*; "btnAdd@"; True:C214)
	End if 
	
	If (User in group:C338(Current user:C182; "Contacts"))
		OBJECT SET ENABLED:C1123(*; "btnCon@"; True:C214)
	End if 
	
	If (User in group:C338(Current user:C182; "Vendors"))
		OBJECT SET ENABLED:C1123(*; "btnVen@"; True:C214)
		If (Size of array:C274(<>aVenRptPop)=0)
			ARRAY TEXT:C222(<>aVenRptPop; 3)
			<>aVenRptPop{1}:="Vendor Listing"
			<>aVenRptPop{2}:="Performance"
			<>aVenRptPop{3}:="Outstanding POs"
			
		End if 
	Else 
		ARRAY TEXT:C222(<>aVenRptPop; 0)
	End if 
	
	If (<>bButtons)  // Added by: Mark Zinke (2/6/13)
		FORM GOTO PAGE:C247(2)
		GET WINDOW RECT:C443($xlLeft; $xlTop; $xlRight; $xlBottom)
		SET WINDOW RECT:C444($xlLeft; $xlTop; $xlRight; $xlBottom)
	End if 
End if 