//%attributes = {"publishedWeb":true}
//gJobDel: Delete [Job] file
//12/29/94 limit to 1 Job, but export entire data structure of that Job
//1/10/95 files added`
//02/10/95 passwd control
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
//                        < >>[FG_Transactions]   _11          1/10/95 files added
//$1 Job number to export
//• mlb - 9/21/01 don't delete fg transactions
// • mel (8/28/03, 09:44:31) include mstrLog and JIC

READ WRITE:C146([Jobs:15])
READ WRITE:C146([Job_Forms:42])
READ WRITE:C146([Job_Forms_Items:44])  //trigger get the JobItemCosts record
READ WRITE:C146([Job_Forms_Materials:55])
READ WRITE:C146([Job_Forms_Machines:43])
READ WRITE:C146([Job_Forms_Machine_Tickets:61])
READ WRITE:C146([Raw_Materials_Transactions:23])
READ WRITE:C146([Job_Forms_Master_Schedule:67])
READ WRITE:C146([Job_Forms_Items_Costs:92])

C_LONGINT:C283($job)

If (User in group:C338(Current user:C182; "Administration"))
	$Job:=Num:C11(Request:C163("Delete which job:"))
	QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=$Job)
	Case of 
		: (OK=0)
			//break    
		: (Records in selection:C76([Jobs:15])=1)
			RELATE MANY:C262([Jobs:15]JobNo:1)  //get jobforms
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=String:C10($Job; "00000")+"@")
			QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=String:C10($Job; "00000")+"@")
			QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=String:C10($Job; "00000")+"@")
			QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobForm:1=String:C10($Job; "00000")+"@")
			
			QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=String:C10($Job; "00000")+"@")
			QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=String:C10($Job; "00000")+"@")
			QUERY:C277([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]JobForm:1=String:C10($Job; "00000")+"@")
			//QUERY([FG_Transactions];[FG_Transactions]JobForm=String($Job;"00000")+"@")
			
			DELETE SELECTION:C66([Job_Forms_Machine_Tickets:61])
			DELETE SELECTION:C66([Raw_Materials_Transactions:23])
			//DELETE SELECTION([FG_Transactions])
			DELETE SELECTION:C66([Job_Forms_Items:44])
			DELETE SELECTION:C66([Job_Forms_Materials:55])
			DELETE SELECTION:C66([Job_Forms_Machines:43])
			DELETE SELECTION:C66([Job_Forms:42])
			DELETE SELECTION:C66([Job_Forms_Master_Schedule:67])
			DELETE SELECTION:C66([Job_Forms_Items_Costs:92])
			DELETE RECORD:C58([Jobs:15])
	End case 
Else 
	BEEP:C151
	ALERT:C41("Only group 'Administration' has access to delete jobs.")
End if 
//