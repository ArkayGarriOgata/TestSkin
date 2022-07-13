//%attributes = {}
// Method: MartyLastRun () -> 
// ----------------------------------------------------
// by: mel: 02/22/05, 10:24:42
// ----------------------------------------------------
// Description:
// based on:
// Method: ELC_WeeksCoveredRpt () -> 
// ----------------------------------------------------
// by: mel: 10/12/04, 09:23:49
// ----------------------------------------------------
// Description:
// calculate how long existing inventory will cover demand
//add the last run date

C_TEXT:C284($dateLastRun)  //add the last run date
C_TEXT:C284($t; $cr)
C_BOOLEAN:C305($onlyELC; $restrict)  //nolonger offer as options
C_LONGINT:C283($i; $numRecs)
C_BOOLEAN:C305($break)

$t:=Char:C90(9)
$cr:=Char:C90(13)
$onlyELC:=False:C215
$restrict:=True:C214

READ ONLY:C145([Customers:16])
READ ONLY:C145([Finished_Goods:26])
READ ONLY:C145([Finished_Goods_Locations:35])
READ ONLY:C145([Customers_ReleaseSchedules:46])
READ ONLY:C145([Job_Forms_Items:44])
READ ONLY:C145([Finished_Goods_Transactions:33])

QUERY:C277([Finished_Goods:26])
QUERY SELECTION:C341([Finished_Goods:26]; [Finished_Goods:26]InventoryNow:73>0; *)
QUERY SELECTION:C341([Finished_Goods:26];  | ; [Finished_Goods:26]FRCST_NumberOfReleases:69>0)

