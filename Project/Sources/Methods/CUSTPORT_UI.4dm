//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 10/22/10, 14:37:34
// ----------------------------------------------------
// Method: CUSTPORT_UI
// ----------------------------------------------------
//v1.0.3-PJK (2/26/20) rewrite for 4D hosted customer portal

C_TEXT:C284($1)
//ARRAY BOOLEAN(box2;0)
C_LONGINT:C283(lb_col; lb_row)

If (Count parameters:C259=0)
	$id:=New process:C317("CUSTPORT_UI"; <>lMinMemPart; "Customer Portal Setup"; "init")
	
Else 
	READ WRITE:C146([Customer_Portal_Extracts:158])
	
	
	$winRef:=Open form window:C675([Customer_Portal_Extracts:158]; "LoginList")  //v1.0.3-PJK (2/26/20)
	DIALOG:C40([Customer_Portal_Extracts:158]; "LoginList")  //v1.0.3-PJK (2/26/20)
	CLOSE WINDOW:C154($winRef)  //v1.0.3-PJK (2/26/20)
	
	
	
	If (False:C215)  //v1.0.3-PJK (2/26/20)
		//ALL RECORDS([Customer_Portal_Extracts])
		//ORDER BY([Customer_Portal_Extracts];[Customer_Portal_Extracts]CustId;>)
		//SELECTION TO ARRAY([Customer_Portal_Extracts]CustId;aCustID)
		
		//$winRef:=Open form window([Customer_Portal_Extracts];"ListBox")
		//DIALOG([Customer_Portal_Extracts];"ListBox")
		//CLOSE WINDOW($winRef)
	End if 
	
	
End if 

