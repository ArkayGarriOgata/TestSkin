//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 03/26/07, 12:42:08
// ----------------------------------------------------
// Method: Job_ExecuteOnServer()  --> 
// ----------------------------------------------------

C_BOOLEAN:C305(serverMethodDone; serverMethodDone_local; isClosing)
C_TEXT:C284($1; $2; $3; process_name; actionRequested)  //$1 is the message, $2 is a tramp used to find an element in the array
C_TEXT:C284(jobform)
C_BOOLEAN:C305($0)
C_LONGINT:C283(server_pid; $hit; $i; $numCPN; $currentExpireAt; expireAt)

process_name:="JobCostRollup:"
$0:=False:C215

Case of 
	: ($1="client-prep")  //set flags and wait your turn
		//put up a block until server pid has started or its id discovered
		serverMethodDone_local:=False:C215  //reset by server
		actionRequested:=$2
		jobform:=$3
		//unload all the records, named selections were save on_load by Jobform_load_related
		SAVE RECORD:C53([Job_Forms:42])
		UNLOAD RECORD:C212([Job_Forms:42])
		
		ORDER BY:C49([Job_Forms_Machines:43]; [Job_Forms_Machines:43]Sequence:5; >)
		COPY NAMED SELECTION:C331([Job_Forms_Machines:43]; "machines")
		ORDER BY:C49([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Sequence:3; >)
		COPY NAMED SELECTION:C331([Job_Forms_Materials:55]; "Related")
		
		ORDER BY:C49([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Sequence:3; >; [Job_Forms_Machine_Tickets:61]CostCenterID:2; >; [Job_Forms_Machine_Tickets:61]DateEntered:5; >)
		COPY NAMED SELECTION:C331([Job_Forms_Machine_Tickets:61]; "machTicks")
		QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue")
		ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Commodity_Key:22; >; [Raw_Materials_Transactions:23]XferDate:3; >)
		COPY NAMED SELECTION:C331([Raw_Materials_Transactions:23]; "rmXfers")
		
		REDUCE SELECTION:C351([Jobs:15]; 0)
		REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
		REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
		REDUCE SELECTION:C351([Job_Forms_Machine_Tickets:61]; 0)
		REDUCE SELECTION:C351([Job_Forms_Materials:55]; 0)
		REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
		REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
		REDUCE SELECTION:C351([Job_Forms_CloseoutSummaries:87]; 0)
		
		server_pid:=Execute on server:C373("Job_ExecuteOnServer"; <>lMinMemPart; process_name+jobform+actionRequested; "init"; actionRequested; jobform)
		If (False:C215)
			Job_ExecuteOnServer
		End if 
		
		DELAY PROCESS:C323(Current process:C322; 60)  //give the server a moment to start
		
	: ($1="init")  //start the server process
		serverMethodDone:=False:C215  //interprocess flags
		// //////////////////////////////
		actionRequested:=$2
		jobform:=$3
		utl_Logfile("JobCloseOut.Log"; jobform+" Init for: "+actionRequested)
		READ WRITE:C146([Job_Forms:42])
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=jobform)
		
		Case of 
			: (actionRequested="get-actuals")
				isClosing:=False:C215
				READ WRITE:C146([Job_Forms_Items:44])
				READ WRITE:C146([Job_Forms_Machines:43])
				READ WRITE:C146([Job_Forms_Materials:55])
				READ WRITE:C146([Job_Forms_Machine_Tickets:61])
				READ WRITE:C146([Raw_Materials_Transactions:23])
				
				READ ONLY:C145([Process_Specs:18])
				READ ONLY:C145([Customers_Projects:9])
				READ ONLY:C145([Finished_Goods_Transactions:33])
				
				RELATE MANY:C262([Job_Forms:42]JobFormID:5)
				QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue")
				
				JOB_RollupActuals
				
				REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
				REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
				REDUCE SELECTION:C351([Job_Forms_Machine_Tickets:61]; 0)
				REDUCE SELECTION:C351([Job_Forms_Materials:55]; 0)
				REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
				REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
				
			: (Position:C15("rollup"; actionRequested)>0)  //could be rollup or rollup-close
				If (Position:C15("close"; actionRequested)>0)
					isClosing:=True:C214
				Else 
					isClosing:=False:C215
				End if 
				READ WRITE:C146([Job_Forms_Items:44])
				READ WRITE:C146([Job_Forms_Machines:43])
				READ WRITE:C146([Job_Forms_Materials:55])
				READ WRITE:C146([Job_Forms_Machine_Tickets:61])
				READ WRITE:C146([Raw_Materials_Transactions:23])
				READ ONLY:C145([Job_Forms_CloseoutSummaries:87])
				
				READ ONLY:C145([Process_Specs:18])
				READ ONLY:C145([Customers_Projects:9])
				READ ONLY:C145([Finished_Goods_Transactions:33])
				
				RELATE MANY:C262([Job_Forms:42]JobFormID:5)
				QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue")
				
				JOB_RollupActuals
				JOB_AllocateActual
				
				REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
				REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
				REDUCE SELECTION:C351([Job_Forms_Machine_Tickets:61]; 0)
				REDUCE SELECTION:C351([Job_Forms_Materials:55]; 0)
				REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
				REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
				REDUCE SELECTION:C351([Job_Forms:42]; 0)  // Modified by: mel (11/25/09) add this to see if locking issue goes away
				REDUCE SELECTION:C351([Jobs:15]; 0)  // Modified by: mel (11/25/09) add this to see if locking issue goes away
				REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
				REDUCE SELECTION:C351([Job_Forms_CloseoutSummaries:87]; 0)
				
			: (actionRequested="closeout")
				isClosing:=True:C214
				READ WRITE:C146([Job_Forms_Master_Schedule:67])
				JCOCloseForm
				
				READ WRITE:C146([Jobs:15])  //this next method often encounters a locked Jobs record per logfile on server,why?
				JCOCloseJobForm  //this procedure checks whether all Job forms are closed  
				
				READ WRITE:C146([Purchase_Orders:11])
				READ WRITE:C146([Purchase_Orders_Items:12])
				//JCOCloseInkPO   //not critical
				
		End case 
		
		UNLOAD RECORD:C212([Job_Forms:42])
		
		serverMethodDone:=True:C214  //tell the client that the arrays are ready
		//utl_Logfile ("JobCloseOut.Log";jobform+" Waiting for client: "+actionRequested)
		While (serverMethodDone)  //wait for the client to get the arrays
			IDLE:C311
			DELAY PROCESS:C323(Current process:C322; (60*10))
		End while 
		//utl_Logfile ("JobCloseOut.Log";jobform+" Done: "+actionRequested)
		
	: ($1="exchange")  //suck the arrays from the server
		C_TIME:C306($timeOutAt)
		$timeOutAt:=Current time:C178+?00:03:00?
		
		Repeat   //waiting until server says it ready
			GET PROCESS VARIABLE:C371(server_pid; serverMethodDone; serverMethodDone_local)
			If (Not:C34(serverMethodDone_local))
				zwStatusMsg("SERVER REQUEST"; "Done yet?")
				DELAY PROCESS:C323(Current process:C322; 60)
			End if 
		Until (serverMethodDone_local) | (Current time:C178>$timeOutAt)
		
		// //////////////////////////////
		If (Current time:C178<$timeOutAt)
			zwStatusMsg("SERVER REQUEST"; jobform+" Done!")
			$0:=True:C214
		Else 
			zwStatusMsg("SERVER REQUEST"; "Timed Out!")
		End if 
		
		SET PROCESS VARIABLE:C370(server_pid; serverMethodDone; False:C215)  //let the service quit
		//restore selections
		LOAD RECORD:C52([Job_Forms:42])
		RELATE ONE:C42([Job_Forms:42]JobNo:2)
		USE NAMED SELECTION:C332("Jobits")
		USE NAMED SELECTION:C332("machines")
		USE NAMED SELECTION:C332("machTicks")
		USE NAMED SELECTION:C332("Related")
		USE NAMED SELECTION:C332("rmXfers")
		//USE NAMED SELECTION("Master_Schedule")
End case 