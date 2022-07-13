//%attributes = {}
// Method: Ink_analysis
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 08/16/13, 13:41:06
// ----------------------------------------------------

READ ONLY:C145([Job_Forms:42])

QUERY:C277([Job_Forms:42])

If (Records in selection:C76([Job_Forms:42])>0)
	C_TEXT:C284($t; $r)
	C_TEXT:C284(xTitle; xText; docName)
	C_TIME:C306($docRef)
	
	$t:=Char:C90(9)
	$r:=Char:C90(13)
	xTitle:=""
	xText:=""
	docName:="Ink_Report"+String:C10(TSTimeStamp)+".xls"
	$docRef:=util_putFileName(->docName)
	
	If ($docRef#?00:00:00?)
		SEND PACKET:C103($docRef; xTitle+$r+$r)
		
		C_LONGINT:C283($i; $numRecs)
		C_BOOLEAN:C305($break)
		$break:=False:C215
		$numRecs:=Records in selection:C76([Job_Forms:42])
		xText:="Jobform"+$t+"Customer"+$t+"Line"+$t+"AVG_P"+$t+"HPV"+$t+"NETSHEETS"+$t+"Two.Nine"+$t+"Ink_Bud"+$t+"Ink_Act"+$t+"2_9/act"+$t+"bud/act"+$r
		uThermoInit($numRecs; "Updating Records")
		For ($i; 1; $numRecs)
			If ($break)
				$i:=$i+$numRecs
			End if 
			
			If (Length:C16(xText)>25000)
				SEND PACKET:C103($docRef; xText)
				xText:=""
			End if 
			$avg_selling_price:=Round:C94(JOB_SellingPrice([Job_Forms:42]JobFormID:5); 2)
			$highest_posible_rev:=Round:C94(JOB_SellingPriceTotal([Job_Forms:42]JobFormID:5); 2)
			$two_point_nine:=Round:C94(($highest_posible_rev*0.029); 2)
			$bud_cost:=Job_getInkCost("bud"; [Job_Forms:42]JobFormID:5)
			$act_cost:=Job_getInkCost("act"; [Job_Forms:42]JobFormID:5)
			xText:=xText+[Job_Forms:42]JobFormID:5+$t+CUST_getName([Job_Forms:42]cust_id:82)+$t+[Job_Forms:42]CustomerLine:62+$t
			xText:=xText+String:C10($avg_selling_price)+$t
			xText:=xText+String:C10($highest_posible_rev)+$t
			xText:=xText+String:C10([Job_Forms:42]EstNetSheets:28)+$t
			xText:=xText+String:C10($two_point_nine)+$t
			xText:=xText+String:C10($bud_cost)+$t
			xText:=xText+String:C10($act_cost)+$t
			xText:=xText+String:C10(Round:C94($two_point_nine/$act_cost*100; 0))+$t
			xText:=xText+String:C10(Round:C94($bud_cost/$act_cost*100; 0))+$t
			xText:=xText+$r
			NEXT RECORD:C51([Job_Forms:42])
			uThermoUpdate($i)
		End for 
		uThermoClose
		
		SEND PACKET:C103($docRef; xText)
		SEND PACKET:C103($docRef; $r+$r+"------ END OF FILE ------")
		CLOSE DOCUMENT:C267($docRef)
		
		// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)  //
		$err:=util_Launch_External_App(docName)
	End if 
	
Else 
	BEEP:C151
	BEEP:C151
End if 