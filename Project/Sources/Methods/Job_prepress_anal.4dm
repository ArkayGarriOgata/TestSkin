//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 05/05/15, 09:22:33
// ----------------------------------------------------
// Method: Job_prepress_anal
// Description
// check the state of prep on press squences that have been sheeted but not plated
//
// ----------------------------------------------------
C_LONGINT:C283($i; $numSeq)

CONFIRM:C162("Look at plating or gluing?"; "Plating"; "Gluing")
If (ok=1)
	
	//find jobs that are sheeted not printed 
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateStockSheeted:47#!00-00-00!; *)
	QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!)
	SELECTION TO ARRAY:C260([Job_Forms_Master_Schedule:67]JobForm:4; $aJML; [Job_Forms_Master_Schedule:67]DateStockSheeted:47; $aSheeted)
	SORT ARRAY:C229($aJML; $aSheeted; >)
	
	//find the press sequences
	$numSeq:=PS_qryPrintingOnly
	//filter not plated
	// ******* Verified  - 4D PS - January  2019 ********
	
	QUERY SELECTION:C341([ProductionSchedules:110]; [ProductionSchedules:110]PlatesReady:18=!00-00-00!; *)
	QUERY SELECTION:C341([ProductionSchedules:110];  | ; [ProductionSchedules:110]CyrelsReady:19=!00-00-00!)
	
	// ******* Verified  - 4D PS - January 2019 (end) *********
	
	ARRAY TEXT:C222($aJobSeq; 0)
	SELECTION TO ARRAY:C260([ProductionSchedules:110]JobSequence:8; $aJobSeq; [ProductionSchedules:110]PlatesReady:18; $aPlates; [ProductionSchedules:110]CyrelsReady:19; $aCyrels)
	$numSeq:=Size of array:C274($aJobSeq)
	SORT ARRAY:C229($aJobSeq; >)
	
	C_TEXT:C284($t; $r)
	C_TEXT:C284($title; $text; $docName)
	C_TIME:C306($docRef)
	C_LONGINT:C283(err)
	$t:=Char:C90(9)
	$r:=Char:C90(13)
	$title:="Jobs waiting for prep to complete"
	$text:="Jobform"+$t+"Sheeted"+$t+"Control#"+$t+"Submitted"+$t+"PrepDone"+$t+"Plates"+$t+"Cyrels"+$r
	$docName:="PrepToPressSchd"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; HH MM SS:K7:1); ":"; "")+".xls"
	$docRef:=util_putFileName(->$docName)
	
	If ($docRef#?00:00:00?)
		SEND PACKET:C103($docRef; $title+$r)
		
		uThermoInit($numSeq; "Processing Array")
		For ($i; 1; $numSeq)
			$jobForm:=Substring:C12($aJobSeq{$i}; 1; 8)
			$hit:=Find in array:C230($aJML; $jobForm)
			If ($hit>-1)  //it has been sheeted
				QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$jobForm)
				DISTINCT VALUES:C339([Job_Forms_Items:44]ControlNumber:26; $aControl)
				For ($c; 1; Size of array:C274($aControl))  //get the scoop on the c# of the jobs
					QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ControlNumber:2=$aControl{$c})
					$text:=$text+$jobForm+$t+String:C10($aSheeted{$hit}; Internal date short:K1:7)+$t+$aControl{$c}+$t+String:C10([Finished_Goods_Specifications:98]DateSubmitted:5; Internal date short:K1:7)+$t+String:C10([Finished_Goods_Specifications:98]DatePrepDone:6; Internal date short:K1:7)+$t+String:C10($aPlates{$i}; Internal date short:K1:7)+$t+String:C10($aCyrels{$i}; Internal date short:K1:7)+$r
				End for 
			End if 
			
			If (Length:C16($text)>25000)
				SEND PACKET:C103($docRef; $text)
				$text:=""
			End if   //len text
			
			uThermoUpdate($i)
		End for 
		uThermoClose
		
		
		SEND PACKET:C103($docRef; $text)
		SEND PACKET:C103($docRef; $r+$r+"------ END OF FILE ------")
		CLOSE DOCUMENT:C267($docRef)
		
		// obsolete call, method deleted 4/28/20 uDocumentSetType ($docName)  //
		$err:=util_Launch_External_App($docName)
	End if   //docref
	
Else   //look at gluing
	
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Glued:33>=!2015-04-01!)  //matches my dataset
	SELECTION TO ARRAY:C260([Job_Forms_Items:44]Jobit:4; $aJobit; [Job_Forms_Items:44]Glued:33; $aGlued; [Job_Forms_Items:44]ControlNumber:26; $aControl; [Job_Forms_Items:44]ProductCode:3; $aCPN)
	SORT ARRAY:C229($aGlued; $aJobit; $aControl; >)
	$numJMI:=Size of array:C274($aJobit)
	C_TEXT:C284($t; $r)
	C_TEXT:C284($title; $text; $docName)
	C_TIME:C306($docRef)
	C_LONGINT:C283(err)
	$t:=Char:C90(9)
	$r:=Char:C90(13)
	$title:="Jobs waiting for prep to complete"
	$text:="Jobit"+$t+"Glued"+$t+"Control#"+$t+"Submitted"+$t+"PrepDone"+$r
	$docName:="PrepToGluing"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; HH MM SS:K7:1); ":"; "")+".xls"
	$docRef:=util_putFileName(->$docName)
	
	If ($docRef#?00:00:00?)
		SEND PACKET:C103($docRef; $title+$r)
		
		uThermoInit($numSeq; "Processing Array")
		For ($i; 1; $numJMI)
			QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ControlNumber:2=$aControl{$i})
			If (Records in selection:C76([Finished_Goods_Specifications:98])>0)
				$text:=$text+$aJobit{$i}+$t+String:C10($aGlued{$i}; Internal date short:K1:7)+$t+$aControl{$i}+$t+String:C10([Finished_Goods_Specifications:98]DateSubmitted:5; Internal date short:K1:7)+$t+String:C10([Finished_Goods_Specifications:98]DatePrepDone:6; Internal date short:K1:7)+$r
				
			Else 
				QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=$aCPN{$i})
				QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ControlNumber:2=[Finished_Goods:26]ControlNumber:61)
				$text:=$text+$aJobit{$i}+$t+String:C10($aGlued{$i}; Internal date short:K1:7)+$t+[Finished_Goods:26]ControlNumber:61+"*"+$t+String:C10([Finished_Goods_Specifications:98]DateSubmitted:5; Internal date short:K1:7)+$t+String:C10([Finished_Goods_Specifications:98]DatePrepDone:6; Internal date short:K1:7)+$r
			End if 
			If (Length:C16($text)>25000)
				SEND PACKET:C103($docRef; $text)
				$text:=""
			End if   //len text
			
			uThermoUpdate($i)
		End for 
		uThermoClose
		
		
		SEND PACKET:C103($docRef; $text)
		SEND PACKET:C103($docRef; $r+$r+"------ END OF FILE ------")
		CLOSE DOCUMENT:C267($docRef)
		
		// obsolete call, method deleted 4/28/20 uDocumentSetType ($docName)  //
		$err:=util_Launch_External_App($docName)
		
	End if   //docref
	
End if   //confirm








