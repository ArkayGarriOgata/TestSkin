//%attributes = {}
//PM:  JOB_BAG_Report  
//All NEW layouts will be named JBN_xxxxx (Job Bag New)
//$1 - string (optional) jobform to print when printing froma selection
//• 11/24/97 cs rewrite of job bag
//• 1/20/98 cs changed from est grosss to press qty - Lena
//• 1/23/98 modifications to handle printing multiple records from output listing
//• 1/30/98 cs moved check boxes to below header of 2nd page
//• 2/2/98 cs added heavy line for sub from seperation,
//   added code & layout for printing subform level sheets to press at each cost 
//   center
//• 2/13/98 cs page overflow problem & checkbox area print problem
//• 2/24/98 cs chenged the way in which the sf break down is determined to print
//  added MR and Runtimes 
//• 3/4/98 cs changed where Caliper is pulled from used to be 
//   ProcessSpec now Jobform  3/10/98 back to pspec
//• 6/3/98 cs insure that page setup is correct
//• 6/4/98 cs use jobform to get caliper 
//•011499  MLB  add Shipdate and Pressdate
//101800 begin Dennis revisions`aRatio
//• mlb - 5/15/02  11:36 add for Color Standard
// • mel (6/17/05, 15:12:58) add glue direction next to outline
// Modified by: Mel Bohince (11/20/13)  exclude components from jobbag, see JOB_CreateJobFormsMaterialsRec
// Modified by: Garri Ogata (07/07/21) added query for plastic 20@ (137)

C_BOOLEAN:C305($fShortGrain; fPrinted)  //• 2/13/98 cs fPrinted - flag for checkbox section 
C_LONGINT:C283($MaxPixels; $Pixels; $PrevPlanQty)  // for multi customers
C_TEXT:C284(tText; xText; Subtitle; xTitle; xComment)  //subtitle
C_TEXT:C284($JobCustID)
C_LONGINT:C283($j)
C_TEXT:C284($1; $Job)
ARRAY REAL:C219(aRatio; 0)
ARRAY LONGINT:C221(aSubForm; 0)
C_TEXT:C284(SWGTA1; SWGTA2; SWGTA3; SWGTA4; SWGTA5; SWGTA6; SWGTA7; SWGTA8; SWGTA9)  //• 2/5/98 used for subform IDs on subform included area

t21:=""
fPrinted:=False:C215
$bool:=FG_LaunchItem("init")

MESSAGES OFF:C175
//NewWindow (500;400;0;4;"Printing Job Bag")

