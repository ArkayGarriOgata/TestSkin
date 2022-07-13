//%attributes = {"publishedWeb":true}
//x_ImportJobObf  see also x_ExportJob, gJobDel
//1/10/95
//5/2/95  remove fg_trans
//• 6/11/98 cs removed freerence to [material_Item] & [machine_Item] tables
// Modified by: Mel Bohince (2/17/16) add pk_id:=Generate UUID
READ WRITE:C146([Jobs:15])
READ WRITE:C146([Job_Forms:42])
READ WRITE:C146([Job_Forms_Items:44])
READ WRITE:C146([Job_Forms_Items_Costs:92])
READ WRITE:C146([Job_Forms_Materials:55])
READ WRITE:C146([Job_Forms_Machines:43])
READ WRITE:C146([Job_Forms_Machine_Tickets:61])
READ WRITE:C146([Raw_Materials_Transactions:23])

$job:=Num:C11(Request:C163("Import which job:"; "0"))
$jobString:=String:C10($job; "00000")
If (OK=1)
	
	SET CHANNEL:C77(10; ($jobString+"_01"))
	RECEIVE RECORD:C79([Jobs:15])
	If (OK=1)
		Open window:C153(20; 50; 180; 350; 1; "")
		MESSAGE:C88(Char:C90(13)+"Job")
		[Jobs:15]pk_id:22:=Generate UUID:C1066
		SAVE RECORD:C53([Jobs:15])
		SET CHANNEL:C77(11)
		
		MESSAGE:C88(Char:C90(13)+"Forms")
		SET CHANNEL:C77(10; ($jobString+"_02"))
		RECEIVE RECORD:C79([Job_Forms:42])
		While (OK=1)
			[Job_Forms:42]pk_id:87:=Generate UUID:C1066
			SAVE RECORD:C53([Job_Forms:42])
			RECEIVE RECORD:C79([Job_Forms:42])
		End while 
		SET CHANNEL:C77(11)
		
		MESSAGE:C88(Char:C90(13)+"materials")
		SET CHANNEL:C77(10; ($jobString+"_03"))
		RECEIVE RECORD:C79([Job_Forms_Materials:55])
		While (OK=1)
			[Job_Forms_Materials:55]pk_id:28:=Generate UUID:C1066
			SAVE RECORD:C53([Job_Forms_Materials:55])
			RECEIVE RECORD:C79([Job_Forms_Materials:55])
		End while 
		SET CHANNEL:C77(11)
		
		MESSAGE:C88(Char:C90(13)+"machines")
		SET CHANNEL:C77(10; ($jobString+"_04"))
		RECEIVE RECORD:C79([Job_Forms_Machines:43])
		While (OK=1)
			[Job_Forms_Machines:43]pk_id:44:=Generate UUID:C1066
			SAVE RECORD:C53([Job_Forms_Machines:43])
			RECEIVE RECORD:C79([Job_Forms_Machines:43])
		End while 
		SET CHANNEL:C77(11)
		
		MESSAGE:C88(Char:C90(13)+"machineTickets")
		SET CHANNEL:C77(10; ($jobString+"_05"))
		RECEIVE RECORD:C79([Job_Forms_Machine_Tickets:61])
		While (OK=1)
			[Job_Forms_Machine_Tickets:61]pk_id:24:=Generate UUID:C1066
			SAVE RECORD:C53([Job_Forms_Machine_Tickets:61])
			RECEIVE RECORD:C79([Job_Forms_Machine_Tickets:61])
		End while 
		SET CHANNEL:C77(11)
		
		MESSAGE:C88(Char:C90(13)+"cartons")
		SET CHANNEL:C77(10; ($jobString+"_06"))
		RECEIVE RECORD:C79([Job_Forms_Items:44])
		While (OK=1)
			[Job_Forms_Items:44]pk_id:54:=Generate UUID:C1066
			SAVE RECORD:C53([Job_Forms_Items:44])
			RECEIVE RECORD:C79([Job_Forms_Items:44])
		End while 
		SET CHANNEL:C77(11)
		
		
		MESSAGE:C88(Char:C90(13)+"r/m transfers")
		SET CHANNEL:C77(10; ($jobString+"_08"))
		RECEIVE RECORD:C79([Raw_Materials_Transactions:23])
		While (OK=1)
			[Raw_Materials_Transactions:23]pk_id:32:=Generate UUID:C1066
			SAVE RECORD:C53([Raw_Materials_Transactions:23])
			RECEIVE RECORD:C79([Raw_Materials_Transactions:23])
		End while 
		SET CHANNEL:C77(11)
		
		MESSAGE:C88(Char:C90(13)+"costs")
		SET CHANNEL:C77(10; ($jobString+"_12"))
		RECEIVE RECORD:C79([Job_Forms_Items_Costs:92])
		While (OK=1)
			[Job_Forms_Items_Costs:92]pk_id:18:=Generate UUID:C1066
			SAVE RECORD:C53([Job_Forms_Items_Costs:92])
			RECEIVE RECORD:C79([Job_Forms_Items_Costs:92])
		End while 
		SET CHANNEL:C77(11)
		
	End if 
	CLOSE WINDOW:C154
Else 
	BEEP:C151
	ALERT:C41($jobString+" could not be received.")
End if 
SET CHANNEL:C77(11)
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
	
	UNLOAD RECORD:C212([Estimates:17])
	UNLOAD RECORD:C212([Jobs:15])
	UNLOAD RECORD:C212([Job_Forms:42])
	UNLOAD RECORD:C212([Job_Forms_Items:44])
	UNLOAD RECORD:C212([Job_Forms_Materials:55])
	UNLOAD RECORD:C212([Job_Forms_Machines:43])
	UNLOAD RECORD:C212([Job_Forms_Machine_Tickets:61])
	UNLOAD RECORD:C212([Raw_Materials_Transactions:23])
	
Else 
	
	//you have reduce selection on line 123
	
End if   // END 4D Professional Services : January 2019 

uClearSelection(->[Estimates:17])
uClearSelection(->[Jobs:15])
uClearSelection(->[Job_Forms:42])
uClearSelection(->[Job_Forms_Items:44])
uClearSelection(->[Job_Forms_Materials:55])
uClearSelection(->[Job_Forms_Machines:43])
uClearSelection(->[Job_Forms_Machine_Tickets:61])
uClearSelection(->[Raw_Materials_Transactions:23])