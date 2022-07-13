//%attributes = {}
//Method: Core_DateValidB(sDate{;nFormat};{dBeginDate;dEndDate})=>True
//  If its a valid date
//Description:  This function checks if a given date entered is valid or not.
//  mm/dd/yyyy to m/d/yy are all handled

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tDate)
	C_LONGINT:C283($2; $nFormat)
	C_DATE:C307($3; $4; $dBeginDate; $dEndDate)
	C_BOOLEAN:C305($0; $bValidDate; $bDateRange)
	
	C_TEXT:C284($tSeperator)
	C_BOOLEAN:C305($bDateRange)
	C_LONGINT:C283($nCountParam; $nPositionFirst; $nPositionSecond; $nYear; $nMonth; $nDay; $nNextMonth; $nLastDay)
	C_DATE:C307($dDate)
	
	$tDate:=$1
	$nCountParam:=Count parameters:C259
	$bDateRange:=False:C215
	
	$nFormat:=1  //Default format to 1
	$tSeperator:="/"
	
	Case of 
			
		: ($nCountParam=2)
			$nFormat:=$2
			
		: ($nCountParam=4)
			$dBeginDate:=$3
			$dEndDate:=$4
	End case 
	
	Case of 
		: ($nFormat=1)  //mm/dd/yyyy to m/d/yy American
		: ($nFormat=2)  //dd/mm/yyyy Europe
		: ($nFormat=3)  //yyyy/mm/dd  Japan
		: ($nFormat=4)  //mm/dd    
			$tDate:=$tDate+"/1996"  //No year is specified so use a year that includes a leap year
	End case 
	
	If (Position:C15("/"; $tDate)=0)  //The date format is mmddyyyy
		If (Length:C16($tDate)=6)  //mmddyy
			$tDate:=String:C10(Num:C11($tDate); "##/##/##")
		Else   //mmddyyyy
			$tDate:=String:C10(Num:C11($tDate); "##/##/####")
		End if   //done checking what type of format it is.
	End if   //Done mmddyyyy check
	
	$nPositionFirst:=Position:C15($tSeperator; $tDate)
	$nPositionSecond:=Position:C15($tSeperator; Substring:C12($tDate; $nPositionFirst+1))
	
	$nYear:=Num:C11(Substring:C12($tDate; $nPositionFirst+$nPositionSecond+1))  //find the year
	
	$nMonth:=Num:C11(Substring:C12($tDate; 1; $nPositionFirst-1))  //find the month
	$nDay:=Num:C11(Substring:C12($tDate; $nPositionFirst+1; $nPositionSecond-1))  //find the day
	
	$bValidDate:=False:C215  //Assume that the date will not be valid
	
End if   //Done Initialize

Case of   //Check if the (month, year and date) are valid
		
	: (Length:C16(String:C10($nYear))>4)  //year is not ok
		
	: (($nMonth<1) | ($nMonth>12))  //Month is not ok
		
	: (($nDay<1) & ($nDay>31))  //Day is not ok    
		
	Else   //The individual values are ok.
		//Make sure we have a valid day for the month
		
		$nNextMonth:=$nMonth+1  //Get the next month
		
		If ($nNextMonth=13)  //If its December 
			$nLastDay:=31  //then the last day of the month is 31
		Else   //Find the last day of the month  
			$dDate:=Date:C102(String:C10($nNextMonth)+"/1/"+String:C10($nYear))-1  //Subtract one from the first day of the next month
			$nLastDay:=Day of:C23($dDate)  //get the  last day of this month
		End if 
		
		If (($nLastDay>=$nDay))  //make sure we have a valid last day
			$bValidDate:=True:C214
		End if   //Done making sure the last day is valid
		
End case   //Done checking if we have a valid date

If ($bDateRange & $bValidDate)  //If theres a date range and we have a valid date
	$dDate:=Date:C102(String:C10($nMonth)+"/"+String:C10($nDay)+"/"+String:C10($nYear))
	If (($dBeginDate>$dDate) | ($dEndDate<$dDate))  //Check this date with our date range
		$bValidDate:=False:C215  //Its an invalid date
	End if   //Done checking if its still valid
End if   //Done cheking if theres a date range.

$0:=$bValidDate