//%attributes = {"publishedWeb":true}
//(p) rPIRmCountSheet
//prints a form to be used for Counting RM during PI
//created 4/8/97 cs
//$1  - flag (any string) tell this procedure to print as a verification report
//• 2/3/98 cs move major reformat of report
//  description in array for printing
// • mel (7/20/05, 11:09:56) rewrite, dump all bin data to excel file
// Modified by: Mel Bohince (9/26/18) fix unit cost
// Modified by: Mel Bohince (11/5/20) change to csv output
// Modified by: Garri Ogata (01/11/21) Added [Raw_Materials]ReceiptUOM and sort on [Raw_Materials_Locations]Raw_Matl_Code

C_TEXT:C284($t; $r; $tUOM)
C_TEXT:C284(xTitle; xText; docName)
C_TIME:C306($docRef)
C_LONGINT:C283($i; $numRecs)
C_BOOLEAN:C305($break)

$t:=","  //Char(9) // Modified by: Mel Bohince (11/5/20) change to csv output
$r:=Char:C90(13)
xTitle:="Raw Material Count Sheet"

docName:="RMCount_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"  // Modified by: Mel Bohince (11/5/20) change to csv output
$docRef:=util_putFileName(->docName)

If ($docRef#?00:00:00?)
	SEND PACKET:C103($docRef; xTitle+$r+$r)
	READ ONLY:C145([Raw_Materials_Locations:25])
	READ ONLY:C145([Purchase_Orders_Items:12])
	If (Count parameters:C259=0)
		ALL RECORDS:C47([Raw_Materials_Locations:25])
	Else 
		USE SET:C118($1)
		CLEAR SET:C117($1)
		OK:=1
	End if 
	
	$numRecs:=Records in selection:C76([Raw_Materials_Locations:25])
	
	ORDER BY:C49([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1; >)
	
	xText:="CommodityKey"+$t+"RawMaterialCode"+$t+"PO_Item"+$t+"OnHand"+$t+"UOM"+$t+"Warehouse"+$t+"Location"+$t+"ExtendedCost"+$t+"ConsignmentQty"+$t+"MillNumber"+$r
	
	uThermoInit($numRecs; "Reporting Records to "+docName)
	
	For ($i; 1; $numRecs)
		If ($break)
			$i:=$i+$numRecs
		End if 
		
		$actCost:=POIpriceToCost([Raw_Materials_Locations:25]POItemKey:19)  // Modified by: Mel Bohince (9/26/18) fix unit cost
		// Modified by: Mel Bohince (11/5/20) change to csv output
		
		$tUOM:=CorektBlank
		
		If (Core_Query_UniqueRecordB(->[Raw_Materials:21]Raw_Matl_Code:1; ->[Raw_Materials_Locations:25]Raw_Matl_Code:1))
			$tUOM:=[Raw_Materials:21]ReceiptUOM:9
		End if 
		
		xText:=xText+txt_ToCSV(->[Raw_Materials_Locations:25]Commodity_Key:12)+$t+txt_ToCSV(->[Raw_Materials_Locations:25]Raw_Matl_Code:1)+$t+[Raw_Materials_Locations:25]POItemKey:19+$t+String:C10([Raw_Materials_Locations:25]QtyOH:9)+$t+$tUOM+$t+txt_ToCSV(->[Raw_Materials_Locations:25]Warehouse:29)+$t+txt_ToCSV(->[Raw_Materials_Locations:25]Location:2)+$t+String:C10(Round:C94($actCost*[Raw_Materials_Locations:25]QtyOH:9; 0))+$t+String:C10([Raw_Materials_Locations:25]ConsignmentQty:26)+$t+[Raw_Materials_Locations:25]MillNumber:25+$r
		
		If (Length:C16(xText)>28000)
			SEND PACKET:C103($docRef; xText)
			xText:=""
		End if 
		
		SAVE RECORD:C53([Raw_Materials_Locations:25])
		NEXT RECORD:C51([Raw_Materials_Locations:25])
		uThermoUpdate($i)
	End for 
	
	uThermoClose
	
	SEND PACKET:C103($docRef; xText)
	SEND PACKET:C103($docRef; Char:C90(13)+Char:C90(13)+"------ END OF FILE ------")
	CLOSE DOCUMENT:C267($docRef)
	
	// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)  //
	If (Count parameters:C259=0)
		$err:=util_Launch_External_App(docName)
	End if 
	
	REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)
	
Else 
	BEEP:C151
	ALERT:C41(docName+" couldn't be created.")
End if 

uWinListCleanup