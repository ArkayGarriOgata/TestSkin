//%attributes = {}
// -------
// Method: PF_JobformToXML3level   ( ) ->
// By: Mel Bohince @ 09/01/17, 10:29:39
// Description
// create an XML file in the format that PrintFlow will accept
// ----------------------------------------------------
// Modified by: Mel Bohince (11/9/17) add JobSalesQuantity
//<>jobformPrefix:=False  // Modified by: Mel Bohince (12/15/17) don't use jobform+seq{+item}, leave out the jobform if set to true


//<?xml version="1.0"?>
//<PrintFlowData Action="Create"Sender="Administrator"Machine="WIN-QAEA4RO0N0B"ProgramName="PrintFlowXMLCsharp.exe  2.0.0.0"Comment="Creating a job"Version="Prism version 123"ChangeDate="2017-08-25T15:02-04:00">
//  <Jobs Code="Jobs">
//    <Job Action="Create"Code="Job 1"JobDescription="strJobDescription"DueDate="2017-08-25T15:02-04:00"EarliestDate="2017-08-25T15:02-04:00"JobCustomer="strJobCustomer"JobProduct="strJobProduct"JobStatus="strJobStatus"JobCustomerName="strJobCustomerName"JobNote="strJobNote"JobSalesRep="strJobSalesRep"JobCustomerServiceRep="strJobCustomerServiceRep"JobSalesQuantity="strJobSalesQuantity"TodoAction="strJobTodoAction"ActionSender="strJobActionSender"LockedBy="strJobLockedBy"AssignedTo="strJobAssignedTo"ParentID="strJobParentID"ChildID="strJobChildID">
//      <Properties>
//        <Property Name="Job character Property"Value="Job Value"/>
//        <Property Name="Job integer Property"Value="10"/>
//      </Properties>
//      <Form Action="Create"Code="Job 1-Form 1"FormDescription="strFormDescription"ProductCode="strFormProductCode"CustomerCode="strFormCustomerCode"Status="strFormStatus"FormNote="strFormNote"CustomerDescription="strFormCustomerDesc"MakeQuantity="100"TodoAction="strFormTodoAction"ActionSender="strFormActionSender"LockedBy="strFormLockedBy"AssignedTo="strFormAssignedTo">
//         <Properties>
//            <Property Name="Form character Property"Value="Form Value"/>
//            <Property Name="Form integer Property"Value="10"/>
//         </Properties>
//         <Task Action="Create"Code="1"Description="Files In"CostCenterCode="100"RunMinutes="60"Status="Complete"TaskNote="strTaskNote"ProblemDescription="strProblemDescription"TodoAction="strTaskTodoAction"ActionSender="strTaskActionSender"LockedBy="strTaskLockedBy"AssignedTo="strTaskAssignedTo">
//           <Properties>
//             <Property Name="Task character Property"Value="Task Value"/>
//             <Property Name="Task integer Property"Value="10"/>
//           </Properties>
//         </Task>
//...
//      </Form>
//      <Properties/>
//    </Job>
//  </Jobs>
//  <Links>
//    <Link Action="Create"FromJobCode="Job 1"FromFormCode="Job 1-Form 1"FromTaskOpCode="1"ToJobCode="Job 1"ToFormCode="Job 1-Form 1"ToTaskOpCode="2"Lag="-1"Delay="0"/>
//    <Link Action="Create"FromJobCode="Job 1"FromFormCode="Job 1-Form 1"FromTaskOpCode="2"ToJobCode="Job 1"ToFormCode="Job 1-Form 1"ToTaskOpCode="3"Lag="-1"Delay="0"/>
//  </Links>
//</PrintFlowData>


C_TEXT:C284($jobform; $1; $xmltext; $note; $printflow_inbox_path; $2)

C_DATE:C307($currentDate; $exported; $0)
$exported:=!00-00-00!
C_TIME:C306($currentTime)
C_BOOLEAN:C305($sendProperties)
$sendProperties:=True:C214

