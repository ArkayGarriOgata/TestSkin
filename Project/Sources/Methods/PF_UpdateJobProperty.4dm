//%attributes = {}
// -------
// Method: PF_UpdateJobProperty   ( ) ->
// By: Mel Bohince @ 03/06/18, 15:46:53
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (3/19/18) fix JobRef and EventSource ref
// Modified by: Mel Bohince (7/9/21) disable
If (False:C215)  // Modified by: Mel Bohince (7/9/21) disable
	
	C_BOOLEAN:C305($err; $sendProperties; $jml_only; $2)
	C_TEXT:C284($jobform; $1; $3; $now)
	C_DATE:C307($currentDate)
	C_TIME:C306($currentTime)
	
	
	If (Count parameters:C259>0)
		$jobForm:=$1
		$jml_only:=$2
		//$propertyName:=$2
		//$propertyValue:=$3
	Else 
		QUERY:C277([Job_Forms_Master_Schedule:67])
		$jobForm:=[Job_Forms_Master_Schedule:67]JobForm:4
		$jml_only:=True:C214
		//$propertyName:="Stock Received"
		//$propertyValue:="Yes"
	End if 
	
	If ($jml_only)
		$target:="JML"
	Else 
		$target:="Job"
	End if 
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
		APPEND TO ARRAY:C911($AttrVal; "Updating "+$target+" Properties")
		
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
		APPEND TO ARRAY:C911($AttrVal; $jobForm)
		APPEND TO ARRAY:C911($AttrName; "Action")
		APPEND TO ARRAY:C911($AttrVal; "Update")
		//APPEND TO ARRAY($AttrName;"JobNote")
		//APPEND TO ARRAY($AttrVal;"")
		DOM SET XML ATTRIBUTE:C866($jobref; $AttrName{1}; $AttrVal{1}; $AttrName{2}; $AttrVal{2})
	End if   //jobs
	
	
	If (True:C214)  //property
		$propref:=DOM Append XML child node:C1080($jobref; XML ELEMENT:K45:20; "<Properties></Properties>")
		//DOM SET XML ATTRIBUTE($propref;"Code";"Property")
		//PF_AddProperty ($propref;$propertyName;$propertyValue)
		If (Not:C34($jml_only))
			//JOB PROPERTIES:
			PF_AddProperty($propref; "Brand"; [Job_Forms:42]CustomerLine:62)
			PF_AddProperty($propref; "Customer Visit Task"; String:C10([Job_Forms:42]NumberUp:26))
			PF_AddProperty($propref; "Job Customer Code"; [Job_Forms:42]cust_id:82)  //dup of attribute
			PF_AddProperty($propref; "Job Status AMS"; [Job_Forms:42]Status:6)  //dup of attribute
			PF_AddProperty($propref; "job-GrossShts"; String:C10([Job_Forms:42]EstGrossSheets:27))  // Modified by: Mel Bohince (3/6/18) added back in
			PF_AddProperty($propref; "Lin. Ft. Required"; String:C10(Job_getBoardLinearFeet([Job_Forms:42]JobFormID:5)))
			$rmCode:=Job_getBoardRMCode($jobform)  // Modified by: Mel Bohince (3/1/18) 
			$rmCommodity:=Job_getBoardCommodityKey($jobform)  // Modified by: Mel Bohince (3/2/18) 
			PF_AddProperty($propref; "Stock-Commodity Code"; $rmCommodity)
			PF_AddProperty($propref; "Stock-RM"; $rmCode)
			PF_AddProperty($propref; "PSpec."; [Job_Forms:42]ProcessSpec:46)  //dup of attribute
		Else 
			//JML PROPERTIES:
			PF_AddProperty($propref; "HRD"; PF_util_FormatDate(->[Job_Forms_Master_Schedule:67]MAD:21))
			PF_AddProperty($propref; "job-1stRelease"; PF_util_FormatDate(->[Job_Forms_Master_Schedule:67]FirstReleaseDat:13))  // see JML_get1stRelease
			PF_AddProperty($propref; "job-HRD"; PF_util_FormatDate(->[Job_Forms_Master_Schedule:67]MAD:21))
			PF_AddProperty($propref; "Plant"; [Job_Forms_Master_Schedule:67]LocationOfMfg:30)
			PF_AddProperty($propref; "TD"; PF_util_FormatDate(->[Job_Forms_Master_Schedule:67]TargetDate_PrintFlow:88))
			
			//JML RESOURCES:
			PF_AddProperty($propref; "Job Bag Approved"; PF_DateToYesNo([Job_Forms_Master_Schedule:67]DateBagApproved:49))
			PF_AddProperty($propref; "Job Bag Received"; PF_DateToYesNo([Job_Forms_Master_Schedule:67]DateBagReceived:48))
			PF_AddProperty($propref; "Printed"; PF_DateToYesNo([Job_Forms_Master_Schedule:67]Printed:32))
			PF_AddProperty($propref; "Stock Received"; PF_DateToYesNo([Job_Forms_Master_Schedule:67]DateStockRecd:17))
			PF_AddProperty($propref; "Stock Sheeted"; PF_DateToYesNo([Job_Forms_Master_Schedule:67]DateStockSheeted:47))  //Substring(String(;Internal date short special);1;5))
		End if 
	End if   //run
	
	
	C_TEXT:C284($xmlvar)
	DOM EXPORT TO VAR:C863($elementRef; $xmlvar)
	CREATE RECORD:C68([PrintFlow_Msg_Queue:169])
	[PrintFlow_Msg_Queue:169]Created:2:=$now
	[PrintFlow_Msg_Queue:169]ModWho:4:=<>zResp
	[PrintFlow_Msg_Queue:169]EventSource:3:=$target+" Properties Update"
	[PrintFlow_Msg_Queue:169]Sent:5:=0
	[PrintFlow_Msg_Queue:169]XML_text:6:=$xmlvar
	[PrintFlow_Msg_Queue:169]JobRef:7:=$jobForm
	
	SAVE RECORD:C53([PrintFlow_Msg_Queue:169])
	UNLOAD RECORD:C212([PrintFlow_Msg_Queue:169])
	
	//DOM EXPORT TO FILE($elementRef;$printflow_export_fn)
	DOM CLOSE XML:C722($elementRef)
	BEEP:C151
	
End if 

