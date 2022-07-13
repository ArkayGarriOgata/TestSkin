//%attributes = {"publishedWeb":true}
//PM: JML_PresScheduleSettings() -> 
//@author mlb - 1/10/02  10:35

Case of 
	: ($1="reset")
		i:=24
		rReal1:=100
		cb1:=1
		cb2:=1
		
	: ($1="Set")
		READ WRITE:C146([Cost_Centers:27])
		If ($2#"All")
			QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=$2)
			//QUERY([COST_CENTER]; & ;[COST_CENTER]ProdCC=True)
			
			$settings:=[Cost_Centers:27]ScheduleSettings:63
			[Cost_Centers:27]ScheduleSettings:63:=String:C10(i)+"•"
			If (cb1=1)
				[Cost_Centers:27]ScheduleSettings:63:=[Cost_Centers:27]ScheduleSettings:63+"Sat"+"•"
			Else 
				[Cost_Centers:27]ScheduleSettings:63:=[Cost_Centers:27]ScheduleSettings:63+"   "+"•"
			End if 
			If (cb2=1)
				[Cost_Centers:27]ScheduleSettings:63:=[Cost_Centers:27]ScheduleSettings:63+"Sun"+"•"
			Else 
				[Cost_Centers:27]ScheduleSettings:63:=[Cost_Centers:27]ScheduleSettings:63+"   "+"•"
			End if 
			[Cost_Centers:27]ScheduleSettings:63:=[Cost_Centers:27]ScheduleSettings:63+String:C10(rReal1)+"•"+TS2String(TSTimeStamp)
			
			SAVE RECORD:C53([Cost_Centers:27])
			$0:=[zz_control:1]PressScheduleSetup:52
			
		Else 
			REDUCE SELECTION:C351([Cost_Centers:27]; 0)
			$0:=""
		End if 
		
	: ($1="Get")
		READ ONLY:C145([Cost_Centers:27])
		If ($2#"All")
			QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=$2)  //;*)
			
			$settings:=[Cost_Centers:27]ScheduleSettings:63
		Else 
			REDUCE SELECTION:C351([Cost_Centers:27]; 0)
			$settings:=""
		End if 
		
		$0:=$settings
		//REDUCE SELECTION([COST_CENTER];0)
		
		$delim:=Position:C15("•"; $settings)
		If ($delim>0)
			i:=Num:C11(Substring:C12($settings; 1; $delim-1))
			$settings:=Substring:C12($settings; $delim+1)
			$delim:=Position:C15("•"; $settings)
			cb1:=Num:C11(Substring:C12($settings; 1; $delim-1)="Sat")
			$settings:=Substring:C12($settings; $delim+1)
			$delim:=Position:C15("•"; $settings)
			cb2:=Num:C11(Substring:C12($settings; 1; $delim-1)="Sun")
			$settings:=Substring:C12($settings; $delim+1)
			$delim:=Position:C15("•"; $settings)
			rReal1:=Num:C11(Substring:C12($settings; 1; $delim-1))
		Else 
			PS_Settings("reset")
		End if 
End case 