//%attributes = {}
// Method: BarCode128mix () -> 
// ----------------------------------------------------
// by: mel: 12/20/04, 14:17:37
// ----------------------------------------------------
//DOES NOT WORK
//DOES NOT WORK
//DOES NOT WORK
//DOES NOT WORK
// Description:
// encode a pair of applicationcode/data combo's into Code128setA
//note, make sure data arguement is uppercase since Set A is being used.
// ----------------------------------------------------

C_LONGINT:C283($position; $codeCrepresentation; $startCode_A; $fnc1; $endCode; $insertFCNHere; $weightedTotal)
C_TEXT:C284($1; $2; $0; $dataToPrint; $dataToEncode)
C_BOOLEAN:C305($two; $allNumbers)  //check if all numbers so set "C" can be used

$insertFCNHere:=0  //to separate combined symbols, like (91)cpn and (37)qty

$startCode_A:=203  //uppercase and control
$startCode_Avalue:=103
$chgCode_A:=201  //use to switch sets
$chgCode_Avalue:=101
//
$startCode_B:=204  //for all characters
$startCode_Avalue:=104
$chgCode_B:=200  //use to switch sets
$chgCode_Bvalue:=100
//
$startCode_C:=205  //for interleaved numbers
$startCode_Cvalue:=105
$chgCode_C:=199  //use to switch sets
$chgCode_Cvalue:=99

$fnc1:=202
$fnc1Char:=Char:C90($fnc1)
$fnc1value:=102
$endCode:=206  //don't encode

$0:=""
$dataToPrint:=""
$dataToEncode:=""
$firstSymbol:=""
$secondSymbol:=""
$two:=False:C215

If (Count parameters:C259>=1)
	//91 95 10 06 13 ;   37 03 60 00
	$firstSymbol:=Uppercase:C13($1)
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
	$secondSymbol:=Uppercase:C13($2)
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

//91 95 10 06 13    37 03 60 00
//combine them and add func 1 character
$dataToEncode:=$fnc1Char+$firstSymbol
If ($two)
	$dataToEncode:=$dataToEncode+$fnc1Char+$secondSymbol
End if 

// /////////////////////////
//parse it into segments of numbers and letters
ARRAY TEXT:C222($aSegment; 10)
$segCursor:=0
$lastType:=0
$thisType:=0

