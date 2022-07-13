//%attributes = {"publishedWeb":true}
//PM: HFSShortName(fullPath) -> 
//@author mlb - 9/5/02  13:03
// Modified by: Mel Bohince (6/14/16) put in a stop condition
C_LONGINT:C283($len)
C_TEXT:C284($1; $fullPath)

$fullPath:=$1
$len:=Length:C16($fullPath)
Repeat 
	$len:=$len-1
Until ($fullPath[[$len]]=<>DELIMITOR) | ($len=1)
$0:=Substring:C12($fullPath; $len+1)