// _______
// Method: [Raw_Materials].IssueToJobForm.jobFormSearch   ( ) ->
// By: Mel Bohince @ 06/21/21, 14:32:33
// Description
// 
// ----------------------------------------------------
C_OBJECT:C1216($jf_es; $jf_e)

Case of 
		
	: (Form event code:C388=On After Keystroke:K2:26)
		Form:C1466.findJobFormID:=Get edited text:C655
		Form:C1466.jobFormID:=""
		
		If (Length:C16(Form:C1466.findJobFormID)>4)
			
			
			$jf_es:=ds:C1482.Job_Forms.query("JobFormID = :1"; (Form:C1466.findJobFormID+"@"))
			
			Case of 
				: ($jf_es.length=1)
					$jf_e:=$jf_es.first()
					Form:C1466.findJobFormID:=$jf_e.JobFormID
					Form:C1466.jobFormID:=Form:C1466.findJobFormID
					
					Form:C1466.billOfMaterial_es:=$jf_e.MATERIALS.orderBy("Sequence")  //will list the budgeted materials for the $form_o.findJobFormID
					Form:C1466.billOfMaterialHold_es:=Form:C1466.billOfMaterial_es
					
					<>JobForm:=Form:C1466.findJobFormID  //in case they jump to Job Bags Review
					Form:C1466.jobFormDescription:=CUST_getName($jf_e.JOB.CustID; "elc")+", "+$jf_e.CustomerLine+", Status = "+$jf_e.Status
					
					GOTO OBJECT:C206(*; "sequence")  //"BillOfMaterials"
					
				: ($jf_es.length>1)
					zwStatusMsg("Find Job"; String:C10($jf_es.length)+" matches to "+Form:C1466.findJobFormID+"@")
					Form:C1466.jobFormDescription:=String:C10($jf_es.length)+" matches to "+Form:C1466.findJobFormID+"@"
					
				Else 
					BEEP:C151
					ALERT:C41(Form:C1466.findJobFormID+" does not appear to be a job.")
					Form:C1466.billOfMaterial_es:=ds:C1482.Job_Forms_Materials.newSelection()
					
			End case 
			
		Else   //init the form
			//RMX_IssueToJobReset ("job-form-entry")
			RMX_IssueToJobReset("budget-item-select")
			RMX_IssueToJobReset("inventory-select")
			
		End if   //at least 4 chars entered
		
	: (Form event code:C388=On Data Change:K2:15)
		If (Length:C16(Form:C1466.findJobFormID)=8) & (Form:C1466.findJobFormID#Form:C1466.jobFormID)  //pasted in?
			$jf_es:=ds:C1482.Job_Forms.query("JobFormID = :1"; (Form:C1466.findJobFormID+"@"))
			Case of 
				: ($jf_es.length=1)
					$jf_e:=$jf_es.first()
					Form:C1466.findJobFormID:=$jf_e.JobFormID
					
					Form:C1466.billOfMaterial_es:=$jf_e.MATERIALS.orderBy("Sequence")  //will list the budgeted materials for the $form_o.findJobFormID
					Form:C1466.billOfMaterialHold_es:=Form:C1466.billOfMaterial_es
					
					<>JobForm:=Form:C1466.findJobFormID  //in case they jump to Job Bags Review
					Form:C1466.jobFormDescription:=CUST_getName($jf_e.JOB.CustID; "elc")+", "+$jf_e.CustomerLine+", Status = "+$jf_e.Status
					
					GOTO OBJECT:C206(*; "sequence")  //"BillOfMaterials"
			End case 
			
		End if 
		
		
End case 
