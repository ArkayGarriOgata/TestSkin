//%attributes = {}
// -------
// Method: Invoice_mapTerms   ( ) ->
// By: Mel Bohince @ 08/18/17, 09:57:12
// Description
// convert verbose ams terms to OpenAccounts key-value
// ----------------------------------------------------
// Modified by: Mel Bohince (10/26/17) add Code 455   2%20-Net 45

C_TEXT:C284($amsTerm; $1; $0)  //ams term
C_LONGINT:C283($hit)

If (Count parameters:C259=1)
	$amsTerm:=$1
Else 
	$amsTerm:="1%20-Net 45"  //should return 454
End if 

ARRAY TEXT:C222($OA_TermCode; 0)
APPEND TO ARRAY:C911($OA_TermCode; "301")
APPEND TO ARRAY:C911($OA_TermCode; "302")
APPEND TO ARRAY:C911($OA_TermCode; "303")
APPEND TO ARRAY:C911($OA_TermCode; "304")
APPEND TO ARRAY:C911($OA_TermCode; "333")
APPEND TO ARRAY:C911($OA_TermCode; "451")
APPEND TO ARRAY:C911($OA_TermCode; "452")
APPEND TO ARRAY:C911($OA_TermCode; "453")
APPEND TO ARRAY:C911($OA_TermCode; "454")
APPEND TO ARRAY:C911($OA_TermCode; "455")  // Modified by: Mel Bohince (10/26/17) 
APPEND TO ARRAY:C911($OA_TermCode; "601")
APPEND TO ARRAY:C911($OA_TermCode; "COD")
APPEND TO ARRAY:C911($OA_TermCode; "N12")
APPEND TO ARRAY:C911($OA_TermCode; "N15")
APPEND TO ARRAY:C911($OA_TermCode; "N30")
APPEND TO ARRAY:C911($OA_TermCode; "N45")
APPEND TO ARRAY:C911($OA_TermCode; "N50")
APPEND TO ARRAY:C911($OA_TermCode; "N60")
APPEND TO ARRAY:C911($OA_TermCode; "N75")
APPEND TO ARRAY:C911($OA_TermCode; "N90")

ARRAY TEXT:C222($OA_TermList; 0)
APPEND TO ARRAY:C911($OA_TermList; "1%15-Net 30")
APPEND TO ARRAY:C911($OA_TermList; "1%10-Net 30")
APPEND TO ARRAY:C911($OA_TermList; "1%20-Net 30")
APPEND TO ARRAY:C911($OA_TermList; "2%20-Net 30")
APPEND TO ARRAY:C911($OA_TermList; "1/3, 1/3, 1/3")
APPEND TO ARRAY:C911($OA_TermList; "1%15-Net 45")
APPEND TO ARRAY:C911($OA_TermList; "2%15-Net 45")
APPEND TO ARRAY:C911($OA_TermList; "2%10-Net 45")  //not in ams
APPEND TO ARRAY:C911($OA_TermList; "1%20-Net 45")
APPEND TO ARRAY:C911($OA_TermList; "2%20-Net 45")  // Modified by: Mel Bohince (10/26/17) 
APPEND TO ARRAY:C911($OA_TermList; "1%10-Net 60")
APPEND TO ARRAY:C911($OA_TermList; "On Receipt")
APPEND TO ARRAY:C911($OA_TermList; "Net 120")
APPEND TO ARRAY:C911($OA_TermList; "Net 150")
APPEND TO ARRAY:C911($OA_TermList; "Net 30")
APPEND TO ARRAY:C911($OA_TermList; "Net 45")
APPEND TO ARRAY:C911($OA_TermList; "Net 50")
APPEND TO ARRAY:C911($OA_TermList; "Net 60")
APPEND TO ARRAY:C911($OA_TermList; "Net 75")
APPEND TO ARRAY:C911($OA_TermList; "Net 90")

//If (Count parameters=0)
//utl_LogIt("init")
//For ($hit;1;Size of array($OA_TermCode))
//utl_LogIt($OA_TermCode{$hit}+" - "+$OA_TermList{$hit})
//End for 
//utl_LogIt("show")
//End if 

$hit:=Find in array:C230($OA_TermList; $amsTerm)
If ($hit>-1)
	$0:=$OA_TermCode{$hit}
Else 
	$0:="ERR"
End if 
