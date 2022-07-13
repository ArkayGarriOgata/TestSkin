//%attributes = {"publishedWeb":true}
//PM: QA_MonthlySummaryB() -> 
//@author mlb - 9/28/01  13:19
// • mel (6/7/05, 13:59:28) add $numJMI:=Records in selection([JobMakesItem]) to second loop
//get a range of fg transactions

C_DATE:C307($1; $2; dDateEnd; dDateBegin)
C_LONGINT:C283($i; $numJF; $j)
C_TEXT:C284($t; $cr)
C_TEXT:C284(xTitle; xText)
C_TIME:C306($docRef)

$t:=Char:C90(9)
$cr:=Char:C90(13)

zwStatusMsg("QA SUM"; "Shortages")
MESSAGES OFF:C175

//*Find the transactions to report
REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)

If (Count parameters:C259>=2)
	dDateBegin:=$1
	dDateEnd:=$2
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39>=dDateBegin; *)
		QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Completed:39<=dDateEnd)
		If (Count parameters:C259=3)
			CREATE SET:C116([Job_Forms:42]; "dateRange")
			RELATE ONE SELECTION:C349([Job_Forms:42]; [Jobs:15])
			QUERY SELECTION:C341([Jobs:15]; [Jobs:15]CustID:2=$3)
			RELATE MANY SELECTION:C340([Job_Forms:42]JobNo:2)
			CREATE SET:C116([Job_Forms:42]; "custRange")
			INTERSECTION:C121("custRange"; "dateRange"; "targets")
			USE SET:C118("targets")
			CLEAR SET:C117("targets")
			CLEAR SET:C117("custRange")
			CLEAR SET:C117("dateRange")
		End if 
		
	Else 
		
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39>=dDateBegin; *)
		QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Completed:39<=dDateEnd)
		If (Count parameters:C259=3)
			QUERY SELECTION:C341([Job_Forms:42]; [Jobs:15]CustID:2=$3)
			
		End if 
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	OK:=1
	$numJF:=Records in selection:C76([Job_Forms_Items:44])
Else 
	$numJF:=qryByDateRange(->[Job_Forms_Items:44]Completed:39; "Date Range of Completed Items")
	If ($numJF>-1)
		OK:=1
	Else 
		OK:=0
	End if 
End if   //params

