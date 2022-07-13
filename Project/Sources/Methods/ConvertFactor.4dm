//%attributes = {"publishedWeb":true}
//Procedure: ConvertFactor($from;$to;»$numerator;»$denominator{;$width;$length}) 
//returns num, denom and factor
//find a numerator and denomenator

C_TEXT:C284($1; $2; $from; $to)
C_POINTER:C301($3; $4; $numerator; $denominator)
C_LONGINT:C283($INCH_PER_FT; $SQIN_P_SQFT; $QTS_PER_GAL; $KILO; $LEAF_UNIT; $ONE)
C_REAL:C285($0; $LBS_PER_GAL; $width; $length)

$0:=0  //num/denom

If (Count parameters:C259>=4)
	$from:=$1
	$to:=$2
	$numerator:=$3
	$denominator:=$4
	$INCH_PER_FT:=12
	$SQIN_P_SQFT:=144
	$LBS_PER_GAL:=8.64
	$QTS_PER_GAL:=4
	$KILO:=1000
	$LEAF_UNIT:=200
	$ONE:=1
	$KILO_PER_LBS:=0.454
	$LBS_PER_KILO:=2.2026
	
	If (Count parameters:C259=6)  //passing in width/length
		$Length:=$5
		$Width:=$6
	Else 
		$Length:=[Purchase_Orders_Items:12]Flex3:33
		$Width:=[Purchase_Orders_Items:12]Flex2:32
	End if 
	
	$failed:=False:C215
	
	Case of 
		: ($From=$To)  //converting to the same units
			$numerator->:=$ONE
			$denominator->:=$ONE
		: ($From="LF")
			Case of 
				: ($To="ROLL")  //length of roll is in feet
					$numerator->:=$ONE
					$denominator->:=$length
				: ($To="SqFt")  //width is in inches
					$numerator->:=$width
					$denominator->:=$INCH_PER_FT
				: ($To="MSF")
					$numerator->:=$width
					$denominator->:=$KILO*$INCH_PER_FT
				: ($To="SqIn")
					$numerator->:=$INCH_PER_FT*$width
					$denominator->:=$ONE
				: ($To="MSI")
					$numerator->:=$INCH_PER_FT*$width
					$denominator->:=$KILO
				: ($To="LI")
					$numerator->:=$INCH_PER_FT
					$denominator->:=$ONE
				: ($To="Sht")
					$numerator->:=$ONE
					$denominator->:=($length/$INCH_PER_FT)
				Else 
					$failed:=True:C214
			End case 
		: ($From="Roll")
			Case of 
				: ($To="LF")
					$numerator->:=$length
					$denominator->:=$ONE
				: ($To="SqFt")
					$numerator->:=$length*($width/$INCH_PER_FT)
					$denominator->:=$ONE
				: ($To="MSF")
					$numerator->:=$length*($width/$INCH_PER_FT)
					$denominator->:=$KILO
				: ($To="SqIn")
					$numerator->:=($length*$INCH_PER_FT)*$width
					$denominator->:=$ONE
				: ($To="MSI")
					$numerator->:=($length*$INCH_PER_FT)*$width
					$denominator->:=$KILO
				: ($To="LI")
					$numerator->:=$length*$INCH_PER_FT
					$denominator->:=$ONE
				: ($To="Unit")  //$ONE unit = $ONE" x $LEAF_UNIT' LEAF only
					$numerator->:=($length/$LEAF_UNIT)*$width
					$denominator->:=$ONE
				Else 
					$failed:=True:C214
			End case 
			
		: ($From="SqIn")
			Case of 
				: ($To="LF")
					$numerator->:=$ONE
					$denominator->:=$width*$INCH_PER_FT
				: ($To="SqFt")
					$numerator->:=$ONE
					$denominator->:=$SQIN_P_SQFT
				: ($To="MSF")
					$numerator->:=$ONE
					$denominator->:=$SQIN_P_SQFT*$KILO
				: ($To="MSI")
					$numerator->:=$ONE
					$denominator->:=$KILO
				: ($To="LI")
					$numerator->:=$ONE
					$denominator->:=$width
				: ($To="Roll")
					$numerator->:=$ONE
					$denominator->:=($width*$INCH_PER_FT)*$length
				: ($To="Sht")
					$numerator->:=$ONE
					$denominator->:=$width*$length
				Else 
					$failed:=True:C214
			End case 
			
		: ($From="MSI")
			Case of 
				: ($To="LF")
					$numerator->:=$KILO
					$denominator->:=$INCH_PER_FT*$width
				: ($To="SqFt")
					$numerator->:=$KILO
					$denominator->:=$SQIN_P_SQFT
				: ($To="MSF")
					$numerator->:=$ONE
					$denominator->:=$SQIN_P_SQFT
				: ($To="LI")
					$numerator->:=$KILO
					$denominator->:=$width
				: ($To="Roll")
					$numerator->:=$KILO
					$denominator->:=($width*$INCH_PER_FT)*$length
				: ($To="Sht")
					$numerator->:=$KILO
					$denominator->:=$length*$width
				Else 
					$failed:=True:C214
			End case 
			
		: ($From="SqFt")
			Case of 
				: ($To="LF")  //$width is in inches
					$numerator->:=$ONE
					$denominator->:=($width/$INCH_PER_FT)
				: ($To="SqIn")
					$numerator->:=$SQIN_P_SQFT
					$denominator->:=$ONE
				: ($To="MSF")
					$numerator->:=$ONE
					$denominator->:=$KILO
				: ($To="MSI")
					$numerator->:=$SQIN_P_SQFT
					$denominator->:=$KILO
				: ($To="LI")
					$numerator->:=$SQIN_P_SQFT
					$denominator->:=$width
				: ($To="Roll")  //length is given in fett, width is in inches
					$numerator->:=$ONE
					$denominator->:=($width/$INCH_PER_FT)*$length
				: ($To="Sht")
					$numerator->:=$ONE
					$denominator->:=($width/$INCH_PER_FT)*($length/$INCH_PER_FT)
				Else 
					$failed:=True:C214
			End case 
			
		: ($From="MSF")
			Case of 
				: ($To="LF")
					$numerator->:=$KILO
					$denominator->:=$width/$INCH_PER_FT
				: ($To="SqIn")
					$numerator->:=$KILO*$SQIN_P_SQFT
					$denominator->:=$ONE
				: ($To="MSI")
					$numerator->:=$SQIN_P_SQFT
					$denominator->:=$ONE
				: ($To="LI")
					$numerator->:=$KILO*$SQIN_P_SQFT
					$denominator->:=$width
				: ($To="Roll")
					$numerator->:=$KILO
					$denominator->:=($width/$INCH_PER_FT)*$length
				: ($To="Sht")
					$numerator->:=$KILO
					$denominator->:=($width/$INCH_PER_FT)*($length/$INCH_PER_FT)
				Else 
					$failed:=True:C214
			End case 
			
		: ($From="LI")
			Case of 
				: ($To="LF")
					$numerator->:=$ONE
					$denominator->:=$INCH_PER_FT
				: ($To="SqIn")
					$numerator->:=$width
					$denominator->:=$ONE
				: ($To="SqFt")
					$numerator->:=$width
					$denominator->:=$SQIN_P_SQFT
				: ($To="MSF")
					$numerator->:=$width
					$denominator->:=$KILO*$SQIN_P_SQFT
				: ($To="MSI")
					$numerator->:=$width
					$denominator->:=$KILO
				: ($To="Roll")
					$numerator->:=$ONE
					$denominator->:=$INCH_PER_FT*$length
				: ($To="Sht")
					$numerator->:=$ONE
					$denominator->:=$length
				Else 
					$failed:=True:C214
			End case 
			
		: ($From="Sht")
			Case of 
				: ($To="LF")
					$numerator->:=$length/$INCH_PER_FT
					$denominator->:=$ONE
				: ($To="SqIn")
					$numerator->:=$width*$length
					$denominator->:=$ONE
				: ($To="SqFt")
					$numerator->:=$width*$length
					$denominator->:=$SQIN_P_SQFT
				: ($To="MSF")
					$numerator->:=$width*$length
					$denominator->:=$KILO*$SQIN_P_SQFT
				: ($To="MSI")
					$numerator->:=$width*$length
					$denominator->:=$KILO
				: ($To="LI")
					$numerator->:=$length
					$denominator->:=$ONE
				Else 
					$failed:=True:C214
			End case 
			
		: ($From="GL")
			Case of 
				: ($To="LB")
					$numerator->:=$LBS_PER_GAL
					$denominator->:=$ONE
				: ($To="Qt")
					$numerator->:=$QTS_PER_GAL
					$denominator->:=$ONE
				Else 
					$failed:=True:C214
			End case 
			
		: ($From="Qt")
			Case of 
				: ($To="LB")
					$numerator->:=$LBS_PER_GAL
					$denominator->:=$QTS_PER_GAL
				: ($To="Gl")
					$numerator->:=$ONE
					$denominator->:=$QTS_PER_GAL
				Else 
					$failed:=True:C214
			End case 
			
		: ($From="Lb")
			Case of 
				: ($To="Gl")
					$numerator->:=$ONE
					$denominator->:=$LBS_PER_GAL
				: ($To="Qt")
					$numerator->:=$QTS_PER_GAL
					$denominator->:=$LBS_PER_GAL
				: ($To="Kilo")
					$numerator->:=$KILO_PER_LBS  //•••••••••••••
					$denominator->:=$ONE
				Else 
					$failed:=True:C214
			End case 
			
		: ($From="kilo")
			Case of 
				: ($To="Lb")
					$numerator->:=$LBS_PER_KILO  //•••••••••••••
					$denominator->:=$ONE
				Else 
					$failed:=True:C214
			End case 
			
		: ($From="Unit")  //• $ONE2/22/97 cs $ONE unit = $ONE" x $LEAF_UNIT' LEAF only
			Case of 
				: ($To="LF")  //# units *$LEAF_UNIT'
					$numerator->:=$LEAF_UNIT
					$denominator->:=$ONE
				: ($To="MSF")  //• $ONE2/22/97 cs #units x ($LEAF_UNIT'(LF) x (Width in Ft))/$KILO
					$numerator->:=$LEAF_UNIT*($width/$INCH_PER_FT)
					$denominator->:=$KILO
				: ($To="LI")  //# units *$LEAF_UNIT' * #inches/foot
					$numerator->:=$LEAF_UNIT*$INCH_PER_FT
					$denominator->:=$ONE
				: ($To="MSI")  //• $ONE2/22/97 cs #units x ($LEAF_UNIT' x Inchesperfoot (Li) x (Width in inches))
					$numerator->:=$LEAF_UNIT*$INCH_PER_FT*$width
					$denominator->:=$KILO
				: ($To="SqIn")  //• $ONE2/22/97 cs #units x ($LEAF_UNIT' x Inchesperfoot (Li) x (Width in inches))
					$numerator->:=$LEAF_UNIT*$INCH_PER_FT*$width
					$denominator->:=$ONE
				: ($To="SqFt")  //• $ONE2/22/97 cs #units x ($LEAF_UNIT'(LF) x (Width in Ft))
					$numerator->:=$LEAF_UNIT*($width/$INCH_PER_FT)
					$denominator->:=$ONE
				: ($To="Roll")  //• $ONE2/22/97 cs #units/(width(roll)*Length(roll)/$LEAF_UNIT)
					$numerator->:=$ONE
					$denominator->:=$width*($length/$LEAF_UNIT)
				Else 
					$failed:=True:C214
			End case 
			
		Else 
			$failed:=True:C214
	End case 
	
	If (Not:C34($failed))
		$0:=$numerator->/$denominator->
	End if 
End if 