//%attributes = {}
// Method: rfc_duplicate () -> 
// ----------------------------------------------------
// by: mel: 02/26/04, 10:56:58
// ----------------------------------------------------
// Description:
//  see also rfc_MakeLiner
// ----------------------------------------------------
//based on:  FG_dupControlNumber  3/29/01  mlb
//make a new control like an existing one
//• mlb - 6/28/02  16:31 don't execute if FG rec is locked
//• mlb - 8/22/02  14:30 todo task to bill old c#
// • mel (10/9/03, 11:09:27) set ord catagory to original

C_TEXT:C284($ctrlNumOld; $1)
C_LONGINT:C283($numChrgs)

READ WRITE:C146([Finished_Goods_SizeAndStyles:132])

$ctrlNumOld:=$1

QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]FileOutlineNum:1=$ctrlNumOld)
If (Records in selection:C76([Finished_Goods_SizeAndStyles:132])=1)
	
	If (fLockNLoad(->[Finished_Goods_SizeAndStyles:132]))  //proceed with revision          
		$fileNum:=rfc_newOutlineNumber("rfc")
		[Finished_Goods_SizeAndStyles:132]SpecialInstructions:27:="REVISED, see S&S#: "+$fileNum+Char:C90(13)+[Finished_Goods_SizeAndStyles:132]SpecialInstructions:27
		SAVE RECORD:C53([Finished_Goods_SizeAndStyles:132])
		
		DUPLICATE RECORD:C225([Finished_Goods_SizeAndStyles:132])
		[Finished_Goods_SizeAndStyles:132]pk_id:61:=Generate UUID:C1066
		[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1:=$fileNum
		[Finished_Goods_SizeAndStyles:132]DateCreated:3:=4D_Current_date
		rfc_resetWorkflow
		[Finished_Goods_SizeAndStyles:132]AdditionalRequest:54:=0
		[Finished_Goods_SizeAndStyles:132]SpecialInstructions:27:="This is a revision to file#"+$ctrlNumOld+Char:C90(13)+[Finished_Goods_SizeAndStyles:132]SpecialInstructions:27
		// deleted 5/15/20: gns_ams_clear_sync_fields(->[Finished_Goods_SizeAndStyles]z_SYNC_ID;->[Finished_Goods_SizeAndStyles]z_SYNC_DATA)
		SAVE RECORD:C53([Finished_Goods_SizeAndStyles:132])
		
		$0:=$fileNum
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
			
			QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]FileOutlineNum:1=$fileNum)
			CREATE SET:C116([Finished_Goods_SizeAndStyles:132]; "◊PassThroughSet")
			REDUCE SELECTION:C351([Finished_Goods_SizeAndStyles:132]; 0)
			
		Else 
			
			SET QUERY DESTINATION:C396(Into set:K19:2; "◊PassThroughSet")
			QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]FileOutlineNum:1=$fileNum)
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			
			If (Records in selection:C76([Finished_Goods_SizeAndStyles:132])>0)
				REDUCE SELECTION:C351([Finished_Goods_SizeAndStyles:132]; 0)
				
			End if 
		End if   // END 4D Professional Services : January 2019 query selection
		
		
		<>PassThrough:=True:C214
		<>Activitiy:=1
		ViewSetter(2; ->[Finished_Goods_SizeAndStyles:132])
		
	Else 
		BEEP:C151
		uConfirm([Finished_Goods_SizeAndStyles:132]FileOutlineNum:1+" was locked in."; "Try later"; "Help")
	End if 
	
Else 
	BEEP:C151
	uConfirm([Finished_Goods_SizeAndStyles:132]FileOutlineNum:1+" was not found."; "Is it old?"; "Help")
End if 