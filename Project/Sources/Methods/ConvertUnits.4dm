//%attributes = {"publishedWeb":true}
//(p) ConvertUnits
//converts from one unit of measure to another (or at least it tries)
//$1 - real - quantity to convert
//$2 - string - UOM to convert FROM
//$3 - string - UOM to convert TO
//$4 - pointer - to numerator field - sets this value
//$5 - pointer - to Denominator field - sets this value
//$6 - String (optional) - anything, flag NO message if convert fails & this exist
//$7 - string (optional) - raw material code
//$8 - real (optional) - flex field 2 - width
//$9 - real (optional) - flex feild 3 -length

//Returns - real - new qty

//• 6/9/97 cs  created upr 1872
//Notes:
//rQty is the Arkay desired amount
//[RAW_MATERIALS]Flex3 = Length
//[RAW_MATERIALS]Flex2 = Width
//• 7/29/97 cs suppresed message if conversion uinits already entered
//• 12/22/97 cs added new UOM - 'unit' for leaf (1" x 200')
//• 1/8/98 cs added parameters 7,8,9 for use when calling from New ven sum report
//   which now uses array
//• 3/18/98 cs changed size of UOM vars
//•1/17/00  mlb  UPR don't disable entry

C_LONGINT:C283($InchperFoot; $SqInperSqFt; $QtsPerGal)
C_REAL:C285($Length; $Width; $0; $1; $LbsPerGal; $Qty; $Numerator; $Denominator)
C_BOOLEAN:C305($CantDo)
C_TEXT:C284($2; $3; $6; $From; $To)
C_POINTER:C301($4; $5)

$Qty:=$1
$From:=$2
$To:=$3
$Numerator:=$4->
$Denominator:=$5->

If (Count parameters:C259=9)  //passing in Rm Code
	If ([Raw_Materials:21]Raw_Matl_Code:1#$7)
		QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=$7)
	End if 
Else 
	If ([Raw_Materials:21]Raw_Matl_Code:1#[Purchase_Orders_Items:12]Raw_Matl_Code:15)
		QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Purchase_Orders_Items:12]Raw_Matl_Code:15)
	End if 
End if 

If (Count parameters:C259=9)  //passing in width/length
	$Length:=$9
	$Width:=$8
Else 
	$Length:=[Purchase_Orders_Items:12]Flex3:33
	$Width:=[Purchase_Orders_Items:12]Flex2:32
End if 
$InchperFoot:=12
$SqInperSqFt:=144
$LbsPerGal:=8.64
$QtsPerGal:=4
$CantDo:=False:C215

