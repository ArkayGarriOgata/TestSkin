//upr 1454 3/24/95
//• 7/17/98 cs allow view of these reocrds from search screen
Case of 
	: (Form event code:C388=On Load:K2:1)
		wWindowTitle("Push"; "Job_Forms_Machines for "+[Job_Forms_Machines:43]JobForm:1+" Seq: "+String:C10([Job_Forms_Machines:43]Sequence:5; "000"))
		If (fAdHoc)  //rev &  from adhoc`• 7/17/98 cs 
			REDUCE SELECTION:C351([Job_Forms_Materials:55]; 0)
			COPY NAMED SELECTION:C331([Job_Forms_Materials:55]; "Related")  //used in accept/cancel button o input layout
			OBJECT SET ENABLED:C1123(bDelete; False:C215)
			OBJECT SET ENABLED:C1123(bValidate; False:C215)
		End if 
		
		If (Is new record:C668([Job_Forms_Machines:43]))
			CANCEL:C270
		Else 
			CostCtr_FlexFieldLabels("Jobs")
			READ ONLY:C145([Cost_Centers:27])
			qryCostCenter([Job_Forms_Machines:43]CostCenterID:4)  //3/15/95 upr 66 
			
			If ((Position:C15([Job_Forms_Machines:43]CostCenterID:4; <>EMBOSSERS)>0) | (Position:C15([Job_Forms_Machines:43]CostCenterID:4; <>STAMPERS)>0))
				zzDESC:=CostCtr_Description_Tweak(->[Job_Forms_Machines:43]CostCenterID:4)
			Else 
				zzDESC:=[Cost_Centers:27]Description:3
			End if 
		End if 
		
		
	: (Form event code:C388=On Validate:K2:3)
		[Job_Forms_Machines:43]ModDate:32:=4D_Current_date
		[Job_Forms_Machines:43]ModWho:33:=<>zResp
		
	: (Form event code:C388=On Unload:K2:2)
		// Modified by: Mel Bohince (12/7/16) always restore selection
		//If (fAdHoc) 
		USE NAMED SELECTION:C332("Related")
		//End if 
		wWindowTitle("Pop")
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
End case 
//EOLP