If (OK=1)
	If ($numJF>0)
		xTitle:="Month Quality Summary B for "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1)+$cr
		xText:="B.  Shortages for:"+$cr
		docName:="QA_Shortages"+fYYMMDD(dDateEnd)
		$docRef:=util_putFileName(->docName)
		
		SEND PACKET:C103($docRef; xTitle+$cr+$cr)
		xText:=xText+$t+"Plant"+$t+"Customer"+$t+"Jobit"+$t+"Want"+$t+"Good"+$t+"Shortage"+$t+"%"+$t+"Completed"+$t+"Closed"+$cr
		
		ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]CustId:15; >; [Job_Forms_Items:44]Jobit:4; >)
		
		ARRAY TEXT:C222($aCust; 0)
		ARRAY TEXT:C222($aJobit; 0)
		ARRAY LONGINT:C221($aWant; 0)
		ARRAY LONGINT:C221($aGood; 0)
		ARRAY DATE:C224($aCompleted; 0)
		ARRAY BOOLEAN:C223($aClosed; 0)
		ARRAY TEXT:C222($aCust; $numJF)
		ARRAY TEXT:C222($aJobit; $numJF)
		ARRAY LONGINT:C221($aWant; $numJF)
		ARRAY LONGINT:C221($aGood; $numJF)
		ARRAY DATE:C224($aCompleted; $numJF)
		ARRAY BOOLEAN:C223($aClosed; $numJF)
		
		$cursor:=0
		$lastJMI:=""
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
			
			FIRST RECORD:C50([Job_Forms_Items:44])
			While (Not:C34(End selection:C36([Job_Forms_Items:44])))  //sum by jobit to handle subforms
				If ($lastJMI#[Job_Forms_Items:44]Jobit:4)
					If ($lastJMI#"")
						$aGood{$cursor}:=JOB_CalcNetProduced($lastJMI)
					End if 
					$cursor:=$cursor+1
					$lastJMI:=[Job_Forms_Items:44]Jobit:4
					$aJobit{$cursor}:=$lastJMI
					//RELATE ONE([JobMakesItem]CustId)
					$aCust{$cursor}:=CUST_getName([Job_Forms_Items:44]CustId:15)
				End if 
				
				$aWant{$cursor}:=$aWant{$cursor}+[Job_Forms_Items:44]Qty_Want:24  //accum subforms
				//$aGood{$cursor}:=$aGood{$cursor}+[JobMakesItem]Qty_Good`***get this at the end
				$aCompleted{$cursor}:=[Job_Forms_Items:44]Completed:39
				$aClosed{$cursor}:=[Job_Forms_Items:44]FormClosed:5
				
				NEXT RECORD:C51([Job_Forms_Items:44])
			End while 
			
		Else 
			
			ARRAY TEXT:C222($_Jobit; 0)
			ARRAY TEXT:C222($_CustId; 0)
			ARRAY LONGINT:C221($_Qty_Want; 0)
			ARRAY DATE:C224($_Completed; 0)
			ARRAY BOOLEAN:C223($_FormClosed; 0)
			
			SELECTION TO ARRAY:C260([Job_Forms_Items:44]Jobit:4; $_Jobit; \
				[Job_Forms_Items:44]CustId:15; $_CustId; \
				[Job_Forms_Items:44]Qty_Want:24; $_Qty_Want; \
				[Job_Forms_Items:44]Completed:39; $_Completed; \
				[Job_Forms_Items:44]FormClosed:5; $_FormClosed)
			
			For ($Iter; 1; Size of array:C274($_CustId); 1)
				
				If ($lastJMI#$_Jobit{$Iter})
					If ($lastJMI#"")
						$aGood{$cursor}:=JOB_CalcNetProduced($lastJMI)
					End if 
					$cursor:=$cursor+1
					$lastJMI:=$_Jobit{$Iter}
					$aJobit{$cursor}:=$lastJMI
					$aCust{$cursor}:=CUST_getName($_CustId{$Iter})
				End if 
				
				$aWant{$cursor}:=$aWant{$cursor}+$_Qty_Want{$Iter}  //accum subforms
				$aCompleted{$cursor}:=$_Completed{$Iter}
				$aClosed{$cursor}:=$_FormClosed{$Iter}
			End for 
			
		End if   // END 4D Professional Services : January 2019 
		
		ARRAY TEXT:C222($aCust; $cursor)
		ARRAY TEXT:C222($aJobit; $cursor)
		ARRAY LONGINT:C221($aWant; $cursor)
		ARRAY LONGINT:C221($aGood; $cursor)
		ARRAY DATE:C224($aCompleted; $cursor)
		ARRAY BOOLEAN:C223($aClosed; $cursor)
		
		For ($i; 1; $cursor)
			If (Length:C16(xText)>28000)
				SEND PACKET:C103($docRef; xText)
				xText:=""
			End if 
			If ($aGood{$i}<$aWant{$i})  //short
				xText:=xText+$t+$t+$aCust{$i}+$t+$aJobit{$i}+$t+String:C10($aWant{$i})+$t+String:C10($aGood{$i})+$t+String:C10($aGood{$i}-$aWant{$i})+$t+String:C10(($aGood{$i}-$aWant{$i})/$aWant{$i})+$t+String:C10($aCompleted{$i}; System date short:K1:1)+$t+(Num:C11($aClosed{$i})*"YES")+$cr
			End if 
		End for 
		
	End if 
	
	If ($numJF>0) & (False:C215)
		xText:=xText+$cr+$t+"Roanoke"+$cr
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			util_outerJoin(->[Job_Forms_Items:44]JobForm:1; ->[Job_Forms:42]JobFormID:5)
			
			
		Else 
			
			zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Job_Forms_Items:44])+" file. Please Wait...")
			RELATE MANY SELECTION:C340([Job_Forms_Items:44]JobForm:1)
			zwStatusMsg(""; "")
			
		End if   // END 4D Professional Services : January 2019 query selection
		$numJMI:=Records in selection:C76([Job_Forms_Items:44])
		ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]CustId:15; >)
		
		ARRAY TEXT:C222($aCust; 0)
		ARRAY TEXT:C222($aJobit; 0)
		ARRAY LONGINT:C221($aWant; 0)
		ARRAY LONGINT:C221($aGood; 0)
		
		ARRAY TEXT:C222($aCust; $numJMI)
		ARRAY TEXT:C222($aJobit; $numJMI)
		ARRAY LONGINT:C221($aWant; $numJMI)
		ARRAY LONGINT:C221($aGood; $numJMI)
		$cursor:=0
		$lastJMI:=""
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			FIRST RECORD:C50([Job_Forms_Items:44])
			
			
		Else 
			
			// see line 140
			
			
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
			
			While (Not:C34(End selection:C36([Job_Forms_Items:44])))  //sum by jobit to handle subforms
				If ($lastJMI#[Job_Forms_Items:44]Jobit:4)
					$cursor:=$cursor+1
					$lastJMI:=[Job_Forms_Items:44]Jobit:4
					$aJobit{$cursor}:=$lastJMI
					RELATE ONE:C42([Job_Forms_Items:44]CustId:15)
					$aCust{$cursor}:=[Customers:16]Name:2
				End if 
				
				$aWant{$cursor}:=$aWant{$cursor}+[Job_Forms_Items:44]Qty_Want:24
				$aGood{$cursor}:=$aGood{$cursor}+[Job_Forms_Items:44]Qty_Good:10
				NEXT RECORD:C51([Job_Forms_Items:44])
			End while 
			
		Else 
			
			ARRAY TEXT:C222($_Jobit; 0)
			ARRAY TEXT:C222($_CustId; 0)
			ARRAY TEXT:C222($_Name; 0)
			ARRAY LONGINT:C221($_Qty_Want; 0)
			ARRAY LONGINT:C221($_Qty_Good; 0)
			
			GET FIELD RELATION:C920([Job_Forms_Items:44]CustId:15; $lienAller; $lienRetour)
			SET FIELD RELATION:C919([Job_Forms_Items:44]CustId:15; Automatic:K51:4; Do not modify:K51:1)
			
			SELECTION TO ARRAY:C260([Job_Forms_Items:44]Jobit:4; $_Jobit; \
				[Job_Forms_Items:44]Qty_Want:24; $_Qty_Want; \
				[Job_Forms_Items:44]Qty_Good:10; $_Qty_Good; \
				[Job_Forms_Items:44]CustId:15; $_CustId; \
				[Customers:16]Name:2; $_Name)
			
			
			SET FIELD RELATION:C919([Job_Forms_Items:44]CustId:15; $lienAller; $lienRetour)
			
			
			
			For ($Iter; 1; Size of array:C274($_CustId); 1)
				
				If ($lastJMI#$_Jobit{$Iter})
					$cursor:=$cursor+1
					$lastJMI:=$_Jobit{$Iter}
					$aJobit{$cursor}:=$lastJMI
					$aCust{$cursor}:=$_Name{$Iter}
				End if 
				
				$aWant{$cursor}:=$aWant{$cursor}+$_Qty_Want{$Iter}
				$aGood{$cursor}:=$aGood{$cursor}+$_Qty_Good{$Iter}
			End for 
			
		End if   // END 4D Professional Services : January 2019 
		
		
		ARRAY TEXT:C222($aCust; $cursor)
		ARRAY TEXT:C222($aJobit; $cursor)
		ARRAY LONGINT:C221($aWant; $cursor)
		ARRAY LONGINT:C221($aGood; $cursor)
		
		For ($i; 1; $cursor)
			If (Length:C16(xText)>28000)
				SEND PACKET:C103($docRef; xText)
				xText:=""
			End if 
			If ($aGood{$i}<$aWant{$i})  //short
				xText:=xText+$t+$t+$aCust{$i}+$t+$aJobit{$i}+$t+String:C10($aWant{$i})+$t+String:C10($aGood{$i})+$t+String:C10($aGood{$i}-$aWant{$i})+$t+String:C10(($aGood{$i}-$aWant{$i})/$aWant{$i})+$cr
			End if 
		End for 
	End if 
	
	CLEAR SET:C117("jobforms")
	SEND PACKET:C103($docRef; xText)
	CLOSE DOCUMENT:C267($docRef)
	BEEP:C151
	// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
	$err:=util_Launch_External_App(docName)
	
	xText:=""
End if 
zwStatusMsg("QA SUM"; "Monthly Summary B Fini")