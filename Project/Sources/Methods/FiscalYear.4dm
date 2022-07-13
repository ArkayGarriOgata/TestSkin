//%attributes = {"publishedWeb":true}
//PM:  FiscalYear(msg;date of interest)  9/17/99  MLB
//return facts about fiscal year
// Modified by Mel Bohince on 12/5/06 setup for a fiscal=calendar yr 
C_DATE:C307($2; $date)
$date:=$2
C_TEXT:C284($1; $0)
C_LONGINT:C283($month; $FISCAL_START_MTH)
If (Current date:C33>=!2007-01-01!)
	If (<>YearStart#1)
		<>YearStart:=1
		READ WRITE:C146([zz_control:1])
		ALL RECORDS:C47([zz_control:1])
		[zz_control:1]FiscalYearStart:34:=<>YearStart
		SAVE RECORD:C53([zz_control:1])
		REDUCE SELECTION:C351([zz_control:1]; 0)
	End if 
End if 
$FISCAL_START_MTH:=<>YearStart

Case of 
	: (Current date:C33<!2007-01-01!)
		Case of 
			: ($1="start")
				If (Month of:C24($date)<$FISCAL_START_MTH)
					$0:=String:C10($FISCAL_START_MTH)+"/1/"+String:C10(Year of:C25($date)-1)
				Else 
					$0:=String:C10($FISCAL_START_MTH)+"/1/"+String:C10(Year of:C25($date))
				End if 
				
			: ($1="month")
				$0:=String:C10($FISCAL_START_MTH)
				
			: ($1="quarter")  //determine which quarter it falls in ex Oct -> (10-4)/3 = 2 + 1 rem  == 3rd q
				$month:=Month of:C24($date)
				If ($month<$FISCAL_START_MTH)  //current month (Jan->Mar)less than start of fiscal calendar, last quarter of prev
					$0:=String:C10($FISCAL_START_MTH)
				Else 
					$0:=String:C10(Int:C8($month/3)+(1*(Num:C11($month%3#0)))-1)  //+ 1 if the month is not a quarter end
				End if 
				
			: ($1="period")
				READ ONLY:C145([x_fiscal_calendars:63])
				QUERY:C277([x_fiscal_calendars:63]; [x_fiscal_calendars:63]StartDate:2<=$2; *)
				QUERY:C277([x_fiscal_calendars:63];  & ; [x_fiscal_calendars:63]EndDate:3>=$2)
				$0:=[x_fiscal_calendars:63]Period:1
				REDUCE SELECTION:C351([x_fiscal_calendars:63]; 0)
				
			: ($1="periodNumber")
				READ ONLY:C145([x_fiscal_calendars:63])
				QUERY:C277([x_fiscal_calendars:63]; [x_fiscal_calendars:63]StartDate:2<=$2; *)
				QUERY:C277([x_fiscal_calendars:63];  & ; [x_fiscal_calendars:63]EndDate:3>=$2)
				$0:=Substring:C12([x_fiscal_calendars:63]Period:1; 5; 2)
				REDUCE SELECTION:C351([x_fiscal_calendars:63]; 0)
				
			: ($1="year")
				If (Month of:C24($date)<$FISCAL_START_MTH)
					$0:=String:C10(Year of:C25($date))
				Else 
					$0:=String:C10(Year of:C25($date)+1)
				End if 
				
			: ($1="make-new-year")
				uChkFisclCalndr
		End case 
		
	: ($1="start")
		$0:=String:C10($FISCAL_START_MTH)+"/1/"+String:C10(Year of:C25($date))
		
	: ($1="month")
		$0:=String:C10($FISCAL_START_MTH)
		
		
	: ($1="quarter")
		$month:=Month of:C24($date)
		Case of 
			: ($month<4)
				$0:="1"
			: ($month<7)
				$0:="2"
			: ($month<10)
				$0:="3"
			: ($month>9)
				$0:="4"
		End case 
		
	: ($1="periodNumber")
		$0:=String:C10(Month of:C24($date))
		
	: ($1="year")
		$0:=String:C10(Year of:C25($date))
		
	: ($1="make-new-year")
		$today:=4D_Current_date
		If (Count parameters:C259>1)
			$fiscalYear:=Year of:C25($2)
		Else 
			$fiscalYear:=Year of:C25($today)+1
		End if 
		QUERY:C277([x_fiscal_calendars:63]; [x_fiscal_calendars:63]StartDate:2>=(Date:C102("01/01/"+String:C10($fiscalYear))))
		If (Records in selection:C76([x_fiscal_calendars:63])=0)
			For ($i; 1; 12)  //see uInitMonths
				CREATE RECORD:C68([x_fiscal_calendars:63])
				[x_fiscal_calendars:63]Period:1:=String:C10($fiscalYear)+String:C10($i; "00")  //fiscal year + month of Fiscal year
				
				[x_fiscal_calendars:63]StartDate:2:=Date:C102(String:C10($i)+"/01/"+String:C10($fiscalYear))
				
				If (Month of:C24([x_fiscal_calendars:63]StartDate:2)=2)  //check leap year
					$Days:=27+(1*(Num:C11(Year of:C25([x_fiscal_calendars:63]StartDate:2)%4=0)))
					[x_fiscal_calendars:63]EndDate:3:=[x_fiscal_calendars:63]StartDate:2+$Days
				Else 
					[x_fiscal_calendars:63]EndDate:3:=[x_fiscal_calendars:63]StartDate:2+<>aDaysInMth{Month of:C24([x_fiscal_calendars:63]StartDate:2)}-1
				End if 
				
				[x_fiscal_calendars:63]Year_Month:4:=Substring:C12(String:C10(Year of:C25([x_fiscal_calendars:63]StartDate:2)); 3; 2)+String:C10(Month of:C24([x_fiscal_calendars:63]StartDate:2); "00")
				[x_fiscal_calendars:63]ModDate:5:=$today
				[x_fiscal_calendars:63]ModWho:6:="aMs"
				SAVE RECORD:C53([x_fiscal_calendars:63])
			End for 
		End if 
		REDUCE SELECTION:C351([x_fiscal_calendars:63]; 0)
		
End case 

//