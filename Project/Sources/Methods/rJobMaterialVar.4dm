//%attributes = {"publishedWeb":true}
//Procedure: rJobMaterialVar()  111798  mlb
//another Cut of Job Shit

C_LONGINT:C283($i)
C_TEXT:C284($t; $cr)
C_TEXT:C284(xTitle; xText)
C_TIME:C306($docRef)

$t:=Char:C90(9)
$cr:=Char:C90(13)

QUERY:C277([Job_Forms:42])
If (OK=1)
	$docRef:=Create document:C266("")
	If (OK=1)
		TRACE:C157
		xTitle:="Jobforms Material Variances - "+fYYMMDD(4D_Current_date)+$cr
		SEND PACKET:C103($docRef; xTitle)
		xText:="JobFormID"+$t+"[JOB]CustomerName"+$t+"[JOB]Line"+$t+"Status"+$t+"ClosedDate"+$t
		
		For ($j; 1; 9)
			xText:=xText+"COMM_"+String:C10($j; "00")+"_Bud"+$t+"COMM_"+String:C10($j; "00")+"_Act"+$t
		End for 
		xText:=xText+"COMM_13Laser_Bud"+$t+"COMM_13Laser_Act"+$t
		xText:=xText+"COMM_13Freight_Bud"+$t+"COMM_13Freight_Act"+$t
		xText:=xText+"COMM_13other_Bud"+$t+"COMM_13other_Act"+$t
		xText:=xText+$cr
		
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
			For ($i; 1; Records in selection:C76([Job_Forms:42]))
				RELATE ONE:C42([Job_Forms:42]JobNo:2)
				
				xText:=xText+[Job_Forms:42]JobFormID:5+$t+[Jobs:15]CustomerName:5+$t+[Jobs:15]Line:3+$t+[Job_Forms:42]Status:6+$t+String:C10([Job_Forms:42]ClosedDate:11; <>MIDDATE)+$t
				
				ARRAY REAL:C219($aBud; 0)
				ARRAY REAL:C219($aBud; 12)
				ARRAY REAL:C219($aAct; 0)
				ARRAY REAL:C219($aAct; 12)
				For ($j; 1; 12)
					$aBud{$j}:=0
					$aAct{$j}:=0
				End for 
				
				QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=[Job_Forms:42]JobFormID:5)
				For ($j; 1; Records in selection:C76([Job_Forms_Materials:55]))
					$com:=Num:C11(Substring:C12([Job_Forms_Materials:55]Commodity_Key:12; 1; 2))
					If ($com>9)
						Case of 
							: ([Job_Forms_Materials:55]Commodity_Key:12="13-Laser@")
								$com:=10
							: ([Job_Forms_Materials:55]Commodity_Key:12="13-Freight@")
								$com:=11
							Else 
								$com:=12
						End case 
					End if 
					
					$aBud{$com}:=$aBud{$com}+[Job_Forms_Materials:55]Planned_Cost:8
					
					NEXT RECORD:C51([Job_Forms_Materials:55])
				End for 
				
				QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=[Job_Forms:42]JobFormID:5; *)
				QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue")
				
				For ($j; 1; Records in selection:C76([Raw_Materials_Transactions:23]))
					$com:=Num:C11(Substring:C12([Raw_Materials_Transactions:23]Commodity_Key:22; 1; 2))
					If ($com>9)
						Case of 
							: ([Raw_Materials_Transactions:23]Commodity_Key:22="13-Laser@")
								$com:=10
							: ([Raw_Materials_Transactions:23]Commodity_Key:22="13-Freight@")
								$com:=11
							Else 
								$com:=12
						End case 
					End if 
					
					$aAct{$com}:=$aAct{$com}+(-1*[Raw_Materials_Transactions:23]ActExtCost:10)
					
					NEXT RECORD:C51([Raw_Materials_Transactions:23])
				End for 
				
				For ($j; 1; 12)
					xText:=xText+String:C10($aBud{$j})+$t+String:C10($aAct{$j})+$t
				End for 
				xText:=xText+$cr
				
				If (Length:C16(xText)>20000)
					SEND PACKET:C103($docRef; xText)
					xText:=""
				End if 
				
				NEXT RECORD:C51([Job_Forms:42])
			End for 
			
		Else 
			
			// laghzaoui replace tree next and relate one 
			ARRAY TEXT:C222($_JobFormID; 0)
			ARRAY TEXT:C222($_Status; 0)
			ARRAY DATE:C224($_ClosedDate; 0)
			ARRAY LONGINT:C221($_JobNo; 0)
			ARRAY TEXT:C222($_CustomerName; 0)
			ARRAY TEXT:C222($_Line; 0)
			
			GET FIELD RELATION:C920([Job_Forms:42]JobNo:2; $lienAller; $lienRetour)
			SET FIELD RELATION:C919([Job_Forms:42]JobNo:2; Automatic:K51:4; Do not modify:K51:1)
			
			SELECTION TO ARRAY:C260([Job_Forms:42]JobFormID:5; $_JobFormID; \
				[Job_Forms:42]Status:6; $_Status; \
				[Job_Forms:42]ClosedDate:11; $_ClosedDate; \
				[Job_Forms:42]JobNo:2; $_JobNo; \
				[Jobs:15]CustomerName:5; $_CustomerName; \
				[Jobs:15]Line:3; $_Line)
			
			SET FIELD RELATION:C919([Job_Forms:42]JobNo:2; $lienAller; $lienRetour)
			
			
			For ($i; 1; Size of array:C274($_Status); 1)
				
				xText:=xText+$_JobFormID{$i}+$t+$_CustomerName{$i}+$t+$_Line{$i}+$t+$_Status{$i}+$t+String:C10($_ClosedDate{$i}; <>MIDDATE)+$t
				
				ARRAY REAL:C219($aBud; 0)
				ARRAY REAL:C219($aBud; 12)
				ARRAY REAL:C219($aAct; 0)
				ARRAY REAL:C219($aAct; 12)
				For ($j; 1; 12)
					$aBud{$j}:=0
					$aAct{$j}:=0
				End for 
				
				QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=$_JobFormID{$i})
				
				ARRAY TEXT:C222($_Commodity_Key; 0)
				ARRAY REAL:C219($_Planned_Cost; 0)
				
				SELECTION TO ARRAY:C260([Job_Forms_Materials:55]Commodity_Key:12; $_Commodity_Key; \
					[Job_Forms_Materials:55]Planned_Cost:8; $_Planned_Cost)
				
				For ($j; 1; Records in selection:C76([Job_Forms_Materials:55]); 1)
					$com:=Num:C11(Substring:C12($_Commodity_Key{$j}; 1; 2))
					If ($com>9)
						Case of 
							: ($_Commodity_Key{$j}="13-Laser@")
								$com:=10
							: ($_Commodity_Key{$j}="13-Freight@")
								$com:=11
							Else 
								$com:=12
						End case 
					End if 
					
					$aBud{$com}:=$aBud{$com}+$_Planned_Cost{$j}
					
				End for 
				
				QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=$_JobFormID{$i}; *)
				QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue")
				
				ARRAY TEXT:C222($_Commodity_Key; 0)
				ARRAY REAL:C219($_ActExtCost; 0)
				
				SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]Commodity_Key:22; $_Commodity_Key; \
					[Raw_Materials_Transactions:23]ActExtCost:10; $_ActExtCost)
				
				For ($j; 1; Records in selection:C76([Raw_Materials_Transactions:23]); 1)
					$com:=Num:C11(Substring:C12($_Commodity_Key{$j}; 1; 2))
					If ($com>9)
						Case of 
							: ($_Commodity_Key{$j}="13-Laser@")
								$com:=10
							: ($_Commodity_Key{$j}="13-Freight@")
								$com:=11
							Else 
								$com:=12
						End case 
					End if 
					
					$aAct{$com}:=$aAct{$com}+(-1*$_ActExtCost{$j})
					
				End for 
				
				For ($j; 1; 12)
					xText:=xText+String:C10($aBud{$j})+$t+String:C10($aAct{$j})+$t
				End for 
				xText:=xText+$cr
				
				If (Length:C16(xText)>20000)
					SEND PACKET:C103($docRef; xText)
					xText:=""
				End if 
				
			End for 
			
		End if   // END 4D Professional Services : January 2019 
		
		SEND PACKET:C103($docRef; xText)
		CLOSE DOCUMENT:C267($docRef)
		BEEP:C151
		ALERT:C41("Data stored in file named: "+Document)
		// obsolete call, method deleted 4/28/20 uDocumentSetType 
		$err:=util_Launch_External_App(Document)
	End if 
End if 
