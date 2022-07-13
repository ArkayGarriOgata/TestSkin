//%attributes = {"publishedWeb":true}
//x_ExportJob    see also x_ImportJobObj  
//12/29/94 limit to 1 Job, but export entire data structure of that Job
//1/10/95 files added
//5/2/95 fg_trans removed, these are part of the fg object
//[Job]   _01
//        < >>[JobForm]    _02
//                        < >>[Material_Job] _03
//                                    < >> [RM_Xfer]  _10        1/10/95 files add
//                        < >>[Machine_Job]  _04
//                                    < >> [MachineTicket]  _05
//                        < >>[JobMakesItem]  _06
//                                    < >> [Material_Item]  _08  1/10/95 files add
//                                    < >> [Machine_Item]   _09  1/10/95 files add
//                        < >>[MonthlySummary]  _07  
//                        < >>[FG_Transactions]   _xx         part of FG object
//$1 Job number to export
//• 6/11/98 cs removed reference to Machine & Material Item table

C_TEXT:C284($1; $job)

READ ONLY:C145([Jobs:15])
READ ONLY:C145([Job_Forms:42])
READ ONLY:C145([Job_Forms_Items:44])
READ ONLY:C145([Job_Forms_Items_Costs:92])
READ ONLY:C145([Job_Forms_Materials:55])
READ ONLY:C145([Job_Forms_Machines:43])
READ ONLY:C145([Job_Forms_Machine_Tickets:61])
READ ONLY:C145([Raw_Materials_Transactions:23])

$Job:=$1

QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=Num:C11($Job))

