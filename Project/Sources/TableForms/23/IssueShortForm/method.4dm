//(lop) [control]issueshortform
//• 6/22/98 cs mods to cover new fields on layout
If (Form event code:C388=On Load:K2:1)
	C_TEXT:C284(DeptCode; sComp; sRefNo)
	C_TEXT:C284(sExpCode)
	sCriterion1:=""
	sCriterion2:=""
	rReal1:=0
	rReal2:=0
	DeptCode:="9999"
	sComp:="1"
	sExpCode:=""
	sRefNo:=""
	
	If ([y_accounting_departments:4]DepartmentID:1#DeptCode)
		QUERY:C277([y_accounting_departments:4]; [y_accounting_departments:4]DepartmentID:1=DeptCode)
	End if 
	
	If (Records in selection:C76([y_accounting_departments:4])=1)
		ExpCodeListBld
	End if 
End if 
//