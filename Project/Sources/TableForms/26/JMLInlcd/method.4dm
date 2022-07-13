
Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		util_alternateBackground
		$i:=qryJMI([Job_Forms_Master_Schedule:67]JobForm:4; 0; [Finished_Goods:26]ProductCode:1)
		
		If ($i>0)
			dDateBegin:=JMI_get1stRelease
		Else 
			dDateBegin:=!00-00-00!
		End if 
		
	: (Form event code:C388=On Clicked:K2:4)
		GET HIGHLIGHTED RECORDS:C902([Finished_Goods:26]; "clickedIncludeRecord")
		
	: (Form event code:C388=On Double Clicked:K2:5)
		If (fSetMAD)
			$i:=qryJMI([Job_Forms_Master_Schedule:67]JobForm:4; 0; [Finished_Goods:26]ProductCode:1)
			If ($i>0)
				APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]MAD:37:=newHRD)
				CUT NAMED SELECTION:C334([Finished_Goods:26]; "redrawThem")
				USE NAMED SELECTION:C332("redrawThem")
			End if 
		End if 
		
End case 

//app_SelectIncludedRecords (->[Finished_Goods]ProductCode)
