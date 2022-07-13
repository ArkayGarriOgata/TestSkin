//%attributes = {}
//Method: Rprt_Entry_LoadCriterion(tReport_Key)
//Desctiption:  This method will take the object info and
//. convert it to a collection

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tReport_Key)
	
	$tReport_Key:=$1
	
End if   //Done initialize

Form:C1466.esRprt_CriterionList:=ds:C1482.Rprt_Criterion.query("Report_Key = :1"; $tReport_Key)
