//%attributes = {"publishedWeb":true}
// ---------
// Method: eBag_loadRelated
// User name (OS): mlb
// Date and time: 5/30/02  13:09
// ----------------------------------------------------
// SetObjectProperties, Modified by: Mark Zinke (5/14/13)
// ----------------------------------------------------
// Modified by: Mel Bohince (5/1/19) 
READ ONLY:C145([Finished_Goods:26])
READ ONLY:C145([ProductionSchedules:110])

RELATE ONE:C42([Job_Forms:42]JobNo:2)
QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=[Job_Forms:42]JobFormID:5)
QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=[Job_Forms:42]ProcessSpec:46)
QUERY:C277([JTB_Job_Transfer_Bags:112]; [JTB_Job_Transfer_Bags:112]Jobform:3=[Job_Forms:42]JobFormID:5)
QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=[Job_Forms:42]ProjectNumber:56)
QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobForm:1=[Job_Forms:42]JobFormID:5)  // Modified by: Mel Bohince (5/2/14)  
ORDER BY:C49([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Sequence:3; >; [Job_Forms_Machine_Tickets:61]DateEntered:5; >; [Job_Forms_Machine_Tickets:61]P_C:10; <)
CREATE SET:C116([Job_Forms_Machine_Tickets:61]; "machinetickets")
Job_LoadLabel("find"; [Job_Forms:42]JobFormID:5)  // Modified by: Mel Bohince (5/1/19) 
READ WRITE:C146([To_Do_Tasks:100])
QUERY:C277([To_Do_Tasks:100]; [To_Do_Tasks:100]Jobform:1=([Job_Forms:42]JobFormID:5+"@"))
ORDER BY:C49([To_Do_Tasks:100]; [To_Do_Tasks:100]Jobform:1; >)

READ WRITE:C146([Job_Forms_Loads:162])
RELATE MANY:C262([Job_Forms:42]JobFormID:5)
UNLOAD RECORD:C212([Job_Forms_Loads:162])  // Modified by: Mel Bohince (7/16/21) 

If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
	
	QUERY SELECTION:C341([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Commodity_Key:12#"04@")  //in the detai
	
	CREATE SET:C116([Job_Forms_Materials:55]; "materials")
	
Else 
	
	SET QUERY DESTINATION:C396(Into set:K19:2; "materials")
	QUERY SELECTION:C341([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Commodity_Key:12#"04@")  //in the detai
	
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	
	
End if   // END 4D Professional Services : January 2019 query selection

CREATE SET:C116([Job_Forms_Machines:43]; "machines")

ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]SubFormNumber:32; >; [Job_Forms_Items:44]ItemNumber:7; >)

SELECTION TO ARRAY:C260([Job_Forms_Items:44]ProductCode:3; $aCPN)
READ ONLY:C145([QA_Corrective_Actions:105])
QUERY WITH ARRAY:C644([QA_Corrective_Actions:105]ProductCode:7; $aCPN)
If (Records in selection:C76([QA_Corrective_Actions:105])>0)
	OBJECT SET ENABLED:C1123(bCAR; True:C214)
Else 
	OBJECT SET ENABLED:C1123(bCAR; False:C215)
End if 

$recNum:=Job_ProdHistory("find"; ([Jobs:15]CustID:2+":"+[Job_Forms:42]ProcessSpec:46); "Specs")
If (Length:C16([Job_Forms_Master_Schedule:67]RepeatJob:27)>=5)
	SetObjectProperties("repeat@"; -><>NULL; True:C214)
	repeatJobText:="This is a Repeat of Job: "+[Job_Forms_Master_Schedule:67]RepeatJob:27
Else 
	SetObjectProperties("repeat@"; -><>NULL; False:C215)
	repeatJobText:=""
End if 

$linkedDocs:=DOC_CountLinkedDocuments(sCriterion1)
Case of 
	: ($linkedDocs=1)
		SetObjectProperties(""; ->bShowLinkedDocs; True:C214; String:C10($linkedDocs)+" Linked Document")
	: ($linkedDocs>0)
		SetObjectProperties(""; ->bShowLinkedDocs; True:C214; String:C10($linkedDocs)+" Linked Documents")
	Else 
		SetObjectProperties(""; ->bShowLinkedDocs; True:C214; "Link Documents to Job")
End case 