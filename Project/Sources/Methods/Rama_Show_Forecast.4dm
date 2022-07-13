//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 05/11/12, 09:48:13
// ----------------------------------------------------
// Method: Rama_Show_Forecast
// ----------------------------------------------------

C_TEXT:C284($1)
C_LONGINT:C283(<>pid_RamaSF; $rel; $numRel; $arrayCursor; $hit; $winRef)
C_TEXT:C284(fcst_period1; fcst_period2; fcst_period3; fcst_period4; fcst_period5; fcst_period6)

If (Count parameters:C259=0)
	If (<>pid_RamaSF=0)
		app_Log_Usage("log"; "RAMA"; "Rama_Show_Forecast")
		<>pid_RamaSF:=New process:C317("Rama_Show_Forecast"; <>lMinMemPart; "Rama Delivery Schedule"; "init")
		
	Else 
		SHOW PROCESS:C325(<>pid_RamaSF)
		BRING TO FRONT:C326(<>pid_RamaSF)
	End if 
	
Else 
	If (Rama_Find_CPNs("forecast")>0)
		$winRef:=Open form window:C675([Customers_ReleaseSchedules:46]; "SimpleForecast"; Plain form window:K39:10)
		SET WINDOW TITLE:C213("Rama/Cayey Forecast"; $winRef)
		MESSAGE:C88("Please Wait, Loading Forecast...")
		
		ARRAY TEXT:C222($aCPN; 0)
		ARRAY DATE:C224($aDateSched; 0)
		ARRAY LONGINT:C221($aQtySched; 0)
		ARRAY TEXT:C222(aCPN; 0)
		ARRAY LONGINT:C221(aQtyOnHand; 0)
		ARRAY LONGINT:C221(aQtyWIP; 0)
		ARRAY LONGINT:C221(aPeriod0; 0)
		ARRAY LONGINT:C221(aPeriod1; 0)
		ARRAY LONGINT:C221(aPeriod2; 0)
		ARRAY LONGINT:C221(aPeriod3; 0)
		ARRAY LONGINT:C221(aPeriod4; 0)
		ARRAY LONGINT:C221(aPeriod5; 0)
		ARRAY LONGINT:C221(aPeriod6; 0)
		
		SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]ProductCode:11; $aCPN; [Customers_ReleaseSchedules:46]Sched_Date:5; $aDateSched; [Customers_ReleaseSchedules:46]Sched_Qty:6; $aQtySched)
		$numRel:=Size of array:C274($aCPN)
		SORT ARRAY:C229($aCPN; $aDateSched; $aQtySched; >)
		$arrayCursor:=0
		MESSAGE:C88("  loading inventory...")
		Rama_Find_CPNs("query"; ->[Finished_Goods_Locations:35]ProductCode:1)
		CREATE SET:C116([Finished_Goods_Locations:35]; "inventory")
		fcst_period1:=fYYYYMM(4D_Current_date; "*")
		fcst_period2:=fYYYYMM(Add to date:C393(4D_Current_date; 0; 1; 0); "*")
		fcst_period3:=fYYYYMM(Add to date:C393(4D_Current_date; 0; 2; 0); "*")
		fcst_period4:=fYYYYMM(Add to date:C393(4D_Current_date; 0; 3; 0); "*")
		fcst_period5:=fYYYYMM(Add to date:C393(4D_Current_date; 0; 4; 0); "*")
		fcst_period6:=fYYYYMM(Add to date:C393(4D_Current_date; 0; 5; 0); "*")
		uThermoInit($numRel; "Preparing cross-tab layout...")
		For ($rel; 1; $numRel)
			$hit:=Find in array:C230(aCPN; $aCPN{$rel})
			If ($hit=-1)
				APPEND TO ARRAY:C911(aCPN; $aCPN{$rel})
				$arrayCursor:=$arrayCursor+1
				$hit:=$arrayCursor
				USE SET:C118("inventory")
				// ******* Verified  - 4D PS - January  2019 ********
				
				QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=aCPN{$hit})
				
				
				// ******* Verified  - 4D PS - January 2019 (end) *********
				$oh:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
				APPEND TO ARRAY:C911(aQtyOnHand; $oh)
				$wip:=JMI_getPlannedQty(aCPN{$hit})
				APPEND TO ARRAY:C911(aQtyWIP; $wip)
				APPEND TO ARRAY:C911(aPeriod0; 0)
				APPEND TO ARRAY:C911(aPeriod1; 0)
				APPEND TO ARRAY:C911(aPeriod2; 0)
				APPEND TO ARRAY:C911(aPeriod3; 0)
				APPEND TO ARRAY:C911(aPeriod4; 0)
				APPEND TO ARRAY:C911(aPeriod5; 0)
				APPEND TO ARRAY:C911(aPeriod6; 0)
				
			End if 
			
			$period:=fYYYYMM($aDateSched{$rel}; "*")
			
			Case of 
				: ($period<fcst_period1)
					aPeriod0{$hit}:=aPeriod0{$hit}+$aQtySched{$rel}
					
				: ($period=fcst_period1)
					aPeriod1{$hit}:=aPeriod1{$hit}+$aQtySched{$rel}
					
				: ($period=fcst_period2)
					aPeriod2{$hit}:=aPeriod2{$hit}+$aQtySched{$rel}
					
				: ($period=fcst_period3)
					aPeriod3{$hit}:=aPeriod3{$hit}+$aQtySched{$rel}
					
				: ($period=fcst_period4)
					aPeriod4{$hit}:=aPeriod4{$hit}+$aQtySched{$rel}
					
				: ($period=fcst_period5)
					aPeriod5{$hit}:=aPeriod5{$hit}+$aQtySched{$rel}
					
				: ($period=fcst_period6)
					aPeriod6{$hit}:=aPeriod6{$hit}+$aQtySched{$rel}
					
			End case 
			
			uThermoUpdate($rel)
		End for 
		uThermoClose
		
		CLEAR SET:C117("inventory")
		
		FORM SET INPUT:C55([Customers_ReleaseSchedules:46]; "SimpleForecast")
		ADD RECORD:C56([Customers_ReleaseSchedules:46]; *)
		CLOSE WINDOW:C154($winRef)
		FORM SET INPUT:C55([Customers_ReleaseSchedules:46]; "Input")
		
	Else 
		uConfirm("No forecasts found."; "OK"; "Help")
	End if 
	
	<>pid_RamaSF:=0
End if 