$numRecs:=Records in selection:C76([Finished_Goods:26])
If ($numRecs>0)
	//summarize open production
	BatchJobcalc
	//summarize inventory
	BatchFGinventor
	
	C_TIME:C306($docRef)
	docName:="HoopsWeeksCovered"+fYYMMDD(4D_Current_date)
	$docRef:=util_putFileName(->docName)
	If ($docRef#?00:00:00?)
		C_TEXT:C284(xTitle; xText)
		xTitle:="Hoops Weeks Covered By Inventory and Production"
		xText:="ProductCode"+$t+"OpenDemand"+$t+"SupplyQuantity"+$t+"SupplyCoverage(weeks)"+$t+"FinishedGoods"+$t+"FG_Coverage(weeks)"+$t+"LastRunDate"+$cr  //"Shipped"+$t+"TransLead"+$t+"itemHRD"+$t+"jobHRD"+$cr
		SEND PACKET:C103($docRef; xTitle+$cr+$cr)
		
		$break:=False:C215
		ORDER BY:C49([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1; >)
		
		uThermoInit($numRecs; "Reporting Weeks Covered")
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
			
			For ($i; 1; $numRecs)
				$dateLastRun:=""  //marty needs to know last run date
				ARRAY DATE:C224($aXdate; 0)
				If ($break)
					$i:=$i+$numRecs
				End if 
				If (Length:C16(xText)>28000)
					SEND PACKET:C103($docRef; xText)
					xText:=""
				End if 
				
				$jobCursor:=Find in array:C230(<>aJMIKey; [Finished_Goods:26]FG_KEY:47)
				If ($jobCursor>-1)
					$mfg:=<>aQty_JMI{$jobCursor}
				Else 
					$mfg:=0
				End if 
				
				$binCursor:=Find in array:C230(<>aFGKey; [Finished_Goods:26]FG_KEY:47)
				If ($binCursor>-1)
					$fg:=<>aQty_FG{$binCursor}
					$oh:=<>aQty_OH{$binCursor}
					QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ProductCode:1=[Finished_Goods:26]ProductCode:1; *)
					QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Receipt")
					If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
						SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]XactionDate:3; $aXdate)
						SORT ARRAY:C229($aXdate; <)
						$dateLastRun:=String:C10($aXdate{1}; Internal date short:K1:7)
					End if 
					
				Else 
					$fg:=0
					$oh:=0
				End if 
				
				$wksInv:=0
				$wksCvr:=0
				$rels:=0
				
				QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
				QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]ProductCode:11=[Finished_Goods:26]ProductCode:1)
				
				If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
					$rels:=Sum:C1([Customers_ReleaseSchedules:46]OpenQty:16)
					If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
						
						CREATE SET:C116([Customers_ReleaseSchedules:46]; "thisFG")
						
						
					Else 
						
					End if   // END 4D Professional Services : January 2019 query selection
					
					QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]THC_State:39=0)
					If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
						ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; <)
						$wksInv:=Round:C94(([Customers_ReleaseSchedules:46]Sched_Date:5-4D_Current_date)/7; 1)
						If ($wksInv<0)
							$wksInv:=0
						End if 
						
					End if 
					If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
						
						USE SET:C118("thisFG")
						CLEAR SET:C117("thisFG")
						QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]THC_State:39<4)
						
						
					Else 
						
						QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
						QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=[Finished_Goods:26]ProductCode:1; *)
						QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]THC_State:39<4)
						
						
					End if   // END 4D Professional Services : January 2019 query selection
					If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
						ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; <)
						$wksCvr:=Round:C94(([Customers_ReleaseSchedules:46]Sched_Date:5-4D_Current_date)/7; 1)
						If ($wksCvr<0)
							$wksCvr:=0
						End if 
					End if 
				End if 
				
				xText:=xText+[Finished_Goods:26]ProductCode:1+$t+String:C10($rels)+$t+String:C10(($mfg+$oh))+$t+String:C10($wksCvr)+$t+String:C10($fg)+$t+String:C10($wksInv)+$t+$dateLastRun+$cr
				
				NEXT RECORD:C51([Finished_Goods:26])
				uThermoUpdate($i)
			End for 
			
			
		Else 
			
			ARRAY TEXT:C222($_FG_KEY; 0)
			ARRAY TEXT:C222($_ProductCode; 0)
			
			SELECTION TO ARRAY:C260([Finished_Goods:26]FG_KEY:47; $_FG_KEY; \
				[Finished_Goods:26]ProductCode:1; $_ProductCode)
			
			
			For ($i; 1; $numRecs)
				$dateLastRun:=""  //marty needs to know last run date
				ARRAY DATE:C224($aXdate; 0)
				If ($break)
					$i:=$i+$numRecs
				End if 
				If (Length:C16(xText)>28000)
					SEND PACKET:C103($docRef; xText)
					xText:=""
				End if 
				
				$jobCursor:=Find in array:C230(<>aJMIKey; $_FG_KEY{$i})
				If ($jobCursor>-1)
					$mfg:=<>aQty_JMI{$jobCursor}
				Else 
					$mfg:=0
				End if 
				
				$binCursor:=Find in array:C230(<>aFGKey; $_FG_KEY{$i})
				If ($binCursor>-1)
					$fg:=<>aQty_FG{$binCursor}
					$oh:=<>aQty_OH{$binCursor}
					QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ProductCode:1=$_ProductCode{$i}; *)
					QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Receipt")
					If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
						SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]XactionDate:3; $aXdate)
						SORT ARRAY:C229($aXdate; <)
						$dateLastRun:=String:C10($aXdate{1}; Internal date short:K1:7)
					End if 
					
				Else 
					$fg:=0
					$oh:=0
				End if 
				
				$wksInv:=0
				$wksCvr:=0
				$rels:=0
				
				QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
				QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]ProductCode:11=$_ProductCode{$i})
				
				If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
					$rels:=Sum:C1([Customers_ReleaseSchedules:46]OpenQty:16)
					QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]THC_State:39=0)
					If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
						ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; <)
						$wksInv:=Round:C94(([Customers_ReleaseSchedules:46]Sched_Date:5-4D_Current_date)/7; 1)
						If ($wksInv<0)
							$wksInv:=0
						End if 
						
					End if 
					QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
					QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$_ProductCode{$i}; *)
					QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]THC_State:39<4)
					If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
						ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; <)
						$wksCvr:=Round:C94(([Customers_ReleaseSchedules:46]Sched_Date:5-4D_Current_date)/7; 1)
						If ($wksCvr<0)
							$wksCvr:=0
						End if 
					End if 
				End if 
				
				xText:=xText+$_ProductCode{$i}+$t+String:C10($rels)+$t+String:C10(($mfg+$oh))+$t+String:C10($wksCvr)+$t+String:C10($fg)+$t+String:C10($wksInv)+$t+$dateLastRun+$cr
				
				uThermoUpdate($i)
			End for 
			
			
		End if   // END 4D Professional Services : January 2019 
		SEND PACKET:C103($docRef; xText)
		uThermoClose
		
		CLOSE DOCUMENT:C267($docRef)
		BEEP:C151
		// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
		$err:=util_Launch_External_App(docName)
		
	Else 
		BEEP:C151
		ALERT:C41("Couldn't create a document.")
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("No F/G records in your query had inventory or releases.")
End if 