//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 02/16/06, 14:56:25
// ----------------------------------------------------
// Method: JMI_CheckControlNumber
// ---------------------------------------------------
// Modified by: Mel Bohince (5/4/20) remove 2nd call to Batch_GetDistributionList, looks like a mistake

C_TEXT:C284($jobsAffected; $1; $controlNumber)
If (Count parameters:C259=1)
	$controlNumber:=$1
Else   //debug
	$controlNumber:="C156131"
End if 

If (Length:C16($controlNumber)>1)
	READ ONLY:C145([Job_Forms_Items:44])
	READ ONLY:C145([Job_Forms:42])
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ControlNumber:26=$controlNumber; *)
	QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Completed:39=!00-00-00!)
	$jobsAffected:=""
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		
		For ($i; 1; Records in selection:C76([Job_Forms_Items:44]))
			If (Position:C15([Job_Forms_Items:44]Jobit:4; $jobsAffected)=0)  //havent already included
				
				RELATE ONE:C42([Job_Forms_Items:44]JobForm:1)
				If (Position:C15([Job_Forms:42]Status:6; " WIP Released ")>0)
					$jobsAffected:=$jobsAffected+[Job_Forms_Items:44]Jobit:4+" "
				End if 
			End if 
			NEXT RECORD:C51([Job_Forms_Items:44])
		End for 
		
		
	Else 
		
		GET FIELD RELATION:C920([Job_Forms_Items:44]JobForm:1; $lienAller; $lienRetour)
		SET FIELD RELATION:C919([Job_Forms_Items:44]JobForm:1; Automatic:K51:4; Do not modify:K51:1)
		
		ARRAY TEXT:C222($_Jobit; 0)
		ARRAY TEXT:C222($_JobForm; 0)
		ARRAY TEXT:C222($_JobFormID; 0)
		ARRAY TEXT:C222($_Status; 0)
		
		SELECTION TO ARRAY:C260([Job_Forms_Items:44]Jobit:4; $_Jobit; [Job_Forms_Items:44]JobForm:1; $_JobForm; [Job_Forms:42]JobFormID:5; $_JobFormID; [Job_Forms:42]Status:6; $_Status)
		
		SET FIELD RELATION:C919([Job_Forms_Items:44]JobForm:1; $lienAller; $lienRetour)
		
		
		For ($i; 1; Size of array:C274($_Jobit); 1)
			If (Position:C15($_Jobit{$i}; $jobsAffected)=0)
				If (Position:C15($_Status{$i}; " WIP Released ")>0)
					$jobsAffected:=$jobsAffected+$_Jobit{$i}+" "
				End if 
			End if 
		End for 
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	If (Length:C16($jobsAffected)>0)  //send warning
		$body:="There has been a Control Number revision that may affect the following jobitems: "
		$body:=$body+$jobsAffected+". Any Jobbags that have been printed are out of date. You have been warned."
		$body:=$body
		User_ResolveInitials(<>zResp)
		$from:=Email_WhoAmI(""; <>zResp)
		$t:=Char:C90(9)
		distribution:=Batch_GetDistributionList(""; "PREPRESS")
		//distribution:="mel.bohince@arkay.com"
		//EMAIL_Sender ("WARNING: New Control Number";"";$body;distribution;"";$from;$from)
		$preheader:="JMI_CheckControlNumber noticed "+$controlNumber+" change"
		Email_html_body("WARNING: New Control Number"; $preheader; $body; 500; distributionList; ""; $from; $from)
	End if 
	
	//Batch_GetDistributionList   // Modified by: Mel Bohince (5/4/20) remove this, looks like a mistake
End if 