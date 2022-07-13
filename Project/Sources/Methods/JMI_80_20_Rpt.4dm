//%attributes = {}
// Method: JMI_80_20_Rpt ({dateBegin;dateEnd}) -> 
// ----------------------------------------------------
// by: mel: 12/05/03, 09:55:56
// ----------------------------------------------------
// Description:
// report mix of make to ship vs make to stock
// ----------------------------------------------------
// in excel, a pivot table with rows of planner/customer, then average of shipped and stocked is interesting 


C_DATE:C307($1; $2; dDateEnd; dDateBegin)
C_TEXT:C284($t; $cr)
C_LONGINT:C283($i; $numRecs)
C_BOOLEAN:C305($break)
C_TEXT:C284(xTitle; xText; docName)
C_TIME:C306($docRef)

MESSAGES OFF:C175

READ ONLY:C145([Job_Forms_Items:44])
READ ONLY:C145([Finished_Goods_Transactions:33])
READ ONLY:C145([Finished_Goods_Locations:35])
READ ONLY:C145([Customers:16])

$t:=Char:C90(9)
$cr:=Char:C90(13)

xText:="JOBIT"+$t+"SCORE"+$t+"PCT_SHIPPED"+$t+"PCT_STOCKED"+$t+"PRODUCED"+$t+"SHIPPED"+$t+"STOCKED"+$t+"GLUED"+$t+"PLANNER"+$t+"CUSTOMER"+$cr
docName:="JMI_80_20_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; HH MM SS:K7:1); ":"; "")+".xls"
$docRef:=util_putFileName(->docName)
If ($docRef#?00:00:00?)
	If (Count parameters:C259=2)
		dDateBegin:=$1
		dDateEnd:=$2
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Glued:33>=dDateBegin; *)
		QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Glued:33<=dDateEnd)
		OK:=1
	Else 
		$numRecs:=qryByDateRange(->[Job_Forms_Items:44]Glued:33; "Select Glued Date")
	End if   //params
	
	QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]OrderItem:2#"Killed")
	
	
	xTitle:="80%Shipped to 20%Stocked Report Glued between "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1)
	SEND PACKET:C103($docRef; xTitle+$cr)
	SEND PACKET:C103($docRef; "in excel a pivot table with rows of planner/customer, then average of shipped and stocked is interesting"+$cr+$cr)
	
	
	ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4; >)
	
	$break:=False:C215
	$numRecs:=Records in selection:C76([Job_Forms_Items:44])
	
	uThermoInit($numRecs; "Applying 80/20 Rule")
	C_TEXT:C284($lastJobit; $score)
	C_LONGINT:C283($numGlued; $numShipped; $numStocked; $pctShipped; $pctStocked; $ttlShipped; $ttlStocked)
	$lastJobit:="start"
	$ttlShipped:=0
	$ttlStocked:=0
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
		
		For ($i; 1; $numRecs)
			If ($break)
				$i:=$i+$numRecs
			End if 
			
			If ($lastJobit#[Job_Forms_Items:44]Jobit:4)  //combine subforms
				RELATE ONE:C42([Job_Forms_Items:44]JobForm:1)
				$jobtype:=Substring:C12([Job_Forms:42]JobType:33; 1; 1)
				If (Position:C15($jobtype; " 2 5 6")=0)  //not  proof line trial r&d
					$numGlued:=0
					$numShipped:=0
					$pctShipped:=0
					$numStocked:=0
					$pctStocked:=0
					$score:="FAIL"
					
					QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Jobit:31=[Job_Forms_Items:44]Jobit:4; *)
					QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Ship")
					If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
						$numShipped:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
					End if 
					
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33=[Job_Forms_Items:44]Jobit:4)
					If (Records in selection:C76([Finished_Goods_Locations:35])>0)
						$numStocked:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
					End if 
					
					$numGlued:=$numShipped+$numStocked
					//if($numGlued>0)
					If ($numGlued>0)
						$pctShipped:=Round:C94($numShipped/$numGlued*100; 0)
						$pctStocked:=Round:C94($numStocked/$numGlued*100; 0)
					Else 
						$pctShipped:=0
						$pctStocked:=0
					End if 
					
					If ($pctShipped>=80)
						$score:="PASS"
					End if 
					
					$ttlShipped:=$ttlShipped+$numShipped
					$ttlStocked:=$ttlStocked+$numStocked
					
					If (Length:C16(xText)>10000)
						SEND PACKET:C103($docRef; xText)
						xText:=""
					End if 
					
					RELATE ONE:C42([Job_Forms_Items:44]CustId:15)
					xText:=xText+[Job_Forms_Items:44]Jobit:4+$t+$score+$t+String:C10($pctShipped)+$t+String:C10($pctStocked)+$t+String:C10($numGlued)+$t+String:C10($numShipped)+$t+String:C10($numStocked)+$t+String:C10([Job_Forms_Items:44]Glued:33; System date short:K1:1)+$t+[Job_Forms_Items:44]PlnnrWho:34+$t+[Customers:16]Name:2+$cr
					//End if   //somethign glued
				End if   // production item
			End if 
			
			$lastJobit:=[Job_Forms_Items:44]Jobit:4
			NEXT RECORD:C51([Job_Forms_Items:44])
			uThermoUpdate($i)
		End for 
		
		
	Else 
		
		SELECTION TO ARRAY:C260([Job_Forms_Items:44]Jobit:4; $_Jobit; \
			[Job_Forms_Items:44]JobForm:1; $_JobForm; \
			[Job_Forms_Items:44]CustId:15; $_CustId; \
			[Job_Forms_Items:44]Glued:33; $_Glued; \
			[Job_Forms_Items:44]PlnnrWho:34; $_PlnnrWho)
		
		For ($i; 1; $numRecs)
			If ($break)
				$i:=$i+$numRecs
			End if 
			
			If ($lastJobit#$_Jobit{$i})  //combine subforms
				
				QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$_JobForm{$i})
				
				$jobtype:=Substring:C12([Job_Forms:42]JobType:33; 1; 1)
				If (Position:C15($jobtype; " 2 5 6")=0)  //not  proof line trial r&d
					$numGlued:=0
					$numShipped:=0
					$pctShipped:=0
					$numStocked:=0
					$pctStocked:=0
					$score:="FAIL"
					
					QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Jobit:31=$_Jobit{$i}; *)
					QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Ship")
					If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
						$numShipped:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
					End if 
					
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33=$_Jobit{$i})
					If (Records in selection:C76([Finished_Goods_Locations:35])>0)
						$numStocked:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
					End if 
					
					$numGlued:=$numShipped+$numStocked
					//if($numGlued>0)
					If ($numGlued>0)
						$pctShipped:=Round:C94($numShipped/$numGlued*100; 0)
						$pctStocked:=Round:C94($numStocked/$numGlued*100; 0)
					Else 
						$pctShipped:=0
						$pctStocked:=0
					End if 
					
					If ($pctShipped>=80)
						$score:="PASS"
					End if 
					
					$ttlShipped:=$ttlShipped+$numShipped
					$ttlStocked:=$ttlStocked+$numStocked
					
					If (Length:C16(xText)>10000)
						SEND PACKET:C103($docRef; xText)
						xText:=""
					End if 
					
					QUERY:C277([Customers:16]; [Customers:16]ID:1=$_CustId{$i})
					
					xText:=xText+$_Jobit{$i}+$t+$score+$t+String:C10($pctShipped)+$t+String:C10($pctStocked)+$t+String:C10($numGlued)+$t+String:C10($numShipped)+$t+String:C10($numStocked)+$t+String:C10($_Glued{$i}; System date short:K1:1)+$t+$_PlnnrWho{$i}+$t+[Customers:16]Name:2+$cr
					//End if   //somethign glued
				End if   // production item
			End if 
			
			$lastJobit:=$_Jobit{$i}
			uThermoUpdate($i)
		End for 
		
		
	End if   // END 4D Professional Services : January 2019 
	uThermoClose
	
	$numGlued:=$ttlShipped+$ttlStocked
	If ($numGlued>0)
		$pctShipped:=Round:C94($ttlShipped/$numGlued*100; 0)
		$pctStocked:=Round:C94($ttlStocked/$numGlued*100; 0)
	Else 
		$pctShipped:=0
		$pctStocked:=0
	End if 
	
	If ($pctShipped>=80)
		$score:="PASS"
	Else 
		$score:="FAIL"
	End if 
	xText:=xText+$cr+"TOTALS"+$t+$score+$t+String:C10($pctShipped)+$t+String:C10($pctStocked)+$t+String:C10($numGlued)+$t+String:C10($ttlShipped)+$t+String:C10($ttlStocked)+$t+""+$t+""+$t+""+$cr
	
	
	SEND PACKET:C103($docRef; xText)
	SEND PACKET:C103($docRef; $cr+$cr+"------ END OF FILE ------")
	CLOSE DOCUMENT:C267($docRef)
	
	
	// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
	
	If (Count parameters:C259=0)  //
		$err:=util_Launch_External_App(docName)
	Else 
		EMAIL_Sender(xTitle; ""; "open attached with Excel"; distributionList; docName)
		util_deleteDocument(docName)
	End if 
	
Else 
	BEEP:C151
	zwStatusMsg("ERROR"; "Couldn't create document named "+docName)
End if 

REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)
REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
REDUCE SELECTION:C351([Customers:16]; 0)