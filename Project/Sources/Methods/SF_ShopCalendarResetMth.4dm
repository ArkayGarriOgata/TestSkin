//%attributes = {"publishedWeb":true}
//PM: SF_ShopCalendarResetMth() -> 
//@author mlb - 11/19/02  12:00

C_TEXT:C284($theYear)
C_LONGINT:C283($1; $day; $month; $weekDay)

SF_ShopHolidays

READ WRITE:C146([ProductionSchedules_Shop_Cal:116])
QUERY:C277([ProductionSchedules_Shop_Cal:116]; [ProductionSchedules_Shop_Cal:116]psMonth:1=$1)
While (Not:C34(End selection:C36([ProductionSchedules_Shop_Cal:116])))
	[ProductionSchedules_Shop_Cal:116]Shifts:2:="-"*31
	
	If (Month of:C24(4D_Current_date)<=[ProductionSchedules_Shop_Cal:116]psMonth:1)  //same year
		$theYear:="/"+String:C10(Year of:C25(4D_Current_date))
	Else   //next year
		$theYear:="/"+String:C10(Year of:C25(4D_Current_date)+1)
	End if 
	
	For ($day; 1; <>aDaysInMth{[ProductionSchedules_Shop_Cal:116]psMonth:1})
		$date:=Date:C102(String:C10([ProductionSchedules_Shop_Cal:116]psMonth:1)+"/"+String:C10($day)+$theYear)
		$weekDay:=Day number:C114($date)
		Case of 
			: (SF_ShopHolidays($date)#$date)  //holiday
				[ProductionSchedules_Shop_Cal:116]Shifts:2[[$day]]:="0"
			: ($weekDay=1)
				[ProductionSchedules_Shop_Cal:116]Shifts:2[[$day]]:="0"
			: ($weekDay=7)
				[ProductionSchedules_Shop_Cal:116]Shifts:2[[$day]]:="1"
			: ($weekDay=2)
				[ProductionSchedules_Shop_Cal:116]Shifts:2[[$day]]:="2"
			Else 
				[ProductionSchedules_Shop_Cal:116]Shifts:2[[$day]]:="3"
		End case 
	End for 
	SAVE RECORD:C53([ProductionSchedules_Shop_Cal:116])
	NEXT RECORD:C51([ProductionSchedules_Shop_Cal:116])
End while 