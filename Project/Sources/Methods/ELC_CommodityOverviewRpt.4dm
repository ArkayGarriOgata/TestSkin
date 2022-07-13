//%attributes = {"publishedWeb":true}
//PM: ELC_CommodityOverviewRpt() -> 
//@author mlb - 1/28/02  10:51
//PM: ELC_ExcessInventory() -> 
//@author mlb - 10/4/01  10:30

MESSAGES OFF:C175

zwStatusMsg("Estée Lauder"; "Commodity Overview Report")

C_TIME:C306($docRef)
C_LONGINT:C283($i; $numRels)
C_TEXT:C284($t; $cr)
C_TEXT:C284(xTitle; xText)

$t:=Char:C90(9)
$cr:=Char:C90(13)
xTitle:=""
xText:=""
$ok:=fGetDateRange(->dDateBegin; ->dDateEnd)
If ($ok=1)
	READ ONLY:C145([Customers:16])
	READ ONLY:C145([Customers_ReleaseSchedules:46])
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 ELC_query
		
		$numRels:=ELC_query(->[Customers_ReleaseSchedules:46]CustID:12)
		
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7>=dDateBegin; *)
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7<dDateEnd)
		
		
	Else 
		$criteria:=ELC_getName
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers:16]ParentCorp:19=$criteria; *)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7>=dDateBegin; *)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7<dDateEnd)
		
		
	End if   // END 4D Professional Services : January 2019 ELC_query
	$numRels:=Records in selection:C76([Customers_ReleaseSchedules:46])
	
	//$docRef:=Create document()
	docName:="ELC_CommOverviewData_ship"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
	$docRef:=util_putFileName(->docName)
	If ($docRef#?00:00:00?)
		uThermoInit($numRels; "Estee Lauder Saving Report")
		xTitle:="ELC Commodity Overview Shipping Data for  "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1)
		SEND PACKET:C103($docRef; xTitle+$cr+$cr)
		xText:="PRODUCT"+$t+"LINE"+$t+"QTY_ACT"+$t+"DATE_ACT"+$t+"MONTH"+$t+"SALES_VAL"+$cr
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			FIRST RECORD:C50([Customers_ReleaseSchedules:46])
			
			
		Else 
			
			//see line 34
			
			
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
			
			For ($i; 1; $numRels)
				$numFG:=qryFinishedGood([Customers_ReleaseSchedules:46]CustID:12; [Customers_ReleaseSchedules:46]ProductCode:11)
				xText:=xText+[Customers_ReleaseSchedules:46]ProductCode:11+$t+[Customers_ReleaseSchedules:46]CustomerLine:28+$t+String:C10([Customers_ReleaseSchedules:46]Actual_Qty:8)+$t+String:C10([Customers_ReleaseSchedules:46]Actual_Date:7; System date short:K1:1)+$t+String:C10(Month of:C24([Customers_ReleaseSchedules:46]Actual_Date:7))+$t+String:C10([Customers_ReleaseSchedules:46]Actual_Qty:8/1000*[Finished_Goods:26]RKContractPrice:49)+$cr
				uThermoUpdate($i)
				If (Length:C16(xText)>28000)
					SEND PACKET:C103($docRef; xText)
					xText:=""
				End if 
				NEXT RECORD:C51([Customers_ReleaseSchedules:46])
			End for 
			
		Else 
			
			
			ARRAY TEXT:C222($_CustID; 0)
			ARRAY TEXT:C222($_ProductCode; 0)
			ARRAY TEXT:C222($_CustomerLine; 0)
			ARRAY LONGINT:C221($_Actual_Qty; 0)
			ARRAY DATE:C224($_Actual_Date; 0)
			
			
			SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]CustID:12; $_CustID; \
				[Customers_ReleaseSchedules:46]ProductCode:11; $_ProductCode; \
				[Customers_ReleaseSchedules:46]CustomerLine:28; $_CustomerLine; \
				[Customers_ReleaseSchedules:46]Actual_Qty:8; $_Actual_Qty; \
				[Customers_ReleaseSchedules:46]Actual_Date:7; $_Actual_Date)
			
			
			For ($i; 1; $numRels; 1)
				$numFG:=qryFinishedGood($_CustID{$i}; $_ProductCode{$i})
				xText:=xText+$_ProductCode{$i}+$t+$_CustomerLine{$i}+$t+String:C10($_Actual_Qty{$i})+$t+String:C10($_Actual_Date{$i}; System date short:K1:1)+$t+String:C10(Month of:C24($_Actual_Date{$i}))+$t+String:C10($_Actual_Qty{$i}/1000*[Finished_Goods:26]RKContractPrice:49)+$cr
				uThermoUpdate($i)
				If (Length:C16(xText)>28000)
					SEND PACKET:C103($docRef; xText)
					xText:=""
				End if 
				
			End for 
			
		End if   // END 4D Professional Services : January 2019 
		
		SEND PACKET:C103($docRef; xText)
		uThermoClose
		
		CLOSE DOCUMENT:C267($docRef)
		BEEP:C151
		// obsolete call, method deleted 4/28/20 uDocumentSetType 
		//$err:=util_Launch_External_App (Document)
		$err:=util_Launch_External_App(docName)
	End if 
	xText:=""
	xTitle:=""
	
	READ ONLY:C145([Jobs:15])
	READ ONLY:C145([Job_Forms_Items:44])
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 ELC_query
		
		$numRels:=ELC_query(->[Job_Forms_Items:44]CustId:15)
		
		QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]Glued:33>=dDateBegin; *)
		QUERY SELECTION:C341([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Glued:33<dDateEnd)
		
		
	Else 
		$criteria:=ELC_getName
		QUERY:C277([Job_Forms_Items:44]; [Customers:16]ParentCorp:19=$criteria; *)
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Glued:33>=dDateBegin; *)
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Glued:33<dDateEnd)
		
		
	End if   // END 4D Professional Services : January 2019 ELC_query
	$numRels:=Records in selection:C76([Job_Forms_Items:44])
	
	docName:="ELC_CommOverviewData_mfg"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
	$docRef:=util_putFileName(->docName)
	If ($docRef#?00:00:00?)
		uThermoInit($numRels; "Estee Lauder Saving Report")
		xTitle:="ELC Commodity Overview Production Data for  "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1)
		SEND PACKET:C103($docRef; xTitle+$cr+$cr)
		xText:="LINE"+$t+"QTY_GOOD"+$t+"GLUED"+$t+"MONTH"+$t+"SALES_VAL"+$cr
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			FIRST RECORD:C50([Job_Forms_Items:44])
			
			
		Else 
			
			// see line 97
			
			
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
			
			For ($i; 1; $numRels)
				QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=(Num:C11(Substring:C12([Job_Forms_Items:44]JobForm:1; 1; 5))))
				$numFG:=qryFinishedGood([Jobs:15]CustID:2; [Job_Forms_Items:44]ProductCode:3)
				xText:=xText+[Jobs:15]Line:3+$t+String:C10([Job_Forms_Items:44]Qty_Good:10)+$t+String:C10([Job_Forms_Items:44]Glued:33; System date short:K1:1)+$t+String:C10(Month of:C24([Job_Forms_Items:44]Glued:33))+$t+String:C10([Job_Forms_Items:44]Qty_Good:10/1000*[Finished_Goods:26]RKContractPrice:49)+$cr
				uThermoUpdate($i)
				If (Length:C16(xText)>28000)
					SEND PACKET:C103($docRef; xText)
					xText:=""
				End if 
				NEXT RECORD:C51([Job_Forms_Items:44])
			End for 
			
		Else 
			
			
			SELECTION TO ARRAY:C260([Job_Forms_Items:44]JobForm:1; $_JobForm; \
				[Job_Forms_Items:44]ProductCode:3; $_ProductCode; \
				[Job_Forms_Items:44]Qty_Good:10; $_Qty_Good; \
				[Job_Forms_Items:44]Glued:33; $_Glued)
			
			
			For ($i; 1; $numRels; 1)
				
				QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=(Num:C11(Substring:C12($_JobForm{$i}; 1; 5))))
				$numFG:=qryFinishedGood([Jobs:15]CustID:2; $_ProductCode{$i})
				xText:=xText+[Jobs:15]Line:3+$t+String:C10($_Qty_Good{$i})+$t+String:C10($_Glued{$i}; System date short:K1:1)+$t+String:C10(Month of:C24($_Glued{$i}))+$t+String:C10($_Qty_Good{$i}/1000*[Finished_Goods:26]RKContractPrice:49)+$cr
				uThermoUpdate($i)
				If (Length:C16(xText)>28000)
					SEND PACKET:C103($docRef; xText)
					xText:=""
				End if 
				
			End for 
			
		End if   // END 4D Professional Services : January 2019 
		
		SEND PACKET:C103($docRef; xText)
		uThermoClose
		
		CLOSE DOCUMENT:C267($docRef)
		BEEP:C151
		// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
		$err:=util_Launch_External_App(docName)
	End if 
End if 

xText:=""
xTitle:=""