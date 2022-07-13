//%attributes = {}

// Method: util_text_CSV_cleaner ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 01/21/14, 16:02:20
// ----------------------------------------------------
// Description
// remove any quoted commas that are in the data 
//
// ----------------------------------------------------

C_TEXT:C284($row; $1)
$row:=$1

$len:=Length:C16($row)
$inQuote:=False:C215
For ($i; 1; $len)
	If (Not:C34($inQuote))
		If ($row[[$i]]=Char:C90(Double quote:K15:41))  //quote found
			$row[[$i]]:="•"
			$inQuote:=True:C214
		End if 
		
	Else 
		If ($row[[$i]]=",")
			$row[[$i]]:="•"
		End if 
		
		If ($row[[$i]]=Char:C90(Double quote:K15:41))
			$row[[$i]]:="•"
			$inQuote:=False:C215
		End if 
		
	End if 
End for 

$0:=Replace string:C233($row; "•"; "")
