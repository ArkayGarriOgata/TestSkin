//%attributes = {"publishedWeb":true}
//(p) doJobCLoseout
//called fom 'Closeout Job' button on [Jobform]Input Actual2
//• 12/16/97 cs created
//• 5/7/98 cs include code to check Job Form Status
//• 6/9/98 cs logic error on situation where issuing did not occur
//• 7/8/98 cs inadvertently exchanged to else condions - fixed
//• 7/28/98 cs make sure that the Rm_xfers are correct user can change selection
//090298 allow parameter to suppress user interation

C_TEXT:C284(aJobNo)
C_LONGINT:C283($1)
C_BOOLEAN:C305(isClosing)

isClosing:=True:C214
$params:=Count parameters:C259

If ([Job_Forms:42]Status:6="Closed") & ($params=0)  //5/7/98
	uConfirm("Job Form "+[Job_Forms:42]JobFormID:5+" has already been closed."+Char:C90(13)+"Are you sure you want to run the Close out routines again?"; "Again"; "Stop")
Else 
	OK:=1
End if 

If (OK=1)
	If (True:C214)
		If (OK=1)
			If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
				$Continue:=True:C214
			Else 
				If ($params=0)
					uConfirm("No Actual Labor entries:"+[Job_Forms:42]JobFormID:5+Char:C90(13)+"Continue?"; "Yes"; "No")
				Else 
					OK:=1
				End if 
				$Continue:=(OK=1)
			End if 
			
			If ($Continue)
				If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
					
					QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=[Job_Forms:42]JobFormID:5)  //• 5/29/98 cs insure that all records ar avail.
					CREATE SET:C116([Job_Forms_Materials:55]; "Materials")  //create sets so that record can be returned
					
					
				Else 
					
					SET QUERY DESTINATION:C396(Into set:K19:2; "Materials")
					QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=[Job_Forms:42]JobFormID:5)  //• 5/29/98 cs insure that all records ar avail.
					SET QUERY DESTINATION:C396(Into current selection:K19:1)
					
					
				End if   // END 4D Professional Services : January 2019 query selection
				If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
					
					COPY NAMED SELECTION:C331([Job_Forms_Items:44]; "Production")
					
					
				Else 
					
					ARRAY LONGINT:C221($_Production; 0)
					LONGINT ARRAY FROM SELECTION:C647([Job_Forms_Items:44]; $_Production)
					
					
				End if   // END 4D Professional Services : January 2019 
				CREATE SET:C116([Job_Forms_Machine_Tickets:61]; "MachTickets")
				//• 7/28/98 cs make sure that the Rm_xfers are correct user can change selection
				QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=[Job_Forms:42]JobFormID:5; *)
				QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Location:15="WIP")
				
				If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
					ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Sequence:13; >; [Raw_Materials_Transactions:23]Commodity_Key:22; >)
				End if 
				CREATE SET:C116([Raw_Materials_Transactions:23]; "RmXfers")
				CREATE SET:C116([Finished_Goods_Transactions:33]; "FGXfers")
				CREATE SET:C116([Jobs:15]; "Jobs")
				If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
					
					QUERY SELECTION:C341([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Actual_Qty:14=0)
					CREATE SET:C116([Job_Forms_Materials:55]; "NotIssued")
					
					USE SET:C118("Materials")
					
				Else 
					
					SET QUERY DESTINATION:C396(Into set:K19:2; "NotIssued")
					QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=[Job_Forms:42]JobFormID:5; *)  //• 5/29/98 cs insure that all records ar avail.
					QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Actual_Qty:14=0)
					SET QUERY DESTINATION:C396(Into current selection:K19:1)
					
					QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=[Job_Forms:42]JobFormID:5)  //• 5/29/98 cs insure that all records ar avail.
					
					
				End if   // END 4D Professional Services : January 2019 query selection
				
				If ($params=0)
					JCOCalcNPrint
				Else 
					JCOCalcNPrint($1)
				End if 
				
				USE SET:C118("Materials")
				
				If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
					
					USE NAMED SELECTION:C332("Production")
					
					
				Else 
					
					CREATE SELECTION FROM ARRAY:C640([Job_Forms_Items:44]; $_Production)
					
					
				End if   // END 4D Professional Services : January 2019 
				USE SET:C118("MachTickets")
				USE SET:C118("RmXfers")
				USE SET:C118("MonthSum")
				USE SET:C118("FGXfers")
				USE SET:C118("Jobs")
				CLEAR SET:C117("NotIssued")
				CLEAR SET:C117("Materials")
				If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
					
					CLEAR NAMED SELECTION:C333("Production")
					
					
				Else 
					
				End if   // END 4D Professional Services : January 2019 
				
				CLEAR SET:C117("MachTickets")
				CLEAR SET:C117("RmXfers")
				CLEAR SET:C117("MonthSum")
				CLEAR SET:C117("FGXfers")
				CLEAR SET:C117("Jobs")
			End if 
		End if 
		
	Else 
		If ($params=0)
			Case of 
				: ([Job_Forms:42]Completed:18=!00-00-00!)
					ALERT:C41("Last Production date NOT entered.."+Char:C90(13)+"Please enter a Last Production date before closing this Jobform.")
				: ([Job_Forms:42]QtyActProduced:35>0)
					ALERT:C41("No Board/Paper issued to this Jobform."+Char:C90(13)+"Please enter amount of Board/Paper cleard before closing this Jobform.")
				Else 
					ALERT:C41("No Actual Production Quantity entered on this Jobform."+Char:C90(13)+"Please enter amount of Actual Production before closing this Jobform.")
			End case 
		End if 
	End if 
End if 