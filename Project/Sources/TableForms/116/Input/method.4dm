//FM: Input() -> 
//@author mlb - 2/22/02  11:23

Case of 
	: (Form event code:C388=On Load:K2:1)
		C_TEXT:C284(xTitle; tText; xText; sWeekDays; $week)
		xTitle:=<>ayMonth{[ProductionSchedules_Shop_Cal:116]psMonth:1}+" "
		xText:=""
		tText:=""
		sWeekDays:=""
		C_DATE:C307($theFirst)
		If (Month of:C24(4D_Current_date)<=[ProductionSchedules_Shop_Cal:116]psMonth:1)  //same year
			$theFirst:=Date:C102(String:C10([ProductionSchedules_Shop_Cal:116]psMonth:1)+"/1/"+String:C10(Year of:C25(4D_Current_date)))
			xTitle:=xTitle+String:C10(Year of:C25(4D_Current_date))
		Else   //next year
			$theFirst:=Date:C102(String:C10([ProductionSchedules_Shop_Cal:116]psMonth:1)+"/1/"+String:C10(Year of:C25(4D_Current_date)+1))
			xTitle:=xTitle+String:C10(Year of:C25(4D_Current_date)+1)
		End if 
		$startOn:=Day number:C114($theFirst)
		Case of 
			: ($startOn=1)
				$week:="SMTWRFS"
			: ($startOn=2)
				$week:="MTWRFSS"
			: ($startOn=3)
				$week:="TWRFSSM"
			: ($startOn=4)
				$week:="WRFSSMT"
			: ($startOn=5)
				$week:="RFSSMTW"
			: ($startOn=6)
				$week:="FSSMTWR"
			: ($startOn=7)
				$week:="SSMTWRF"
		End case 
		$week:=$week*6
		
		For ($day; 1; <>aDaysInMth{[ProductionSchedules_Shop_Cal:116]psMonth:1})
			If (Substring:C12(String:C10($day; "00"); 1; 1)#"0")
				tText:=tText+Substring:C12(String:C10($day; "00"); 1; 1)
			Else 
				tText:=tText+" "
			End if 
			xText:=xText+Substring:C12(String:C10($day; "00"); 2; 1)
			sWeekDays:=sWeekDays+$week[[$day]]
		End for 
		
End case 