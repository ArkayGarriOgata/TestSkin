//%attributes = {"publishedWeb":true}
//PM: JOB_CloseoutSummary() -> 
//@author mlb - 8/22/01  15:55
//• mlb - 9/19/01  changes and deletions
//• mlb - 5/15/02  10:33 add date and type
// Modified by: Mark Zinke (1/22/14) Removed and reordered columns.
// Modified by: Mel Bohince (2/26/14) add Jobtype back in
// Modified by: Mel Bohince (9/9/15) dont report on r&d proof and line trails
C_DATE:C307(dDateBegin; $4; dDateEnd; $5)
C_TEXT:C284($customer)
C_TEXT:C284($client_call_back; $1; $methodNameOnClient; $2; docName; $3)
C_TEXT:C284($t; $r)
$t:=Char:C90(9)
$r:=Char:C90(13)

// // // // // // // // // // // // // //
//server-side
// build a docName
C_TEXT:C284($1; $client_call_back; $docShortName; docName)

Case of 
	: (Count parameters:C259>=2)
		$client_call_back:=$1
		If (Length:C16($client_call_back)>0)
			$methodNameOnClient:=$2  // or distribution list for email
			docName:=$3  //************UNCOmMENT when used, just so patter can comple
			dDateBegin:=$4
			dDateEnd:=$5
			
		Else 
			$distributionList:=$2
			docName:="JobSummaryRpt_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
			dDateBegin:=$4
			dDateEnd:=$5
		End if 
		
		$customer:="@"
		OK:=1
		bSearch:=0
		
	Else 
		dDateBegin:=!00-00-00!
		dDateEnd:=!00-00-00!
		$customer:="@"
		DIALOG:C40([zz_control:1]; "DateRange2")
		$client_call_back:=""
		$methodNameOnClient:=""
		$distributionList:=""
		docName:="JobSummaryRpt_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
End case 


//TRACE
$docShortName:=docName  //capture before path is prepended
C_TIME:C306($docRef)
$docRef:=util_putFileName(->docName)
C_BLOB:C604($blob)
SET BLOB SIZE:C606($blob; 0)
If (Count parameters:C259>=2)
	If (Length:C16($client_call_back)>0)
		utl_Logfile("benchmark.log"; Current method name:C684+": "+$1+", "+$2+", "+$3+", "+String:C10($4; System date short:K1:1)+", "+String:C10($5; System date short:K1:1))
	End if 
End if 

