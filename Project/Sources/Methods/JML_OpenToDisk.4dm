//%attributes = {}
// Method: JML_OpenToDisk () -> 
// ----------------------------------------------------
// by: mel: 10/23/03, 10:07:56
// ----------------------------------------------------
// Description:
// report that marty wants to compare jobs to releases
//see also REL_OpenReportToDisk
// ----------------------------------------------------

C_TEXT:C284($t; $cr)
C_TEXT:C284($distributionList; $1; xTitle; xText; docName)
C_DATE:C307($today; $last)
C_LONGINT:C283($days; $i; $j; $numJML; $numJMI; $numRels)
C_TEXT:C284($histoGram; $distribution)
C_TIME:C306($docRef)

$t:=Char:C90(9)
$cr:=Char:C90(13)
xTitle:="Open Jobs on JobMasterLog (not Glue Ready)"
xText:="Jobform"+$t+"Line"+$t+"JobType"+$t+"MAD_REV"+$t+"Period"+$t+"SalesValue"+$t+"ProduceQty"+$t+"ReleaseHistogram"+$t+"see: http://intranet.arkay.com/ams/categories/faqs/2003/09/26.html#a79"+$cr
$distributionList:=$1

$days:=7*10
$histoGram:="-"*$days  //each character represents a day, the first being today
$today:=4D_Current_date
$last:=$today+$days-1

