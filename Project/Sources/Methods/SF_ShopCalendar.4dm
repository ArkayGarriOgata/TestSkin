//%attributes = {"publishedWeb":true}
//PM: SF_ShopCalendar() -> 
//@author mlb - 02/22/02 

C_TEXT:C284($1; $2)
C_LONGINT:C283($3)
C_TEXT:C284($theYear)

$params:=Count parameters:C259
Case of 
	: ($1="recall")  //init
		ARRAY INTEGER:C220(aSFcalendar; 0; 0)
		ARRAY INTEGER:C220(aSFcalendar; 12; 31)
		ARRAY INTEGER:C220($aMonth; 0)
		ARRAY TEXT:C222($aDay; 0)
		READ ONLY:C145([ProductionSchedules_Shop_Cal:116])
		QUERY:C277([ProductionSchedules_Shop_Cal:116]; [ProductionSchedules_Shop_Cal:116]Dept:3=$2)
		SELECTION TO ARRAY:C260([ProductionSchedules_Shop_Cal:116]psMonth:1; $aMonth; [ProductionSchedules_Shop_Cal:116]Shifts:2; $aDay)
		REDUCE SELECTION:C351([ProductionSchedules_Shop_Cal:116]; 0)
		
		If (Size of array:C274($aMonth)>0)
			SORT ARRAY:C229($aMonth; $aDay; >)
			For ($month; 1; Size of array:C274($aMonth))
				//aSFcalendar{$month}:=$aMonth{$month}
				If (Length:C16($aDay{$month})<31)
					$aDay{$month}:=txt_Pad($aDay{$month}; "_"; 1; 31)
				End if 
				
				For ($day; 1; 31)
					aSFcalendar{$month}{$day}:=Num:C11($aDay{$month}[[$day]])
					$x:=aSFcalendar{$month}{$day}
				End for 
			End for 
			
		Else 
			BEEP:C151
			ALERT:C41("No shop calendar found for dept "+$2)
		End if 
		
	: ($1="store")
		READ WRITE:C146([ProductionSchedules_Shop_Cal:116])
		QUERY:C277([ProductionSchedules_Shop_Cal:116]; [ProductionSchedules_Shop_Cal:116]Dept:3=$2)
		For ($month; 1; Records in selection:C76([ProductionSchedules_Shop_Cal:116]))
			[ProductionSchedules_Shop_Cal:116]Shifts:2:=""
			For ($day; 1; 31)
				[ProductionSchedules_Shop_Cal:116]Shifts:2:=[ProductionSchedules_Shop_Cal:116]Shifts:2+String:C10(aSFcalendar{[ProductionSchedules_Shop_Cal:116]psMonth:1}{$day})
			End for 
			SAVE RECORD:C53([ProductionSchedules_Shop_Cal:116])
			NEXT RECORD:C51([ProductionSchedules_Shop_Cal:116])
		End for 
		REDUCE SELECTION:C351([ProductionSchedules_Shop_Cal:116]; 0)
		
	: ($1="month")
		READ WRITE:C146([ProductionSchedules_Shop_Cal:116])
		QUERY:C277([ProductionSchedules_Shop_Cal:116]; [ProductionSchedules_Shop_Cal:116]Dept:3=$2; *)
		QUERY:C277([ProductionSchedules_Shop_Cal:116];  & ; [ProductionSchedules_Shop_Cal:116]psMonth:1=$3)
		If (fLockNLoad(->[ProductionSchedules_Shop_Cal:116]))
			[ProductionSchedules_Shop_Cal:116]Shifts:2:="-"*31
			$theYear:=String:C10(Year of:C25(4D_Current_date))
			
			
			For ($day; 1; <>aDaysInMth{[ProductionSchedules_Shop_Cal:116]psMonth:1})
				$date:=Date:C102(String:C10($month)+"/"+String:C10($day)+$theYear)
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
		End if 
		REDUCE SELECTION:C351([ProductionSchedules_Shop_Cal:116]; 0)
		
	: ($1="init")
		SF_ShopHolidays
		
		READ WRITE:C146([ProductionSchedules_Shop_Cal:116])
		QUERY:C277([ProductionSchedules_Shop_Cal:116]; [ProductionSchedules_Shop_Cal:116]Dept:3=$2)
		DELETE SELECTION:C66([ProductionSchedules_Shop_Cal:116])
		For ($month; 1; 12)
			CREATE RECORD:C68([ProductionSchedules_Shop_Cal:116])
			[ProductionSchedules_Shop_Cal:116]psMonth:1:=$month
			
			[ProductionSchedules_Shop_Cal:116]Shifts:2:="-"*31
			[ProductionSchedules_Shop_Cal:116]Dept:3:=$2
			C_TEXT:C284($theYear)
			If (Month of:C24(4D_Current_date)<=[ProductionSchedules_Shop_Cal:116]psMonth:1)  //same year
				$theYear:="/"+String:C10(Year of:C25(4D_Current_date))
			Else   //next year
				$theYear:="/"+String:C10(Year of:C25(4D_Current_date)+1)
			End if 
			
			For ($day; 1; <>aDaysInMth{$month})
				$date:=Date:C102(String:C10($month)+"/"+String:C10($day)+$theYear)
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
		End for 
		REDUCE SELECTION:C351([ProductionSchedules_Shop_Cal:116]; 0)
		
End case 