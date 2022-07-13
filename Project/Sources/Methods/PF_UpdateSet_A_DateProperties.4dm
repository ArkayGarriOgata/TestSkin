//%attributes = {}
// -------
// Method: PF_UpdateSet_A_DateProperties   ( ) ->
// By: Mel Bohince @ 03/08/18, 15:46:55
// Description
// like PF_UpdateTaskProperty, but all properties and resources at once
// ----------------------------------------------------
If (False:C215)  // Modified by: Mel Bohince (7/9/21) disable
	
	C_BOOLEAN:C305($err; $sendProperties)
	C_TEXT:C284($jobform; $1; $2; $jobFormSeq; $costCtr; $jobitem; $job; $form; $now)
	C_DATE:C307($currentDate)
	C_TIME:C306($currentTime)
	C_LONGINT:C283($3)
	
	If (Count parameters:C259>0)
		$jobFormSeq:=$1
		$costCtr:=$2
		$jobitem:=String:C10($3; "00")
		
	Else 
		QUERY:C277([ProductionSchedules:110])
		$jobFormSeq:=[ProductionSchedules:110]JobSequence:8
		$costCtr:=[ProductionSchedules:110]CostCenter:1
		$jobitem:="00"
	End if 
	
	$jobform:=Substring:C12($jobFormSeq; 1; 8)
	$jobseq:=$jobFormSeq
	$job:=$jobform  //Substring($jobform;1;5)
	$form:=$job+"-0"
	$currentTime:=Current time:C178
	$currentDate:=Current date:C33
	$now:=PF_util_FormatDate(->$currentDate; $currentTime)
	
	
	C_TEXT:C284($elementRef)
	If (True:C214)  //root
		$elementRef:=DOM Create XML Ref:C861("PrintFlowData")
		ARRAY TEXT:C222($AttrName; 0)
		ARRAY TEXT:C222($AttrVal; 0)
		APPEND TO ARRAY:C911($AttrName; "Action")
		APPEND TO ARRAY:C911($AttrVal; "Create")
		
		APPEND TO ARRAY:C911($AttrName; "Sender")
		APPEND TO ARRAY:C911($AttrVal; "Administrator")
		
		APPEND TO ARRAY:C911($AttrName; "Machine")
		APPEND TO ARRAY:C911($AttrVal; "WIN-QAEA4RO0N0B")
		
		APPEND TO ARRAY:C911($AttrName; "ProgramName")
		APPEND TO ARRAY:C911($AttrVal; "PrintFlowXMLCsharp.exe  2.0.0.0")
		
		APPEND TO ARRAY:C911($AttrName; "Comment")
		APPEND TO ARRAY:C911($AttrVal; "Updating Properties by Set-a-date")
		
		APPEND TO ARRAY:C911($AttrName; "Version")
		APPEND TO ARRAY:C911($AttrVal; "Prism version 123")
		
		APPEND TO ARRAY:C911($AttrName; "ChangeDate")
		APPEND TO ARRAY:C911($AttrVal; $now)
		
		DOM SET XML ATTRIBUTE:C866($elementRef; $AttrName{1}; $AttrVal{1}; $AttrName{2}; $AttrVal{2}; $AttrName{3}; $AttrVal{3}; $AttrName{4}; $AttrVal{4}; $AttrName{5}; $AttrVal{5}; $AttrName{6}; $AttrVal{6}; $AttrName{7}; $AttrVal{7})
	End if   //root
	
	If (True:C214)  //jobs-job-form
		$jobsref:=DOM Append XML child node:C1080($elementRef; XML ELEMENT:K45:20; "<Jobs></Jobs>")
		DOM SET XML ATTRIBUTE:C866($jobsref; "Code"; "Jobs")
		
		$jobref:=DOM Append XML child node:C1080($jobsref; XML ELEMENT:K45:20; "<Job></Job>")
		ARRAY TEXT:C222($AttrName; 0)
		ARRAY TEXT:C222($AttrVal; 0)
		APPEND TO ARRAY:C911($AttrName; "Code")
		APPEND TO ARRAY:C911($AttrVal; $job)
		APPEND TO ARRAY:C911($AttrName; "Action")
		APPEND TO ARRAY:C911($AttrVal; "None")
		//APPEND TO ARRAY($AttrName;"JobNote")
		//APPEND TO ARRAY($AttrVal;"")
		DOM SET XML ATTRIBUTE:C866($jobref; $AttrName{1}; $AttrVal{1}; $AttrName{2}; $AttrVal{2})
	End if   //jobs
	
	If (True:C214)  //form
		$formref:=DOM Append XML child node:C1080($jobref; XML ELEMENT:K45:20; "<Form></Form>")
		ARRAY TEXT:C222($AttrName; 0)
		ARRAY TEXT:C222($AttrVal; 0)
		APPEND TO ARRAY:C911($AttrName; "Code")
		APPEND TO ARRAY:C911($AttrVal; $form)
		APPEND TO ARRAY:C911($AttrName; "Action")
		APPEND TO ARRAY:C911($AttrVal; "None")
		DOM SET XML ATTRIBUTE:C866($formref; $AttrName{1}; $AttrVal{1}; $AttrName{2}; $AttrVal{2})
	End if   //form
	
	If (True:C214)  //task
		$taskref:=DOM Append XML child node:C1080($formref; XML ELEMENT:K45:20; "<Task></Task>")
		ARRAY TEXT:C222($AttrName; 0)
		ARRAY TEXT:C222($AttrVal; 0)
		APPEND TO ARRAY:C911($AttrName; "Code")
		If (Position:C15($costCtr; <>GLUERS)=0)
			APPEND TO ARRAY:C911($AttrVal; Substring:C12($jobFormSeq; 10))
		Else 
			$jobformSeqItem:=Substring:C12($jobFormSeq; 10)+"."+$jobitem
			APPEND TO ARRAY:C911($AttrVal; $jobformSeqItem)
		End if 
		APPEND TO ARRAY:C911($AttrName; "Action")
		APPEND TO ARRAY:C911($AttrVal; "Update")
		
		DOM SET XML ATTRIBUTE:C866($taskref; $AttrName{1}; $AttrVal{1}; $AttrName{2}; $AttrVal{2})
	End if   //task
	
	If (True:C214)  //property
		$propref:=DOM Append XML child node:C1080($taskref; XML ELEMENT:K45:20; "<Properties></Properties>")
		DOM SET XML ATTRIBUTE:C866($propref; "Code"; "Property")
		
		
		//Printing RESOURCES:
		PF_AddProperty($propref; "Cold Foil"; PF_BooleanToYesNo([ProductionSchedules:110]ColdFoil:76))
		PF_AddProperty($propref; "Cyrel Plate"; PF_DateToYesNo([ProductionSchedules:110]CyrelsReady:19))
		PF_AddProperty($propref; "Ink"; PF_DateToYesNo([ProductionSchedules:110]InkReady:20))
		PF_AddProperty($propref; "Plated"; PF_DateToYesNo([ProductionSchedules:110]PlatesReady:18))
		
		//Stamping RESOURCES:
		PF_AddProperty($propref; "Dylux Checked"; PF_DateToYesNo([ProductionSchedules:110]DateDyluxChecked:75))
		PF_AddProperty($propref; "Embossing Dies Received"; PF_DateToYesNo([ProductionSchedules:110]EmbossingDies:29))
		PF_AddProperty($propref; "Embossing Film"; PF_DateToYesNo([ProductionSchedules:110]DateFilmEmbossRcd:44))
		PF_AddProperty($propref; "Leaf Received"; PF_DateToYesNo([ProductionSchedules:110]Leaf:30))
		PF_AddProperty($propref; "Stamp Dies Received"; PF_DateToYesNo([ProductionSchedules:110]StampingDies:28))
		PF_AddProperty($propref; "Stamping Film Received"; PF_DateToYesNo([ProductionSchedules:110]DateFilmStampingRcd:43))
		
		//blanking RESOURCES:
		PF_AddProperty($propref; "Blanker Rec'd"; PF_DateToYesNo([ProductionSchedules:110]DateBlankerRecd:42))
		PF_AddProperty($propref; "Counters Rec'd"; PF_DateToYesNo([ProductionSchedules:110]DateCountersRecd:41))
		PF_AddProperty($propref; "Die Board Rec'd"; PF_DateToYesNo([ProductionSchedules:110]DateDieBoardRecd:45))
		PF_AddProperty($propref; "Dylux Checked"; PF_DateToYesNo([ProductionSchedules:110]DateDyluxChecked:75))
		PF_AddProperty($propref; "Female Stripper"; PF_DateToYesNo([ProductionSchedules:110]FemaleStripperBoard:26))
		PF_AddProperty($propref; "Stripping Unit"; PF_DateToYesNo([ProductionSchedules:110]CyrelsReady:19))
	End if   //run
	
	
	C_TEXT:C284($xmlvar)
	DOM EXPORT TO VAR:C863($elementRef; $xmlvar)
	CREATE RECORD:C68([PrintFlow_Msg_Queue:169])
	[PrintFlow_Msg_Queue:169]Created:2:=$now
	[PrintFlow_Msg_Queue:169]ModWho:4:=<>zResp
	[PrintFlow_Msg_Queue:169]EventSource:3:="Task Property Update: "+$costCtr
	[PrintFlow_Msg_Queue:169]Sent:5:=0
	[PrintFlow_Msg_Queue:169]XML_text:6:=$xmlvar
	If (Position:C15($costCtr; <>GLUERS)=0)
		[PrintFlow_Msg_Queue:169]JobRef:7:=$jobFormSeq
	Else 
		[PrintFlow_Msg_Queue:169]JobRef:7:=$jobformSeqItem
	End if 
	SAVE RECORD:C53([PrintFlow_Msg_Queue:169])
	UNLOAD RECORD:C212([PrintFlow_Msg_Queue:169])
	
	//DOM EXPORT TO FILE($elementRef;$printflow_export_fn)
	DOM CLOSE XML:C722($elementRef)
	BEEP:C151
End if 

