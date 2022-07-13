//%attributes = {}
// _______
// Method: BarCode_UPC_A_CheckDigit   ( ) ->
//see also Barcode_UPC_ChkDigit

// By: Mel Bohince @ 08/23/19, 11:11:13
// Description
// return and validate upc with calculated check digit per UPC-A rules, see https://en.wikipedia.org/wiki/Check_digit
//The final digit of a Universal Product Code is a check digit computed as follows[2]

//Add the digits in the odd-numbered positions(first, third, fifth, etc.)together and multiply by three.
//Add the digits(up to but not including the check digit)in the even-numbered positions(second, fourth, sixth, etc.)to the result.
//Take the remainder of the result divided by 10(modulo operation).If the remainder is equal to 0 then use 0 as the check digit, and if not 0 subtr.
//For instance, the UPC-A barcode for a box of tissues is"036000241457".The last digit is the check digit"7", and if the other numbers are correct then the check digit calculation must pro.

//Add the odd number digits: 0+6+0+2+1+5=14
//Multiply the result by 3: 14 ? 3=42
//Add the even number digits: 3+0+0+4+4=11
//Add the two results together: 42+11=53
//To calculate the check digit, take the remainder of (53 / 10), which is also known as (53 modulo 10), and if not 0, subtract from 10. Therefore, the check digit value is 7. i.e. (53 / 10) = 5 remainder 3; 10 - 3 = 7.
// ----------------------------------------------------

C_TEXT:C284($1; $0; $upc; $assertion)
C_LONGINT:C283($i; $length; $odd; $even; $checkDigit)

If (Count parameters:C259=1)
	$upc:=Replace string:C233($1; " "; "")
Else 
	$upc:="036000241457"  //should get a 7 
	//$upc:="84073211468" //should get an 8
End if 

$length:=Length:C16($upc)

If ($length=12)
	$assertion:=Substring:C12($upc; 12; 1)
	$upc:=Substring:C12($upc; 1; 11)
	$length:=11
Else 
	$assertion:=""
End if 

If ($length=11)
	$even:=0
	$odd:=0
	
	For ($i; 1; $length)
		If (($i%2)=0)
			$even:=$even+Num:C11($upc[[$i]])
		Else 
			$odd:=$odd+Num:C11($upc[[$i]])
		End if 
	End for 
	
	$checkDigit:=(($odd*3)+$even)%10
	If ($checkDigit#0)
		$checkDigit:=10-$checkDigit
	End if 
	
	If (Length:C16($assertion)=1)
		If (String:C10($checkDigit)#$assertion)
			ALERT:C41("Invalid UPC-A number? Check digit looks wrong.")
		End if 
	End if 
	
	$0:=$upc+String:C10($checkDigit)
	
Else 
	BEEP:C151
	ALERT:C41("Invalid UPC-A number, needs to be 11 characters.")
	$0:=$upc
End if 