//(s) aCommCode [poitems]input
If (aCostCtrDes#0) & (aCostCtrDes<=Size of array:C274(aCostCtrDes))
	[QA_Corrective_Actions:105]CostCenter:14:=aCostCtrDes{aCostCtrDes}
	//If (Position(Substring([QA_Corrective_Actions]CostCenter;1;3);◊ROANOKE_WC)>0)
	[QA_Corrective_Actions:105]Plant:13:="Roanoke"
	//Else 
	//[QA_Corrective_Actions]Plant:="Hauppauge"
	//End if 
	GOTO OBJECT:C206([QA_Corrective_Actions:105]RootCause:17)
End if 