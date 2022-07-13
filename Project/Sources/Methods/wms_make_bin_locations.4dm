//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 10/07/08, 08:24:36
// ----------------------------------------------------
// Method: wms_make_bin_locations
// ----------------------------------------------------

C_TEXT:C284($t; $r; $prefix)
C_TEXT:C284(xTitle; xText; docName)
C_TIME:C306($docRef)
$prefix:="BN"
docName:=Request:C163("Save As:"; "BIN_LOCATIONS.txt"; "OK"; "Cancel")
If (ok=1)
	$docRef:=util_putFileName(->docName)
	
	If ($docRef#?00:00:00?)
		$whs:=Request:C163("Warehouse:"; "V"; "OK"; "Cancel")
		$desc:=Request:C163("Description:"; "East Park Warehouse"; "OK"; "Cancel")
		$amsMapping:=Request:C163("aMs Mapping:"; "FG"; "OK"; "Cancel")
		
		$t:=Char:C90(9)
		$r:=Char:C90(13)
		xTitle:=""
		xText:=""
		
		CONFIRM:C162("Normal or LittleBin?"; "Normal"; "Little")
		If (ok=1)
			$whs:=Request:C163("Warehouse:"; "V"; "OK"; "Cancel")
			$numIsles:=Num:C11(Request:C163("Aisles:"; String:C10(16); "OK"; "Cancel"))
			$numCol:=Num:C11(Request:C163("Columns:"; String:C10(28); "OK"; "Cancel"))
			$numShelves:=Num:C11(Request:C163("Shelves:"; String:C10(5); "OK"; "Cancel"))
			
			For ($isle; 1; $numIsles)
				For ($col; 1; $numCol)
					For ($shelf; 1; $numShelves)
						$bin:=$prefix+$whs+"-"+String:C10($isle; "00")+"-"+String:C10($col; "000")+"-"+String:C10($shelf; "00")
						SEND PACKET:C103($docRef; $bin+$t+$whs+$t+String:C10($isle)+$t+String:C10($col)+$t+String:C10($shelf)+$t+$amsMapping+$t+$desc+$r)
						
					End for 
				End for 
			End for 
			
			BEEP:C151
			zwStatusMsg("SAVED"; "see "+docName)
			
			
		Else 
			
			$numBins:=Num:C11(Request:C163("Number or Bins:"; String:C10(480); "OK"; "Cancel"))
			For ($i; 1; $numBins)
				$bin:=$prefix+$whs+"--"+String:C10($i)
				SEND PACKET:C103($docRef; $bin+$t+$whs+$t+String:C10(0)+$t+String:C10(0)+$t+String:C10(1)+$t+$amsMapping+$t+$desc+$r)
			End for 
		End if   //normal or little
		
		CLOSE DOCUMENT:C267($docRef)
		
	End if   //doc to write to
End if   //doc