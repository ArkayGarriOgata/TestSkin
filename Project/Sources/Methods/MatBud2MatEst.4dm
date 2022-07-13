//%attributes = {"publishedWeb":true}
//(p) MatEst2MatBud • 7/23/98 cs created
//this assumes we're sitting on a [Job_Forms_Materials] record
//move changes in the material budgets (mostly RMs)
//back into the material estimate file
//this way duplication of Estimates take into concideration
//changes in actual production from original estimation
//only update for Board 01, Ink 02, Coatings 03, or Leaf 05
//IF - the original material code (mostly Ink) is invalid
//  update through out the system
//ELSE - update the specified item & estimate/pspec ONLY
//  for the specific job/estimate/psepc
//mlb 4/6/12 parameter option, some housekeepting

C_TEXT:C284($old_rm; $1; $new_rm; $comm_key)

READ ONLY:C145([Raw_Materials:21])
READ WRITE:C146([Estimates_Materials:29])
READ WRITE:C146([Process_Specs_Materials:56])
MESSAGES OFF:C175

If (Count parameters:C259=1)  //passed in case there was some trickery prior to arriving here
	$old_rm:=$1
Else 
	$old_rm:=Old:C35([Job_Forms_Materials:55]Raw_Matl_Code:7)
End if 

If ($old_rm#"")
	//only update for Board 01, Ink 02, Coatings 03, or Leaf 05
	If ([Job_Forms_Materials:55]Commodity_Key:12="01@") | ([Job_Forms_Materials:55]Commodity_Key:12="02@") | ([Job_Forms_Materials:55]Commodity_Key:12="05@") | ([Job_Forms_Materials:55]Commodity_Key:12="03@")
		QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=$old_rm)
		
		If (Records in selection:C76([Raw_Materials:21])=0)  //* update across database - the old RM code did not exist
			MsgFloatWindow("Updating Estimate materials"+Char:C90(13)+"to match the change just made "+Char:C90(13)+"to budget materials.")
			QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]Raw_Matl_Code:4=$old_rm)
			Repeat 
				APPLY TO SELECTION:C70([Estimates_Materials:29]; ChngMatEst)
			Until (uChkLockedSet(->[Estimates_Materials:29]))
			READ ONLY:C145([Estimates_Materials:29])
			
			MESSAGE:C88(Char:C90(13)+Char:C90(13)+Char:C90(13)+"Updating Process Spec materials"+Char:C90(13)+"to match the change just made"+Char:C90(13)+"to budget materials")
			QUERY:C277([Process_Specs_Materials:56]; [Process_Specs_Materials:56]Raw_Matl_Code:13=$old_rm)
			Repeat 
				APPLY TO SELECTION:C70([Process_Specs_Materials:56]; ChngMatPspec)
			Until (uChkLockedSet(->[Process_Specs_Materials:56]))
			
			MESSAGE:C88(Char:C90(13)+Char:C90(13)+Char:C90(13)+"Updating Current Job materials"+Char:C90(13)+"to match the change just made"+Char:C90(13)+"to budget materials")
			$new_rm:=[Job_Forms_Materials:55]Raw_Matl_Code:7
			$comm_key:=[Job_Forms_Materials:55]Commodity_Key:12
			If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
				
				COPY NAMED SELECTION:C331([Job_Forms_Materials:55]; "Inuse")
				
			Else 
				
				ARRAY LONGINT:C221($_Inuse; 0)
				LONGINT ARRAY FROM SELECTION:C647([Job_Forms_Materials:55]; $_Inuse)
				
			End if   // END 4D Professional Services : January 2019 
			
			QUERY SELECTION:C341([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Raw_Matl_Code:7=$old_rm)
			Repeat 
				APPLY TO SELECTION:C70([Job_Forms_Materials:55]; ChngMatJob($new_rm; $comm_key))
			Until (uChkLockedSet(->[Job_Forms_Materials:55]))
			If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
				
				USE NAMED SELECTION:C332("InUse")
				CLEAR NAMED SELECTION:C333("InUse")
				
			Else 
				
				CREATE SELECTION FROM ARRAY:C640([Job_Forms_Materials:55]; $_Inuse)
				
			End if   // END 4D Professional Services : January 2019 
			
		Else   //* old raw material DID exist this is simply a change from one material to anothe
			MsgFloatWindow("Updating Estimate materials"+Char:C90(13)+"to match the change just made "+Char:C90(13)+"to budget materials.")
			QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]Raw_Matl_Code:4=$old_rm; *)  //locate old material code (could be blank)
			QUERY:C277([Estimates_Materials:29];  & ; [Estimates_Materials:29]EstimateNo:5=Substring:C12([Job_Forms:42]EstimateNo:47; 1; 6)+".@"; *)  //for this jobs estimate - all versions
			QUERY:C277([Estimates_Materials:29];  & ; [Estimates_Materials:29]Commodity_Key:6=Old:C35([Job_Forms_Materials:55]Commodity_Key:12); *)  //verify commodity key
			QUERY:C277([Estimates_Materials:29];  & ; [Estimates_Materials:29]Sequence:12=[Job_Forms_Materials:55]Sequence:3)  //& sequence since sme material may exist in multiple seq.
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
				
				If (Records in selection:C76([Estimates_Materials:29])>1)  //if we find multiple records insure that we get only one/estimate
					ARRAY TEXT:C222($aEstNo; Records in selection:C76([Estimates_Materials:29]))
					CREATE EMPTY SET:C140([Estimates_Materials:29]; "Unique")
					$Count:=1
					
					For ($i; 1; Size of array:C274($aEstNo))
						
						If (Find in array:C230($aEstNo; [Estimates_Materials:29]EstimateNo:5)<0)
							$aEstNo{$Count}:=[Estimates_Materials:29]EstimateNo:5
							ADD TO SET:C119([Estimates_Materials:29]; "Unique")
							$Count:=$Count+1
						End if 
						
						NEXT RECORD:C51([Estimates_Materials:29])
					End for 
					
					ARRAY TEXT:C222($aEstNo; 0)  //clear array
					USE SET:C118("Unique")
					CLEAR SET:C117("Unique")
				End if 
				
			Else 
				
				If (Records in selection:C76([Estimates_Materials:29])>1)  //if we find multiple records insure that we get only one/estimate
					
					ARRAY TEXT:C222($_EstimateNo; 0)
					ARRAY TEXT:C222($_EstimateNo_copie; 0)
					ARRAY LONGINT:C221($_Nb_record_Estimates_Materials; 0)
					ARRAY LONGINT:C221($_Nb_record_Estimates_copie; 0)
					C_LONGINT:C283($Size)
					
					SELECTION TO ARRAY:C260([Estimates_Materials:29]EstimateNo:5; $_EstimateNo; \
						[Estimates_Materials:29]; $_Nb_record_Estimates_Materials)
					
					$Size:=Size of array:C274($_EstimateNo)
					For ($Iter; 1; $Size; 1)
						If (Find in array:C230($_EstimateNo_copie; $_EstimateNo{$Iter})<0)
							
							APPEND TO ARRAY:C911($_EstimateNo_copie; $_EstimateNo{$Iter})
							APPEND TO ARRAY:C911($_Nb_record_Estimates_copie; $_Nb_record_Estimates_Materials{$Iter})
							
						End if 
					End for 
					
					CREATE SELECTION FROM ARRAY:C640([Estimates_Materials:29]; $_Nb_record_Estimates_copie)
				End if 
				
			End if   // END 4D Professional Services : January 2019 query selection
			
			
			Repeat 
				APPLY TO SELECTION:C70([Estimates_Materials:29]; ChngMatEst)
			Until (uChkLockedSet(->[Estimates_Materials:29]))
			
			
			MESSAGE:C88(Char:C90(13)+Char:C90(13)+Char:C90(13)+"Updating Process Spec materials"+Char:C90(13)+"to match the change just made"+Char:C90(13)+"to budget materials")
			QUERY:C277([Process_Specs_Materials:56]; [Process_Specs_Materials:56]Raw_Matl_Code:13=$old_rm; *)
			QUERY:C277([Process_Specs_Materials:56];  & ; [Process_Specs_Materials:56]ProcessSpec:1=[Job_Forms:42]ProcessSpec:46; *)
			QUERY:C277([Process_Specs_Materials:56];  & ; [Process_Specs_Materials:56]Commodity_Key:8=Old:C35([Job_Forms_Materials:55]Commodity_Key:12); *)
			QUERY:C277([Process_Specs_Materials:56];  & ; [Process_Specs_Materials:56]Sequence:4=[Job_Forms_Materials:55]Sequence:3)
			
			If (Records in selection:C76([Process_Specs_Materials:56])>1)  //in the instance where (Inks) a materials occurs more than one
				REDUCE SELECTION:C351([Process_Specs_Materials:56]; 1)  //time we want to ONLY change one occurance    
			End if 
			
			Repeat 
				APPLY TO SELECTION:C70([Process_Specs_Materials:56]; ChngMatPspec)
			Until (uChkLockedSet(->[Process_Specs_Materials:56]))
			
		End if   //old rm exists
		
	End if   //the rite commodities
End if   //old rm specified

READ ONLY:C145([Estimates_Materials:29])
REDUCE SELECTION:C351([Estimates_Materials:29]; 0)
READ ONLY:C145([Process_Specs_Materials:56])
REDUCE SELECTION:C351([Process_Specs_Materials:56]; 0)