If (Count parameters:C259=2)
	$jobform:=$1
	$printflow_inbox_path:=$2
Else 
	$jobform:="99280.01"
	$printflow_inbox_path:=util_DocumentPath("get")
End if 
$job:=Substring:C12($jobform; 1; 5)

READ ONLY:C145([Job_Forms:42])
READ ONLY:C145([Jobs:15])
//READ ONLY([Job_Forms_Items])
READ ONLY:C145([Job_Forms_Machines:43])
//READ ONLY([Job_Forms_Materials])
READ ONLY:C145([Job_Forms_Master_Schedule:67])

QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$jobform)

If (Records in selection:C76([Job_Forms:42])=1)
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=$jobform)
	RELATE ONE:C42([Job_Forms:42]JobNo:2)
	QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=$jobform)
	ORDER BY:C49([Job_Forms_Machines:43]; [Job_Forms_Machines:43]Sequence:5; >)
	
	$currentTime:=Current time:C178
	$currentDate:=Current date:C33
	//$now:=Change string($now;"T";11)
	$now:=PF_util_FormatDate(->$currentDate; $currentTime)
	C_TEXT:C284($title; $text; $docName)
	C_TIME:C306($docRef)
	$title:=""
	$text:=""
	$docName:="Job_"+Replace string:C233($jobform; "."; "_")+"_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xml"
	$docName:=$printflow_inbox_path+$docName
	
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
		APPEND TO ARRAY:C911($AttrVal; "Creating a job")
		
		APPEND TO ARRAY:C911($AttrName; "Version")
		APPEND TO ARRAY:C911($AttrVal; "Prism version 123")
		
		APPEND TO ARRAY:C911($AttrName; "ChangeDate")
		APPEND TO ARRAY:C911($AttrVal; $now)
		
		DOM SET XML ATTRIBUTE:C866($elementRef; $AttrName{1}; $AttrVal{1}; $AttrName{2}; $AttrVal{2}; $AttrName{3}; $AttrVal{3}; $AttrName{4}; $AttrVal{4}; $AttrName{5}; $AttrVal{5}; $AttrName{6}; $AttrVal{6}; $AttrName{7}; $AttrVal{7})
	End if   //root
	
	If (True:C214)  //jobs-job
		$jobsref:=DOM Append XML child node:C1080($elementRef; XML ELEMENT:K45:20; "<Jobs></Jobs>")
		DOM SET XML ATTRIBUTE:C866($jobsref; "Code"; "Jobs")
		
		$jobref:=DOM Append XML child node:C1080($jobsref; XML ELEMENT:K45:20; "<Job></Job>")
		ARRAY TEXT:C222($AttrName; 0)
		ARRAY TEXT:C222($AttrVal; 0)
		
		APPEND TO ARRAY:C911($AttrName; "Code")  //1
		APPEND TO ARRAY:C911($AttrVal; $job)
		
		APPEND TO ARRAY:C911($AttrName; "Action")  //2
		APPEND TO ARRAY:C911($AttrVal; "Create")
		
		APPEND TO ARRAY:C911($AttrName; "JobDescription")  //3
		APPEND TO ARRAY:C911($AttrVal; [Job_Forms:42]CustomerLine:62)
		
		APPEND TO ARRAY:C911($AttrName; "DueDate")  // Modified by: Mel Bohince (1/31/18) not JobDueDate
		APPEND TO ARRAY:C911($AttrVal; PF_util_FormatDate(->[Job_Forms_Master_Schedule:67]TargetDate_PrintFlow:88))
		
		APPEND TO ARRAY:C911($AttrName; "EarliestDate")  //5
		$epd:=Add to date:C393(Current date:C33; 0; 0; 14)  //arbitrary
		APPEND TO ARRAY:C911($AttrVal; PF_util_FormatDate(->$epd))
		
		APPEND TO ARRAY:C911($AttrName; "JobCustomer")  //6
		APPEND TO ARRAY:C911($AttrVal; [Jobs:15]CustID:2)
		
		APPEND TO ARRAY:C911($AttrName; "JobProduct")  //7
		APPEND TO ARRAY:C911($AttrVal; [Job_Forms:42]ProcessSpec:46)
		
		APPEND TO ARRAY:C911($AttrName; "JobStatus")  //8
		APPEND TO ARRAY:C911($AttrVal; [Job_Forms:42]Status:6)
		
		C_TEXT:C284($salerep; $cood; $plnnr; $csr)
		$salerep:=""
		$cood:=""
		$plnnr:=""
		$csr:=""
		Cust_getTeam([Job_Forms:42]cust_id:82; ->$salerep; ->$cood; ->$plnnr; ->$csr)
		APPEND TO ARRAY:C911($AttrName; "JobCustomerServiceRep")  //12
		APPEND TO ARRAY:C911($AttrVal; $csr)
		
		APPEND TO ARRAY:C911($AttrName; "JobSalesRep")  //13
		APPEND TO ARRAY:C911($AttrVal; $salerep)
		
		APPEND TO ARRAY:C911($AttrName; "JobCustomerName")  //9
		APPEND TO ARRAY:C911($AttrVal; Substring:C12(CUST_getName([Job_Forms:42]cust_id:82; "elc"); 1; 20))
		
		APPEND TO ARRAY:C911($AttrName; "JobSalesQuantity")  //10  Modified by: Mel Bohince (11/9/17) 
		APPEND TO ARRAY:C911($AttrVal; String:C10([Job_Forms:42]QtyWant:22))
		
		$note:=Replace string:C233([Job_Forms:42]Notes:32; Char:C90(13); "**")  //11
		$note:=Replace string:C233($note; "  "; "")
		
		APPEND TO ARRAY:C911($AttrName; "JobNote")
		APPEND TO ARRAY:C911($AttrVal; Substring:C12($note; 1; 200))
		
		DOM SET XML ATTRIBUTE:C866($jobref; $AttrName{1}; $AttrVal{1}; $AttrName{2}; $AttrVal{2}; $AttrName{3}; $AttrVal{3}; $AttrName{4}; $AttrVal{4}; $AttrName{5}; $AttrVal{5}; $AttrName{6}; $AttrVal{6}; $AttrName{7}; $AttrVal{7}; $AttrName{8}; $AttrVal{8}; $AttrName{9}; $AttrVal{9}; $AttrName{10}; $AttrVal{10}; $AttrName{11}; $AttrVal{11}; $AttrName{12}; $AttrVal{12}; $AttrName{13}; $AttrVal{13})
	End if   //jobs
	
	If ($sendProperties)  //job prop
		$propref:=DOM Append XML child node:C1080($jobref; XML ELEMENT:K45:20; "<Properties></Properties>")
		//PF_AddProperty ($propref;"job-1stRelease";PF_util_FormatDate (->[Job_Forms_Master_Schedule]FirstReleaseDat))
		//PF_AddProperty ($propref;"job-HRD";PF_util_FormatDate (->[Job_Forms_Master_Schedule]MAD))
		//PF_AddProperty ($propref;"job-GrossShts";String([Job_Forms]EstGrossSheets))
		PF_AddProperty($propref; "Brand"; [Job_Forms:42]CustomerLine:62)
		//PF_AddProperty ($propref;"Die Cut";PF_DateToYesNo ([Job_Forms_Master_Schedule]GlueReady))
		PF_AddProperty($propref; "Job Bag Approved"; PF_DateToYesNo([Job_Forms_Master_Schedule:67]DateBagApproved:49))
		PF_AddProperty($propref; "Job Bag Received"; PF_DateToYesNo([Job_Forms_Master_Schedule:67]DateBagReceived:48))
		//PF_AddProperty ($propref;"Job Code";[Job_Forms]JobType)
		
		//PF_AddProperty ($propref;"Job Customer Code";[Job_Forms]cust_id)
		//PF_AddProperty ($propref;"Job Customer Name";CUST_getName ([Job_Forms]cust_id;"elc"))
		//PF_AddProperty ($propref;"Job Due Date";String([Job_Forms_Master_Schedule]MAD;Internal date short special))
		
		//PF_AddProperty ($propref;"Job Quantity";String([Job_Forms]EstNetSheets))
		PF_AddProperty($propref; "HRD"; PF_util_FormatDate(->[Job_Forms_Master_Schedule:67]MAD:21))
		//PF_AddProperty ($propref;"Job Status AMS";[Job_Forms]Status)
		PF_AddProperty($propref; "Plant"; [Job_Forms_Master_Schedule:67]LocationOfMfg:30)
		PF_AddProperty($propref; "PSpec."; [Job_Forms:42]ProcessSpec:46)
		PF_AddProperty($propref; "Stock Received"; PF_DateToYesNo([Job_Forms_Master_Schedule:67]DateStockRecd:17))
		PF_AddProperty($propref; "Stock Sheeted"; PF_DateToYesNo([Job_Forms_Master_Schedule:67]DateStockSheeted:47))  //Substring(String(;Internal date short special);1;5))
		PF_AddProperty($propref; "Lin. Ft. Required"; String:C10(Job_getBoardLinearFeet([Job_Forms:42]JobFormID:5)))
		PF_AddProperty($propref; "Printed"; PF_DateToYesNo([Job_Forms_Master_Schedule:67]Printed:32))
		
	End if   //1st prop
	
	If (True:C214)  //form
		$formref:=DOM Append XML child node:C1080($jobref; XML ELEMENT:K45:20; "<Form></Form>")
		ARRAY TEXT:C222($AttrName; 0)
		ARRAY TEXT:C222($AttrVal; 0)
		APPEND TO ARRAY:C911($AttrName; "Code")
		APPEND TO ARRAY:C911($AttrVal; $jobform)
		
		APPEND TO ARRAY:C911($AttrName; "Action")
		APPEND TO ARRAY:C911($AttrVal; "Create")
		
		APPEND TO ARRAY:C911($AttrName; "FormDescription")
		APPEND TO ARRAY:C911($AttrVal; [Job_Forms:42]CustomerLine:62)
		
		APPEND TO ARRAY:C911($AttrName; "MakeQuantity")
		APPEND TO ARRAY:C911($AttrVal; String:C10([Job_Forms:42]EstNetSheets:28))
		
		APPEND TO ARRAY:C911($AttrName; "Status")
		APPEND TO ARRAY:C911($AttrVal; [Job_Forms:42]Status:6)
		DOM SET XML ATTRIBUTE:C866($formref; $AttrName{1}; $AttrVal{1}; $AttrName{2}; $AttrVal{2}; $AttrName{3}; $AttrVal{3}; $AttrName{4}; $AttrVal{4}; $AttrName{5}; $AttrVal{5})
	End if   //form
	
	If ($sendProperties)  //form prop
		$propref:=DOM Append XML child node:C1080($formref; XML ELEMENT:K45:20; "<Properties></Properties>")
		PF_AddProperty($propref; "sheet-caliper"; String:C10([Job_Forms:42]Caliper:49))
		$rmWidth:=String:C10(Job_getBoardWidth($jobform))
		
		PF_AddProperty($propref; "sheet-width"; String:C10([Job_Forms:42]Width:23))
		PF_AddProperty($propref; "sheet-length"; String:C10([Job_Forms:42]Lenth:24))
		If ([Job_Forms:42]ShortGrain:48)
			PF_AddProperty($propref; "Grain"; "ShortGrain")
		End if 
	End if   //form prop
	
	
	If (True:C214)  //task
		ARRAY TEXT:C222(aTaskChain; 0)
		While (Not:C34(End selection:C36([Job_Forms_Machines:43])))
			If (Position:C15([Job_Forms_Machines:43]CostCenterID:4; <>GLUERS)=0)
				//If (<>jobformPrefix)
				//APPEND TO ARRAY(aTaskChain;[Job_Forms_Machines]JobSequence)  // use this for the link section
				//Else   //cut off jobform part
				APPEND TO ARRAY:C911(aTaskChain; Substring:C12([Job_Forms_Machines:43]JobSequence:8; 10))  //12345.78.010
				//End if 
				PF_JobFormTask($formref; $sendProperties)
			Else 
				//task chain updated within this call
				PF_JobFormItem($formref; $sendProperties)
			End if 
			NEXT RECORD:C51([Job_Forms_Machines:43])
		End while 
	End if   //task
	
	
	If (True:C214)  //link
		$linkref:=DOM Append XML child node:C1080($elementRef; XML ELEMENT:K45:20; "<Links></Links>")
		//setup base link attributes, then vary the predecessor and successor
		ARRAY TEXT:C222($AttrName; 0)
		ARRAY TEXT:C222($AttrVal; 0)
		
		APPEND TO ARRAY:C911($AttrName; "Action")
		APPEND TO ARRAY:C911($AttrVal; "Create")
		
		APPEND TO ARRAY:C911($AttrName; "FromJobCode")
		APPEND TO ARRAY:C911($AttrVal; Substring:C12($jobform; 1; 5))
		
		APPEND TO ARRAY:C911($AttrName; "FromFormCode")
		APPEND TO ARRAY:C911($AttrVal; $jobform)
		
		APPEND TO ARRAY:C911($AttrName; "FromTaskOpCode")
		APPEND TO ARRAY:C911($AttrVal; "010")
		
		APPEND TO ARRAY:C911($AttrName; "ToJobCode")
		APPEND TO ARRAY:C911($AttrVal; Substring:C12($jobform; 1; 5))
		
		APPEND TO ARRAY:C911($AttrName; "ToFormCode")
		APPEND TO ARRAY:C911($AttrVal; $jobform)
		
		APPEND TO ARRAY:C911($AttrName; "ToTaskOpCode")
		APPEND TO ARRAY:C911($AttrVal; "020")
		
		APPEND TO ARRAY:C911($AttrName; "Lag")
		APPEND TO ARRAY:C911($AttrVal; "-1")
		
		APPEND TO ARRAY:C911($AttrName; "Delay")
		APPEND TO ARRAY:C911($AttrVal; "0")
		
		$blankingSeq:=""
		For ($link; 1; (Size of array:C274(aTaskChain)-1))
			$ccRef:=DOM Append XML child node:C1080($linkref; XML ELEMENT:K45:20; "<Link />")
			If (Length:C16(aTaskChain{$link+1})<4)
				$blankingSeq:=aTaskChain{$link+1}  //saving the highest code# before finishing
				
				$AttrVal{4}:=aTaskChain{$link}
				$AttrVal{7}:=aTaskChain{$link+1}
				
			Else 
				$AttrVal{4}:=$blankingSeq
				$AttrVal{7}:=aTaskChain{$link+1}
			End if 
			DOM SET XML ATTRIBUTE:C866($ccRef; $AttrName{1}; $AttrVal{1}; $AttrName{2}; $AttrVal{2}; $AttrName{3}; $AttrVal{3}; $AttrName{4}; $AttrVal{4}; $AttrName{5}; $AttrVal{5}; $AttrName{6}; $AttrVal{6}; $AttrName{7}; $AttrVal{7}; $AttrName{8}; $AttrVal{8}; $AttrName{9}; $AttrVal{9})
		End for 
	End if   //link
	
	DOM EXPORT TO FILE:C862($elementRef; $docName)
	If (ok=1)  // Modified by: Mel Bohince (12/18/17) 
		$exported:=Current date:C33
	End if 
	DOM CLOSE XML:C722($elementRef)
	//BEEP
	
	
Else 
	uConfirm($jobform+" was not found.")
End if 

$0:=$exported
//api_Jobs