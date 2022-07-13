//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 09/07/07, 15:25:50
// ----------------------------------------------------
// Method: CUST_isRamaProject(billto;shipto)->RAMA_PROJECT:=true if 
// Description
// check billto and shipto's to see if part of the Rama deal-e-o
// ----------------------------------------------------

C_BOOLEAN:C305($0; RAMA_PROJECT)
C_TEXT:C284($1; $2; $billto; $shipto)  //billto;shipto respectively

$billto:=$1
$shipto:=$2

If (($billto="02568") | ($billto="02768") | ($billto="02769")) & (($shipto="02563") | ($shipto="01666"))
	$0:=True:C214
Else 
	$0:=False:C215
End if 