For ($position; 1; Length:C16($dataToEncode))
	$test:=$dataToEncode[[$position]]
	Case of 
		: ($test=$fnc1Char)  //   if a fnc1 treat special
			$thisType:=1
		: ((Character code:C91($test)>47) & (Character code:C91($test)<58))  //   if segment is a numeric, Start C
			$thisType:=2
		Else   //else treat segment as alpha, Start A
			$thisType:=3
	End case 
	If ($thisType#$lastType)
		$segCursor:=$segCursor+1
		$aSegment{$segCursor}:=""
		$lastType:=$thisType
	End if 
	$aSegment{$segCursor}:=$aSegment{$segCursor}+$test
End for 
ARRAY TEXT:C222($aSegment; $segCursor)

// /////////////////////////
//for each segment, encode it
$weightedTotal:=0
$dataToPrint:=""
$weight:=0
$positionInSegment:=0
$positionInData:=0
$lastType:=0

For ($segment; 1; $segCursor)
	$test:=$aSegment{$segment}[[1]]  //check the type of the first character
	Case of 
		: ($test=$fnc1Char)  //   if a fnc1 treat special
			$dataToPrint:=$dataToPrint+$fnc1Char
		: ((Character code:C91($test)>47) & (Character code:C91($test)<58))  //   if segment is a numeric, Start C
			
		Else   //else segment is alpha, Start A
			
			
	End case 
End for 

For ($segment; 1; $segCursor)
	
	$dataToEncode:=$aSegment{$segment}
	$test:=$dataToEncode[[1]]  //check the type of the first character
	Case of 
		: ($test=$fnc1Char)  //   if a fnc1 treat special
			$positionInData:=$positionInData+1
			If ($positionInData=1)  //first field
				$weightedTotal:=$startCode_Cvalue
				$dataToEncode:=Char:C90($startCode_C)+$dataToEncode
				$wgtFNC1:=Barcode_128weightFnc1($test; $positionInData)
				$weightedTotal:=$weightedTotal+$wgtFNC1
				$dataToPrint:=$dataToPrint+Char:C90($startCode_C)+$fnc1Char
				$lastChar:=$fnc1Char
			Else   //next field
				If ($lastType#2)  //switch set
					$lastType:=2
					$weightedTotal:=$weightedTotal+($positionInData*$chgCode_Cvalue)
					$dataToEncode:=Char:C90($chgCode_C)+$dataToEncode
					$positionInData:=$positionInData+1
				End if 
				$wgtFNC1:=Barcode_128weightFnc1($test; $positionInData)
				$weightedTotal:=$weightedTotal+$wgtFNC1
				$dataToPrint:=$dataToPrint+Char:C90($chgCode_C)+$fnc1Char
				$lastChar:=$fnc1Char
			End if 
			
		: ((Character code:C91($test)>47) & (Character code:C91($test)<58))  //   if segment is a numeric, Start C
			
			If ((Length:C16($dataToEncode)%2)=1)
				$dataToEncode:="0"+$dataToEncode
			End if 
			
			If ($lastChar=$fnc1Char)  //just printed fnc1 `($positionInData=1)
				For ($positionInSegment; 1; Length:C16($dataToEncode); 2)  //skip the loop counter cause we got a pair
					$positionInData:=$positionInData+1
					
					$codeCrepresentation:=Barcode_128interleaveGetCode($dataToEncode; $positionInSegment)
					$dataToPrint:=$dataToPrint+Barcode_128interleaveGetChar($codeCrepresentation)
					$weightedTotal:=$weightedTotal+($codeCrepresentation*$positionInData)  //accumulate the weighted values
				End for 
				$lastChar:="+"
			Else 
				If ($lastType#2)  //switch set
					$lastType:=2
					$dataToEncode:=Char:C90($startCode_C)+$dataToEncode
					$positionInData:=$positionInData+1
					$weightedTotal:=$weightedTotal+($positionInData*$chgCode_Cvalue)
					$dataToPrint:=$dataToPrint+Char:C90($chgCode_C)
				End if 
				For ($positionInSegment; 2; Length:C16($dataToEncode); 2)  //skip the loop counter cause we got a pair
					$positionInData:=$positionInData+1
					
					$codeCrepresentation:=Barcode_128interleaveGetCode($dataToEncode; $positionInSegment)
					$dataToPrint:=$dataToPrint+Barcode_128interleaveGetChar($codeCrepresentation)
					$weightedTotal:=$weightedTotal+($codeCrepresentation*$positionInData)  //accumulate the weighted values
				End for 
				$lastChar:="+"
			End if 
			
		Else   //else segment is alpha, Start A
			If ($lastType#3)  //switch set
				$lastType:=3
				$dataToEncode:=Char:C90($chgCode_A)+$dataToEncode
				$positionInData:=$positionInData+1
				$weightedTotal:=$weightedTotal+($positionInData*$chgCode_Avalue)
			End if 
			$dataToPrint:=$dataToPrint+$dataToEncode
			$lastChar:="+"
			For ($positionInSegment; 2; Length:C16($dataToEncode))
				$positionInData:=$positionInData+1
				$char:=Character code:C91($dataToEncode[[$positionInSegment]])
				Case of 
					: ($char=194)
						$charValue:=0
					: ($char>126)
						$charValue:=$positionInData*($char-100)  //100 is the offset between value and ascii number of specials
					Else 
						$charValue:=$positionInData*($char-32)  //32 is the offset between value and ascii number
				End case 
				$weightedTotal:=$weightedTotal+$charValue
			End for 
			
	End case 
End for 

$chkChar:=Barcode_128getChkDigit($weightedTotal)

$0:=$dataToPrint+$chkChar+Char:C90($endCode)