//%attributes = {}
//Method:  Quik_List_Excel(tQuick_Key)
//Description:  This will allow a user to print a quick report

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tQuick_Key)
	
	$tQuick_Key:=$1
	
End if   //Done Initialize

SET AUTOMATIC RELATIONS:C310(True:C214; True:C214)

If (Quik_List_QueryB($tQuick_Key))
	
	Quik_List_Report($tQuick_Key)
	
End if 

SET AUTOMATIC RELATIONS:C310(False:C215; False:C215)
