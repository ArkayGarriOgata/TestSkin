//%attributes = {"publishedWeb":true}
//uPrintFormCarto  9/30/94

$numCartons:=Records in selection:C76([Estimates_FormCartons:48])
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	
	ORDER BY:C49([Estimates_FormCartons:48]; [Estimates_FormCartons:48]ItemNumber:3; >)
	FIRST RECORD:C50([Estimates_FormCartons:48])
	
	
Else 
	
	ORDER BY:C49([Estimates_FormCartons:48]; [Estimates_FormCartons:48]ItemNumber:3; >)
	
End if   // END 4D Professional Services : January 2019 First record

// 4D Professional Services : after Order by , query or any query type you don't need First record  
ii1:=0  //form counters
ii2:=0
ii3:=0
ii4:=0


For ($j; 1; $numCartons)
	RELATE ONE:C42([Estimates_FormCartons:48]Carton:1)
	t16:=String:C10([Estimates_FormCartons:48]NumberUp:4)
	//  If (Num(t16)>0)
	t10:=String:C10([Estimates_FormCartons:48]ItemNumber:3)
	t11:=[Estimates_Carton_Specs:19]ProductCode:5
	t12:=[Estimates_Carton_Specs:19]Description:14+" OL#:"+[Estimates_Carton_Specs:19]OutLineNumber:15+" Art#:"+[Estimates_Carton_Specs:19]z_ArtReceived:60  //"-"+ the dash is a secret code which says FG record not available
	C_TEXT:C284($dim_A; $dim_B; $dem_ht)
	$success:=FG_getDimensions(->$dim_A; ->$dim_B; ->$dem_ht; [Estimates_Carton_Specs:19]OutLineNumber:15; [Estimates_Carton_Specs:19]ProductCode:5)
	If ($success)
		t13:=$dim_A+" * "+$dim_B+" * "+$dem_ht
	Else 
		t13:="*** dimensions unavailable ***"
	End if 
	//t13:=String([Estimates_Carton_Specs]Width_Dec;"#,##0.0###")+" x "+String([Estimates_Carton_Specs]Depth_Dec;"#,##0.0###")+" x "+String([Estimates_Carton_Specs]Height_Dec;"#,##0.0###")
	t14:=String:C10([Estimates_Carton_Specs:19]SquareInches:16)
	t15:=[Estimates_Carton_Specs:19]Style:4  //OutLineNumber      
	// upr 1141  t17:=String([CARTON_SPEC]Quantity_Want;"###,###,##0")
	// upr 1141  t18:=String([CARTON_SPEC]Quantity_Yield;"###,###,##0")
	t17:=String:C10([Estimates_FormCartons:48]FormWantQty:9; "###,###,##0")
	t18:=String:C10([Estimates_FormCartons:48]MakesQty:5; "###,###,##0")
	Print form:C5([Estimates:17]; "Est.D1")
	
	ii1:=ii1+[Estimates_FormCartons:48]NumberUp:4
	
	ii2:=ii2+Num:C11(t17)
	
	// upr 1141  i3:=i3+[CARTON_SPEC]Quantity_Yield
	ii3:=ii3+Num:C11(t18)
	pixels:=pixels+15
	uChk4Room(47; 70; "Est.H1"; "Est.H3")
	//End if   `some up
	NEXT RECORD:C51([Estimates_FormCartons:48])
End for 


ii4:=((ii3-ii2)/ii2)*100  //percent Excess on form    
$i1:=i1
$i2:=i2
$i3:=i3
$i4:=i4
i1:=ii1
i2:=ii2
i3:=ii3
i4:=ii4

Print form:C5([Estimates:17]; "Est.T1")
pixels:=pixels+17
i1:=$i1
i2:=$i2
i3:=$i3
i4:=$i4
Print form:C5([zz_control:1]; "BlankPix8")  //blank line
pixels:=pixels+8
//