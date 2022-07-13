//%attributes = {"publishedWeb":true}
//PM:  FG_dupControlNumber  3/29/01  mlb
//make a new control like an existing one
//• mlb - 6/28/02  16:31 don't execute if FG rec is locked
//• mlb - 8/22/02  14:30 todo task to bill old c#
// • mel (10/9/03, 11:09:27) set ord catagory to original

READ WRITE:C146([Finished_Goods:26])

C_TEXT:C284($ctrlNumOld; $1)
C_LONGINT:C283($numChrgs)

$today:=4D_Current_date
$ctrlNumOld:=$1

QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ControlNumber:2=$ctrlNumOld)
If (Records in selection:C76([Finished_Goods_Specifications:98])=1)
	$numFG:=qryFinishedGood("#KEY"; [Finished_Goods_Specifications:98]FG_Key:1)
	If ($numFG>0)
		If (fLockNLoad(->[Finished_Goods:26]))  //proceed with revision 
			If (fLockNLoad(->[Finished_Goods_Specifications:98]))  //proceed with revision          
				$comment:=FG_PrepServiceSupercede($ctrlNumOld)
				
				FG_dupInks("copy")
				
				DUPLICATE RECORD:C225([Finished_Goods_Specifications:98])
				[Finished_Goods_Specifications:98]ControlNumber:2:=FG_newControlNumber(pjtCustid)
				[Finished_Goods_Specifications:98]pk_id:78:=Generate UUID:C1066
				FG_dupInks("paste")
				//[Finished_Goods_Specifications]RequestNumber:=$request
				[Finished_Goods_Specifications:98]DateSubmitted:5:=!00-00-00!
				[Finished_Goods_Specifications:98]DatePrepDone:6:=!00-00-00!
				[Finished_Goods_Specifications:98]DateProofRead:7:=!00-00-00!
				[Finished_Goods_Specifications:98]DateSentToCustomer:8:=!00-00-00!
				[Finished_Goods_Specifications:98]DateDirectFiled:66:=!00-00-00!
				[Finished_Goods_Specifications:98]DateReturned:9:=!00-00-00!
				[Finished_Goods_Specifications:98]DateArtEntered:71:=$today
				C_DATE:C307($received)  // • mel (2/6/04, 10:30:00)
				//$received:=Date(Request("When would you like to say art was received?";String([FG_Specification]DateArtReceived;Short );"Back Date";"Today"))
				//Case of 
				//: ($received=!00/00/00!)
				//$received:=$today
				//may be a correction, not new art
				//: (ok=0)
				$received:=[Finished_Goods_Specifications:98]DateArtReceived:63  //use original date instead of $today
				//End case 
				//[FG_Specification]DateArtReceived:=$received
				[Finished_Goods_Specifications:98]Approved:10:=False:C215
				[Finished_Goods_Specifications:98]SizeAndStyleApproved:12:=""
				[Finished_Goods_Specifications:98]OriginalItem:13:=""
				[Finished_Goods_Specifications:98]CommentsFromPlanner:19:="Copied from, Control# "+$ctrlNumOld+Char:C90(13)+$comment
				[Finished_Goods_Specifications:98]InvoiceNumber:60:=0
				[Finished_Goods_Specifications:98]OrderNumber:59:=0
				[Finished_Goods_Specifications:98]PreflightBy:58:=""
				[Finished_Goods_Specifications:98]PrepBy:57:=""
				[Finished_Goods_Specifications:98]Hold:62:=False:C215
				[Finished_Goods_Specifications:98]Status:68:="1 Planning"
				//FG_PrepServiceProofReadDelete 
				FG_PrepServiceProofRead
				
				[Finished_Goods_Specifications:98]ServiceRequested:54:="1"
				// deleted 5/15/20: gns_ams_clear_sync_fields(->[Finished_Goods_Specifications]z_SYNC_ID;->[Finished_Goods_Specifications]z_SYNC_DATA)
				SAVE RECORD:C53([Finished_Goods_Specifications:98])
				
				LOAD RECORD:C52([Finished_Goods:26])
				$numChrgs:=FG_PrepAddCharges([Finished_Goods_Specifications:98]ControlNumber:2)
				FG_Virgin_ize("*")
				[Finished_Goods:26]ArtReceivedDate:56:=$received
				[Finished_Goods:26]HaveArt:51:=True:C214
				JMI_CheckControlNumber([Finished_Goods:26]ControlNumber:61)
				[Finished_Goods:26]ControlNumber:61:=[Finished_Goods_Specifications:98]ControlNumber:2
				[Finished_Goods:26]OutLine_Num:4:=[Finished_Goods_Specifications:98]OutLine_Num:65
				If ([Finished_Goods:26]UPC:37#[Finished_Goods_Specifications:98]UPC_encoded:76) & (Length:C16([Finished_Goods_Specifications:98]UPC_encoded:76)#0)
					//uConfirm ("Change FG upc from "+[Finished_Goods]UPC+" to "+[Finished_Goods_Specifications]UPC_encoded)
					//If (ok=1)
					[Finished_Goods:26]UPC:37:=[Finished_Goods_Specifications:98]UPC_encoded:76
					//End if 
				End if 
				
				If (Length:C16([Finished_Goods:26]ProjectNumber:82)=0)
					[Finished_Goods:26]ProjectNumber:82:=pjtId
				End if 
				SAVE RECORD:C53([Finished_Goods:26])
				
				<>EstNo:=[Finished_Goods_Specifications:98]ControlNumber:2
				If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
					
					QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ControlNumber:2=<>EstNo)
					CREATE SET:C116([Finished_Goods_Specifications:98]; "◊PassThroughSet")
					REDUCE SELECTION:C351([Finished_Goods_Specifications:98]; 0)
					
				Else 
					
					SET QUERY DESTINATION:C396(Into set:K19:2; "◊PassThroughSet")
					QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ControlNumber:2=<>EstNo)
					SET QUERY DESTINATION:C396(Into current selection:K19:1)
					If (Records in selection:C76([Finished_Goods_Specifications:98])>0)
						REDUCE SELECTION:C351([Finished_Goods_Specifications:98]; 0)
					End if 
					
				End if   // END 4D Professional Services : January 2019 
				
				<>PassThrough:=True:C214
				ViewSetter(2; ->[Finished_Goods_Specifications:98])
				//FORM GOTO PAGE(1)
				
			Else 
				BEEP:C151
				ALERT:C41([Finished_Goods_Specifications:98]FG_Key:1+" was locked in FG_Specifications."; "Try later")
			End if 
			
		Else 
			BEEP:C151
			ALERT:C41([Finished_Goods_Specifications:98]FG_Key:1+" was locked in FinishedGoods."; "Try later")
		End if 
		REDUCE SELECTION:C351([Finished_Goods:26]; 0)
		
	Else 
		BEEP:C151
		ALERT:C41([Finished_Goods_Specifications:98]FG_Key:1+" was not found in FinishedGoods."; "No way")
	End if 
	
Else 
	BEEP:C151
	ALERT:C41($ctrlNumOld+" was not found, email Mel some details."; "Yeah rite")
	util_OpenEmailClient("mel.bohince@arkay.com"; "mel.bohince@arkay.com"; ""; "DupFGspecFailed"; "ControlNum "+$ctrlNumOld+" NotFoundEvenThoughSelected")
End if 