Case of 
	: ($From=$To)  //converting to the same units
		$Numerator:=1
		$Denominator:=1
		
	: ($From="LF")
		Case of 
			: ($To="ROLL")  //length of roll is in feet
				$Numerator:=1
				$Denominator:=$Length
			: ($To="SqFt")  //width is in inches
				$Numerator:=$Width
				$Denominator:=$InchperFoot
			: ($To="MSF")
				$Numerator:=$Width
				$Denominator:=1000*$InchperFoot
			: ($To="SqIn")
				$Numerator:=$InchperFoot*$Width
				$Denominator:=1
			: ($To="MSI")
				$Numerator:=$InchperFoot*$Width
				$Denominator:=1000
			: ($To="LI")
				$Numerator:=$InchperFoot
				$Denominator:=1
			: ($To="Sht")
				$Numerator:=1
				$Denominator:=($Length/$InchperFoot)
			Else 
				$CantDo:=True:C214
		End case 
		
	: ($From="Roll")
		Case of 
			: ($To="LF")
				$Numerator:=$Length
				$Denominator:=1
			: ($To="SqFt")
				$Numerator:=$Length*($Width/$InchperFoot)
				$Denominator:=1
			: ($To="MSF")
				$Numerator:=$Length*($Width/$InchperFoot)
				$Denominator:=1000
			: ($To="SqIn")
				$Numerator:=($Length*$InchperFoot)*$Width
				$Denominator:=1
			: ($To="MSI")
				$Numerator:=($Length*$InchperFoot)*$Width
				$Denominator:=1000
			: ($To="LI")
				$Numerator:=$Length*$InchperFoot
				$Denominator:=1
			: ($To="Unit")  //1 unit = 1" x 200' LEAF only
				$Numerator:=($Length/200)*$Width
				$Denominator:=1
			Else 
				$CantDo:=True:C214
		End case 
		
	: ($From="SqIn")
		Case of 
			: ($To="LF")
				$Numerator:=1
				$Denominator:=$Width*$InchperFoot
			: ($To="SqFt")
				$Numerator:=1
				$Denominator:=$SqInperSqFt
			: ($To="MSF")
				$Numerator:=1
				$Denominator:=$SqInperSqFt*1000
			: ($To="MSI")
				$Numerator:=1
				$Denominator:=1000
			: ($To="LI")
				$Numerator:=1
				$Denominator:=$Width
			: ($To="Roll")
				$Numerator:=1
				$Denominator:=($Width*$InchperFoot)*$Length
			: ($To="Sht")
				$Numerator:=1
				$Denominator:=$Width*$Length
			Else 
				$CantDo:=True:C214
		End case 
		
	: ($From="MSI")
		Case of 
			: ($To="LF")
				$Numerator:=1000
				$Denominator:=$InchperFoot*$Width
			: ($To="SqFt")
				$Numerator:=1000
				$Denominator:=$SqInperSqFt
			: ($To="MSF")
				$Numerator:=1
				$Denominator:=$SqInperSqFt
			: ($To="LI")
				$Numerator:=1000
				$Denominator:=$Width
			: ($To="Roll")
				$Numerator:=1000
				$Denominator:=($Width*$InchperFoot)*$Length
			: ($To="Sht")
				$Numerator:=1000
				$Denominator:=$Length*$Width
			Else 
				$CantDo:=True:C214
		End case 
		
	: ($From="SqFt")
		Case of 
			: ($To="LF")  //$Width is in inches
				$Numerator:=1
				$Denominator:=($Width/$InchperFoot)
			: ($To="SqIn")
				$Numerator:=$SqInperSqFt
				$Denominator:=1
			: ($To="MSF")
				$Numerator:=1
				$Denominator:=1000
			: ($To="MSI")
				$Numerator:=$SqInperSqFt
				$Denominator:=1000
			: ($To="LI")
				$Numerator:=$SqInperSqFt
				$Denominator:=$Width
			: ($To="Roll")  //length is given in fett, width is in inches
				$Numerator:=1
				$Denominator:=($Width/$InchperFoot)*$Length
			: ($To="Sht")
				$Numerator:=1
				$Denominator:=($Width/$InchperFoot)*($Length/$InchperFoot)
			Else 
				$CantDo:=True:C214
		End case 
		
	: ($From="MSF")
		Case of 
			: ($To="LF")
				$Numerator:=1000
				$Denominator:=$Width/$InchperFoot
			: ($To="SqIn")
				$Numerator:=1000*$SqInperSqFt
				$Denominator:=1
			: ($To="MSI")
				$Numerator:=$SqInperSqFt
				$Denominator:=1
			: ($To="LI")
				$Numerator:=1000*$SqInperSqFt
				$Denominator:=$Width
			: ($To="Roll")
				$Numerator:=1000
				$Denominator:=($Width/$InchperFoot)*$Length
			: ($To="Sht")
				$Numerator:=1000
				$Denominator:=($Width/$InchperFoot)*($Length/$InchperFoot)
			Else 
				$CantDo:=True:C214
		End case 
		
	: ($From="LI")
		Case of 
			: ($To="LF")
				$Numerator:=1
				$Denominator:=$InchperFoot
			: ($To="SqIn")
				$Numerator:=$Width
				$Denominator:=1
			: ($To="SqFt")
				$Numerator:=$Width
				$Denominator:=$SqInperSqFt
			: ($To="MSF")
				$Numerator:=$Width
				$Denominator:=1000*$SqInperSqFt
			: ($To="MSI")
				$Numerator:=$Width
				$Denominator:=1000
			: ($To="Roll")
				$Numerator:=1
				$Denominator:=$InchperFoot*$Length
			: ($To="Sht")
				$Numerator:=1
				$Denominator:=$Length
			Else 
				$CantDo:=True:C214
		End case 
		
	: ($From="Sht")
		Case of 
			: ($To="LF")
				$Numerator:=$Length/$InchperFoot
				$Denominator:=1
			: ($To="SqIn")
				$Numerator:=$Width*$Length
				$Denominator:=1
			: ($To="SqFt")
				$Numerator:=$Width*$Length
				$Denominator:=$SqInperSqFt
			: ($To="MSF")
				$Numerator:=$Width*$Length
				$Denominator:=1000*$SqInperSqFt
			: ($To="MSI")
				$Numerator:=$Width*$Length
				$Denominator:=1000
			: ($To="LI")
				$Numerator:=$Length
				$Denominator:=1
			Else 
				$CantDo:=True:C214
		End case 
		
	: ($From="GL")
		Case of 
			: ($To="LB")
				$Numerator:=$LbsPerGal
				$Denominator:=1
			: ($To="Qt")
				$Numerator:=$QtsPerGal
				$Denominator:=1
			Else 
				$CantDo:=True:C214
		End case 
		
	: ($From="Qt")
		Case of 
			: ($To="LB")
				$Numerator:=$LbsPerGal
				$Denominator:=$QtsPerGal
			: ($To="Gl")
				$Numerator:=1
				$Denominator:=$QtsPerGal
			Else 
				$CantDo:=True:C214
		End case 
		
	: ($From="Lb")
		Case of 
			: ($To="Gl")
				$Numerator:=1
				$Denominator:=$LbsPerGal
			: ($To="Qt")
				$Numerator:=$QtsPerGal
				$Denominator:=$LbsPerGal
			Else 
				$CantDo:=True:C214
		End case 
		
	: ($From="Unit")  //• 12/22/97 cs 1 unit = 1" x 200' LEAF only
		Case of 
			: ($To="LF")  //# units *200'
				$Numerator:=200
				$Denominator:=1
			: ($To="MSF")  //• 12/22/97 cs #units x (200'(LF) x (Width in Ft))/1000
				$Numerator:=200*($Width/$InchperFoot)
				$Denominator:=1000
			: ($To="LI")  //# units *200' * #inches/foot
				$Numerator:=200*$InchPerFoot
				$Denominator:=1
			: ($To="MSI")  //• 12/22/97 cs #units x (200' x Inchesperfoot (Li) x (Width in inches))/1000
				$Numerator:=200*$InchperFoot*$Width
				$Denominator:=1000
			: ($To="SqIn")  //• 12/22/97 cs #units x (200' x Inchesperfoot (Li) x (Width in inches))
				$Numerator:=200*$InchperFoot*$Width
				$Denominator:=1
			: ($To="SqFt")  //• 12/22/97 cs #units x (200'(LF) x (Width in Ft))
				$Numerator:=200*($Width/$InchperFoot)
				$Denominator:=1
			: ($To="Roll")  //• 12/22/97 cs #units/(width(roll)*Length(roll)/200)
				$Numerator:=1
				$Denominator:=$Width*($Length/200)
			Else 
				$CantDo:=True:C214
		End case 
	Else 
		$CantDo:=True:C214
