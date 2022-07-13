//%attributes = {"publishedWeb":true}
//PM: Rel_RevenueStream(msg;date;int;real) -> real
//@author mlb - 4/24/01  13:35

C_TEXT:C284($1)
C_DATE:C307($2; $date)
C_LONGINT:C283($3)
C_REAL:C285($4; $0; $return)

Case of 
	: ($1="init")
		ARRAY TEXT:C222(aPeriod; 0)
		ARRAY LONGINT:C221(aRel; 0)
		ARRAY REAL:C219(aRevPeriod; 0)
		ARRAY TEXT:C222(aPeriod; $3)
		ARRAY LONGINT:C221(aRel; $3)
		ARRAY REAL:C219(aRevPeriod; $3)
		C_DATE:C307($date)
		C_LONGINT:C283($i)
		$date:=Add to date:C393($2; 0; -1; 0)
		For ($i; 1; $3)
			$date:=Add to date:C393($date; 0; 1; 0)
			aPeriod{$i}:=fYYYYMM($date)
			aRel{$i}:=0
			aRevPeriod{$i}:=0
		End for 
		$return:=Size of array:C274(aPeriod)
		
	: ($1="set")
		$date:=$2
		If ($date>(Add to date:C393(4D_Current_date; 1; 0; 0)))
			$date:=Add to date:C393(4D_Current_date; 1; 0; 0)
		End if 
		If ($date<4D_Current_date)
			$date:=4D_Current_date
		End if 
		$period:=fYYYYMM($date)
		
		$i:=Find in array:C230(aPeriod; $period)
		If ($i>-1)
			aRel{$i}:=aRel{$i}+$3
			aRevPeriod{$i}:=aRevPeriod{$i}+$4
		End if 
		$return:=$i
		
	: ($1="npv")
		$return:=util_NPV((0.075/12); ->aRevPeriod)
		
	: ($1="qty")
		$return:=0
		For ($i; 1; Size of array:C274(aPeriod))
			$return:=$return+aRel{$i}
		End for 
		
	: ($1="rev")
		$return:=0
		For ($i; 1; Size of array:C274(aPeriod))
			$return:=$return+aRevPeriod{$i}
		End for 
		
	: ($1="count")
		$return:=Size of array:C274(aPeriod)
		
End case 

$0:=$return