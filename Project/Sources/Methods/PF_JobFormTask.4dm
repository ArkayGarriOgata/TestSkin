//%attributes = {}
// -------
// Method: PF_JobFormTask   ( ) ->
// By: Mel Bohince @ 09/01/17, 11:49:57
// Description
// return a complete task node
// ----------------------------------------------------
// <Task Action="Create" Code="2" Description="Press" CostCenterCode="210" SetupMinutes="20" RunMinutes="120" Status="Available"
//<Task Action="Create"Code="1"Description="Files In"CostCenterCode="100"RunMinutes="60"Status="Complete"TaskNote="strTaskNote"ProblemDescription="strProblemDescription"TodoAction="strTaskTodoAction"ActionSender="strTaskActionSender"LockedBy="strTaskLockedBy"AssignedTo="strTaskAssignedTo">
//  <Properties>
//    <Property Name="Task character Property"Value="Task Value"/>
//    <Property Name="Task integer Property"Value="10"/>
//  </Properties>
//</Task>
// Modified by: Mel Bohince (11/9/17) add PlannedTotalQuantity

READ ONLY:C145([Cost_Centers:27])
READ ONLY:C145([ProductionSchedules:110])
READ ONLY:C145([Job_Forms_Materials:55])

C_TEXT:C284($formref; $1; $yesNo)
$formref:=$1
C_BOOLEAN:C305($sendProperties)
$sendProperties:=$2
$jobform:=Substring:C12([Job_Forms_Machines:43]JobSequence:8; 1; 8)

$taskref:=DOM Append XML child node:C1080($formref; XML ELEMENT:K45:20; "<Task></Task>")

ARRAY TEXT:C222($AttrName; 0)
ARRAY TEXT:C222($AttrVal; 0)
APPEND TO ARRAY:C911($AttrName; "Code")
//If (<>jobformPrefix)
//APPEND TO ARRAY($AttrVal;[Job_Forms_Machines]JobSequence)
//Else 
APPEND TO ARRAY:C911($AttrVal; Substring:C12([Job_Forms_Machines:43]JobSequence:8; 10))
//End if 

APPEND TO ARRAY:C911($AttrName; "Action")
APPEND TO ARRAY:C911($AttrVal; "Create")

APPEND TO ARRAY:C911($AttrName; "Description")
QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=[Job_Forms_Machines:43]CostCenterID:4)
APPEND TO ARRAY:C911($AttrVal; Substring:C12([Cost_Centers:27]cc_Group:2; 4))

APPEND TO ARRAY:C911($AttrName; "CostCenterCode")
APPEND TO ARRAY:C911($AttrVal; String:C10(Num:C11(Substring:C12([Cost_Centers:27]cc_Group:2; 1; 2)); "000"))  //[Job_Forms_Machines]CostCenterID)

APPEND TO ARRAY:C911($AttrName; "Status")
If ([Job_Forms_Machines:43]Actual_Qty:19>0) & ([Job_Forms_Machines:43]Planned_Qty:10>0)
	APPEND TO ARRAY:C911($AttrVal; String:C10(Round:C94([Job_Forms_Machines:43]Actual_Qty:19/[Job_Forms_Machines:43]Planned_Qty:10*100; 0))+"%")
Else 
	APPEND TO ARRAY:C911($AttrVal; "Waiting")
End if 

//APPEND TO ARRAY($AttrName;"SetupMinutes")
//APPEND TO ARRAY($AttrVal;String(Round(([Job_Forms_Machines]Planned_MR_Hrs*60);0)))

APPEND TO ARRAY:C911($AttrName; "RunMinutes")
APPEND TO ARRAY:C911($AttrVal; String:C10(Round:C94((([Job_Forms_Machines:43]Planned_MR_Hrs:15+[Job_Forms_Machines:43]Planned_RunHrs:37)*60); 0)))

APPEND TO ARRAY:C911($AttrName; "PlannedTotalQuantity")  // Modified by: Mel Bohince (11/9/17) 
APPEND TO ARRAY:C911($AttrVal; String:C10([Job_Forms_Machines:43]Planned_Qty:10))  //+[Job_Forms_Machines]Planned_Waste

