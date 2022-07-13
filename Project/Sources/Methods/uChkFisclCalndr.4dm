//%attributes = {"publishedWeb":true}
//(p)uChkFisclCalndr
//check wether it is nessesary to create fiscal calendar records
//if it is needed create.
//• 4/3/98 cs created
//•4/26/99  mlb  put on server startup
//•5/01/00  mlb  replace ◊array with $array since wasn't inited
READ ONLY:C145([zz_control:1])
ALL RECORDS:C47([zz_control:1])
C_DATE:C307($today)
$today:=4D_Current_date
//$today:=!04/05/00!
If ([zz_control:1]FiscalYearStart:34=Month of:C24($today)) & (Day of:C23($today)<=10)
	QUERY:C277([x_fiscal_calendars:63]; [x_fiscal_calendars:63]StartDate:2>=$today)
	
	If (Records in selection:C76([x_fiscal_calendars:63])=0)  //no fiscal calendar yet created
		$Start:=Year of:C25($today)+1
		$Month:=[zz_control:1]FiscalYearStart:34
		MESSAGE:C88("just a moment - updating fiscal calendar."+Char:C90(13))
		
		//see (P) uInitMonths
		ARRAY LONGINT:C221($aDayInMth; 12)  //•4/03/00  mlb wasn't inited in server method
		$aDayInMth{4}:=30
		$aDayInMth{5}:=31
		$aDayInMth{6}:=30
		$aDayInMth{7}:=31
		$aDayInMth{8}:=31
		$aDayInMth{9}:=30
		$aDayInMth{10}:=31
		$aDayInMth{11}:=30
		$aDayInMth{12}:=31
		$aDayInMth{1}:=31
		$aDayInMth{2}:=28
		$aDayInMth{3}:=31
		
		For ($i; 1; 12)
			CREATE RECORD:C68([x_fiscal_calendars:63])
			
			If ($i>3)  //april -> dec
				[x_fiscal_calendars:63]Period:1:=String:C10($Start)+String:C10($i-3; "00")  //fiscal year + month of Fiscal year
				[x_fiscal_calendars:63]StartDate:2:=Date:C102(String:C10($i)+"/01/"+String:C10($Start-1))  //real year start date
			Else   //jan,feb,march        
				[x_fiscal_calendars:63]Period:1:=String:C10($Start)+String:C10($i+9; "00")  //fiscal year + month of Fiscal year
				[x_fiscal_calendars:63]StartDate:2:=Date:C102(String:C10($i)+"/01/"+String:C10($Start))  //next real year start date
			End if 
			
			If (Month of:C24([x_fiscal_calendars:63]StartDate:2)=2)
				$Days:=27+(1*(Num:C11(Year of:C25([x_fiscal_calendars:63]StartDate:2)%4=0)))
				[x_fiscal_calendars:63]EndDate:3:=[x_fiscal_calendars:63]StartDate:2+$Days
			Else 
				[x_fiscal_calendars:63]EndDate:3:=[x_fiscal_calendars:63]StartDate:2+$aDayInMth{Month of:C24([x_fiscal_calendars:63]StartDate:2)}-1
			End if 
			
			[x_fiscal_calendars:63]Year_Month:4:=Substring:C12(String:C10(Year of:C25([x_fiscal_calendars:63]StartDate:2)); 3; 2)+String:C10(Month of:C24([x_fiscal_calendars:63]StartDate:2); "00")
			[x_fiscal_calendars:63]ModDate:5:=$today
			[x_fiscal_calendars:63]ModWho:6:="syst"
			SAVE RECORD:C53([x_fiscal_calendars:63])
			
		End for 
		
	End if 
End if 
uClearSelection(->[x_fiscal_calendars:63])
uClearSelection(->[zz_control:1])
//