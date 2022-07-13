//%attributes = {}
// Method: PS_menu_mgr () -> 
// --------------------------
// by: mel: 06/16/04, 16:54:38
// ---------------------------
// Modified by: Mel Bohince (6/3/21) use Storage cache

C_LONGINT:C283($i; $0)
C_TEXT:C284(<>psOUTSIDE_SERVICE_MENU)

$0:=0

Case of 
	: ($1="do")
		$MenuText:=Get menu item:C422($2\65536; $2%65536)
		$cc:=String:C10(PS_pid_mgr($MenuText))
		If (Length:C16($cc)=3)
			PS_PressScheduleUI($cc)
		End if 
		
	: ($1="init")
		If (True:C214)
			// Modified by: Mel Bohince (6/3/21) use Storage cache
			<>psOUTSIDE_SERVICE_MENU:=CostCtrBuildMenu("OUTSIDE SERVICE")
			
		Else   //old way
			READ ONLY:C145([Cost_Centers:27])
			QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]cc_Group:2="89.OUTSIDE SERVICE")
			SELECTION TO ARRAY:C260([Cost_Centers:27]ID:1; $aOSid; [Cost_Centers:27]Description:3; $aOSdesc)
			REDUCE SELECTION:C351([Cost_Centers:27]; 0)
			//If (Size of array(aStdCC)=0)
			CostCtrCurrent("init"; "00/00/00")
			//End if 
			
			ARRAY TEXT:C222($aOSid; 0)
			ARRAY TEXT:C222($aOSdesc; 0)
			For ($i; 1; Size of array:C274(aStdCC))
				If (aCostCtrGroup{$i}="89.OUTSIDE SERVICE")
					APPEND TO ARRAY:C911($aOSid; aStdCC{$i})
					APPEND TO ARRAY:C911($aOSdesc; aCostCtrDes{$i})
				End if 
			End for 
			
			If (Size of array:C274($aOSdesc)>0)  // Modified by: Mel Bohince (4/9/18) so new datafile can be created
				SORT ARRAY:C229($aOSid; $aOSdesc; >)
				<>psOUTSIDE_SERVICE_MENU:=$aOSdesc{1}
				For ($i; 2; Size of array:C274($aOSid))
					<>psOUTSIDE_SERVICE_MENU:=<>psOUTSIDE_SERVICE_MENU+";"+$aOSdesc{$i}
				End for 
			End if 
			
		End if   //new way
		
	: ($1="make")  //was menu 8
		If (Count menu items:C405(8)=0)  //was 4+2048 when associated menu
			APPEND MENU ITEM:C411(8; <>psOUTSIDE_SERVICE_MENU)  //4+2048
		End if 
End case 
