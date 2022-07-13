//%attributes = {"publishedWeb":true}
//PM: Ink_Import() -> 
//@author mlb - 5/31/01  12:56

C_LONGINT:C283($1; $id)
C_DATE:C307($today)
C_TEXT:C284($recordDelimitor)
C_TIME:C306($docRef)
C_REAL:C285($cost)
C_TEXT:C284($rmCode; $desc)

If (Count parameters:C259=0)
	CONFIRM:C162("import text as RMCode<tab>SAP#<tab>Cost<cr>?")
	If (OK=1)
		$id:=New process:C317("Ink_Import"; <>lMinMemPart; "Ink_Import"; 2)
		If (False:C215)
			Ink_Import
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
				
				//QUERY([Raw_Materials];[Raw_Materials]VendorPartNum=$sap)
				//If (Records in selection([Raw_Materials])=0) & (False)  `DON'T CREATE 
				//QUERY([Raw_Materials];[Raw_Materials]Raw_Matl_Code=$rmCode)
				//If (Records in selection([Raw_Materials])>0)
				//[Raw_Materials]VendorPartNum:=$sap
				//SAVE RECORD([Raw_Materials])
				//Else 
				//CREATE RECORD([Raw_Materials])
				//[Raw_Materials]Raw_Matl_Code:=$rmCode
				//[Raw_Materials]VendorPartNum:=$sap
				//[Raw_Materials]ConvertRatio_N:=1
				//[Raw_Materials]ConvertRatio_D:=1
				//[Raw_Materials]Matl_Manager:="INX"
				//[Raw_Materials]CommodityCode:=2
				//[Raw_Materials]SubGroup:="UV Special"
				//$success:=fCreateRMgroup (2)
				//[Raw_Materials]ReceiptUOM:=[Raw_Materials]IssueUOM
				//[Raw_Materials]Flex4:="created "+String($today;System date short )  `      sMachLabel4:="Note:"
				//[Raw_Materials]Flex5:=$color  `      sMachLabel5:="Color:"
				//[Raw_Materials]Description:=$desc
				//If (Length([Raw_Materials]Flex5)=0)
				//[Raw_Materials]Flex5:=util_findColor ($desc)
				//End if 
				//If (Position("varnish";[RAW_MATERIALS]Flex5)>0)
				//[RAW_MATERIALS]SubGroup:="UV Special"
				//End if 
				//SAVE RECORD([Raw_Materials])
				//End if 
				//End if 
				
				If (Records in selection:C76([Raw_Materials:21])>0)
					CREATE SET:C116([Raw_Materials:21]; "new_cost")
					UNION:C120("modified"; "new_cost"; "modified")
					APPLY TO SELECTION:C70([Raw_Materials:21]; Ink_Import_Set_Cost($cost; $sap))
				Else 
					utl_Logfile("Ink_Import.log"; $rmCode+" was not found")
				End if 
				
			Else   //something missing
				utl_Logfile("Ink_Import.log"; $rmCode+", "+$sap+", "+String:C10($cost)+" ignored")
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