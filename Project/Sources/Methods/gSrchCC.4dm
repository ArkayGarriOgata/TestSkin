//%attributes = {"publishedWeb":true}
//(P) gSrchCC: Search Cost Center

zDefault:="["+Table name:C256(->[Job_Forms_Machine_Tickets:61])+"]"
Case of 
	: (rbSearchEd=1)
		QUERY:C277([Job_Forms_Machine_Tickets:61])
	: ((xCriterion1="") & (xCriterion2="") & (xCriterion3=""))
		ALL RECORDS:C47([Job_Forms_Machine_Tickets:61])
	: (xCriterion1#"")
		Case of 
			: (rb1=1)
				QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]CostCenterID:2=xCriterion1+"@")
			: (rb2=1)
				QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]Description:3=xCriterion1+"@")
				QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]CostCenterID:2=[Cost_Centers:27]ID:1)
			: (rb3=1)
				//SEARCH([MACH_ACT_JOB];[MACH_ACT_JOB]Group=xCriterion1+"@")
		End case 
	Else 
		gCheckCrit
		Case of 
			: (rb1=1)
				QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]CostCenterID:2<=xLoName+"@"; *)
				QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]CostCenterID:2>=xHiName+"@")
			: (rb2=1)
				QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]Description:3>=xLoName+"@"; *)
				QUERY:C277([Cost_Centers:27];  & ; [Cost_Centers:27]Description:3<=xHiName+"@")
				If (Records in selection:C76([Cost_Centers:27])>1)
					QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]CostCenterID:2=[Cost_Centers:27]ID:1; *)
					If (Records in selection:C76([Cost_Centers:27])>2)
						For (i; 1; (Records in selection:C76([Cost_Centers:27])-2))
							NEXT RECORD:C51([Cost_Centers:27])
							QUERY:C277([Job_Forms_Machine_Tickets:61];  | ; [Job_Forms_Machine_Tickets:61]CostCenterID:2=[Cost_Centers:27]ID:1; *)
						End for 
					End if 
					NEXT RECORD:C51([Cost_Centers:27])
					QUERY:C277([Job_Forms_Machine_Tickets:61];  | ; [Job_Forms_Machine_Tickets:61]CostCenterID:2=[Cost_Centers:27]ID:1)
				Else 
					QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]CostCenterID:2=[Cost_Centers:27]ID:1)
				End if 
			: (rb3=1)
				//SEARCH([MachineTicket];[MACH_ACT_JOB]Group>=xLoName+"@";*)
				//SEARCH([MachineTicket]; &[MACH_ACT_JOB]Group<=xHiName+"@")
		End case 
End case 
If (Records in selection:C76([Job_Forms_Machine_Tickets:61])=0)
	uNoneFound
	REJECT:C38
Else 
	C_TEXT:C284($SortDir)
	C_TEXT:C284($File)
	$SortDir:=(">"*sAsc)+("<"*sDes)
	$file:="["+Table name:C256(->[Job_Forms_Machine_Tickets:61])+"]"
	Case of 
		: ((rbSearchEd=1) | (sSortEd=1))
			ORDER BY:C49([Job_Forms_Machine_Tickets:61])
			zSort:=""
		: (rb1=1)
			zSort:=$file+Field name:C257(->[Job_Forms_Machine_Tickets:61]CostCenterID:2)+";"+$SortDir
		: (rb2=1)
			zSort:=$file+Field name:C257(->[Cost_Centers:27]Description:3)+";"+$SortDir
		: (rb3=1)
			//zSort:=$file+Fieldname(» •[MACH_ACT_JOB]Group• )+";"+$SortDir
	End case 
End if 