Case of 
	: (Records in selection:C76([Jobs:15])=1)
		CREATE SET:C116([Jobs:15]; "Job")
		uClearSelection(->[Job_Forms:42])
		RELATE MANY:C262([Jobs:15]JobNo:1)  //get jobforms
		CREATE SET:C116([Job_Forms:42]; "JobForm")
		//uRelateSelect (»[JobMakesItem]JobForm;»[JobForm]JobFormID;0)  `get JobMakesItem 
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$Job+"@")
			CREATE SET:C116([Job_Forms_Items:44]; "Items")
			//• mlb - 9/19/01  10:30
			QUERY:C277([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]JobForm:1=$Job+"@")
			CREATE SET:C116([Job_Forms_Items_Costs:92]; "Costs")
			//uRelateSelect (»[Material_Job]JobForm;»[JobForm]JobFormID;0)  `get materialjob r
			QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=$Job+"@")
			CREATE SET:C116([Job_Forms_Materials:55]; "MatJob")
			
			//uRelateSelect (»[Machine_Job]JobForm;»[JobForm]JobFormID;0)  `get machinejob rec
			QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=$Job+"@")
			CREATE SET:C116([Job_Forms_Machines:43]; "MachJob")
			
			//uRelateSelect (»[MachineTicket]JobForm;»[Machine_Job]JobForm;0)  `get machine ti
			QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobForm:1=$Job+"@")
			CREATE SET:C116([Job_Forms_Machine_Tickets:61]; "MachTick")
			
			//uRelateSelect (»[MonthlySummary]JobFormID;»[JobForm]JobFormID;0)  `get monthly  
			//QUERY([MonthlySummary];[MonthlySummary]JobFormID=$Job+"@")
			//CREATE SET([MonthlySummary];"Summary")
			
			QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=$Job+"@")
			CREATE SET:C116([Raw_Materials_Transactions:23]; "rmx")
			
		Else 
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		
		//SEARCH([FG_Transactions];[FG_Transactions]JobForm=$Job+"@")
		//CREATE SET([FG_Transactions];"fgx")
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			USE SET:C118("Job")
			FIRST RECORD:C50([Jobs:15])
			
		Else 
			
			USE SET:C118("Job")
			//we create set after query the same order will be on the set 
			
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		
		SET CHANNEL:C77(12; $Job+"_01")
		For ($i; 1; Records in selection:C76([Jobs:15]))
			SEND RECORD:C78([Jobs:15])
			NEXT RECORD:C51([Jobs:15])
		End for 
		SET CHANNEL:C77(11)
		CLEAR SET:C117("Job")
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			USE SET:C118("JobForm")
			FIRST RECORD:C50([Job_Forms:42])
			
		Else 
			
			USE SET:C118("JobForm")
			// we use set wat was created after related line 38
			
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		
		SET CHANNEL:C77(12; $Job+"_02")
		For ($i; 1; Records in selection:C76([Job_Forms:42]))
			SEND RECORD:C78([Job_Forms:42])
			NEXT RECORD:C51([Job_Forms:42])
		End for 
		SET CHANNEL:C77(11)
		CLEAR SET:C117("JobForm")
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
			
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
				
				USE SET:C118("MatJob")
				FIRST RECORD:C50([Job_Forms_Materials:55])
				
			Else 
				
				USE SET:C118("MatJob")
				// we create set after query 
				
			End if   // END 4D Professional Services : January 2019 First record
			
		Else 
			
			QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=$Job+"@")
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		
		SET CHANNEL:C77(12; $Job+"_03")
		For ($i; 1; Records in selection:C76([Job_Forms_Materials:55]))
			SEND RECORD:C78([Job_Forms_Materials:55])
			NEXT RECORD:C51([Job_Forms_Materials:55])
		End for 
		SET CHANNEL:C77(11)
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
			
			CLEAR SET:C117("MatJob")
			
			
		Else 
			
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
			
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
				
				USE SET:C118("machJob")
				FIRST RECORD:C50([Job_Forms_Machines:43])
				
			Else 
				
				USE SET:C118("machJob")
				// we use after was created using query
				
			End if   // END 4D Professional Services : January 2019 First record
			
		Else 
			
			QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=$Job+"@")
			
		End if   // END 4D Professional Services : January 2019 query selection
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		
		SET CHANNEL:C77(12; $Job+"_04")
		For ($i; 1; Records in selection:C76([Job_Forms_Machines:43]))
			SEND RECORD:C78([Job_Forms_Machines:43])
			NEXT RECORD:C51([Job_Forms_Machines:43])
		End for 
		SET CHANNEL:C77(11)
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
			
			CLEAR SET:C117("machJob")
			
			
		Else 
			
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
				
				USE SET:C118("MachTick")
				FIRST RECORD:C50([Job_Forms_Machine_Tickets:61])
				
				
			Else 
				
				USE SET:C118("MachTick")
				// we use set was created after query
				
				
			End if   // END 4D Professional Services : January 2019 First record
			
			
		Else 
			QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobForm:1=$Job+"@")
			
		End if   // END 4D Professional Services : January 2019 query selection
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		SET CHANNEL:C77(12; $Job+"_05")
		For ($i; 1; Records in selection:C76([Job_Forms_Machine_Tickets:61]))
			SEND RECORD:C78([Job_Forms_Machine_Tickets:61])
			NEXT RECORD:C51([Job_Forms_Machine_Tickets:61])
		End for 
		SET CHANNEL:C77(11)
		
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
			
			CLEAR SET:C117("MachTick")
			
			
		Else 
			
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
			
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
				
				USE SET:C118("Items")
				FIRST RECORD:C50([Job_Forms_Items:44])
				
			Else 
				
				USE SET:C118("Items")
				// we use a set after was created using query
				
			End if   // END 4D Professional Services : January 2019 First record
			// 4D Professional Services : after Order by , query or any query type you don't need First record  
			
		Else 
			
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$Job+"@")
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		SET CHANNEL:C77(12; $Job+"_06")
		For ($i; 1; Records in selection:C76([Job_Forms_Items:44]))
			SEND RECORD:C78([Job_Forms_Items:44])
			NEXT RECORD:C51([Job_Forms_Items:44])
		End for 
		SET CHANNEL:C77(11)
		
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
			
			CLEAR SET:C117("Items")
			
		Else 
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
			
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
				
				USE SET:C118("rmx")
				FIRST RECORD:C50([Raw_Materials_Transactions:23])
				
				
			Else 
				
				USE SET:C118("rmx")
				//see the creation operation of this set
				
				
			End if   // END 4D Professional Services : January 2019 First record
			
		Else 
			
			QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=$Job+"@")
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		SET CHANNEL:C77(12; $Job+"_08")
		For ($i; 1; Records in selection:C76([Raw_Materials_Transactions:23]))
			SEND RECORD:C78([Raw_Materials_Transactions:23])
			NEXT RECORD:C51([Raw_Materials_Transactions:23])
		End for 
		SET CHANNEL:C77(11)
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
			
			CLEAR SET:C117("rmx")
			
			
		Else 
			
		End if   // END 4D Professional Services : January 2019 query selection
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
			
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
				
				USE SET:C118("Costs")
				FIRST RECORD:C50([Job_Forms_Items_Costs:92])
				
			Else 
				
				USE SET:C118("Costs")
				// using a set after was created using query
				
			End if   // END 4D Professional Services : January 2019 First record
			// 4D Professional Services : after Order by , query or any query type you don't need First record  
			
		Else 
			
			QUERY:C277([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]JobForm:1=$Job+"@")
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		SET CHANNEL:C77(12; $Job+"_12")
		For ($i; 1; Records in selection:C76([Job_Forms_Items_Costs:92]))
			SEND RECORD:C78([Job_Forms_Items_Costs:92])
			NEXT RECORD:C51([Job_Forms_Items_Costs:92])
		End for 
		SET CHANNEL:C77(11)
		
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
			
			CLEAR SET:C117("Costs")
			
		Else 
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		uClearSelection(->[Jobs:15])
		uClearSelection(->[Job_Forms:42])
		uClearSelection(->[Job_Forms_Items:44])
		REDUCE SELECTION:C351([Job_Forms_Items_Costs:92]; 0)
		uClearSelection(->[Job_Forms_Materials:55])
		uClearSelection(->[Job_Forms_Machines:43])
		uClearSelection(->[Job_Forms_Machine_Tickets:61])
		//uClearSelection (->[MonthlySummary])
		uClearSelection(->[Raw_Materials_Transactions:23])
		
	: (Records in selection:C76([Jobs:15])>1)
		ALERT:C41("Can Only Export One Job at a Time.")
		
	: (Records in selection:C76([Jobs:15])=0)
		ALERT:C41("No Job with Job Number "+$Job+" Found.")
End case 