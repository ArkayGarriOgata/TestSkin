//%attributes = {}
//Method: Core_Date_UsePhraseD(tPhrase;{dSeed})=dPhrase
//Descriptiion:  This method allows you to use a phrase and 
//     it will return the date that meets the phrase give {dSeed}.
//     If {dSeed} is not specified it uses Current date(*)

//   Phrases supported:

//  Begin Year - 01/01/YY
//  End Year - 12/31/YY

//  Begin Week - Sunday of week
//  End Week - Saturday of week

//  Begin Work - Monday of week
//  End Work - Friday of week

//  Begin Month - MM/01/YY
//  End Month - MM/##/YY where ## is the last day of the month for that year

//  (Y;M;D) -  will add Y, M, D to dSeed

If (True:C214)  //Initialze
	
	C_TEXT:C284($1; $tPhrase)
	C_DATE:C307($2; $dSeed)
	C_DATE:C307($0; $dPhrase)
	
	C_LONGINT:C283($nDay; $nDayNumber)
	C_LONGINT:C283($nMonth; $nYear)
	
	C_LONGINT:C283($nYears; $nMonths; $nDays)  //Used for (YY;MM;DD)
	
	ARRAY TEXT:C222($atAdd; 0)
	
	$tPhrase:=$1
	
	$dSeed:=Current date:C33(*)
	
	If (Count parameters:C259>=2)  //Parameters
		$dSeed:=$2
	End if   //Done parameters
	
	$dPhrase:=!00-00-00!
	
	$nYear:=Year of:C25($dSeed)  //YYYY
	$nMonth:=Month of:C24($dSeed)  //MM
	$nDay:=Day of:C23($dSeed)  //DD
	
	$nDayNumber:=Day number:C114($dSeed)  //1-7 where Sunday=1 Saturday=7
	
End if   //Done initialize

Case of   //Phrase
	: (Position:C15("Current"; $tPhrase)>0)
		
		$dPhrase:=Current date:C33(*)
		
	: (Position:C15("Year"; $tPhrase)>0)
		
		If (Position:C15("Begin"; $tPhrase)>0)  //Begin
			
			$dPhrase:=Date:C102("01/01/"+String:C10($nYear))
			
		Else   //End
			
			$dPhrase:=Date:C102("12/31/"+String:C10($nYear))
			
		End if   //Done begin
		
	: (Position:C15("Month"; $tPhrase)>0)
		
		If (Position:C15("Begin"; $tPhrase)>0)  //Begin
			
			$dPhrase:=Date:C102(String:C10($nMonth)+"/01/"+String:C10($nYear))
			
		Else   //End
			
			$nNextMonth:=Choose:C955(($nMonth=12); 12; $nMonth+1)
			
			$dFirstOfNextMonth:=Date:C102(String:C10($nNextMonth)+"/01/"+String:C10($nYear))
			
			$nDay:=Day of:C23(Add to date:C393($dFirstOfNextMonth; 0; 0; -1))
			
			$dPhrase:=Date:C102(String:C10($nMonth)+"/"+String:C10($nDay)+"/"+String:C10($nYear))
			
		End if   //Done begin
		
	: (Position:C15("Week"; $tPhrase)>0)
		
		If (Position:C15("Begin"; $tPhrase)>0)  //Begin
			
			$nAdd:=Choose:C955(\
				($nDayNumber=1); \
				0; \
				-($nDayNumber-1))
			
			$dPhrase:=Add to date:C393($dSeed; 0; 0; $nAdd)
			
		Else   //End
			
			$dPhrase:=Add to date:C393($dSeed; 0; 0; 7-$nDayNumber)
			
		End if   //Done begin
		
	: (Position:C15("Work"; $tPhrase)>0)
		
		If (Position:C15("Begin"; $tPhrase)>0)  //Begin
			
			$nAdd:=Choose:C955(\
				($nDayNumber=1); \
				1; \
				-($nDayNumber-($nDayNumber-2)))
			
			$dPhrase:=Add to date:C393($dSeed; 0; 0; $nAdd)
			
		Else   //End
			
			$nAdd:=Choose:C955(\
				($nDayNumber=7); \
				-1; \
				(6-$nDayNumber))
			
			$dPhrase:=Add to date:C393($dSeed; 0; 0; $nAdd)
			
		End if   //Done begin
		
	: (Position:C15(CorektRightParen; $tPhrase)>0)  //(YY;MM;DD)
		
		Core_Text_ParseToArray($tPhrase; ->$atAdd; CorektSemiColon)
		
		$nYears:=Num:C11($atAdd{1})
		$nMonths:=Num:C11($atAdd{2})
		$nDays:=Num:C11($atAdd{3})
		
		$dPhrase:=Add to date:C393($dSeed; $nYears; $nMonths; $nDays)
		
End case   //Done phrase

$0:=$dPhrase
