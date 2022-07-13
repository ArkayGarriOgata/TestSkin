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
// Modified by: Mel Bohince (5/5/19) change GlueDuration to GlueRate  (/1000)
// Modified by: Mel Bohince (1/28/20) force overrite of existing GlueRate

C_LONGINT:C283($i; $numElements)
C_REAL:C285($rate)
C_TEXT:C284($1; $2; $3)

READ WRITE:C146([Job_Forms_Items:44])
READ ONLY:C145([Job_Forms_Machines:43])
$preheader:="For uncompleted jobits with a HRD , set their duration based on job machine record"  // Modified by: Mel Bohince (5/5/19) 
Case of 
	: (Count parameters:C259=1)
		$distributionList:=$1
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39=!00-00-00!)  //;*)  //these will be the items that need the rate set
		//QUERY([Job_Forms_Items]; & ;[Job_Forms_Items]MAD#!00-00-00!;*)  //scheduled
		// Modified by: Mel Bohince (1/28/20) force overrite of existing GlueRate
		//QUERY([Job_Forms_Items]; & ;[Job_Forms_Items]GlueRate=0)  //not already set
		
	: (Count parameters:C259=2)
		$distributionList:=$1
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$2)  //overrite
		
	: (Count parameters:C259=3)  //retrofit old duration calc
		$distributionList:="mel.bohince@arkay.com"
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39=!00-00-00!)  //these will be the items that need the duration changed
		//QUERY([Job_Forms_Items]; & ;[Job_Forms_Items]GlueRate>0)  //not already set
		
	Else 
		$distributionList:=Email_WhoAmI
		QUERY:C277([Job_Forms_Items:44])
End case 


If (Records in selection:C76([Job_Forms_Items:44])>0)  // reason to continue
	// Modified by: Mel Bohince (5/5/19) 
	DISTINCT VALUES:C339([Job_Forms_Items:44]JobForm:1; $aJobForm)  //visit items on each form once
	REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)  //done with candidtates, will go form by form next
	
	$numElements:=Size of array:C274($aJobForm)
	uThermoInit($numElements; "Processing Array")
	
	For ($form; 1; $numElements)
		If ($aJobForm{$form}="13555.03")
			
		End if 
		///get the gluers' machine record
		QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=$aJobForm{$form})
		QUERY SELECTION WITH ARRAY:C1050([Job_Forms_Machines:43]CostCenterID:4; <>aGLUERS)
		If (Records in selection:C76([Job_Forms_Machines:43])>0)  //otherwise treat as o/s
			$rate:=[Job_Forms_Machines:43]Planned_RunRate:36/1000  //grab the rate, could be more than one, but unlikely
			REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
			
			If (Count parameters:C259<3)  //normal run
				QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$aJobForm{$form}; *)
				QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Completed:39=!00-00-00!; *)
				QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]MAD:37#!00-00-00!)  //;*)
				//QUERY([Job_Forms_Items]; & ;[Job_Forms_Items]GlueRate=0)
				
			Else   //retrofit duration
				QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$aJobForm{$form}; *)
				QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Completed:39=!00-00-00!)
			End if 
			
			If (Records in selection:C76([Job_Forms_Items:44])>0)
				ARRAY REAL:C219($aGlueRate; 0)
				SELECTION TO ARRAY:C260([Job_Forms_Items:44]GlueRate:52; $aGlueRate)
				$numItemsUpdate:=Size of array:C274($aGlueRate)
				
				For ($i; 1; $numItemsUpdate)
					$aGlueRate{$i}:=$rate
				End for 
				ARRAY TO SELECTION:C261($aGlueRate; [Job_Forms_Items:44]GlueRate:52)
				
			End if 
			
		Else   //not glued, set to o/s number
			//If (Count parameters<3)  //normal run
			//QUERY([Job_Forms_Items];[Job_Forms_Items]JobForm=$aJobForm{$form};*)
			//QUERY([Job_Forms_Items]; & ;[Job_Forms_Items]Completed=!00-00-00!;*)
			//QUERY([Job_Forms_Items]; & ;[Job_Forms_Items]MAD#!00-00-00!;*)
			//QUERY([Job_Forms_Items]; & ;[Job_Forms_Items]Gluer="";*)
			//QUERY([Job_Forms_Items]; & ;[Job_Forms_Items]GlueRate=0)
			
			//Else   //retrofit duration
			//QUERY([Job_Forms_Items];[Job_Forms_Items]JobForm=$aJobForm{$form};*)
			//QUERY([Job_Forms_Items]; & ;[Job_Forms_Items]Completed=!00-00-00!;*)
			//QUERY([Job_Forms_Items]; & ;[Job_Forms_Items]Gluer="")
			//End if 
			
			//if(Records in selection([Job_Forms_Items])>0)
			//SELECTION TO ARRAY([Job_Forms_Items]Gluer;$_aGluer)
			//$numItemsUpdate:=Size of array($_aGluer)
			
			//For ($i;1;$numItemsUpdate)
			//$_aGluer:="9xx"
			//End for 
			//ARRAY TO SELECTION($_aGluer;[Job_Forms_Items]Gluer)
			//End if 
			
		End if 
		
		uThermoUpdate($form)
	End for   //form
	uThermoClose
	
	// Modified by: Mel Bohince (5/5/19) 
	$body:="Criteria: Form status Released or WIP, HRD this month, Rate currently zero.  "+String:C10($numItemsUpdate)+" items updated."+"<br><br>View on Glue Schedule."
	Email_html_body("JMI_setGlueRate "; $preheader; $body; 500; $distributionList)  // Modified by: Mel Bohince (5/5/19) 
	
	REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
	
End if   //jobits found