DOM SET XML ATTRIBUTE:C866($taskref; $AttrName{1}; $AttrVal{1}; $AttrName{2}; $AttrVal{2}; $AttrName{3}; $AttrVal{3}; $AttrName{4}; $AttrVal{4}; $AttrName{5}; $AttrVal{5}; $AttrName{6}; $AttrVal{6}; $AttrName{7}; $AttrVal{7})  //;$AttrName{8};$AttrVal{8

If ($sendProperties)
	
	$propref:=DOM Append XML child node:C1080($taskref; XML ELEMENT:K45:20; "<Properties></Properties>")
	QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8=[Job_Forms_Machines:43]JobSequence:8)
	
	Case of 
			//: ([Cost_Centers]cc_Group="10.PREP")  //unlikely
			//: ([Cost_Centers]cc_Group="90.STRIPPING")  //unlikely
			//Not(util_isDateNull (->datefield))
			
		: ([Cost_Centers:27]cc_Group:2="20.PRINTING")
			//PROPERTIES:
			//ink related:
			QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Commodity_Key:12="02@"; *)
			QUERY:C277([Job_Forms_Materials:55];  | ; [Job_Forms_Materials:55]Commodity_Key:12="03@"; *)
			QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]JobForm:1=$jobform; *)
			QUERY:C277([Job_Forms_Materials:55];  & [Job_Forms_Materials:55]Sequence:3=Num:C11(Substring:C12([Job_Forms_Machines:43]JobSequence:8; 10)))
			ORDER BY FORMULA:C300([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Alpha20_2:21; >; [Job_Forms_Materials:55]Real2:18; >; Substring:C12([Job_Forms_Materials:55]Commodity_Key:12; 1; 2); >)
			$numMatl:=Records in selection:C76([Job_Forms_Materials:55])
			PF_AddProperty($propref; "Number of Colors"; String:C10($numMatl))
			PF_AddProperty($propref; "Process"; PF_BooleanToYesNo([ProductionSchedules:110]ProcessColors:21))
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
				
				For ($rot; 1; $numMatl)
					QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Job_Forms_Materials:55]Raw_Matl_Code:7)
					PF_AddProperty($propref; "Rotation "+String:C10([Job_Forms_Materials:55]Real2:18)+" Color"; [Raw_Materials:21]Flex5:23)
					PF_AddProperty($propref; "Rotation "+String:C10([Job_Forms_Materials:55]Real2:18)+" Material Code"; [Job_Forms_Materials:55]Raw_Matl_Code:7)
					NEXT RECORD:C51([Job_Forms_Materials:55])
				End for 
				
				
			Else 
				
				GET FIELD RELATION:C920([Job_Forms_Materials:55]Raw_Matl_Code:7; $lienAller; $lienRetour)
				SET FIELD RELATION:C919([Job_Forms_Materials:55]Raw_Matl_Code:7; Automatic:K51:4; Do not modify:K51:1)
				
				ARRAY REAL:C219($_Real2; 0)
				ARRAY TEXT:C222($_Raw_Matl_Code; 0)
				ARRAY TEXT:C222($_Raw_Matl_Code1; 0)
				ARRAY TEXT:C222($_Flex5; 0)
				
				SELECTION TO ARRAY:C260([Job_Forms_Materials:55]Real2:18; $_Real2; [Job_Forms_Materials:55]Raw_Matl_Code:7; $_Raw_Matl_Code; [Raw_Materials:21]Raw_Matl_Code:1; $_Raw_Matl_Code1; [Raw_Materials:21]Flex5:23; $_Flex5)
				
				SET FIELD RELATION:C919([Job_Forms_Materials:55]Raw_Matl_Code:7; $lienAller; $lienRetour)
				
				
				For ($Iter; 1; Size of array:C274($_Real2); 1)
					
					PF_AddProperty($propref; "Rotation "+String:C10($_Real2{$Iter})+" Color"; $_Flex5{$Iter})
					PF_AddProperty($propref; "Rotation "+String:C10($_Real2{$Iter})+" Material Code"; $_Raw_Matl_Code{$Iter})
					
				End for 
				
				
			End if   // END 4D Professional Services : January 2019 query selection
			
			//RESOURCES:
			PF_AddProperty($propref; "Cold Foil"; PF_BooleanToYesNo([ProductionSchedules:110]ColdFoil:76))
			PF_AddProperty($propref; "Cyrel Plate"; PF_DateToYesNo([ProductionSchedules:110]CyrelsReady:19))
			PF_AddProperty($propref; "Ink"; PF_DateToYesNo([ProductionSchedules:110]InkReady:20))
			PF_AddProperty($propref; "Plated"; PF_DateToYesNo([ProductionSchedules:110]PlatesReady:18))
			
			
		: ([Cost_Centers:27]cc_Group:2="30.SHEETING")
			$rmWidth:=String:C10(Job_getBoardWidth($jobform))
			PF_AddProperty($propref; "Roll Width"; $rmWidth)
			
		: ([Cost_Centers:27]cc_Group:2="50.STAMPING")
			//PROPERTIES:
			PF_AddProperty($propref; "Combo Units"; String:C10([Job_Forms_Machines:43]Flex_field3:17))
			//PF_AddProperty ($propref;"Emboss";String([Job_Forms_Machines]Flex_field1))
			PF_AddProperty($propref; "Emboss Units"; String:C10([Job_Forms_Machines:43]Flex_field1:6))
			PF_AddProperty($propref; "Flat Units"; String:C10([Job_Forms_Machines:43]Flex_field2:7))
			//RESOURCES:
			PF_AddProperty($propref; "Dylux Checked"; PF_DateToYesNo([ProductionSchedules:110]DateDyluxChecked:75))
			PF_AddProperty($propref; "Embossing Dies Received"; PF_DateToYesNo([ProductionSchedules:110]EmbossingDies:29))
			PF_AddProperty($propref; "Embossing Film"; PF_DateToYesNo([ProductionSchedules:110]DateFilmEmbossRcd:44))
			PF_AddProperty($propref; "Leaf Received"; PF_DateToYesNo([ProductionSchedules:110]Leaf:30))
			PF_AddProperty($propref; "Stamp Dies Received"; PF_DateToYesNo([ProductionSchedules:110]StampingDies:28))
			PF_AddProperty($propref; "Stamping Film Received"; PF_DateToYesNo([ProductionSchedules:110]DateFilmStampingRcd:43))
			
		: ([Cost_Centers:27]cc_Group:2="55.BLANKING")
			//PROPERTIES:
			PF_AddProperty($propref; "Repeat Form"; PF_BooleanToYesNo([Job_Forms_Machines:43]Flex_field6:34))
			PF_AddProperty($propref; "Stripping Unit"; PF_BooleanToYesNo([Job_Forms_Machines:43]Flex_Field5:27))
			//RESOURCES:
			PF_AddProperty($propref; "Blanker Rec'd"; PF_DateToYesNo([ProductionSchedules:110]DateBlankerRecd:42))
			PF_AddProperty($propref; "Counters Rec'd"; PF_DateToYesNo([ProductionSchedules:110]DateCountersRecd:41))
			PF_AddProperty($propref; "Die Board Rec'd"; PF_DateToYesNo([ProductionSchedules:110]DateDieBoardRecd:45))
			PF_AddProperty($propref; "Dylux Checked"; PF_DateToYesNo([ProductionSchedules:110]DateDyluxChecked:75))
			PF_AddProperty($propref; "Female Stripper"; PF_DateToYesNo([ProductionSchedules:110]FemaleStripperBoard:26))
			PF_AddProperty($propref; "Stripping Unit"; PF_DateToYesNo([ProductionSchedules:110]CyrelsReady:19))
			
			//: ([Cost_Centers]cc_Group="80.FINISHING")  //this should have been redirected to PF_JobFormItem
			// see PF_JobFormItem
			
			//: ([Cost_Centers]cc_Group="89.OUTSIDE SERVICE")
			// in house, requistioned,purchased, tooling, standards, stock, wip rtn'd
			
			
			
	End case 
	
	//send for all
	PF_AddProperty($propref; "task-qty-net"; String:C10([Job_Forms_Machines:43]Planned_Qty:10))
	PF_AddProperty($propref; "task-qty-waste"; String:C10([Job_Forms_Machines:43]Planned_Waste:11))
	PF_AddProperty($propref; "Customer Visit"; PF_BooleanToYesNo([ProductionSchedules:110]CustomerVisit:24))
	PF_AddProperty($propref; "CV Day Shift"; PF_BooleanToYesNo([ProductionSchedules:110]DayShift:80))  // Modified by: Mel Bohince (10/2/18) 
End if 