If (Count parameters:C259=0)  //printing from a menu option
	$Job:=Request:C163("Enter Jobform")
	
	If (OK=1)
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$Job)
		If (Records in selection:C76([Job_Forms:42])#1)  //if the entered job form is not unique
			OK:=0  //stop printing
		End if 
	End if 
End if 

If (OK=1)  //it is OK to continue
	If (cb1=1) | (cb5=1)
		PDF_setUp("jobbag"+[Job_Forms:42]JobFormID:5+".pdf"; False:C215)
		$maxPixels:=540  //landscape
		iPage:=1
		$Pixels:=0
		$PrevPlanQty:=0  //• 2/24/98 cs used to track previous planed qty to look for sheet differnces
		
		If ([Jobs:15]JobNo:1#[Job_Forms:42]JobNo:2)
			RELATE ONE:C42([Job_Forms:42]JobNo:2)
		End if 
		
		C_DATE:C307($pressDate; $shipDate)  //•011499  MLB  
		If ([Job_Forms_Master_Schedule:67]JobForm:4#[Job_Forms:42]JobFormID:5)
			READ ONLY:C145([Job_Forms_Master_Schedule:67])
			QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=[Job_Forms:42]JobFormID:5)
			$shipDate:=[Job_Forms_Master_Schedule:67]FirstReleaseDat:13
			$pressDate:=[Job_Forms_Master_Schedule:67]PressDate:25
			REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
		Else 
			$shipDate:=[Job_Forms_Master_Schedule:67]FirstReleaseDat:13
			$pressDate:=[Job_Forms_Master_Schedule:67]PressDate:25
		End if 
		$isLaunch:=Pjt_isLaunch([Job_Forms:42]JobFormID:5)
		If (Not:C34($isLaunch))
			$numJMI:=qryJMI([Job_Forms:42]JobFormID:5; 0; "@")
			If ($numJMI>0)
				SELECTION TO ARRAY:C260([Job_Forms_Items:44]ProductCode:3; $aCPN)
				For ($item; 1; $numJMI)
					If (FG_LaunchItem("hold"; $aCPN{$item}))
						$isLaunch:=True:C214
						$item:=$item+$numJMI
					End if 
				End for 
			End if 
		End if 
		
		//----------------------- SET UP MAIN HEADER -----------
		//•011499  MLB  add press and ship dates
		t2b:="("+Substring:C12([Job_Forms:42]JobType:33; 3)+") Need:"+String:C10([Job_Forms:42]NeedDate:1; <>MIDDATE)+" Press:"+Substring:C12(String:C10($pressDate; <>MIDDATE); 1; 5)+" Ship:"+Substring:C12(String:C10($shipDate; <>MIDDATE); 1; 5)  //•071797  mBohince  add need date
		$JobForm:=[Job_Forms:42]JobFormID:5
		
		tText:=fBarCodeSym(39; [Job_Forms:42]JobFormID:5)
		If (Not:C34($isLaunch))
			t2:=[Job_Forms:42]JobFormID:5+" - "+[Jobs:15]CustomerName:5
		Else 
			t2:=[Job_Forms:42]JobFormID:5+" LAUNCH "+[Jobs:15]CustomerName:5
			BEEP:C151
			ALERT:C41("USE COLORED PAPER FOR LAUNCH"; "Ready")
		End if 
		
		t3:=String:C10(4D_Current_date; <>MIDDATE)+" "+String:C10(4d_Current_time; <>HHMM)
		t3a:="Version "+String:C10([Job_Forms:42]VersionNumber:57)+" as of "+String:C10([Job_Forms:42]VersionDate:58; <>MIDDATE)+" by "+[Job_Forms:42]ModWho:8
		tText1:=Uppercase:C13([Job_Forms:42]Status:6)+"  "+[Job_Forms:42]Run_Location:55
		$Sheets2Pres:=[Job_Forms:42]EstGrossSheets:27
		
		If (cb5=1)  //page 1
			Print form:C5([Jobs:15]; "JBN_Head1")
			$Pixels:=$Pixels+29
			
			//----------------------- SET UP JOB HEADER -----------
			t99:=[Job_Forms:42]ProcessSpec:46
			t7a:=[Jobs:15]Line:3
			RELATE MANY:C262([Job_Forms:42]JobFormID:5)
			JBNSubFormRatio  //• 2/2/98 cs created array of ratios for each subform, see materials
			QUERY SELECTION:C341([Job_Forms_Materials:55]; [Job_Forms_Materials:55]CostCenterID:2#"INX")  // Modified by: Mel Bohince (11/20/13)  exclude from jobbag, see JOB_CreateJobFormsMaterialsRec
			CREATE SET:C116([Job_Forms_Materials:55]; "Matl")  //materials for this job
			CREATE SET:C116([Job_Forms_Machines:43]; "Mach")  //machines for this job
			t98:=String:C10([Job_Forms:42]FormNumber:3)
			t8a:=[Job_Forms:42]CaseFormID:9
			sStr255:=Substring:C12([Job_Forms:42]JobType:33; 2)
			$fShortGrain:=[Job_Forms:42]ShortGrain:48  //determine if this is a short grain run
			$JobCustId:=[Jobs:15]CustID:2  //• 1/10/97 multiple cust/job, store Job's Id for comparision later
			Print form:C5([Jobs:15]; "JBN_Head2")
			$Pixels:=$Pixels+34
			
			//-------------- Board/Paper description --------------
			//t4 - caliper,   t5 - Board type,   t6 - Sheet Size,   t7 - S(tock)-Number
			//t8 - Sheets to press,    t9 - Lin Feet Required,    t10 - Grain direction
			
			If ([Process_Specs:18]ID:1#[Job_Forms:42]ProcessSpec:46)
				QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=[Job_Forms:42]ProcessSpec:46)
			End if 
			USE SET:C118("matl")
			QUERY SELECTION:C341([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Commodity_Key:12="01@"; *)  //get all the board
			QUERY SELECTION:C341([Job_Forms_Materials:55];  | ; [Job_Forms_Materials:55]Commodity_Key:12="20@")
			
			t4:=String:C10([Job_Forms:42]Caliper:49; "0.000#")  //• 6/4/98 cs  use New Jobform caliper instead
			t5:=[Process_Specs:18]Stock:7
			t6:=String:C10([Job_Forms:42]Width:23)+" x "+String:C10([Job_Forms:42]Lenth:24)
			t8:=String:C10([Job_Forms:42]EstGrossSheets:27; "|Int_no_zero")  //Lena wants default to Gross Form Qty
			If ([Job_Forms:42]ColorStdSheets:60#0)  //• mlb - 5/15/02  11:36 add for Color Standard"
				xComment:=String:C10([Job_Forms:42]ColorStdSheets:60; "|Int_no_zero")+" for Color Standards"
			Else 
				xComment:=""  //
			End if 
			$Sheets2Pres:=[Job_Forms:42]EstGrossSheets:27
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
				
				ORDER BY:C49([Job_Forms_Machines:43]; [Job_Forms_Machines:43]Sequence:5; >)
				FIRST RECORD:C50([Job_Forms_Machines:43])
				
				While (Not:C34(End selection:C36([Job_Forms_Machines:43])))
					If (Position:C15([Job_Forms_Machines:43]CostCenterID:4; <>SHEETERS)>0)
						//If ([Machine_Job]CostCenterID="426") | ([Machine_Job]CostCenterID="427") |
						//« ([Machine_Job]CostCenterID="428")
						t8:=String:C10([Job_Forms_Machines:43]Planned_Qty:10; "|Int_no_zero")
						$Sheets2Pres:=[Job_Forms_Machines:43]Planned_Qty:10
					End if 
					NEXT RECORD:C51([Job_Forms_Machines:43])
				End while 
				
			Else 
				
				ARRAY TEXT:C222($_CostCenterID; 0)
				ARRAY REAL:C219($_Planned_Qty; 0)
				ARRAY INTEGER:C220($_Sequence; 0)
				
				SELECTION TO ARRAY:C260([Job_Forms_Machines:43]CostCenterID:4; $_CostCenterID; [Job_Forms_Machines:43]Planned_Qty:10; $_Planned_Qty; [Job_Forms_Machines:43]Sequence:5; $_Sequence)
				
				SORT ARRAY:C229($_Sequence; $_CostCenterID; $_Planned_Qty; >)
				
				For ($Iter; 1; Size of array:C274($_Sequence); 1)
					If (Position:C15($_CostCenterID{$Iter}; <>SHEETERS)>0)
						t8:=String:C10($_Planned_Qty{$Iter}; "|Int_no_zero")
						$Sheets2Pres:=$_Planned_Qty{$Iter}
					End if 
				End for 
				
			End if   // END 4D Professional Services : January 2019 First record
			// 4D Professional Services : after Order by , query or any query type you don't need First record  
			
			If ([Job_Forms:42]ColorStdSheets:60#0)
				t8:=String:C10($Sheets2Pres+[Job_Forms:42]ColorStdSheets:60; "|Int_no_zero")
			End if 
			
			If (Records in selection:C76([Job_Forms_Materials:55])>0)
				If (Length:C16([Job_Forms_Materials:55]Raw_Matl_Code:7)>0)
					t7:=[Job_Forms_Materials:55]Raw_Matl_Code:7
					$certified:=RM_isCertified_FSC_orSFI("RawMaterial"; t7)
					If (Length:C16($certified)>0)
						t7:=t7+" "+$certified
					End if 
					
				Else 
					t7:="Board not specified"
				End if 
				
			Else 
				t7:="Board not budgeted"
			End if 
			$PrevPlanQty:=$Sheets2Pres  //set sheets for testing whether to print subform info
			
			If (Position:C15("LF"; [Job_Forms_Materials:55]UOM:5)#0)
				t9:=String:C10([Job_Forms_Materials:55]Planned_Qty:6; "|Int_no_zero")
			Else 
				Case of   //this insures that there is NO problem with data entry order (length v width)
					: ([Job_Forms:42]Width:23=[Job_Forms:42]Lenth:24)  //if these are the same size pick one
						$Size:=[Job_Forms:42]Width:23
					: ($fShortGrain)  //if this is SHORT grain, use the SMALLEST entered measurement
						$Size:=(Num:C11([Job_Forms:42]Width:23<[Job_Forms:42]Lenth:24)*[Job_Forms:42]Width:23)+(Num:C11([Job_Forms:42]Lenth:24<[Job_Forms:42]Width:23)*[Job_Forms:42]Lenth:24)
					Else   //if this is NORMAL grain, use the LARGEST entered measurement
						$Size:=(Num:C11([Job_Forms:42]Width:23>[Job_Forms:42]Lenth:24)*[Job_Forms:42]Width:23)+(Num:C11([Job_Forms:42]Lenth:24>[Job_Forms:42]Width:23)*[Job_Forms:42]Lenth:24)
				End case 
				t9:=String:C10((($Size/12)*[Job_Forms:42]EstGrossSheets:27); "|Int_no_zero")
			End if 
			t10:=("Short Grain"*Num:C11($fShortGrain))+("Normal Grain"*Num:C11(Not:C34($fShortGrain)))
			Print form:C5([Jobs:15]; "JBN_BoardDesc")
			$Pixels:=$Pixels+32
			USE SET:C118("Matl")
			QUERY SELECTION:C341([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Commodity_Key:12#"01@"; *)  //lena wants to ignore the following Commodities
			QUERY SELECTION:C341([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Commodity_Key:12#"04@"; *)  //in the details under each machine
			//QUERY SELECTION([Material_Job]; & ;[Material_Job]Commodity_Key#"06@";*)  `so this will remove them from concideration
			QUERY SELECTION:C341([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Commodity_Key:12#"07@")
			CREATE SET:C116([Job_Forms_Materials:55]; "Matl")
			
			//----------------------- OPERATIONAL SEQUENCES -----------
			Print form:C5([Jobs:15]; "JBN_Head4")  //this header needs to show [caseform]formnumber
			$Pixels:=$Pixels+20
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
				
				ORDER BY:C49([Job_Forms_Machines:43]; [Job_Forms_Machines:43]Sequence:5; >)
				FIRST RECORD:C50([Job_Forms_Machines:43])
				
				
			Else 
				
				ORDER BY:C49([Job_Forms_Machines:43]; [Job_Forms_Machines:43]Sequence:5; >)
				
				
			End if   // END 4D Professional Services : January 2019 First record
			// 4D Professional Services : after Order by , query or any query type you don't need First record  
			CREATE EMPTY SET:C140([Job_Forms_Materials:55]; "Printed")
			READ ONLY:C145([To_Do_Tasks:100])
			
			For ($j; 1; Records in selection:C76([Job_Forms_Machines:43]))
				If ($Pixels+15>$MaxPixels)  //if there is not enough room start new page
					$Pixels:=JBN_PrintHeader("M")
				End if 
				
				$Seq:=[Job_Forms_Machines:43]Sequence:5
				$jobSeq:=[Job_Forms_Machines:43]JobSequence:8
				QUERY:C277([To_Do_Tasks:100]; [To_Do_Tasks:100]Jobform:1=$jobSeq)
				If (Records in selection:C76([To_Do_Tasks:100])>0)
					If ([To_Do_Tasks:100]Done:4)
						xText:="√ "+[To_Do_Tasks:100]DoneBy:7+" "+String:C10([To_Do_Tasks:100]DateDone:6; System date short:K1:1)
					Else 
						xText:="TO DO"
					End if 
				Else 
					xText:="__/__/__"
				End if 
				
				
				//used to locate correct materials
				t10:=String:C10($Seq; "000")
				//xText:=""  `fBarCodeSym (39;t10)
				
				If (Position:C15([Job_Forms_Machines:43]CostCenterID:4; <>EMBOSSERS)>0)
					$cc:="4"+Substring:C12([Job_Forms_Machines:43]CostCenterID:4; 2)  //read only but wtf
				Else 
					$cc:=[Job_Forms_Machines:43]CostCenterID:4
				End if 
				
				$Ff:=(Num:C11([Job_Forms_Machines:43]FormChangeHere:38)*"ƒ")
				t11:=$cc+" "+$Ff  //+$Dot
				
				Case of 
					: ((Position:C15($cc; <>EMBOSSERS)>0) | (Position:C15($cc; <>STAMPERS)>0))
						t12:=CostCtr_Description_Tweak(->[Job_Forms_Machines:43]CostCenterID:4)
						
						
						//If ((Position([Job_Forms_Machines]CostCenterID;<>EMBOSSERS)>0) | (Position([Job_Forms_Machines]CostCenterID;<>STAMPERS)>0))
						//$desc:=""
						//If ([Job_Forms_Machines]Flex_field1>0)
						//$desc:=$desc+String([Job_Forms_Machines]Flex_field1)+" EMBOSS UNITS "
						//End if 
						//If ([Job_Forms_Machines]Flex_field2>0)
						//$desc:=$desc+String([Job_Forms_Machines]Flex_field2)+" FLAT UNITS "
						//End if 
						//If ([Job_Forms_Machines]Flex_field3>0)
						//$desc:=$desc+String([Job_Forms_Machines]Flex_field3)+" COMBO UNITS "
						//End if 
						//t12:="Bobst Stamping & Embossing:  "+$desc
						
					: (Position:C15($cc; <>PRESSES)>0)
						QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=$cc)
						t12:=[Cost_Centers:27]Description:3
						If ([Job_Forms_Machines:43]Flex_field6:34)  // Modified by: Mel Bohince (7/18/16) backside flag
							t12:="BACKSIDE "+t12
						End if 
						
					Else 
						QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=$cc)
						t12:=[Cost_Centers:27]Description:3
				End case 
				
				
				t12a:=String:C10([Job_Forms_Machines:43]Planned_Qty:10; "###,###,##0")
				t12b:=String:C10([Job_Forms_Machines:43]Planned_Waste:11; "###,##0")
				
				If ($j#1)  //lena wants a light line between sequences, do not do for first one 
					Print form:C5([Jobs:15]; "JBN_SepLine")
					$Pixels:=$Pixels+3
				End if 
				Print form:C5([Jobs:15]; "JBN_Detail4")  //print machine (cost center) detail
				$Pixels:=$Pixels+12
				
				If ($Seq#0)
					USE SET:C118("Matl")
					QUERY SELECTION:C341([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Sequence:3=$Seq)
					
					If (Records in selection:C76([Job_Forms_Materials:55])>0)
						$Pixels:=JBPrintMatl($Pixels; $MaxPixels)
					End if 
				End if 
				
				If (JB_CCEatsSheets($cc; $PrevPlanQty)) & (Size of array:C274(aRatio)>1)
					$Pixels:=JBNCCSubformSum($Pixels; $MaxPixels; [Job_Forms_Machines:43]Planned_Qty:10)  //• 2/2/98 cs added area to print sheet breakup by subform
				End if 
				$PrevPlanQty:=[Job_Forms_Machines:43]Planned_Qty:10
				NEXT RECORD:C51([Job_Forms_Machines:43])
			End for   //printing machines
			DIFFERENCE:C122("Matl"; "Printed"; "Printed")
			USE SET:C118("Printed")
			
			If (Records in selection:C76([Job_Forms_Materials:55])>0)  //print those materials which DO NOT have a coresponding seq
				$Pixels:=JBPrintMatl($Pixels; $MaxPixels)
			End if 
		End if   //page 1
		
		If (cb1=1)  //page 2
			$Pixels:=JBN_PrintHeader("P")  //New Page
			
			//----------------------- SET UP JOB ITEMS -----------
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
				
				ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]SubFormNumber:32; >; [Job_Forms_Items:44]ItemNumber:7; >)  //added sort by jobform upr 1416
				FIRST RECORD:C50([Job_Forms_Items:44])
				
				
			Else 
				
				ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]SubFormNumber:32; >; [Job_Forms_Items:44]ItemNumber:7; >)  //added sort by jobform upr 1416
				
				
			End if   // END 4D Professional Services : January 2019 First record
			// 4D Professional Services : after Order by , query or any query type you don't need First record  
			t21:=""  //•1/10/97 clear before loop
			
			For ($j; 1; Records in selection:C76([Job_Forms_Items:44]))  //print Job Form Items
				If ($Pixels+16>$MaxPixels)
					$Pixels:=JBN_PrintHeader("P")
				End if 
				qryFinishedGood([Job_Forms_Items:44]CustId:15; [Job_Forms_Items:44]ProductCode:3)  //•1/10/97 -cs- replaced above search
				t10:=String:C10([Job_Forms_Items:44]ItemNumber:7; "00")
				xText:=fBarCodeSym(39; [Finished_Goods:26]PlateID:21)
				t10a:=[Finished_Goods:26]OriginalOrRepeat:71
				If (FG_LaunchItem("is"; [Job_Forms_Items:44]ProductCode:3))
					t10a:="L"
				End if 
				
				If ([Job_Forms_Items:44]SubFormNumber:32#0)
					t10b:=String:C10([Job_Forms_Items:44]SubFormNumber:32)
				Else 
					t10b:=""
				End if 
				t11:=[Job_Forms_Items:44]ProductCode:3
				//• mlb - 9/26/01  10:04
				t11a:=[Job_Forms_Items:44]ControlNumber:26  //[JobMakesItem]ControlNumber  `fBarCodeSym (39;t11)
				If ([Finished_Goods:26]ControlNumber:61#[Job_Forms_Items:44]ControlNumber:26)
					BEEP:C151
					ALERT:C41("F/G Control No is different than jobit's Control No.")
				End if 
				READ ONLY:C145([Finished_Goods_Specifications:98])
				QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ControlNumber:2=[Job_Forms_Items:44]ControlNumber:26)
				If (Records in selection:C76([Finished_Goods_Specifications:98])>0)
					$prepspec_notes:=[Finished_Goods_Specifications:98]CommentsFromImaging:20+[Finished_Goods_Specifications:98]CommentsFromQA:53
					$prepspec_notes:=Replace string:C233($prepspec_notes; " "; "")
					If (Length:C16($prepspec_notes)>0)
						t11a:=t11a+"*"
					End if 
				End if 
				t4:=String:C10([Job_Forms_Items:44]NumberUp:8)  //# up for this carton    
				t12:=[Finished_Goods:26]CartonDesc:3
				t15:=[Job_Forms_Items:44]OutlineNumber:43+"-"+Substring:C12([Finished_Goods:26]GlueDirection:104; 1; 3)  //[Finished_Goods]OutLine_Num
				If ([Finished_Goods:26]OutLine_Num:4#[Job_Forms_Items:44]OutlineNumber:43)
					BEEP:C151
					ALERT:C41("F/G Outline is different than jobit's Outline")
				End if 
				t16:=String:C10(PK_getCaseCount([Finished_Goods:26]OutLine_Num:4); "##,##0")
				//t16:=String([Finished_Goods]PackingQty;"##,##0")  `• 9/17/97 cs add case pack to job bag
				t17:=String:C10([Job_Forms_Items:44]Qty_Want:24; "###,###,##0")
				t18:=String:C10([Job_Forms_Items:44]Qty_Yield:9; "###,###,##0")
				xTitle:=[Finished_Goods:26]DieSize:68
				
				If ([Finished_Goods:26]Preflight:66)
					tText1:=[Finished_Goods:26]PreflightBy:67
					If (Length:C16(tText1)=0)
						tText1:="X"
					End if 
				Else 
					tText1:=""
				End if 
				
				tText2:=[Finished_Goods:26]PrepressMedia:65
				//• 1/20/98 cs changed from est gross to press qty - Lena
				//$ShtCnt:=(([JobMakesItem]Qty_Yield/[JobMakesItem]NumberUp)/
				//«[JobForm]EstNetSheets)*[Machine_Job]Planned_Qty  `Sheet Cnt/ Subform
				$ShtCnt:=(([Job_Forms_Items:44]Qty_Yield:9/[Job_Forms_Items:44]NumberUp:8)/[Job_Forms:42]EstNetSheets:28)*$Sheets2Pres  //Sheet Cnt/ Subform
				t19:=String:C10(Round:C94($ShtCnt; 0); "###,###,##0")
				
				//•1/9/97 print customer id on jobs where there are 2 or more customers          
				If ($JobCustID=<>sCombindID)  //•1/13/97 - cs - changed test from below (no data on report,  job record lost??
					If ([Customers:16]ID:1#[Job_Forms_Items:44]CustId:15) | (t21="")  //get current customer if needed
						qryCustomer(->[Customers:16]ID:1; ""; ->[Job_Forms_Items:44]CustId:15)
						t21:=t21+[Customers:16]ID:1+" = "+[Customers:16]Name:2+";"
					End if 
					t20:=[Job_Forms_Items:44]CustId:15
				Else 
					t20:=""
				End if 
				$SubForm:=[Job_Forms_Items:44]SubFormNumber:32
				NEXT RECORD:C51([Job_Forms_Items:44])
				Print form:C5([Jobs:15]; "JBN_ProdDetail")
				$Pixels:=$Pixels+14
				
				If ($j#Records in selection:C76([Job_Forms_Items:44]))  //place a light line between items, do not do for last one
					If ($SubForm=[Job_Forms_Items:44]SubFormNumber:32)  //seperator line for items
						Print form:C5([Jobs:15]; "JBN_SepLine")
					Else   //seperator line for Forms
						Print form:C5([Jobs:15]; "JBN_SepLine2")  //• 2/2/98 cs added heavier line to seperate subforms
					End if 
					$Pixels:=$Pixels+3
				End if 
			End for 
		End if   //true
		
		PAGE BREAK:C6  //force entire documant to print
	End if   //cb1=1
	
	If (cb4=1)
		rRptJobMad("*"; [Job_Forms:42]JobFormID:5)
	End if 
	If (cb3=1)
		JOB_QuantityControlSheet([Job_Forms:42]JobFormID:5)
	End if 
	PDF_setUp
Else 
	//If ([JobForm]NeedDate=!00/00/00!) & (Records in selection([JobForm])>0)
	//ALERT("Job form need date has not been determined.")
	//Else 
	ALERT:C41("No Job Form found.")
	//End if 
End if 

uWinListCleanup