End case 

If ($CantDo)
	If (Count parameters:C259<6) & ([Purchase_Orders_Items:12]FactNship2cost:29=[Purchase_Orders_Items:12]FactDship2cost:37)  //not a suppressed message (called for cost -> price) & convert not entered • 7/29
		ALERT:C41("Can NOT convert entered UOMs"+Char:C90(13)+"Please enter conversion factors.")
		SetObjectProperties(""; ->[Purchase_Orders_Items:12]FactNship2cost:29; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		SetObjectProperties(""; ->[Purchase_Orders_Items:12]FactDship2cost:37; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		GOTO OBJECT:C206([Purchase_Orders_Items:12]FactNship2cost:29)
		fManualConv:=True:C214
	End if 
	$0:=Round:C94(($Qty*$Numerator)/$Denominator; 3)
	
Else   //conversion was possible do not let user change values
	If (Count parameters:C259<6)
		SetObjectProperties(""; ->[Purchase_Orders_Items:12]FactNship2cost:29; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		SetObjectProperties(""; ->[Purchase_Orders_Items:12]FactDship2cost:37; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		fManualConv:=False:C215
	End if 
	$0:=Round:C94(($Qty*$Numerator)/$Denominator; 3)
	$4->:=$Numerator
	$5->:=$Denominator
End if 