If (OK=1)
	xText:=""
	If (bSearch=0)
		QUERY:C277([Job_Forms_CloseoutSummaries:87]; [Job_Forms_CloseoutSummaries:87]CloseDate:19>=dDateBegin; *)
		QUERY:C277([Job_Forms_CloseoutSummaries:87];  & ; [Job_Forms_CloseoutSummaries:87]CloseDate:19<=dDateEnd; *)
		QUERY:C277([Job_Forms_CloseoutSummaries:87];  & ; [Job_Forms_CloseoutSummaries:87]Customer:2=$customer)
		xTitle:="Job Close-Outs for the period from "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1)+" and Customer = "+$customer
		
	Else 
		QUERY:C277([Job_Forms_CloseoutSummaries:87])
		xTitle:="Job Close-Outs for user-selected records"
	End if 
	
	$numJCS:=Records in selection:C76([Job_Forms_CloseoutSummaries:87])
	
	xText:=xText+xTitle+$r+$r
	
	xText:=xText+$t+"JobForm"+$t+"JobType"+$t+"Customer"+$t+"Line"+$t+"Actual Qty Produced"+$t+"Sales $ Actual"+$t+"Mat'l $ Actual"+$t+"Conv $ Actual"
	xText:=xText+$t+"Total Mfg Actual"+$t+"Contrib Actual"+$t+"PV Actual"+$t+"Contr Var to Bud (Unfav)"+$t+"Contr Budget"+$r
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		
		ORDER BY:C49([Job_Forms_CloseoutSummaries:87]; [Job_Forms_CloseoutSummaries:87]Customer:2; >; [Job_Forms_CloseoutSummaries:87]Line:3; >; [Job_Forms_CloseoutSummaries:87]JobForm:1; >)
		uThermoInit($numJCS; "job closeout summary")
		For ($i; 1; $numJCS)
			If (Length:C16(xText)>28000)  //flush the buffer
				SEND PACKET:C103($docRef; xText)
				xText:=""
			End if 
			RELATE ONE:C42([Job_Forms_CloseoutSummaries:87]JobForm:1)
			//xText:=xText+String([Job_Forms_CloseoutSummaries]CloseDate;System date short)+$t+[Job_Forms_CloseoutSummaries]JobForm+$t+[Job_Forms]JobType+$t+[Job_Forms_CloseoutSummaries]Customer+$t+[Job_Forms_CloseoutSummaries]Line  //5
			//xText:=xText+$t+String([Job_Forms_CloseoutSummaries]QtyProduced)+$t+String([Job_Forms_CloseoutSummaries]QtyBudgeted)  //+$t+String(([JobCloseSum]QtyProduced-[JobCloseSum]QtyBudgeted))
			//xText:=xText+$t+String([Job_Forms_CloseoutSummaries]TotalMaterial)+$t+String([Job_Forms_CloseoutSummaries]BudgetedMaterial)+$t+String([Job_Forms_CloseoutSummaries]TotalMaterial-[Job_Forms_CloseoutSummaries]BudgetedMaterial)+$t+String(Round(([Job_Forms_CloseoutSummaries]TotalMaterial-[Job_Forms_CloseoutSummaries]BudgetedMaterial)/[Job_Forms_CloseoutSummaries]BudgetedMaterial*100;0))
			//xText:=xText+$t+String([Job_Forms_CloseoutSummaries]TotalConversion)+$t+String([Job_Forms_CloseoutSummaries]BudgetedConversion)+$t+String([Job_Forms_CloseoutSummaries]TotalConversion-[Job_Forms_CloseoutSummaries]BudgetedConversion)+$t+String(Round(([Job_Forms_CloseoutSummaries]TotalConversion-[Job_Forms_CloseoutSummaries]BudgetedConversion)/[Job_Forms_CloseoutSummaries]BudgetedConversion*100;0))
			//xText:=xText+$t+String([Job_Forms_CloseoutSummaries]TotalCost)+$t+String([Job_Forms_CloseoutSummaries]BudgetedTotalCost)+$t+String([Job_Forms_CloseoutSummaries]TotalCost-[Job_Forms_CloseoutSummaries]BudgetedTotalCost)+$t+String([Job_Forms_CloseoutSummaries]ActSP)+$t+String([Job_Forms_CloseoutSummaries]BookSP)  //+$r
			//xText:=xText+$t+String([Job_Forms_CloseoutSummaries]ActContrib)+$t+String([Job_Forms_CloseoutSummaries]BookContrib)+$t+String([Job_Forms_CloseoutSummaries]ActPV)+$t+String([Job_Forms_CloseoutSummaries]BookPV)+$r
			
			
			Case of 
				: ([Job_Forms:42]JobType:33="2@")  // Proof")
					//pass
				: ([Job_Forms:42]JobType:33="3 COMPONENT")  // Modified by: Mel Bohince (3/7/17) 
					//pass
				: ([Job_Forms:42]JobType:33="4@")  // Do Over")
					//pass
				: ([Job_Forms:42]JobType:33="5@")  // Line Trial")
					//pass
				: ([Job_Forms:42]JobType:33="6@")  // R & D")
					//pass
					
				Else   //3 production, 3 assembly, 9 Paid P/LT
					//If (Position(Substring([Job_Forms]JobType;1;1);" 3 9")>0)  //([Job_Forms]JobType="3 Prod")  // Modified by: Mel Bohince (9/9/15) dont report on r&d proof and line trails
					xText:=xText+$t+[Job_Forms_CloseoutSummaries:87]JobForm:1+$t+[Job_Forms:42]JobType:33+$t+[Job_Forms_CloseoutSummaries:87]Customer:2+$t+[Job_Forms_CloseoutSummaries:87]Line:3+$t+String:C10([Job_Forms_CloseoutSummaries:87]QtyProduced:23)
					xText:=xText+$t+String:C10(Round:C94([Job_Forms_CloseoutSummaries:87]ActSP:18; 0))+$t+String:C10([Job_Forms_CloseoutSummaries:87]TotalMaterial:20)+$t+String:C10([Job_Forms_CloseoutSummaries:87]TotalConversion:21)
					xText:=xText+$t+String:C10([Job_Forms_CloseoutSummaries:87]TotalCost:22)+$t+String:C10(Round:C94([Job_Forms_CloseoutSummaries:87]ActContrib:14; 0))+$t+String:C10([Job_Forms_CloseoutSummaries:87]ActPV:15)+$t+String:C10(Round:C94([Job_Forms_CloseoutSummaries:87]ActContrib:14-[Job_Forms_CloseoutSummaries:87]BookContrib:12; 0))+$t+String:C10(Round:C94([Job_Forms_CloseoutSummaries:87]BookContrib:12; 0))+$r
			End case 
			
			uThermoUpdate($i)
			NEXT RECORD:C51([Job_Forms_CloseoutSummaries:87])
		End for 
		uThermoClose
		
	Else 
		
		ARRAY TEXT:C222($_Customer; 0)
		ARRAY TEXT:C222($_Line; 0)
		ARRAY TEXT:C222($_JobForm; 0)
		ARRAY TEXT:C222($_JobFormID; 0)
		ARRAY TEXT:C222($_JobType; 0)
		ARRAY LONGINT:C221($_QtyProduced; 0)
		ARRAY REAL:C219($_TotalMaterial; 0)
		ARRAY REAL:C219($_TotalConversion; 0)
		ARRAY REAL:C219($_TotalCost; 0)
		ARRAY REAL:C219($_ActContrib; 0)
		ARRAY REAL:C219($_ActPV; 0)
		ARRAY REAL:C219($_ActSP; 0)
		ARRAY REAL:C219($_BookContrib; 0)
		
		GET FIELD RELATION:C920([Job_Forms_CloseoutSummaries:87]JobForm:1; $lienAller; $lienRetour)
		SET FIELD RELATION:C919([Job_Forms_CloseoutSummaries:87]JobForm:1; Automatic:K51:4; Do not modify:K51:1)
		
		
		SELECTION TO ARRAY:C260([Job_Forms_CloseoutSummaries:87]Customer:2; $_Customer; [Job_Forms_CloseoutSummaries:87]Line:3; $_Line; [Job_Forms_CloseoutSummaries:87]JobForm:1; $_JobForm; [Job_Forms:42]JobFormID:5; $_JobFormID; [Job_Forms:42]JobType:33; $_JobType; [Job_Forms_CloseoutSummaries:87]QtyProduced:23; $_QtyProduced; [Job_Forms_CloseoutSummaries:87]TotalMaterial:20; $_TotalMaterial; [Job_Forms_CloseoutSummaries:87]TotalConversion:21; $_TotalConversion; [Job_Forms_CloseoutSummaries:87]TotalCost:22; $_TotalCost; [Job_Forms_CloseoutSummaries:87]ActContrib:14; $_ActContrib; [Job_Forms_CloseoutSummaries:87]ActPV:15; $_ActPV; [Job_Forms_CloseoutSummaries:87]ActSP:18; $_ActSP; [Job_Forms_CloseoutSummaries:87]BookContrib:12; $_BookContrib)
		
		SET FIELD RELATION:C919([Job_Forms_CloseoutSummaries:87]JobForm:1; $lienAller; $lienRetour)
		
		
		SORT ARRAY:C229($_Customer; $_Line; $_JobForm; $_JobFormID; $_JobType; $_QtyProduced; $_TotalMaterial; $_TotalConversion; $_TotalCost; $_ActContrib; $_ActPV; $_ActSP; $_BookContrib; >)
		
		uThermoInit($numJCS; "job closeout summary")
		For ($i; 1; $numJCS; 1)
			If (Length:C16(xText)>28000)  //flush the buffer
				SEND PACKET:C103($docRef; xText)
				xText:=""
			End if 
			
			Case of 
				: ($_JobType{$i}="2@")  // Proof")
					//pass
				: ($_JobType{$i}="3 COMPONENT")  // Modified by: Mel Bohince (3/7/17) 
					//pass
				: ($_JobType{$i}="4@")  // Do Over")
					//pass
				: ($_JobType{$i}="5@")  // Line Trial")
					//pass
				: ($_JobType{$i}="6@")  // R & D")
					//pass
					
				Else 
					
					xText:=xText+$t+$_JobForm{$i}+$t+$_JobType{$i}+$t+$_Customer{$i}+$t+$_Line{$i}+$t+String:C10($_QtyProduced{$i})
					
					xText:=xText+$t+String:C10(Round:C94($_ActSP{$i}; 0))+$t+String:C10($_TotalMaterial{$i})+$t+String:C10($_TotalConversion{$i})
					
					xText:=xText+$t+String:C10($_TotalCost{$i})+$t+String:C10(Round:C94($_ActContrib{$i}; 0))+$t+String:C10($_ActPV{$i})+$t+String:C10(Round:C94($_ActContrib{$i}-$_BookContrib{$i}; 0))+$t+String:C10(Round:C94($_BookContrib{$i}; 0))+$r
					
			End case 
			
			uThermoUpdate($i)
		End for 
		uThermoClose
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	SEND PACKET:C103($docRef; xText)
	SEND PACKET:C103($docRef; $r+$r+"------ END OF FILE ------")
	CLOSE DOCUMENT:C267($docRef)
	
	If (Count parameters:C259>0)  //$client_requesting:=clientRegistered_as
		If (Length:C16($client_call_back)>0)
			DOCUMENT TO BLOB:C525(docName; $blob)
			DELETE DOCUMENT:C159(docName)  // no reason to leave it around
			EXECUTE ON CLIENT:C651($client_call_back; $methodNameOnClient; $docShortName; $blob)
			If (ok=0)
				utl_Logfile("benchmark.log"; Current method name:C684+": Sending "+docName+" to client-fail?")
			End if 
			DELAY PROCESS:C323(Current process:C322; 30)
			SET BLOB SIZE:C606($blob; 0)  //clean up
			utl_Logfile("benchmark.log"; Current method name:C684+": Sending "+docName+" to client3")
			
		Else 
			EMAIL_Sender("Job Closeout Summary "+fYYMMDD(Current date:C33); ""; "Attached text doc"; $distributionList; docName)
			util_deleteDocument(docName)
		End if 
		
	Else   //legacy running on client
		$err:=util_Launch_External_App(docName)
	End if 
	//end server-side
	
	
End if   //ok
