//%attributes = {}

// Method: JMI_setGlueDuration (emaildistribution; {jobform })  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 03/26/14, 15:45:34
// ----------------------------------------------------
// Description
// allocate the gluing operation across all uncompleted jobit
// unless duration has already been set
// A 1 month planning fence is used to limit num of records
// ----------------------------------------------------

C_LONGINT:C283($i; $numElements)
C_REAL:C285($ttl_hrs; $mr; $run)
C_LONGINT:C283($ttl_units)
C_TEXT:C284($1)
C_TEXT:C284($2)
READ WRITE:C146([Job_Forms_Items:44])
READ ONLY:C145([Job_Forms_Machines:43])
$preheader:="For uncompleted jobits with a HRD in the next month, set their duration based on an allocation of the gluing MR and Run"

Case of 
	: (Count parameters:C259=1)
		$distributionList:=$1
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39=!00-00-00!; *)  //these will be the items that need the duration set
		QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]MAD:37#!00-00-00!; *)  //establish a 1 month planning fence
		QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]MAD:37<=(Add to date:C393(4D_Current_date; 0; 1; 0)); *)  //establish a 1 month planning fence
		//QUERY([Job_Forms_Items]; & ;[Job_Forms_Items]Gluer#"9xx";*) //see PSG_NotGlued
		QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]GlueRate:52=0)
		
	: (Count parameters:C259=2)
		$distributionList:=$1
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$2)  //overrite
		
	Else 
		$distributionList:=Email_WhoAmI
		QUERY:C277([Job_Forms_Items:44])
End case 


If (Records in selection:C76([Job_Forms_Items:44])>0)
	$gluer_ids:=txt_Trim(<>GLUERS)  //load all gluers in an array for a build query below
	$cnt_of_gluers:=Num:C11(util_TextParser(16; $gluer_ids; Character code:C91(" "); 13))
	
	DISTINCT VALUES:C339([Job_Forms_Items:44]JobForm:1; $aJobForm)  //visit each form once
	$numElements:=Size of array:C274($aJobForm)
	$numItemsUpdate:=0
	$backlogAdded:=0
	uThermoInit($numElements; "Processing Array")
	For ($form; 1; $numElements)
		$jobform:=$aJobForm{$form}
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$jobform)
		If (Position:C15([Job_Forms:42]Status:6; " Released WIP ")>0)
			//find the glue sequences in this form's budget
			QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=$jobform)
			QUERY SELECTION:C341([Job_Forms_Machines:43]; [Job_Forms_Machines:43]CostCenterID:4=util_TextParser(1); *)
			For ($gluer; 2; $cnt_of_gluers)
				QUERY SELECTION:C341([Job_Forms_Machines:43];  | ; [Job_Forms_Machines:43]CostCenterID:4=util_TextParser($gluer); *)
			End for 
			QUERY SELECTION:C341([Job_Forms_Machines:43])
			
			If (Records in selection:C76([Job_Forms_Machines:43])>0)  //some gluer(s) specified
				$mr:=Sum:C1([Job_Forms_Machines:43]Planned_MR_Hrs:15)
				$run:=Sum:C1([Job_Forms_Machines:43]Planned_RunHrs:37)
				$ttl_hrs:=$mr+$run
				
				QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$jobform)  //find the items on this form 
				If (Records in selection:C76([Job_Forms_Items:44])>0)
					If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
						$ttl_units:=Sum:C1([Job_Forms_Items:44]Qty_Want:24)
						
						FIRST RECORD:C50([Job_Forms_Items:44])
					Else 
						
						$ttl_units:=Sum:C1([Job_Forms_Items:44]Qty_Want:24)
						
						// the sum don' t change the order after query 
						
					End if   // END 4D Professional Services : January 2019 First record
					// 4D Professional Services : after Order by , query or any query type you don't need First record  
					
					$allc_hrs:=0
					While (Not:C34(End selection:C36([Job_Forms_Items:44])))
						$allocation:=util_roundUp(($ttl_hrs*([Job_Forms_Items:44]Qty_Want:24/$ttl_units)))
						If ([Job_Forms_Items:44]GlueRate:52=0) & ([Job_Forms_Items:44]Completed:39=!00-00-00!)  //don't over-rite manual entries or done jobs
							[Job_Forms_Items:44]GlueRate:52:=$allocation  //allocate based on percent of cartons
							$numItemsUpdate:=$numItemsUpdate+1
							$backlogAdded:=$backlogAdded+$allocation
							SAVE RECORD:C53([Job_Forms_Items:44])
						End if 
						$allc_hrs:=$allc_hrs+$allocation  //for a checksum
						//
						NEXT RECORD:C51([Job_Forms_Items:44])
					End while 
					
					//ASSERT(round($allc_hrs;1)=round($ttl_hrs;1);"allocation off by "+string($allc_hrs-$ttl_hrs))
					
				Else 
					//utl_Logfile ("setglue.log";"no items "+$jobform)
				End if   //items
				
			Else 
				//utl_Logfile ("setglue.log";"no gluers "+$jobform)
				QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$jobform)  //find the items on this form 
				If (Records in selection:C76([Job_Forms_Items:44])>0)
					If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
						
						FIRST RECORD:C50([Job_Forms_Items:44])
						While (Not:C34(End selection:C36([Job_Forms_Items:44])))
							If ([Job_Forms_Items:44]Completed:39=!00-00-00!)  //don't over-rite manual entries or done jobs
								[Job_Forms_Items:44]Gluer:47:="9xx"
								SAVE RECORD:C53([Job_Forms_Items:44])
							End if 
							NEXT RECORD:C51([Job_Forms_Items:44])
						End while 
						
						
					Else 
						
						// we have query previous
						
						ARRAY LONGINT:C221($_Job_Forms_Items; 0)
						SELECTION TO ARRAY:C260([Job_Forms_Items:44]; $_Job_Forms_Items)
						QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39=!00-00-00!)
						
						APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]Gluer:47:="9xx")
						
						CREATE SELECTION FROM ARRAY:C640([Job_Forms_Items:44]; $_Job_Forms_Items)
					End if   // END 4D Professional Services : January 2019 First record
					// 4D Professional Services : after Order by , query or any query type you don't need First record  
				End if 
				
			End if   //gluers
			
		Else 
			//utl_Logfile ("setglue.log";"wrong status "+$jobform+" "+[Job_Forms]Status)
		End if   //form was released
		
		uThermoUpdate($form)
	End for 
	uThermoClose
	util_TextParser
	
	
	$body:="Criteria: Form status Released or WIP, HRD this month, Duration currently zero.  "+String:C10($numItemsUpdate)+" items updated, "+String:C10($backlogAdded)+" hrs added to backlog.  "+"<br><br>View on Glue Schedule."
	//EMAIL_Sender ("JMI_setGlueDuration "+String($numElements)+" forms checked";"";$body;$distributionList)
	Email_html_body("JMI_setGlueDuration "+String:C10($numElements)+" forms checked"; $preheader; $body; 500; $distributionList)
	
End if   //unset glue items
