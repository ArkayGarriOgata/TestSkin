// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 08/16/11, 11:46:54
// ----------------------------------------------------
// Form Method: [ProductionSchedules]GlueSchedule
// ----------------------------------------------------
// Modified by: Mel Bohince (10/10/14) Gluer Priority Added
// Modified by: Mel Bohince (6/24/19) use <>Gluer varible to enable extend button
C_LONGINT:C283(vAskMePID; $sort_order)
C_TEXT:C284(tTimingText; tText; tSortOrder)  // Display current selection stats, Added by: Mark Zinke (12/5/13) 
C_POINTER:C301(columnClicked)

Case of 
	: (Form event code:C388=On Load:K2:1)
		//set the Options normally done with the Gear button
		columnClicked:=->Header2
		psg_progress:="Anything"
		If (gluer_id="ALLGluers")
			psg_assignments:=<>Gluers+" 9xx N/A"
		Else 
			psg_assignments:=gluer_id
		End if 
		psg_timeing:="All Releases"
		tTimingText:="Progress: "+psg_progress+"; Assignments: "+psg_assignments+"; Timing: "+psg_timeing
		numRecs:=PSG_ApplySettingOptions(psg_progress; psg_assignments; psg_timeing)
		
		
		OBJECT SET ENABLED:C1123(bExtend; False:C215)  //only enable if just one gluer shown
		If (Length:C16(psg_assignments)<5)
			//$ccID:=Num(psg_assignments)
			If (Position:C15(psg_assignments; <>Gluers)>0)  //If ($ccID>475) & ($ccID<486)// Modified by: Mel Bohince (6/24/19) 
				OBJECT SET ENABLED:C1123(bExtend; True:C214)
			End if 
		End if 
		
		If (gluer_id="ALLGluers")
			$sort_order:=PSG_LocalArray("sort"; 1)  //by release date, hrd, jobit
		Else 
			$sort_order:=PSG_LocalArray("sort"; 2)  //by gluer, priority, rel
		End if 
		tSortOrder:="Sorted by "
		$sort_string:=String:C10($sort_order)
		For ($i; 1; Length:C16($sort_string))
			tSortOrder:=tSortOrder+$sort_string[[$i]]+","
		End for 
		
		
		// Modified by: Mel Bohince (10/10/14) Gluer Priority Added
		tGluerOrder:="Machine Priority: "
		READ ONLY:C145([Cost_Centers:27])
		QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]cc_Group:2="80@"; *)
		QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]Priority:42>0)
		SELECTION TO ARRAY:C260([Cost_Centers:27]Priority:42; $aPriority; [Cost_Centers:27]ID:1; $aPriorityCC)
		REDUCE SELECTION:C351([Cost_Centers:27]; 0)
		SORT ARRAY:C229($aPriority; $aPriorityCC; >)
		For ($i; 1; Size of array:C274($aPriority))
			If ($aPriority{$i}>0)
				tGluerOrder:=tGluerOrder+String:C10($aPriority{$i})+": "+$aPriorityCC{$i}+"     "
			End if 
		End for 
		
		
		OBJECT SET ENABLED:C1123(*; "select@"; False:C215)
		SetObjectProperties(""; ->bAskMe; True:C214; "Ask Me")
		vAskMePID:=0
		SetObjectProperties(""; ->b4Edit; True:C214; "Job")
		SetObjectProperties(""; ->bJobMstr; True:C214; "Job Master")
		SetObjectProperties(""; ->bSizeNStyle; True:C214; "S&S")
		
		// Modified by: Mel Bohince (1/30/18) move gear out of restricted user
		If (gluer_id="ALLGluers")
			SetObjectProperties("bGear@"; -><>NULL; True:C214)  //Show the Gear Icon.
		Else 
			SetObjectProperties("bGear@"; -><>NULL; False:C215)  //Hide the Gear Icon.
		End if 
		
		If (User in group:C338(Current user:C182; "Role_Glue_Scheduling"))
			SetObjectProperties("Edit_@"; -><>NULL; True:C214; ""; True:C214)
			SetObjectProperties(""; ->bEdit; True:C214; ""; True:C214)
			SetObjectProperties(""; ->bHistory; True:C214; ""; True:C214)
			// Modified by: Mel Bohince (1/30/18) move gear out of restricted user
			
		Else 
			SetObjectProperties("Edit_@"; -><>NULL; True:C214; ""; False:C215)
			SetObjectProperties("Edit_aCasesMade"; -><>NULL; True:C214; ""; True:C214)
			SetObjectProperties(""; ->bEdit; False:C215; ""; False:C215)
			SetObjectProperties(""; ->bHistory; False:C215; ""; False:C215)
			//SetObjectProperties ("bGear@";-><>NULL;False)  //Hide the Gear Icon.// Modified by: Mel Bohince (1/30/18) move gear out of restricted user
		End if 
		
		$err:=PS_menu_mgr("make")
		
	: (Form event code:C388=On Clicked:K2:4)
		//not called
		
	: (Form event code:C388=On Activate:K2:9)
		If (Length:C16(<>jobform)=8)
			tText:=<>jobform
		End if 
		
	: (Form event code:C388=On Menu Selected:K2:14)
		$err:=PS_menu_mgr("do"; Menu selected:C152)
		
	: (Form event code:C388=On Unload:K2:2)
		//PSG_ServerArrays ("die!")  //Kill the stored procedure so other users can get the changes.
		
End case 