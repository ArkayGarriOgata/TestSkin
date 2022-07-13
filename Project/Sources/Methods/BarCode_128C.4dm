//%attributes = {}
// Method: BarCode_128C () -> 
// ----------------------------------------------------
// by: mel: 12/27/04, 11:29:25
// ----------------------------------------------------
// Description:
// interleave a pair of numbers using set C
// ----------------------------------------------------

C_TEXT:C284($1; $2; $0; $data; $dataToPrint; $dataToEncode)
C_LONGINT:C283($position; $startCode_C; $fnc1; $stopCode; $weight)
C_TEXT:C284($chkChar)
C_BOOLEAN:C305($two; $allNumbers)  //check if all numbers so set "C" can be used

$startCode_C:=util_ConvertAscii(205)  //for interleaved numbers
$fnc1:=util_ConvertAscii(202)
$fnc1Char:=Char:C90($fnc1)
$stopCode:=util_ConvertAscii(206)  //don't encode
$0:=""
$dataToPrint:=""
$dataToEncode:=""
$firstSymbol:=""
$secondSymbol:=""
$two:=False:C215
//(91 95 10 06 13 ;   37 03 60 00) !spaces added for clairity
If (Count parameters:C259>=1)
	$firstSymbol:=$1
	$allNumbers:=True:C214
	
	For ($position; 1; Length:C16($firstSymbol))
		If (Character code:C91($firstSymbol[[$position]])<48) | (Character code:C91($firstSymbol[[$position]])>57)
			$allNumbers:=False:C215
			$position:=1+Length:C16($firstSymbol)
		End if 
	End for 
	
	If ($allNumbers)  //make it an even number of number pairs
		If ((Length:C16($firstSymbol)%2)=1)
			$firstSymbol:=Substring:C12($firstSymbol; 1; 2)+"0"+Substring:C12($firstSymbol; 3)  //tuck it in after the (application) code
		End if 
	End if 
End if 

If (Count parameters:C259>=2)
	$secondSymbol:=$2
	$two:=True:C214
	For ($position; 1; Length:C16($secondSymbol))
		If (Character code:C91($secondSymbol[[$position]])<48) | (Character code:C91($secondSymbol[[$position]])>57)
			$allNumbers:=False:C215
			$position:=1+Length:C16($secondSymbol)
		End if 
	End for 
	
	If ($allNumbers)  //make it an even number of number pairs
		If ((Length:C16($secondSymbol)%2)=1)  //make it an even number of number pairs
			$secondSymbol:=Substring:C12($secondSymbol; 1; 2)+"0"+Substring:C12($secondSymbol; 3)  //tuck it in after the (application) code
		End if 
	End if 
End if 

//*test that all are numeric, if so where going to used C
$allNumbers:=True:C214
$test:=$firstSymbol+$secondSymbol
For ($position; 1; Length:C16($test))
	If (Character code:C91($test[[$position]])<48) | (Character code:C91($test[[$position]])>57)
		$allNumbers:=False:C215
		$position:=1+Length:C16($test)
	End if 
End for 

If ($allNumbers)  //then slam dunk using C
	//91 95 10 06 13    37 03 60 00
	//combine them and add func 1 character
	$dataToEncode:=$fnc1Char+$firstSymbol
	If ($two)
		$dataToEncode:=$dataToEncode+$fnc1Char+$secondSymbol
	End if 
	
	$weightedTotal:=Barcode_128aGetValue($startCode_C)  //primer, don't use position of start char
	
	$weight:=0  //increment by 1 for each pair
	$dataToPrint:=""
	For ($position; 1; Length:C16($dataToEncode))
		$weight:=$weight+1  //increment the weighting, position skips
		
		$wgtFNC1:=Barcode_128weightFnc1($dataToEncode[[$position]]; $weight)
		If ($wgtFNC1>0)  //we're at a Function 1 character, treat special
			$weightedTotal:=$weightedTotal+$wgtFNC1
			$dataToPrint:=$dataToPrint+$fnc1Char
			//$weight:=$position  `reset to current position
		Else 
			$codeCrepresentation:=Barcode_128interleaveGetCode($dataToEncode; $position)
			$dataToPrint:=$dataToPrint+Barcode_128interleaveGetChar($codeCrepresentation)
			$weightedTotal:=$weightedTotal+($codeCrepresentation*$weight)  //accumulate the weighted values
			$position:=$position+1  //skip the loop counter cause we got a pair
		End if 
		
	End for 
	
	$chkChar:=Barcode_128getChkDigit($weightedTotal)
	
	$0:=Char:C90($startCode_C)+$dataToPrint+$chkChar+Char:C90($stopCode)
	
Else   //treat as Set B
	$0:=BarCode_128B($1; $2)
End if 