//%attributes = {"publishedWeb":true}
//(p) piEndPi
//THIS (p) "books" Physical Inventory into perpetual, and creates adjustment recor
//physical Inventory started - Glue line, shipping, etc. DIDNOT STOP"
//procedure is: PiDuringXfer
//•3/5/97 cs complete rewrite based on new PI Logistics
// • 4/8/97 cs, after PI clean up

C_LONGINT:C283(lStart; lEnd)
C_BOOLEAN:C305($fContinue; $Test; $FGDel; $RMDel)  //• Adam Soos April 8, 1996 $FGDel, $RMDel
C_DATE:C307(dInvDate)
C_TIME:C306(tInvTime)

If (User in group:C338(Current user:C182; "Physical Inv Manager"))
	If (Read only state:C362([zz_control:1]))
		READ WRITE:C146([zz_control:1])
		ALL RECORDS:C47([zz_control:1])
		$releaseControl:=True:C214
	Else 
		If (Records in selection:C76([zz_control:1])=1)
			$releaseControl:=False:C215
		Else 
			ALL RECORDS:C47([zz_control:1])
			$releaseControl:=True:C214
		End if 
	End if 
	
	$Test:=False:C215
	If (fLockNLoad(->[zz_control:1]))
		If (Not:C34(Semaphore:C143("EndInventory")))  //semaphore does not yet exist (should not), create it      
			If (Count users:C342<=2)  //this is the only user on the system        
				$Test:=[zz_control:1]InvTestRun:33
				$fContinue:=True:C214
				<>fLastBkup:=$Test
				
				BEEP:C151
				CONFIRM:C162("Have you made a BACK UP?"; "Continue"; "Abort")
				If (OK=1)
					BEEP:C151
					CONFIRM:C162("Continuing this Action will Lock aMs to ALL Users Until Finished!"; "Continue"; "Abort")
					If (OK=1)
						READ WRITE:C146([Finished_Goods_Locations:35])
						READ WRITE:C146([Raw_Materials_Locations:25])
						READ ONLY:C145([zz_control:1])
						dInvDate:=[zz_control:1]InvDate:25
						tInvTime:=[zz_control:1]InvTime:35
						
						ALL RECORDS:C47([Finished_Goods_Locations:35])
						zwStatusMsg("PHYS INV"; "Cleaning up F/G Records...")
						APPLY TO SELECTION:C70([Finished_Goods_Locations:35]; PiFgEndPi)
						
						zwStatusMsg("PHYS INV"; "Removing Zero FG Bins…")
						FG_DelZeroBins
						
						ALL RECORDS:C47([Raw_Materials_Locations:25])
						zwStatusMsg("PHYS INV"; "Cleaning up RM Records...")
						APPLY TO SELECTION:C70([Raw_Materials_Locations:25]; PiRmEndPi)
						
						zwStatusMsg("PHYS INV"; "Removing Zero RM Bins…")
						RM_DelZeroBins
						
						[zz_control:1]InvInProgress:24:=False:C215
						SAVE RECORD:C53([zz_control:1])
						If ($releaseControl)
							REDUCE SELECTION:C351([zz_control:1]; 0)
						End if 
						uClearSelection(->[Raw_Materials_Locations:25])
						uClearSelection(->[Finished_Goods_Locations:35])
						zwStatusMsg("PHYS INV"; "Physical Inventory has been completed.")
						BEEP:C151
						
						CLEAR SEMAPHORE:C144("EndInventory")
					End if   //lockout
				End if   //backup
				
			Else 
				CLEAR SEMAPHORE:C144("EndInventory")
				BEEP:C151
				ALERT:C41("There are Currently "+String:C10(Count users:C342)+" Users Logged into the AMS System."+"  To End 'Physical Inventory' ALL Other Users MUST be Logged off the"+" the System.")
			End if 
			
		Else 
			BEEP:C151
			ALERT:C41("The Ending Inventory System is Currently in use by Another User.")  //this should never happen
		End if 
		
	Else 
		BEEP:C151
		ALERT:C41("Control record is locked, you may not proceed.")
	End if 
	
Else 
	uNotAuthorized
End if 