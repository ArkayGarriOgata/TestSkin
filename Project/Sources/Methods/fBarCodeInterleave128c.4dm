//%attributes = {"publishedWeb":true}
//PM:  fBarCodeInterleave128data)  11/09/00  mlb
//convert data to the 128C characters
//this uses the UCC128 style checkdigit which begins
//the weighting as 2 rather than 1

C_LONGINT:C283($position; $codeCrepresentation; $startCode_C; $fnc1; $endCode)
C_TEXT:C284($1; $dataToEncode; $0; $dataToPrint)

$dataToEncode:=Replace string:C233($1; "-"; "")
$dataToEncode:=Replace string:C233($dataToEncode; "."; "")
$dataToEncode:=Replace string:C233($dataToEncode; " "; "")
$dataToPrint:=""
$0:=""
$startCode_C:=205
$fnc1:=202
$endCode:=206  //don't encode
//*make sure that there are an even number of characters
If ((Length:C16($dataToEncode)%2)=1)
	$dataToEncode:="0"+$dataToEncode
End if 
//
//*test lenght for P&G SSCC
Case of 
	: (Length:C16($dataToEncode)>20)
		BEEP:C151
		ALERT:C41("Too many characters to be a valid P&G barcode.")
	: (Length:C16($dataToEncode)<20)
		BEEP:C151
		ALERT:C41("Too few characters to be a valid P&G barcode.")
		//assert 20 characters
		//While (Length($dataToEncode)<20)
		//$dataToEncode:="0"+$dataToEncode
		//End while 
End case 

//*test that all are numeric
$pass:=True:C214
For ($position; 1; Length:C16($dataToEncode))
	If (Character code:C91($dataToEncode[[$position]])<48) | (Character code:C91($dataToEncode[[$position]])>57)
		$pass:=False:C215
		BEEP:C151
		ALERT:C41("Can only barcode numeric characters")
		$position:=1+Length:C16($dataToEncode)
	End if 
End for 

If ($pass)
	$weightedTotal:=102+105  //value of the startC and fnc1, then accumulate
	$weight:=2  //increment by 1 for each pair
	For ($position; 1; Length:C16($dataToEncode); 2)  //skip every other one
		$pair:=Substring:C12($dataToEncode; $position; 2)  //grab to characters
		$codeCrepresentation:=Num:C11($pair)  //convert to integer
		Case of 
			: ($codeCrepresentation=0)  //special rule for zero
				$dataToPrint:=$dataToPrint+Char:C90(159)
			: ($codeCrepresentation<95)  //add to 32 to obtain ascii representation
				$dataToPrint:=$dataToPrint+Char:C90($codeCrepresentation+32)
			Else   //add to 100 to obtain ascii representation
				$dataToPrint:=$dataToPrint+Char:C90($codeCrepresentation+100)
		End case 
		
		$weightedTotal:=$weightedTotal+($codeCrepresentation*$weight)  //accumulate the weighted values
		$weight:=$weight+1  //increment the weighting
	End for 
	
	$chkDigitValue:=$weightedTotal%103  //get the remainder
	
	Case of   //get ascii representation of check digit
		: ($chkDigitValue=0)
			$chkDigitValue:=159
		: ($chkDigitValue<95)
			$chkDigitValue:=$chkDigitValue+32
		Else 
			$chkDigitValue:=$chkDigitValue+100
	End case 
	
	$0:=Char:C90($startCode_C)+Char:C90($fnc1)+$dataToPrint+Char:C90($chkDigitValue)+Char:C90($endCode)
End if 