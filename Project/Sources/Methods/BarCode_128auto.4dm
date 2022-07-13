//%attributes = {}
// Method: BarCode_128auto () -> 
// ----------------------------------------------------
// by: mel bohince: 01/19/05, 17:04:41
// ----------------------------------------------------
// Description:
//Translated to 4D from example Code 128 Set B.txt 
// and the VBA excel example 'The following is a Visual Basic Example:
// Public Function IDAutomation_C128(DataToEncode As String) As String
//STEPS:
//first set up the keyed pairs for mapping triplets, then
//determing which set to use and make initial assignments, then loop twice,
//once to perform the substitutions ,  then to
//calculate the check digit
// ----------------------------------------------------

C_TEXT:C284($1; $DataToEncode; $DataToFormat; $0; $PrintableString; $CurrentEncoding)
C_LONGINT:C283($i; $WeightedTotal; $StringLength; $CurrentCharNum; $CurrentValue; $CheckDigitValue; $CorrectFNC)

$PrintableString:=""
$DataToFormat:=$1
$DataToEncode:=""

$CorrectFNC:=202  //on Win, 230 on Mac?
//declare as keyed pairs as interprocess ARRAY TEXT(◊aSetC128;0) "On StartUp"
If (Size of array:C274(<>aSetC128)=0)  // | (True)  `define these once per session
	Barcode_MapToTriplets
End if 

