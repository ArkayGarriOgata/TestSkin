//%attributes = {}
// Method: ELC_WeeksCoveredRpt () -> 
// ----------------------------------------------------
// by: mel: 10/12/04, 09:23:49
// ----------------------------------------------------
// Description:
// calculate how long existing inventory will cover demand
// • mel (4/14/05, 13:41:13) add contract price
// • mel (4/21/05, 09:37:43) add wk group and value for Rug-man

C_TEXT:C284($t; $cr)
C_BOOLEAN:C305($onlyELC)
C_TIME:C306($docRef)

$t:=Char:C90(9)
$cr:=Char:C90(13)

CONFIRM:C162("Only report on Estee Lauder products?"; "EL"; "Search")
If (OK=1)
	$onlyELC:=True:C214
Else 
	$onlyELC:=False:C215
	CONFIRM:C162("Restrict to only F/G's with inventory or releases?"; "Restrict"; "Not restricted")
	If (OK=1)
		$restrict:=True:C214
	Else 
		$restrict:=False:C215
	End if 
End if 

CONFIRM:C162("Update Job, Inventory, and THC info?"; "Update"; "As-is")
If (OK=1)
	//reset [Finished_Goods]FRCST_NumberOfReleases and [Finished_Goods]InventoryNow
	Batch_ForecastAnalysis("UPDATE ALL AND SEND EMAIL TO MEL")
	//update THC
	BatchTHCcalc
End if 
//summarize open production
BatchJobcalc
//summarize inventory
BatchFGinventor

docName:="WeeksCovered"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
$docRef:=util_putFileName(->docName)
If ($docRef#?00:00:00?)
	C_TEXT:C284(xTitle; xText)
	xTitle:="Weeks Covered By Inventory and Production"
	xText:="ProductCode"+$t+"OpenDemand"+$t+"SupplyQuantity"+$t+"SupplyCoverage(weeks)"+$t+"FinishedGoods"+$t+"FG_Coverage(weeks)"+$t+"ContractPrice"+$t+"Group"+$t+"Value"+$cr  //"Shipped"+$t+"TransLead"+$t+"itemHRD"+$t+"jobHRD"+$cr
	SEND PACKET:C103($docRef; xTitle+$cr+$cr)
	
	READ ONLY:C145([Customers:16])
	READ ONLY:C145([Finished_Goods:26])
	READ ONLY:C145([Finished_Goods_Locations:35])
	READ ONLY:C145([Customers_ReleaseSchedules:46])
	READ ONLY:C145([Job_Forms_Items:44])
	
	If ($onlyELC)
		
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 ELC_query
			
			$numRecs:=ELC_query(->[Finished_Goods:26]CustID:2)  //get elc's inventory
			QUERY SELECTION:C341([Finished_Goods:26]; [Finished_Goods:26]InventoryNow:73>0; *)
			QUERY SELECTION:C341([Finished_Goods:26];  | ; [Finished_Goods:26]FRCST_NumberOfReleases:69>0)
			
		Else 
			
			$Critiria:=ELC_getName
			QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]InventoryNow:73>0; *)
			QUERY:C277([Finished_Goods:26];  | ; [Finished_Goods:26]FRCST_NumberOfReleases:69>0; *)
			QUERY:C277([Finished_Goods:26]; [Customers:16]ParentCorp:19=$Critiria)
			
			
			$numRecs:=Records in selection:C76([Finished_Goods:26])
			
		End if   // END 4D Professional Services : January 2019 ELC_query
		
	Else 
		QUERY:C277([Finished_Goods:26])
		If ($restrict)
			QUERY SELECTION:C341([Finished_Goods:26]; [Finished_Goods:26]InventoryNow:73>0; *)
			QUERY SELECTION:C341([Finished_Goods:26];  | ; [Finished_Goods:26]FRCST_NumberOfReleases:69>0)
		End if 
	End if 
	
	$numRecs:=Records in selection:C76([Finished_Goods:26])
	C_LONGINT:C283($i; $numRecs)
	C_BOOLEAN:C305($break)
	$break:=False:C215
	ORDER BY:C49([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1; >)
	
	uThermoInit($numRecs; "Reporting Weeks Covered")
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
		
		For ($i; 1; $numRecs)
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
			Case of 
				: ($wksCvr<=2)
					$gp:="` wks ≤ 2"
				: ($wksCvr<=6)
					$gp:="`2 < wks ≤ 6"
				: ($wksCvr<=12)
					$gp:="`6 < wks ≤ 12"
				Else 
					$gp:="`wks > 12"
			End case 
			$value:=Round:C94((($mfg+$oh)*[Finished_Goods:26]RKContractPrice:49)/1000; 0)
			xText:=xText+[Finished_Goods:26]ProductCode:1+$t+String:C10($rels)+$t+String:C10(($mfg+$oh))+$t+String:C10($wksCvr)+$t+String:C10($fg)+$t+String:C10($wksInv)+$t+String:C10([Finished_Goods:26]RKContractPrice:49)+$t+$gp+$t+String:C10($value)+$cr
			
			NEXT RECORD:C51([Finished_Goods:26])
			uThermoUpdate($i)
		End for 
		
		
	Else 
		
		ARRAY TEXT:C222($_FG_KEY; 0)
		ARRAY REAL:C219($_RKContractPrice; 0)
		ARRAY TEXT:C222($_ProductCode; 0)
		
		SELECTION TO ARRAY:C260([Finished_Goods:26]FG_KEY:47; $_FG_KEY; \
			[Finished_Goods:26]RKContractPrice:49; $_RKContractPrice; \
			[Finished_Goods:26]ProductCode:1; $_ProductCode)
		
		
		For ($i; 1; $numRecs; 1)
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
			Case of 
				: ($wksCvr<=2)
					$gp:="` wks ≤ 2"
				: ($wksCvr<=6)
					$gp:="`2 < wks ≤ 6"
				: ($wksCvr<=12)
					$gp:="`6 < wks ≤ 12"
				Else 
					$gp:="`wks > 12"
			End case 
			$value:=Round:C94((($mfg+$oh)*$_RKContractPrice{$i})/1000; 0)
			xText:=xText+$_ProductCode{$i}+$t+String:C10($rels)+$t+String:C10(($mfg+$oh))+$t+String:C10($wksCvr)+$t+String:C10($fg)+$t+String:C10($wksInv)+$t+String:C10($_RKContractPrice{$i})+$t+$gp+$t+String:C10($value)+$cr
			
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