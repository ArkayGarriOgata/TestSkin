//Layout Proc.: [control]SemiFinished()  
If (Form event code:C388=On Load:K2:1)
	sCriterion1:="00000.00"
	sCriterion2:="00"
	sCriterion3:="1"
	sCriterion4:="Semi-Finished"
	
	sCriterion5:="Type.Cal.Wth.Lth.Spl"
	sCriterion6:="Arkay"
	rReal1:=0
	QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3="01-Semi-Finished")  //to get type
	If (Records in selection:C76([Raw_Materials_Groups:22])>=1)
		tText:=[Raw_Materials_Groups:22]CompanyID:21+"-"+[Raw_Materials_Groups:22]DepartmentID:22+"-"+[Raw_Materials_Groups:22]GL_Expense_Code:25
	Else 
		tText:="0-0000-0000"
	End if 
	t2:="SHT"
End if 
//