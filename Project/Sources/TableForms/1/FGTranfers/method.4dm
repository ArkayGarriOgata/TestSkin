// ----------------------------------------------------
// User name (OS): MLB
// Date: 091196
// ----------------------------------------------------
// Form Method: [zz_control].FGTranfers
// SetObjectProperties, Modified by: Mark Zinke (5/14/13)
// ----------------------------------------------------

If (Form event code:C388=On Load:K2:1)
	ARRAY TEXT:C222(asCriter2; 1)
	C_BOOLEAN:C305($reasonRequired)
	C_TEXT:C284(sCriterion7; sCriterion8; sCriterion9)  // somewhere criter9 was getting changed to an array
	sCriterion1:=""  //        cpn
	sCriterion2:="00000"  //custid
	rReal1:=0  //             qty
	sCriterion3:=""  //from
	sCriterion4:=""  //to
	sCriterion5:=""  //jobform
	tJobItNum:=""  // Added by: Mark Zinke (10/11/13) 
	sJobit:=""
	i1:=0  //                job item
	sCriterion6:=""  //orderline
	sCriterion7:=""  //reason comment
	sCriterion8:=""  //action taken
	sCriterion9:=""  //reason
	sCriter10:=<>zResp+fYYMMDD(Current date:C33; 4)+"-"+Replace string:C233(String:C10(Current time:C178; HH MM SS:K7:1); ":"; "")  //""  //   skid ticket
	
	sCriter11:=<>zResp  //user
	sCriter12:=""  //release
	asCriter2{1}:="00000"
	asCriter2:=1
	sCriterion2:=asCriter2{asCriter2}
	wms_number_cases:=0
	$reasonRequired:=wms_locationsRequiringReason
	
	tReason:="Last Skid for this Job Form Item?"  // Added by: Mark Zinke (10/11/13) 
	SetObjectProperties(""; ->sCriterion3; True:C214; ""; True:C214)
	SetObjectProperties(""; ->sCriterion4; True:C214; ""; True:C214)
	SetObjectProperties(""; ->sCriterion6; True:C214; ""; False:C215)
	SetObjectProperties(""; ->sCriterion7; True:C214; ""; False:C215)
	SetObjectProperties(""; ->sCriterion8; True:C214; ""; False:C215)
	SetObjectProperties(""; ->sCriterion9; True:C214; ""; False:C215)
	SetObjectProperties(""; ->sCriter12; True:C214; ""; False:C215)
	SetObjectProperties("Last@"; -><>NULL; False:C215)
	SetObjectProperties("Reason@"; -><>NULL; False:C215)
	bLastSkid1:=1
	bLastSkid2:=0
	
	Case of 
		: (iMode=0)  //a move
			sCriter10:=""
			ARRAY TEXT:C222(asFrom; 4)
			ARRAY TEXT:C222(asMove; 3)
			
			SetObjectProperties(""; ->bPost; True:C214; "Move")
			If (User in group:C338(Current user:C182; "Roanoke"))
				asFrom{1}:="CC:R"
				asFrom{2}:="Ex:R"
				asFrom{3}:="XC:R"
				asFrom{4}:="FG:R"
				//asFrom{5}:="QA:R"
				//asFrom{6}:="RC:R"
				//asFrom{7}:="CE:R"
				//asFrom{8}:="BH:R"  //•090299  mlb 
				//asFrom{9}:="FX:R"
				//asFrom{10}:="FG:V"
				//asFrom{11}:="FX:V"
				//asFrom{12}:="BH:V"
			Else 
				asFrom{1}:="CC:"
				asFrom{2}:="Ex:"
				asFrom{3}:="XC:"
				asFrom{4}:="FG:"
				//asFrom{5}:="QA:"
				//asFrom{6}:="RC:"
				//asFrom{7}:="CE:"
				//asFrom{8}:="BH:"  //•090299  mlb  
				//asFrom{9}:="FX:"
			End if 
			COPY ARRAY:C226(<>asCC; asMove)
			asFrom:=1
			asMove:=1
			sCriterion3:=asFrom{1}
			sCriterion4:=asMove{2}
			If (wms_locationsRequiringReason(sCriterion4))  //move to exam `•100798  mlb  UPR 1972
				tReason:="Reasons:"  // Added by: Mark Zinke (10/11/13) 
				SetObjectProperties(""; ->sCriterion7; True:C214; ""; True:C214)
				SetObjectProperties(""; ->sCriterion9; True:C214; ""; True:C214)
				sCriterion9:="Reject"
				OBJECT SET LIST BY NAME:C237(sCriterion7; "RejectReason")
				SetObjectProperties("Reason@"; -><>NULL; True:C214)
			Else 
				tReason:="Last Skid for this Job Form Item?"  // Added by: Mark Zinke (10/11/13) 
				sCriterion9:=""
				If (iMode=0)  //move
					SetObjectProperties(""; ->sCriterion7; True:C214; ""; False:C215)
					SetObjectProperties(""; ->sCriterion9; True:C214; ""; False:C215)
				End if 
			End if 
			
		: (iMode=1)
			
		: (iMode=2)  //receiving
			sCriterion3:="WIP"
			
			sCriterion4:="CC:OS-MULTIFOLD"
			
			SetObjectProperties(""; ->sCriterion3; True:C214; ""; False:C215)
			SetObjectProperties(""; ->bPost; True:C214; "Receive")
			ARRAY TEXT:C222(asFrom; 1)
			asFrom{1}:="WIP"
			COPY ARRAY:C226(<>asWIP; asMove)
			asFrom:=1
			asMove:=1
			SetObjectProperties("Last@"; -><>NULL; True:C214)
			
		: (iMode=3)
			sCriterion3:="n/r"
			sCriterion4:="n/r"
			ARRAY TEXT:C222(asFrom; 1)
			ARRAY TEXT:C222(asMove; 1)
			asFrom{1}:="n/r"
			asMove{1}:="n/r"
			asFrom:=1
			asMove:=1
			SetObjectProperties(""; ->sCriterion3; True:C214; ""; False:C215)
			SetObjectProperties(""; ->sCriterion4; True:C214; ""; False:C215)
			SetObjectProperties(""; ->sCriterion6; True:C214; ""; True:C214)
			SetObjectProperties(""; ->bPost; True:C214; "Labels")
			
		: (iMode=4)  //scrap
			SetObjectProperties(""; ->bPost; True:C214; "Scrap")
			ARRAY TEXT:C222(asMove; 1)
			If (User in group:C338(Current user:C182; "Roanoke"))
				sCriterion3:="Ex:R"
				sCriterion4:="Sc:R"
				asMove{1}:="Sc:R"
				
			Else 
				sCriterion3:="Ex:"
				sCriterion4:="Sc:"
				asMove{1}:="Sc:"
			End if 
			COPY ARRAY:C226(<>asSc; asFrom)
			SetObjectProperties(""; ->sCriterion3; True:C214; ""; True:C214)
			SetObjectProperties(""; ->sCriterion4; True:C214; ""; False:C215)
			SetObjectProperties(""; ->sCriterion6; True:C214; ""; True:C214)
			sCriterion9:="Reject"
			asFrom:=1
			asMove:=1
			SetReturnReject
			
		: (iMode=5)
			SetObjectProperties(""; ->bPost; True:C214; "Bill & Hold")
			ARRAY TEXT:C222(asFrom; 1)
			ARRAY TEXT:C222(asMove; 1)
			If (User in group:C338(Current user:C182; "Roanoke"))
				asFrom{1}:="FG:R"
				//asFrom{2}:="CE:R"
				asMove{1}:="BH:R"
				
				sCriterion3:="FG:R"
				sCriterion4:="BH:R"
			Else 
				asFrom{1}:="FG:"
				//asFrom{2}:="CE:"
				asMove{1}:="BH:"
				
				sCriterion3:="FG:"
				sCriterion4:="BH:"
			End if 
			asFrom:=1
			asMove:=1
			sCriterion9:="Bill & Hold"  //reason
			
			SetObjectProperties(""; ->sCriterion5; True:C214; ""; False:C215)  //job number
			SetObjectProperties(""; ->i1; True:C214; ""; False:C215)
			SetObjectProperties(""; ->sCriterion6; True:C214; ""; True:C214)  //ordernumber
			SetObjectProperties(""; ->sCriter10; False:C215; ""; False:C215)
			
			OBJECT SET ENTERABLE:C238(*; "Reason@"; False:C215)  // Modified by: Mel Bohince (10/9/19) 
			OBJECT SET VISIBLE:C603(*; "as@"; False:C215)  // Modified by: Mel Bohince (10/9/19) 
	End case 
	
	sCriterion5:="00000.00"
	sCriterion6:="00000.00"
End if 