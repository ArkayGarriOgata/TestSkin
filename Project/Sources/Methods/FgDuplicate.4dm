//%attributes = {"publishedWeb":true}
//(p) FGDuplicate
//Copy an existing FG record
//code copied from Button script on FG input2 so that it can 
//be used for button on FG pallete too
//Added Parameter to flag that this is coming FROM a layout, NOT its own processs
//$1 - string - (optional) anything flag this is called from an entry layout
//• 10/30/97 cs 
//• 8/18/97 cs Gregg found that a duplicated FG carried art info from original
//• 10/30/97 cs Lena requested that this info be cleared also
// • mel (3/21/05, 16:25:50) clear ordercategory

C_TEXT:C284($ID; $OLDID; $CPN)  //(S) [PROCESS_SPEC]Input'bDUplicate
C_TEXT:C284($1)
C_BOOLEAN:C305($Continue)

If (Count parameters:C259=1)  //called from layout
	$Continue:=True:C214
Else   //called from Palette
	$Continue:=False:C215  //default to failure
	
	Repeat   //get a unique CPN from user
		$CPN:=Request:C163("Enter a Unique Product Code to Copy")
	Until (OK=0) | ($Cpn#"")
	
	If (OK=1)
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=$CPN)
		
		If (Records in selection:C76([Finished_Goods:26])=1)  //if the entered code is unique, continue
			$Continue:=True:C214
		Else 
			ALERT:C41("Entered Product Code was Not unique")
			$Continue:=False:C215
		End if 
	End if 
End if 

If ($Continue)  //if ok to continue
	$ID:=Request:C163("Enter name of new Finished Good: "; [Finished_Goods:26]ProductCode:1+":"+<>zResp)
	If ((OK=1) & ($ID#""))
		$OLDID:=[Finished_Goods:26]ProductCode:1
		DUPLICATE RECORD:C225([Finished_Goods:26])
		FG_Virgin_ize
		//• 8/18/97 cs start - clear art received information on duplicate of record  
		If ([Customers:16]ID:1#[Finished_Goods:26]CustID:2)  //if for some reason customer does not match finished good
			QUERY:C277([Customers:16]; [Customers:16]ID:1=[Finished_Goods:26]CustID:2)
		End if 
		//[Finished_Goods]HaveDisk:=Not([Customers]NotifyEmails)
		//[Finished_Goods]HaveBnW:=Not([Customers]CommissionPercent)
		[Finished_Goods:26]HaveSpecSht:55:=Not:C34([Customers:16]NeedSpecSheet:51)
		
		[Finished_Goods:26]ProductCode:1:=$ID
		[Finished_Goods:26]FG_KEY:47:=[Finished_Goods:26]CustID:2+":"+[Finished_Goods:26]ProductCode:1
		
		<>RecordSaved:=True:C214
		ON ERR CALL:C155("eSaveRecError")
		SAVE RECORD:C53([Finished_Goods:26])
		ON ERR CALL:C155("")
		
		If (Not:C34(<>RecordSaved))
			BEEP:C151
			ALERT:C41("Please try again with a different Product Code.")
			<>RecordSaved:=True:C214
			
		Else 
			If (Count parameters:C259=0)  //if this is called from pallete open window to allow user to modify it
				<>PassThrough:=True:C214
				ONE RECORD SELECT:C189([Finished_Goods:26])
				UNLOAD RECORD:C212([Finished_Goods:26])
				CREATE SET:C116([Finished_Goods:26]; "◊PassThroughSet")
				
				
				
				ViewSetter(2; ->[Finished_Goods:26])
			Else 
				MODIFY RECORD:C57([Finished_Goods:26]; *)
			End if 
		End if 
	End if 
End if 

If (Count parameters:C259=0)  //clean up after done
	uWinListCleanup
End if 