docName:="OpenJobs"+fYYMMDD(4D_Current_date; 1)+".xls"
$docRef:=util_putFileName(->docName)
If ($docRef#?00:00:00?)
	SEND PACKET:C103($docRef; xTitle+$cr+$cr)
	SEND PACKET:C103($docRef; xText)
	xText:=""
	READ ONLY:C145([Job_Forms_Master_Schedule:67])
	READ ONLY:C145([Job_Forms:42])
	
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
	QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]JobForm:4#"@**"; *)
	QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]GlueReady:28=!00-00-00!)
	
	C_LONGINT:C283($i; $numRecs)
	C_BOOLEAN:C305($break)
	$break:=False:C215
	$numRecs:=Records in selection:C76([Job_Forms_Master_Schedule:67])
	C_DATE:C307($mad)
	C_TEXT:C284($period)
	
	uThermoInit($numRecs; "Reporting JML Records")
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
		
		For ($i; 1; $numRecs)
			If ($break)
				$i:=$i+$numRecs
			End if 
			If (Length:C16(xText)>20000)
				SEND PACKET:C103($docRef; xText)
				xText:=""
			End if 
			QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=[Job_Forms_Master_Schedule:67]JobForm:4)
			$mad:=Date:C102(util_iif([Job_Forms_Master_Schedule:67]OrigRevDate:20#!00-00-00!; String:C10([Job_Forms_Master_Schedule:67]OrigRevDate:20; System date short:K1:1); String:C10([Job_Forms_Master_Schedule:67]MAD:21; System date short:K1:1)))
			$period:=String:C10(Year of:C25($mad)+(Month of:C24($mad)/100); "0000.00")
			xText:=xText+[Job_Forms_Master_Schedule:67]JobForm:4+$t+[Job_Forms_Master_Schedule:67]Line:5+$t+[Job_Forms_Master_Schedule:67]JobType:31+$t+String:C10($mad; System date short:K1:1)+$t+$period+$t+String:C10([Job_Forms_Master_Schedule:67]SalesValue:35)+$t+String:C10([Job_Forms:42]QtyWant:22)+$t
			
			$distribution:=$histoGram
			$numRels:=0
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=[Job_Forms_Master_Schedule:67]JobForm:4)
			$numJMI:=Records in selection:C76([Job_Forms_Items:44])
			SELECTION TO ARRAY:C260([Job_Forms_Items:44]ProductCode:3; $aCPN)
			
			For ($j; 1; $numJMI)
				QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5#!00-00-00!; *)
				QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]ProductCode:11=$aCPN{$j}; *)
				QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39>1; *)
				QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<@"; *)
				QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!; *)
				QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0)
				$numRels:=Records in selection:C76([Customers_ReleaseSchedules:46])
				If ($numRels>0)
					SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]Sched_Date:5; $aSchd)
					
					For ($k; 1; $numRels)
						$relDate:=$aSchd{$k}
						Case of 
							: ($relDate=!00-00-00!)
								$when:=$days
							: ($relDate<=$today)
								$when:=1
							: ($relDate>=$last)
								$when:=$days
							Else 
								$when:=$relDate-$today+1
						End case 
						$current:=Num:C11($distribution[[$when]])
						If ($current>=9)
							$distribution[[$when]]:="X"
						Else 
							$distribution[[$when]]:=String:C10(Num:C11($distribution[[$when]])+1)
						End if 
					End for 
					
				End if 
			End for 
			xText:=xText+$distribution+$cr
			
			NEXT RECORD:C51([Job_Forms_Master_Schedule:67])
			uThermoUpdate($i)
		End for 
		
		
	Else 
		
		ARRAY TEXT:C222($_JobForm; 0)
		ARRAY DATE:C224($_OrigRevDate; 0)
		ARRAY TEXT:C222($_Line; 0)
		ARRAY TEXT:C222($_JobType; 0)
		ARRAY DATE:C224($_MAD; 0)
		ARRAY REAL:C219($_SalesValue; 0)
		
		SELECTION TO ARRAY:C260([Job_Forms_Master_Schedule:67]JobForm:4; $_JobForm; \
			[Job_Forms_Master_Schedule:67]OrigRevDate:20; $_OrigRevDate; \
			[Job_Forms_Master_Schedule:67]Line:5; $_Line; \
			[Job_Forms_Master_Schedule:67]JobType:31; $_JobType; \
			[Job_Forms_Master_Schedule:67]MAD:21; $_MAD; \
			[Job_Forms_Master_Schedule:67]SalesValue:35; $_SalesValue)
		
		
		
		For ($i; 1; $numRecs)
			If ($break)
				$i:=$i+$numRecs
			End if 
			
			If (Length:C16(xText)>20000)
				SEND PACKET:C103($docRef; xText)
				xText:=""
			End if 
			
			QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$_JobForm{$i})
			$mad:=Date:C102(util_iif($_OrigRevDate{$i}#!00-00-00!; String:C10($_OrigRevDate{$i}; System date short:K1:1); String:C10($_MAD{$i}; System date short:K1:1)))
			$period:=String:C10(Year of:C25($mad)+(Month of:C24($mad)/100); "0000.00")
			xText:=xText+$_JobForm{$i}+$t+$_Line{$i}+$t+$_JobType{$i}+$t+String:C10($mad; System date short:K1:1)+$t+$period+$t+String:C10($_SalesValue{$i})+$t+String:C10([Job_Forms:42]QtyWant:22)+$t
			
			$distribution:=$histoGram
			$numRels:=0
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$_JobForm{$i})
			$numJMI:=Records in selection:C76([Job_Forms_Items:44])
			SELECTION TO ARRAY:C260([Job_Forms_Items:44]ProductCode:3; $aCPN)
			
			For ($j; 1; $numJMI)
				QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5#!00-00-00!; *)
				QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]ProductCode:11=$aCPN{$j}; *)
				QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39>1; *)
				QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<@"; *)
				QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!; *)
				QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0)
				$numRels:=Records in selection:C76([Customers_ReleaseSchedules:46])
				
				If ($numRels>0)
					SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]Sched_Date:5; $aSchd)
					
					For ($k; 1; $numRels)
						$relDate:=$aSchd{$k}
						Case of 
							: ($relDate=!00-00-00!)
								$when:=$days
							: ($relDate<=$today)
								$when:=1
							: ($relDate>=$last)
								$when:=$days
							Else 
								$when:=$relDate-$today+1
						End case 
						$current:=Num:C11($distribution[[$when]])
						If ($current>=9)
							$distribution[[$when]]:="X"
						Else 
							$distribution[[$when]]:=String:C10(Num:C11($distribution[[$when]])+1)
						End if 
					End for 
					
				End if 
			End for 
			xText:=xText+$distribution+$cr
			
			uThermoUpdate($i)
		End for 
		
		
	End if   // END 4D Professional Services : January 2019 
	uThermoClose
	//
	SEND PACKET:C103($docRef; xText)
	CLOSE DOCUMENT:C267($docRef)
	// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
	
	REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
	REDUCE SELECTION:C351([Job_Forms:42]; 0)
	EMAIL_Sender(xTitle; ""; "Open attached spreadsheet with Excel."; $distributionList; docName)
	util_deleteDocument(docName)
	
Else 
	EMAIL_Sender(xTitle; ""; "Couldn't create document"; $distributionList)
End if 

xTitle:=""
xText:=""