$StringLength:=Length:C16($DataToFormat)
If ($StringLength>0)
	//'Here we select initial character set, start string, and init the weighted total
	$CurrentCharNum:=Character code:C91($DataToFormat[[1]])  // look at the first char`Mac to Win() not needed
	Case of 
		: ($CurrentCharNum=202)  //'202 is for the FNC1, with this Start C is mandatory
			$C128Start:=<>aSetC128{105+1}  //"EBJ"  `
			$CurrentEncoding:="C"
			$WeightedTotal:=105
			
		: ($CurrentCharNum>211)  //'212-215 is for the FNC1, with this Start C is mandatory
			$C128Start:=<>aSetC128{105+1}  //"EBJ"  `
			$CurrentEncoding:="C"
			$WeightedTotal:=105
			
		: ($StringLength>4) & (util_isNumeric(Substring:C12($DataToFormat; 1; 4)))  //or  `test if 1st four chars are numeric, then use set C
			$C128Start:=<>aSetC128{105+1}  //"EBJ"  `
			$CurrentEncoding:="C"
			$WeightedTotal:=105
			
		: ($CurrentCharNum<32)  //use set A
			$C128Start:=<>aSetC128{103+1}  //"EDB"  `
			$CurrentEncoding:="A"
			$WeightedTotal:=103
			
		: ($CurrentCharNum>31) & ($CurrentCharNum<127)  //use set B
			$C128Start:=<>aSetC128{104+1}  //"EBD"  `
			$CurrentEncoding:="B"
			$WeightedTotal:=104
			
		Else   //this shouldn't be happening!
			BEEP:C151
			ALERT:C41("Start Sting case failed. See lines beginning at 30")
	End case 
	
	//   '<<<< Format the string to triplet map >>>>
	For ($i; 1; $StringLength)  //each char of $DataToFormat
		
		$CurrentCharNum:=Character code:C91($DataToFormat[[$i]])  //Mac to Win() not needed to be like =(AscW(Mid($DataToEncode,$i, 1)))-32` VBA functions
		
		//see what to do with this char
		Case of 
				// 'check for FNC1 in any set which is ASCII 202 and ASCII 212-215
			: ($CurrentCharNum=202) | ($CurrentCharNum>211)
				$DataToEncode:=$DataToEncode+Char:C90(202)  //based on OS
				
				//if in C, get next pair if they are numeric
			: ($CurrentEncoding="C") & ($i<$StringLength) & (util_isNumeric(Substring:C12($DataToFormat; $i; 2)))
				$CurrentChar:=Substring:C12($DataToFormat; $i; 2)  //take the next pair, treat as an ascii code
				$CurrentCharNum:=Num:C11($CurrentChar)  //reset from the next one to the next pair
				$DataToEncode:=$DataToEncode+Char:C90($CurrentCharNum+32)
				$i:=$i+1  //skip next number
				
				//'check for switching to character set C if at least 4 characters left
			: (($i<($StringLength-2)) & (util_isNumeric(Substring:C12($DataToFormat; $i; 4))))
				If ($CurrentEncoding#"C")  //'switch to set C if not already in it
					$DataToEncode:=$DataToEncode+Char:C90(199)
					$CurrentEncoding:="C"
				End if 
				
				$CurrentChar:=Substring:C12($DataToFormat; $i; 2)  //take the next pair, treat as an ascii code
				$CurrentCharNum:=Num:C11($CurrentChar)  //reset from the next one to the next pair
				$DataToEncode:=$DataToEncode+Char:C90($CurrentCharNum+32)
				$i:=$i+1  //skip next number
				
				//'check for switching to character set A
			: ($CurrentCharNum<31)
				If ($CurrentEncoding#"A")  //'switch to set A if not already in it
					$DataToEncode:=$DataToEncode+Char:C90(201)
					$CurrentEncoding:="A"
				End if 
				
				If ($CurrentCharNum<32)
					$DataToEncode:=$DataToEncode+Char:C90($CurrentCharNum+96)
				Else 
					$DataToEncode:=$DataToEncode+Char:C90($CurrentCharNum)
				End if 
				
				//if in A and ascii is in range 33 to95 (uppercase, numbers, or some control symbols)
			: (($CurrentEncoding="A") & ($CurrentCharNum>32) & ($CurrentCharNum<96))
				If ($CurrentCharNum<32)
					$DataToEncode:=$DataToEncode+Char:C90($CurrentCharNum+96)
				Else 
					$DataToEncode:=$DataToEncode+Char:C90($CurrentCharNum)
				End if 
				
				//'check for switching to character set B, printable characters
			: ($CurrentCharNum>31) & ($CurrentCharNum<127)
				If ($CurrentEncoding#"B")  //'switch to set B if not already in it
					$DataToEncode:=$DataToEncode+Char:C90(200)
					$CurrentEncoding:="B"
				End if 
				$DataToEncode:=$DataToEncode+Char:C90($CurrentCharNum)
				
			Else   //this shouldn't be happening!
				BEEP:C151
				ALERT:C41("Mapping case failed. See lines beginning at 68")
		End case 
	End for 
	
	//   '<<<< Calculate Modulo 103 Check Digit >>>>
	$StringLength:=Length:C16($DataToEncode)
	For ($i; 1; $StringLength)
		$CurrentCharNum:=Character code:C91($DataToEncode[[$i]])  //$CurrentCharNum=(AscW(Mid($DataToEncode,$i, 1)))-32` VBA functions
		Case of 
			: ($CurrentCharNum<135)
				$CurrentValue:=$CurrentCharNum-32
			: ($CurrentCharNum=194) | ($CurrentCharNum=159)
				$CurrentValue:=0
			Else   //: ($CurrentCharNum>134)
				$CurrentValue:=$CurrentCharNum-100
		End case 
		$PrintableString:=$PrintableString+<>aSetC128{$CurrentValue+1}  //4D array starts with 1
		$CurrentValue:=$CurrentValue*$i
		$WeightedTotal:=$WeightedTotal+$CurrentValue
	End for 
	
	$CheckDigitValue:=$WeightedTotal%103  //Mod
	
	$0:=$C128Start+$PrintableString+<>aSetC128{$CheckDigitValue+1}+<>aSetC128{106+1}  //"GIAHj"  `GIAH produces the stop charact
	
Else   //passed an empty string to encode
	$0:=""
End if 