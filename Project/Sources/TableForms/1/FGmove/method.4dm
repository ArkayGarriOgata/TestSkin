Case of 
	: (Form event code:C388=On Load:K2:1)
		//(LP) [CONTROL]fgTransfer
		//•091196  MLB  make ready for roanoke
		//•100798  mlb  UPR 1972  
		C_TEXT:C284(sCriterion7; sCriterion8; sCriterion9)  // somewhere criter9 was getting changed to an array
		sCriterion1:=""  //        cpn
		sCriterion2:="00000"  //custid
		rReal1:=0  //             qty
		sCriterion3:=""  //from
		sCriterion4:=""  //to
		sCriterion5:=""  //jobform
		i1:=0  //                job item
		sCriterion6:=""  //orderline
		sCriterion7:=""  //reason comment
		sCriterion8:=""  //action taken
		sCriterion9:=""  //reason
		sCriter10:=""  //   skid ticket
		sCriter11:=<>zResp  //user
		sCriter12:=""  //release
		wms_number_cases:=0
		C_BOOLEAN:C305($reasonRequired)
		$reasonRequired:=wms_locationsRequiringReason
		
		ARRAY TEXT:C222(asFrom; 8)
		ARRAY TEXT:C222(asMove; 3)
		If (User in group:C338(Current user:C182; "Roanoke"))
			asFrom{1}:="CC:R"
			asFrom{2}:="Ex:R"
			asFrom{3}:="XC:R"
			asFrom{4}:="FG:R"
			asFrom{5}:="QA:R"
			asFrom{6}:="RC:R"
			asFrom{7}:="FX:R"
			asFrom{8}:="BH:R"  //•090299  mlb 
		Else 
			asFrom{1}:="CC:"
			asFrom{2}:="Ex:"
			asFrom{3}:="XC:"
			asFrom{4}:="FG:"
			asFrom{5}:="QA:"
			asFrom{6}:="RC:"
			asFrom{7}:="FX:"
			asFrom{8}:="BH:"  //•090299  mlb  
		End if 
		COPY ARRAY:C226(<>asCC; asMove)
		asFrom:=0
		asMove:=0
		sCriterion3:=asFrom{0}
		sCriterion4:=asMove{0}
		SetObjectProperties("Reason@"; -><>NULL; False:C215)
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
		
End case 
//EOP