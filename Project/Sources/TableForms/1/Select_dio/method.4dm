// ----------------------------------------------------
// User name (OS): cs
// Date: 6/4/97
// ----------------------------------------------------
// Form Method: [zz_control].Select_dio
// SetObjectProperties, Mark Zinke (5/16/13)
// ----------------------------------------------------

If (Form event code:C388=On Load:K2:1)
	rb1:=1
	uSelectReset(1)
	sDes:=1
	sAsc:=0
	sCriterion1:=""
	sCriterion2:=""
	sCriterion3:=""
	sCriterion4:=""
	zSort:=""
	zSelectNum:=1
	If (aSlctField{5}=(<>NIL_PTR))  //deal with exceptions
		SetObjectProperties(""; ->rb5; True:C214; "")
		OBJECT SET ENABLED:C1123(rb5; False:C215)
	Else 
		SetObjectProperties(""; ->rb5; True:C214; Field name:C257(aSlctField{5}))
	End if 
	If (aSlctField{4}=(<>NIL_PTR))
		SetObjectProperties(""; ->rb4; True:C214; "")
		OBJECT SET ENABLED:C1123(rb4; False:C215)
	Else 
		SetObjectProperties(""; ->rb4; True:C214; Field name:C257(aSlctField{4}))
	End if   //4    
	If (aSlctField{3}=(<>NIL_PTR))
		SetObjectProperties(""; ->rb3; True:C214; "")
		OBJECT SET ENABLED:C1123(rb3; False:C215)
	Else 
		SetObjectProperties(""; ->rb3; True:C214; Field name:C257(aSlctField{3}))
	End if   //3    
	If (aSlctField{2}=(<>NIL_PTR))
		SetObjectProperties(""; ->rb2; True:C214; "")
		OBJECT SET ENABLED:C1123(rb2; False:C215)
	Else 
		SetObjectProperties(""; ->rb2; True:C214; Field name:C257(aSlctField{2}))
	End if   //2    
	If (aSlctField{1}=(<>NIL_PTR))
		ALERT:C41("Mr. Programmer, check 'uInitSelectArra' for "+Table name:C256(filePtr))
	Else 
		SetObjectProperties(""; ->rb1; True:C214; Field name:C257(aSlctField{1}))
	End if 
	
	If (Position:C15(<>sReqName; tMessage1)>0)  //• 6/4/97 cs renames radio buttons to reflect Requistion 'fields' instead of PO
		SetObjectProperties(""; ->rb4; True:C214; "Req Date")
	End if 
	
	$lastsel:=Records in set:C195("◊LastSelection"+String:C10(Table:C252(filePtr)))
	If ($lastsel>0)
		OBJECT SET ENABLED:C1123(rbCurrSel; True:C214)
		SetObjectProperties(""; ->rbCurrSel; True:C214; "Prior "+String:C10($lastsel)+" recs")
	Else 
		OBJECT SET ENABLED:C1123(rbCurrSel; False:C215)
		SetObjectProperties(""; ->rbCurrSel; True:C214; "Last Selection")
	End if 
	
End if 