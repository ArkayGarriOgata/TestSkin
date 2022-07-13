//%attributes = {"publishedWeb":true}
//(p) piFreezeInv
//this 'Freezes' inventory, moves current counts to a freeze file
//• 3/5/97 cs upr 1858 complete rewrite based on NEW PI logistics
//    
C_LONGINT:C283(lStart; lEnd; highTag; lowTag)
C_BOOLEAN:C305($Test)

$test:=False:C215

If (User in group:C338(Current user:C182; "Physical Inv Manager"))
	//TRACE
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
	
	If (fLockNLoad(->[zz_control:1]))
		If (Not:C34(Semaphore:C143("InventoryFrz")))  //semaphore does not yet exist (should not), create it
			If (Count users:C342<=2)  //this is the only user on the system
				CONFIRM:C162("Continuing this Action will Lock aMs to ALL Users Until Finished!"; "Continue"; "Abort")
				If (OK=1)
					CONFIRM:C162("Bin data will be changed. Have you made backups?"; "Continue"; "Abort")
					If (ok=1)
						lowTag:=Num:C11(Request:C163("What is the lowest Tag Number to expect?"; String:C10([zz_control:1]PhyInvTagLowNumber:49); "Set"; "Enter Later"))
						highTag:=Num:C11(Request:C163("What is the highest Tag Number to expect?"; String:C10([zz_control:1]PhyInvTagHighNumber:50); "Set"; "Enter Later"))
						
						READ WRITE:C146([Finished_Goods_Locations:35])  //•Mod Adam Soos - moved here
						ALL RECORDS:C47([Finished_Goods_Locations:35])
						utl_LogfileServer(<>zResp; "[Finished_Goods_Locations] = "+String:C10(Records in selection:C76([Finished_Goods_Locations:35]))+" to be frozen."; "PhyInv.log")
						APPLY TO SELECTION:C70([Finished_Goods_Locations:35]; PiSetUpFGFrz)  //move current quantities to frz quantity field, set flag NOT to delete   
						QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]PiDoNotDelete:29=False:C215)
						If (Records in selection:C76([Finished_Goods_Locations:35])>0)
							utl_LogfileServer(<>zResp; "[Finished_Goods_Locations] Freeze failed to set "+String:C10(Records in selection:C76([Finished_Goods_Locations:35]))+" records"; "PhyInv.log")
						End if 
						
						zwStatusMsg("PHYS INV"; "Freezing 'Raw Materials' On Hand Quantities…")
						READ WRITE:C146([Raw_Materials_Locations:25])  //040201
						//ALL RECORDS([Raw_Materials_Locations])  //040201
						QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]ConsignmentQty:26=0)  // Modified by: Mel Bohince (11/27/19) 
						utl_LogfileServer(<>zResp; "[[Raw_Materials_Locations]] = "+String:C10(Records in selection:C76([Raw_Materials_Locations:25]))+" to be frozen."; "PhyInv.log")
						
						APPLY TO SELECTION:C70([Raw_Materials_Locations:25]; PiSetUpRMFrz)
						QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]QtyOH:9#0; *)
						QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]ConsignmentQty:26=0)
						If (Records in selection:C76([Raw_Materials_Locations:25])>0)
							BEEP:C151
							BEEP:C151
							utl_LogfileServer(<>zResp; "[[Raw_Materials_Locations]] Freeze failed to set "+String:C10(Records in selection:C76([Raw_Materials_Locations:25]))+" records"; "PhyInv.log")
						End if 
						
						zwStatusMsg("PHYS INV"; "Bins ready for Physical Inventory")
						[zz_control:1]InvInProgress:24:=True:C214
						[zz_control:1]InvDate:25:=4D_Current_date
						[zz_control:1]InvTestRun:33:=$Test
						[zz_control:1]PhyInvTagLowNumber:49:=lowTag
						[zz_control:1]PhyInvTagHighNumber:50:=highTag
						SAVE RECORD:C53([zz_control:1])
						If ($releaseControl)
							REDUCE SELECTION:C351([zz_control:1]; 0)
						End if 
						ALERT:C41("All Other Users Are Currently Locked Out of the AMS System.  Click OK to proceed")
						CLEAR SEMAPHORE:C144("InventoryFrz")
						
					End if   //Backup for REAL PI
				End if   // confirm to continue lockout
				
			Else   //not in mono mode
				BEEP:C151
				ALERT:C41("There are Currently "+String:C10(Count users:C342)+" Users Logged into the AMS System."+"  To Start 'Physical Inventory' ALL Other Users MUST be Logged off the"+" the System.")
			End if 
			
		Else   //semiphour
			BEEP:C151
			ALERT:C41("The Inventory System is Currently in use by Another User.")  //this should never happen
		End if 
		READ ONLY:C145([Finished_Goods_Locations:35])  //•9/14/95 Chip, upr 1739, was above at '**' stopped ticket number from being save
		READ ONLY:C145([Raw_Materials_Locations:25])
		REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)
		REDUCE SELECTION:C351([Raw_Materials:21]; 0)
		REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
		
	Else 
		BEEP:C151
		ALERT:C41("Control record is locked, you may not proceed.")
	End if 
	
Else 
	uNotAuthorized
End if 