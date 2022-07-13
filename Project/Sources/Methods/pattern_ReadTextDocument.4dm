//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 12/27/12, 11:44:14
// ----------------------------------------------------
// Method: pattern_ReadTextDocument
// ----------------------------------------------------

C_LONGINT:C283($1; $id)
C_DATE:C307($today)
C_TEXT:C284($recordDelimitor)
C_TIME:C306($docRef)
C_REAL:C285($cost)
C_TEXT:C284($rmCode; $desc)

If (Count parameters:C259=0)
	CONFIRM:C162("import text as RMCode<tab>SAP#<tab>Cost<cr>?")
	If (OK=1)
		$id:=New process:C317("pattern_ReadTextDocument"; <>lMinMemPart; "Data_Import"; 2)
		If (False:C215)
			pattern_ReadTextDocument
		End if 
	End if 
	
Else 
	READ WRITE:C146([Raw_Materials:21])
	CREATE EMPTY SET:C140([Raw_Materials:21]; "modified")
	$recordDelimitor:=Char:C90(13)
	$today:=4D_Current_date
	$docRef:=Open document:C264("")  //open the document
	If (OK=1)
		RECEIVE PACKET:C104($docRef; row; $recordDelimitor)  //read the document
		$i:=0
		row:=Replace string:C233(row; Char:C90(34); "")
		While (Length:C16(row)>10)  //(OK=1) &
			$i:=$i+1
			zwStatusMsg("Row"+String:C10($i); row)
			
			util_TextParser(3; row)
			
			$rmCode:=util_TextParser(1)
			$sap:=util_TextParser(2)
			$cost:=Num:C11(util_TextParser(3))
			util_TextParser
			
			$rmCode:=fStripSpace("B"; $rmCode)
			$sap:=fStripSpace("B"; $sap)
			If (Length:C16($sap)>0) & (Length:C16($rmCode)>0) & ($cost>0)
				QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=$rmCode)
				If (Records in selection:C76([Raw_Materials:21])=0)
					$rmCode:=Insert string:C231($rmCode; "-"; 3)
					QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=$rmCode)
				End if 
				
				If (Records in selection:C76([Raw_Materials:21])>0)
					CREATE SET:C116([Raw_Materials:21]; "new_cost")
					UNION:C120("modified"; "new_cost"; "modified")
					//APPLY TO SELECTION([Raw_Materials];Ink_Import_Set_Cost ($cost;$sap))
				Else 
					utl_Logfile("Import.log"; $rmCode+" was not found")
				End if 
				
			Else   //something missing
				utl_Logfile("Import.log"; $rmCode+", "+$sap+", "+String:C10($cost)+" ignored")
			End if   //something to use
			
			RECEIVE PACKET:C104($docRef; row; $recordDelimitor)
			row:=Replace string:C233(row; Char:C90(34); "")
		End while 
		
		CLOSE DOCUMENT:C267($docRef)
		
		USE SET:C118("modified")
		pattern_PassThru(->[Raw_Materials:21])
		ViewSetter(2; ->[Raw_Materials:21])
		
		REDUCE SELECTION:C351([Raw_Materials:21]; 0)
		CLEAR SET:C117("new_cost")
		CLEAR SET:C117("modified")
		BEEP:C151
	End if 
End if 