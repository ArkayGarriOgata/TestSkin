// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/07/06, 17:08:32
// ----------------------------------------------------
// Object Method: [Estimates_DifferentialsForms].Input.Tab Control2
// SetObjectProperties, Mark Zinke (5/16/13)
// ----------------------------------------------------

C_LONGINT:C283($itemRef)
C_TEXT:C284($targetPage)

GET LIST ITEM:C378(iTabControlSub; *; $itemRef; $targetPage)

Case of 
	: ($targetPage="Form Details")
		QUERY:C277([Estimates_FormCartons:48]; [Estimates_FormCartons:48]DiffFormID:2=[Estimates_DifferentialsForms:47]DiffFormId:3)
		r1:=Sum:C1([Estimates_FormCartons:48]FormWantQty:9)  //3/15/95 upr 66
		r2:=Sum:C1([Estimates_FormCartons:48]MakesQty:5)
		ORDER BY:C49([Estimates_FormCartons:48]; [Estimates_FormCartons:48]ItemNumber:3; >)
		
	: ($targetPage="Machines & Materials")
		If (testRestrictions)
			SetObjectProperties("estOnly@"; -><>NULL; False:C215)
		Else 
			SetObjectProperties("estOnly@"; -><>NULL; True:C214)
			Mat_viaForm:=True:C214  //tells material delete procedure how to restore correct selection of material rec
			QUERY:C277([Estimates_Machines:20]; [Estimates_Machines:20]DiffFormID:1=[Estimates_DifferentialsForms:47]DiffFormId:3)
			ORDER BY:C49([Estimates_Machines:20]; [Estimates_Machines:20]Sequence:5; >)
			QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]DiffFormID:1=[Estimates_DifferentialsForms:47]DiffFormId:3)
			ORDER BY:C49([Estimates_Materials:29]; [Estimates_Materials:29]Sequence:12; >)
			COPY NAMED SELECTION:C331([Estimates_Materials:29]; "materialsOnForm")  //use when returning from a form
		End if 
		
End case 