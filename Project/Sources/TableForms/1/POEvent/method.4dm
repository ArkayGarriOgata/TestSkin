//(lp)POEvent
//• 11/13/97 cs added laser po report
If (Form event code:C388=On Load:K2:1)
	OBJECT SET ENABLED:C1123(ibNew; False:C215)
	OBJECT SET ENABLED:C1123(ibMod; False:C215)
	OBJECT SET ENABLED:C1123(ibDel; False:C215)
	OBJECT SET ENABLED:C1123(ibCopy; False:C215)
	OBJECT SET ENABLED:C1123(bRmCleanup; False:C215)
	OBJECT SET ENABLED:C1123(bCombine; False:C215)
	OBJECT SET ENABLED:C1123(bApprovePO; False:C215)
	OBJECT SET ENABLED:C1123(bToOrder; False:C215)
	OBJECT SET ENABLED:C1123(bAccruals; False:C215)
	
	If (User in group:C338(Current user:C182; "Purchasing Modify"))
		OBJECT SET ENABLED:C1123(ibNew; True:C214)
		OBJECT SET ENABLED:C1123(ibMod; True:C214)
		OBJECT SET ENABLED:C1123(ibDel; True:C214)
		OBJECT SET ENABLED:C1123(ibCopy; True:C214)
		OBJECT SET ENABLED:C1123(bRmCleanup; True:C214)
		OBJECT SET ENABLED:C1123(bCombine; True:C214)
		OBJECT SET ENABLED:C1123(bApprovePO; True:C214)
		OBJECT SET ENABLED:C1123(bToOrder; True:C214)
	End if 
	
	If (User in group:C338(Current user:C182; "RoleAccounting"))
		OBJECT SET ENABLED:C1123(bAccruals; True:C214)
	End if 
	
	If (Size of array:C274(<>aPORptPop)=0)
		ARRAY TEXT:C222(<>aPORptPop; 10)
		<>aPORptPop{1}:="Purchase Order"
		<>aPORptPop{2}:="PO Status"
		<>aPORptPop{3}:="PO Listing"
		<>aPORptPop{4}:="-"
		<>aPORptPop{5}:="Open PO Items"
		<>aPoRptPop{6}:="Ven Sum Report"
		<>aPoRptPop{7}:="Dept Sum Report"
		<>aPORptPop{8}:="-"
		<>aPORptPop{9}:="Short Lead Times"
		<>aPORptPop{10}:="Last Week's POs"
		
		<>aPORptPopMenu:=<>aPORptPop{1}
		For ($i; 2; Size of array:C274(<>aPORptPop))
			If (Substring:C12(<>aPORptPop{$i}; 1; 1)="-")
				<>aPORptPopMenu:=<>aPORptPopMenu+";("+<>aPORptPop{$i}
			Else 
				<>aPORptPopMenu:=<>aPORptPopMenu+";"+<>aPORptPop{$i}
			End if 
		End for 
	End if 
	
	If (<>bButtons)  // Added by: Mark Zinke (2/8/13)
		FORM GOTO PAGE:C247(2)
		GET WINDOW RECT:C443($xlLeft; $xlTop; $xlRight; $xlBottom)
		SET WINDOW RECT:C444($xlLeft; $xlTop; $xlRight; $xlBottom-10)
	End if 
End if 