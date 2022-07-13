//%attributes = {"publishedWeb":true}
//Procedure: doPurge()  062795  MLB
//see also gEstDel
//•062795  MLB  UPR 1507
//•070595 MLB
//•070895  MLB put alert box on dialogs ok button
//•031596  MLB  fix job purge, mark estimates partially purged 
//•040296  MLB  fix loop controller & and print DoPurgeChk4Holes fore and aft.
//•050196  MLB  inlarge window
//• 6/17/97 cs added code to mark customer active/inactive Jim email
//• 11/5/97 cs added code/checkbox for Issue tickets
//• 11/5/97 cs added code to archive POs over 2 fical years +1 day old
//• 11/21/97 cs added code to spawn PO purge into its own process
//• 12/2/97 cs moved FG transactions overlap in Vars with Estimate purge
//• 3/11/98 cs cb12 is NEXT check box to add 
//NOTE: checkboxes were named rxx between r1 -> r20 - due to overlap
//  all newer check boxes are named cbxx starting at cb1
// (r21 -> are numeric entries for number of days) into past to archive
//• 8/19/98 cs change to Fg tranasactions handling - save most for min 15months
//    can recycle cb6,cb7,cb8,cb10 -  also returned Default path to original 

C_TEXT:C284($CR)
C_TEXT:C284(xTitle; xText; <>purgeFolderPath)
C_BOOLEAN:C305(<>fContinue)  //• 11/21/97 cs flag for PO purge routines

MESSAGES OFF:C175
ON EVENT CALL:C190("eCancelProc")
REDUCE SELECTION:C351([zz_control:1]; 0)  //• 11/21/97 cs insure that control record is not locked
READ ONLY:C145([zz_control:1])
ALL RECORDS:C47([zz_control:1])

$CR:=Char:C90(13)
<>purgeFolderPath:=Application file:C491
$len:=Length:C16(<>purgeFolderPath)

Repeat 
	$len:=$len-1
Until (<>purgeFolderPath[[$len]]=":")
<>purgeFolderPath:=Substring:C12(<>purgeFolderPath; 1; $len)

If (<>purgeFolderPath[[Length:C16(<>purgeFolderPath)]]#":")
	<>purgeFolderPath:=<>purgeFolderPath+":"
End if 
<>purgeFolderPath:=<>purgeFolderPath+fYYMMDD(4D_Current_date)+"Purgeƒ:"
<>fContinue:=True:C214

ALERT:C41("To insure completion of a Purge You need to have at least "+"30 Megs of RAM allocated to aMs."; "Don't Worry")
BEEP:C151
CONFIRM:C162("Have you made a backup of the datafile?"; "Yes"; "No")

If (OK=1)
	doPurgeInit  //*Init varibles
	
	NewWindow(435; 390; 6; 8; "Define Purge Criterian")
	DIALOG:C40([zz_control:1]; "Purge")
	If (OK=1)  //*Bag & Tag
		zCursorMgr("beachBallOff")
		zCursorMgr("watch")
		SET WINDOW TITLE:C213("Data Purge in Progress")
		ERASE WINDOW:C160
		utl_Trace
		
		If (Test path name:C476(<>purgeFolderPath)<0)
			$Error:=NewFolder(<>purgeFolderPath)
		Else 
			$Error:=0
		End if 
		
		If ($Error=0)  //folder created
			$Error:=SetDefaultPath(<>purgeFolderPath)
			If ($Error=0)  //path set
				doPurgeChk4Hole  //•040296  MLB 
				$didSomething:=False:C215
				
				If ((r16+r17+r18)>0) & (<>fContinue)  //*Purge Customer Orders
					CloseCustOrders  //sets DateClosed and status if all lines closed
					doPurgeOrders  //export orders, lines, release, & cco then delete
					$didSomething:=True:C214
				End if 
				
				If (r19=1) & (<>fContinue)  //*Purge Jobs
					CloseJobHdrs
					doPurgeJobs(r37)
					$didSomething:=True:C214
				End if 
				
				If ((cb3+cb4+cb5)>0) & (<>fContinue)  //*Purge FG Transactioins    
					doPurgeFGtrans
					$didSomething:=True:C214
				End if 
				
				If ((r1+r2+r3+r4+r5+r6+r7+r8+r9+r10+r11+r12+r13+rSuper)>0) & (<>fContinue)
					doPurgeEstimate  //• 11/6/97 cs moved code to this procedure    
					$didSomething:=True:C214
				End if 
				
				If (r14=1) & (<>fContinue)  //*.   Purge Orphans
					doPurgeOrphans
					$didSomething:=True:C214
				End if 
				
				If (cb2=1) & (<>fContinue)  //* purge Issue tickets
					doPurgeIssTick
					$didSomething:=True:C214
				End if 
				
				If (cb11=1) & (<>fContinue)
					doPurgePSpec
					$didSomething:=True:C214
				End if 
				
				If (cb1=1) & (<>fContinue)  //*Purge Purchase Orders          
					doPurgePOs
					$didSomething:=True:C214
				End if 
				
				If (cbRmArchive=1) & (<>fContinue)  //archiving rm transactions
					doPurgeRmXfers
					$didSomething:=True:C214
				End if 
				
				If (cb12=1) & (<>fContinue)
					doPurge_Rms
					$didSomething:=True:C214
				End if 
				
				If (<>fContinue) & ($didSomething)
					doPurgeChk4Hole  //•040296  MLB
					BEEP:C151
					BEEP:C151
					ALERT:C41("Purge is complete. Integrate the files in the "+$cr+<>purgeFolderPath+$cr+" folder with your archive datafile."; "Right Away")
				End if 
				
				CLOSE WINDOW:C154
				
				zCursorMgr("restore")
			Else 
				ALERT:C41("Finding folder.")
			End if   //default path
		Else 
			ALERT:C41("Error creating folder.")
		End if   //new folder      
	End if   //OKed P  urge dialog
End if   //confirmed backup

doPurgeClear
uWinListCleanup
ON EVENT CALL:C190("")
MESSAGES ON:C181