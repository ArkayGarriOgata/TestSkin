//%attributes = {"publishedWeb":true}
//(p) gREfreshRMList
//update the RM choice list 
//after addding one or more RM Group records
//1/10/95
//Upr 0235 Cs - 12/4/96 - Chargecode Change

ARRAY TEXT:C222($ayCode; 0)
ARRAY TEXT:C222($ayComm_Key; 0)

//Upr 0235
//ARRAY TEXT($ayCode;0)
ARRAY TEXT:C222($ayExpense; 0)
ARRAY TEXT:C222($ayDept; 0)
ARRAY TEXT:C222($ayCompany; 0)
//end upr 0235

MESSAGES OFF:C175
$winRef:=NewWindow(180; 30; 6; 1; "")
MESSAGE:C88("Updating Raw Material Lists…")
QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]ReceiptType:13#3)
ORDER BY:C49([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3; >)

//Upr 0235 - below 2 lines are one line of code
//SELECTION TO ARRAY([RM_GROUP]ChargeCode;$ayCode;[RM_GROUP]Commodity_Key
//«;$ayComm_Key)
SELECTION TO ARRAY:C260([Raw_Materials_Groups:22]GL_Expense_Code:25; $ayExpense; [Raw_Materials_Groups:22]DepartmentID:22; $ayDept; [Raw_Materials_Groups:22]CompanyID:21; $ayCompany; [Raw_Materials_Groups:22]Commodity_Key:3; $ayComm_Key)
//end Upr 0235

ARRAY TEXT:C222($ayCode_DESC; Size of array:C274($ayCode))  //1/10/95
For ($i; 1; Size of array:C274($ayCode))
	//Upr 0235
	//$ayCode_DESC{$i}:=$ayCode{$i}+" - "+$ayComm_Key{$i} 
	$ayCode_DESC{$i}:=$ayCompany{$i}+$ayDept{$i}+$ayExpense{$i}+" - "+$ayComm_Key{$i}
	//end Upr 0235
End for 
ARRAY TO LIST:C287($ayCode_DESC; "MATL_DESC")

//Upr 0235
//ARRAY TEXT($ayCode;0)
ARRAY TEXT:C222($ayExpense; 0)
ARRAY TEXT:C222($ayDept; 0)
ARRAY TEXT:C222($ayCompany; 0)
//end upr 0235

ARRAY TEXT:C222($ayComm_Key; 0)
MESSAGES ON:C181
CLOSE WINDOW:C154($winRef)