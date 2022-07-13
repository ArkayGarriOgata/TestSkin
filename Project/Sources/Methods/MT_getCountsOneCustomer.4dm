//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 06/10/15, 09:55:20
// ----------------------------------------------------
// Method: MT_getCountsOneCustomer
// Description
// based on MT_getCounts
//
// ----------------------------------------------------

C_TEXT:C284($custId; $customer)  // Modified by: Mel Bohince (6/10/15) 
$custId:=Request:C163("Enter Customer ID:"; "00050"; "Continue"; "Cancel")
If (ok=1)
	If (Length:C16($custId)=5)
		$customer:=CUST_getName($custId)
		//[Job_Forms_Machine_Tickets]JobForm
		//[Job_Forms]jobformid
		ARRAY TEXT:C222($aOutput; 0)
		ARRAY TEXT:C222($aCC; 0)
		ARRAY DATE:C224($aDate; 0)  //DateEntered
		ARRAY LONGINT:C221($aQty; 0)
		ARRAY TEXT:C222($aJobs; 0)
		ARRAY TEXT:C222($aJobTypes; 0)
		ARRAY LONGINT:C221($aNumTypes; 0)
		ARRAY LONGINT:C221($aNumSubforms; 0)
		C_LONGINT:C283($numberOfJobs; $numberOfImpressions; $numberOfSubforms; $i)
		C_DATE:C307($dateBegin; $dateEnd)
		C_TEXT:C284($department)
		$baseDate:=Current date:C33
		$dateBegin:=Date:C102("01/01/"+String:C10(Year of:C25($dateEnd)))
		$department:="%"+Uppercase:C13("printing")+"%"
		
		ARRAY LONGINT:C221($aNumberOfImpressions; 0)
		ARRAY LONGINT:C221($aNumberOfJobs; 0)
		ARRAY LONGINT:C221($aNumberOfSubforms; 0)
		ARRAY LONGINT:C221($aSheetsPerJob; 0)
		ARRAY LONGINT:C221($aSheetsPerSubform; 0)
		ARRAY TEXT:C222($aAllJobs; 0)  // Modified by: Mel Bohince (6/10/15) 
		
		For ($year; 0; 2)
			
			$dateEnd:=Add to date:C393($baseDate; (-1*$year); 0; 0)
			
			$dateBegin:=Date:C102("01/01/"+String:C10(Year of:C25($dateEnd)))
			$department:="%"+Uppercase:C13("printing")+"%"
			
			// Modified by: Mel Bohince (6/10/15) find a floor jobform so results don't go to begining of time
			Begin SQL
				
				select distinct JobForm
				from Job_Forms_Machine_Tickets
				where DateEntered between :$dateBegin and :$dateEnd and Good_Units>0 and CostCenterID in(SELECT distinct(ID)from Cost_Centers where cc_Group like :$department)
				and JobForm not like '020%'
				ORDER BY JobForm 
				into   :$aAllJobs;
				
			End SQL
			$lowJobNumber:=$aAllJobs{1}
			
			
			Begin SQL
				
				select sum(Good_Units)
				from Job_Forms_Machine_Tickets
				where DateEntered between :$dateBegin and :$dateEnd and Good_Units>0 and CostCenterID in(SELECT distinct(ID)from Cost_Centers where cc_Group like :$department)
				and JobForm in (select JobFormID from Job_Forms where cust_id = :$custId and JobFormID >= :$lowJobNumber)
				into  :$numberOfImpressions;
				
			End SQL
			APPEND TO ARRAY:C911($aNumberOfImpressions; $numberOfImpressions)
			
			
			
			Begin SQL
				
				select distinct JobForm
				from Job_Forms_Machine_Tickets
				where DateEntered between :$dateBegin and :$dateEnd and Good_Units>0 and CostCenterID in(SELECT distinct(ID)from Cost_Centers where cc_Group like :$department)
				and JobForm in (select JobFormID from Job_Forms where cust_id = :$custId and JobFormID >= :$lowJobNumber)
				into   :$aJobs;
				
			End SQL
			$NumberOfJobs:=Size of array:C274($aJobs)
			APPEND TO ARRAY:C911($aNumberOfJobs; $NumberOfJobs)
			
			//[Job_Forms]SubForms
			//[Job_Forms]cust_id
			//[Job_Forms]JobFormID
			Begin SQL
				
				select  SubForms
				from Job_Forms
				where StartDate between :$dateBegin and :$dateEnd and JobType not in ('7 Liners', '8 Misc') and cust_id = :$custId
				into   :$aNumSubforms;
				
			End SQL
			$numberOfSubforms:=0
			For ($i; 1; Size of array:C274($aNumSubforms))
				If ($aNumSubforms{$i}=0)
					$numberOfSubforms:=$numberOfSubforms+1
				Else 
					$numberOfSubforms:=$numberOfSubforms+$aNumSubforms{$i}
				End if 
			End for 
			APPEND TO ARRAY:C911($aNumberOfSubforms; $numberOfSubforms)
			
			$sheetsPerJob:=Round:C94($numberOfImpressions/$NumberOfJobs; 0)
			APPEND TO ARRAY:C911($aSheetsPerJob; $sheetsPerJob)
			$sheetsPerSubform:=Round:C94($numberOfImpressions/$numberOfSubforms; 0)
			APPEND TO ARRAY:C911($aSheetsPerSubform; $sheetsPerSubform)
			
			//[Job_Forms]JobType
			Begin SQL
				
				select  JobType, count(*)
				from Job_Forms
				where StartDate between :$dateBegin and :$dateEnd and JobType not in ('3 Prod', '7 Liners', '8 Misc') and cust_id = :$custId
				group BY JobType 
				into   :$aJobTypes, :$aNumTypes;
				
			End SQL
			
			
			APPEND TO ARRAY:C911($aOutput; "===")
			APPEND TO ARRAY:C911($aOutput; "YTD: "+String:C10(Year of:C25($dateEnd)))
			APPEND TO ARRAY:C911($aOutput; "  Number of Impressions: "+String:C10($numberOfImpressions; "###,###,###,##0"))
			APPEND TO ARRAY:C911($aOutput; "  Number of Jobs: "+String:C10($NumberOfJobs; "###,###,###,##0")+"     @ "+"Sheets/Job: "+String:C10($sheetsPerJob; "###,###,###,##0"))
			APPEND TO ARRAY:C911($aOutput; "  Number of Subforms: "+String:C10($numberOfSubforms; "###,###,###,##0")+"  @ "+"Sheets/Subform: "+String:C10($sheetsPerSubform; "###,###,###,##0"))
			APPEND TO ARRAY:C911($aOutput; "---")
			APPEND TO ARRAY:C911($aOutput; "Counts of non-production jobs:")
			//utl_LogIt ("Sheets/Subform: "+string($sheetsPerSubform))
			//utl_LogIt ("Sheets/Job: "+String($sheetsPerJob))
			For ($i; 1; Size of array:C274($aJobTypes))
				APPEND TO ARRAY:C911($aOutput; $aJobTypes{$i}+": "+String:C10($aNumTypes{$i}))
			End for 
			
			APPEND TO ARRAY:C911($aOutput; " ")
			
		End for 
		
		ARRAY TEXT:C222($aSummary; 0)
		APPEND TO ARRAY:C911($aSummary; "### "+$customer+" ###")
		APPEND TO ARRAY:C911($aSummary; "===")
		APPEND TO ARRAY:C911($aSummary; "Compared to last year:")
		$delta:=Round:C94((($aNumberOfJobs{1}-$aNumberOfJobs{2})/$aNumberOfJobs{2})*100; 0)
		If ($delta>=0)
			$blurb:=" increased by "+String:C10($delta)
		Else 
			$blurb:=" decreased by "+String:C10(Abs:C99($delta))
		End if 
		APPEND TO ARRAY:C911($aSummary; "  Number of jobs has"+$blurb+"%")
		
		$delta:=Round:C94((($aNumberOfSubforms{1}-$aNumberOfSubforms{2})/$aNumberOfSubforms{2})*100; 0)
		If ($delta>=0)
			$blurb:=" increased by "+String:C10($delta)
		Else 
			$blurb:=" decreased by "+String:C10(Abs:C99($delta))
		End if 
		APPEND TO ARRAY:C911($aSummary; "  Number of make readies has"+$blurb+"%")
		
		$delta:=Round:C94((($aSheetsPerJob{1}-$aSheetsPerJob{2})/$aSheetsPerJob{2})*100; 0)
		If ($delta>=0)
			$blurb:=" increased by "+String:C10($delta)
		Else 
			$blurb:=" decreased by "+String:C10(Abs:C99($delta))
		End if 
		APPEND TO ARRAY:C911($aSummary; "  Sheets per job has"+$blurb+"%")
		
		$delta:=Round:C94((($aSheetsPerSubform{1}-$aSheetsPerSubform{2})/$aSheetsPerSubform{2})*100; 0)
		If ($delta>=0)
			$blurb:=" increased by "+String:C10($delta)
		Else 
			$blurb:=" decreased by "+String:C10(Abs:C99($delta))
		End if 
		APPEND TO ARRAY:C911($aSummary; "  Sheets per subform has"+$blurb+"%")
		
		APPEND TO ARRAY:C911($aSummary; " ")
		///////////////////////////////////
		
		APPEND TO ARRAY:C911($aSummary; "===")
		APPEND TO ARRAY:C911($aSummary; "Compared to the year before last:")
		$delta:=Round:C94((($aNumberOfJobs{1}-$aNumberOfJobs{3})/$aNumberOfJobs{3})*100; 0)
		If ($delta>=0)
			$blurb:=" increased by "+String:C10($delta)
		Else 
			$blurb:=" decreased by "+String:C10(Abs:C99($delta))
		End if 
		APPEND TO ARRAY:C911($aSummary; "  Number of jobs has"+$blurb+"%")
		
		$delta:=Round:C94((($aNumberOfSubforms{1}-$aNumberOfSubforms{3})/$aNumberOfSubforms{3})*100; 0)
		If ($delta>=0)
			$blurb:=" increased by "+String:C10($delta)
		Else 
			$blurb:=" decreased by "+String:C10(Abs:C99($delta))
		End if 
		APPEND TO ARRAY:C911($aSummary; "  Number of make readies has"+$blurb+"%")
		
		$delta:=Round:C94((($aSheetsPerJob{1}-$aSheetsPerJob{3})/$aSheetsPerJob{3})*100; 0)
		If ($delta>=0)
			$blurb:=" increased by "+String:C10($delta)
		Else 
			$blurb:=" decreased by "+String:C10(Abs:C99($delta))
		End if 
		APPEND TO ARRAY:C911($aSummary; "  Sheets per job has"+$blurb+"%")
		
		$delta:=Round:C94((($aSheetsPerSubform{1}-$aSheetsPerSubform{3})/$aSheetsPerSubform{3})*100; 0)
		If ($delta>=0)
			$blurb:=" increased by "+String:C10($delta)
		Else 
			$blurb:=" decreased by "+String:C10(Abs:C99($delta))
		End if 
		APPEND TO ARRAY:C911($aSummary; "  Sheets per subform has"+$blurb+"%")
		
		APPEND TO ARRAY:C911($aSummary; " ")
		
		utl_LogIt("init")
		For ($i; 1; Size of array:C274($aSummary))
			utl_LogIt($aSummary{$i})
		End for 
		For ($i; 1; Size of array:C274($aOutput))
			utl_LogIt($aOutput{$i})
		End for 
		utl_LogIt("show")
		
	Else 
		ALERT:C41("Customer Id's are 5 digits long")
	End if 
End if 
