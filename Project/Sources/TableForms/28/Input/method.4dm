//[Process_Specs_Machines];"Input"
Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Is new record:C668([Process_Specs_Machines:28]))
			CANCEL:C270
		Else 
			If (imode>2)
				OBJECT SET ENABLED:C1123(bValidate; False:C215)
				OBJECT SET ENABLED:C1123(bGetRM; False:C215)
			End if 
			OBJECT SET ENABLED:C1123(bDelete; False:C215)
			CostCtr_FlexFieldLabels("PSpec")
		End if 
		
		QUERY:C277([Process_Specs_Materials:56]; [Process_Specs_Materials:56]ProcessSpec:1=[Process_Specs:18]ID:1; *)
		QUERY:C277([Process_Specs_Materials:56];  & ; [Process_Specs_Materials:56]CustID:2=[Process_Specs:18]Cust_ID:4; *)
		QUERY:C277([Process_Specs_Materials:56];  & ; [Process_Specs_Materials:56]Sequence:4=[Process_Specs_Machines:28]Seq_Num:3)
		
		sSetPspecMatl
		
		If ((Position:C15([Process_Specs_Machines:28]CostCenterID:4; <>EMBOSSERS)>0) | (Position:C15([Process_Specs_Machines:28]CostCenterID:4; <>STAMPERS)>0))
			$shouldUse:=CostCtr_Description_Tweak(->[Process_Specs_Machines:28]CostCtrName:5; "save")
		End if 
		
	: (Form event code:C388=On Validate:K2:3)
		If ((Position:C15([Process_Specs_Machines:28]CostCenterID:4; <>EMBOSSERS)>0) | (Position:C15([Process_Specs_Machines:28]CostCenterID:4; <>STAMPERS)>0))
			$shouldUse:=CostCtr_Description_Tweak(->[Process_Specs_Machines:28]CostCtrName:5; "save")
		End if 
		uUpdateTrail(->[Process_Specs_Machines:28]ModDate:7; ->[Process_Specs_Machines:28]ModWho:8; ->[Process_Specs_Machines:28]zCount:6)
		
	: (Form event code:C388=On Unload:K2:2)
		USE NAMED SELECTION:C332("Related")  //reutrns mat psec selection to parnet
		If (Records in selection:C76([Process_Specs_Materials:56])=0)  //this would be true on a brand new form
			PSpecEstimateLd(""; "Materials")
			ORDER BY:C49([Process_Specs_Materials:56]; [Process_Specs_Materials:56]Sequence:4; >)
		End if 
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
End case 
//