//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 09/08/08, 18:39:19
// ----------------------------------------------------
// Method: edi_format_FTX_segment
// Description
// return an FTX segment given some fields to work with

C_POINTER:C301($1; $2; $3)
C_TEXT:C284($tElDel; $4; $tSubElDel; $5; $tSegDel; $6)

$tElDel:=$4
$tSubElDel:=$5
$tSegDel:=$6
// ----------------------------------------------------
$ftx:=""
If ((Length:C16($1->)+Length:C16($2->)+Length:C16($3->))>0)
	$ftx:=$ftx+"FTX"+$tElDel+"AAI"+$tElDel+$tElDel+$tElDel+Substring:C12(edi_filter_delimiters($1->); 1; 70)
	If ((Length:C16($2->)+Length:C16($3->))>0)
		$ftx:=$ftx+$tSubElDel+Substring:C12(edi_filter_delimiters($2->); 1; 70)
		If (Length:C16($3->)>0)
			$ftx:=$ftx+$tSubElDel+Substring:C12(edi_filter_delimiters($3->); 1; 70)
		End if 
	End if 
	$ftx:=$ftx+$tSegDel
End if 

$0:=$ftx