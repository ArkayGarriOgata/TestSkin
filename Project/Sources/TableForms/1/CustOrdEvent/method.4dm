// ----------------------------------------------------
// Method: [zz_control].CustOrdEvent
// ----------------------------------------------------
// Modified by: Mel Bohince (11/24/21) moved ytd billings to btn

If (Form event code:C388=On Load:K2:1)
	If (Size of array:C274(<>aCORptPop)=0) | (True:C214)
		ARRAY TEXT:C222(<>aCORptPop; 11)
		<>aCORptPop{1}:="Cust_Order"
		<>aCORptPop{2}:="Change Order"
		<>aCORptPop{3}:="Change History"
		<>aCORptPop{4}:="Expirations"
		<>aCORptPop{5}:="Shortage Report"
		<>aCORptPop{6}:="Production Activity"
		<>aCORptPop{7}:="Preparatory Activity"
		<>aCORptPop{8}:="Spcl Bilng Exceptions"  //upr 1444
		<>aCORptPop{9}:="Prep Billing Summary"
		<>aCORptPop{10}:="Open Order Backlog"
		<>aCORptPop{11}:="No Cost Order Lines"
		
		<>aCORptPopMenu:=<>aCORptPop{1}
		For ($i; 2; Size of array:C274(<>aCORptPop))
			If (Substring:C12(<>aCORptPop{$i}; 1; 1)="-")
				<>aCORptPopMenu:=<>aCORptPopMenu+";("+<>aCORptPop{$i}
			Else 
				<>aCORptPopMenu:=<>aCORptPopMenu+";"+<>aCORptPop{$i}
			End if 
		End for 
		
	End if 
	
	If (Current user:C182="Designer")  // Modified by: Mel Bohince (8/18/21) 
		OBJECT SET ENABLED:C1123(ibDel; True:C214)
	Else 
		OBJECT SET ENABLED:C1123(ibDel; False:C215)
	End if 
	
	
	If (<>bButtons)  // Added by: Mark Zinke (2/6/13)
		FORM GOTO PAGE:C247(2)
	End if 
End if 