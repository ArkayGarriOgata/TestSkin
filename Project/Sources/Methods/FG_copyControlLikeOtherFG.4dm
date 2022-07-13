//%attributes = {"publishedWeb":true}
//PM:  FG_copyControlLikeOtherFG  3/30/01  mlb
//make a new like some other cpn
//$ctrlNumOld:=Request("Make like Control Number:";"C123000";"Copy";"Cancel")
//• mlb - 6/28/02  16:31 don't execute if FG rec is locked
// • mel (10/9/03, 11:09:27) set ord catagory to original
// Modified by: Garri Ogata (5/13/21) clear [Finished_Goods_Specifications]CommentsFromImaging when duplicated

C_TEXT:C284($cpnOld; $newCPN)
C_TEXT:C284($ctrlNumOld)
C_LONGINT:C283($origRec)

START TRANSACTION:C239  // Added by: Mark Zinke (9/23/13) 

$today:=4D_Current_date
$cpnOld:=Request:C163("Make this new one look like Product Code:"; [Finished_Goods_Specifications:98]ProductCode:3; "Copy"; "Cancel")
If (OK=1) & (Length:C16($cpnOld)>0)
	QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=$cpnOld)
	If (Records in selection:C76([Finished_Goods:26])>0)
		$ctrlNumOld:=[Finished_Goods:26]ControlNumber:61
		$origRec:=Record number:C243([Finished_Goods:26])
		
		QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ControlNumber:2=$ctrlNumOld)
		If (Records in selection:C76([Finished_Goods_Specifications:98])>0)
			$newCPN:=fStripSpace("B"; Request:C163("What is the new Product Code?"; ""))
			If (OK=1) & (Length:C16($newCPN)>0)
				READ WRITE:C146([Finished_Goods:26])
				$numFG:=qryFinishedGood([Customers_Projects:9]Customerid:3; $newCPN)
				If ($numFG=0)
					uConfirm("Create a DUPLICATE F/G record for "+$newCPN+"?")
					If (OK=1)
						GOTO RECORD:C242([Finished_Goods:26]; $origRec)
						
						DUPLICATE RECORD:C225([Finished_Goods:26])
						FG_Virgin_ize
						[Finished_Goods:26]ProductCode:1:=$newCPN
						[Finished_Goods:26]CustID:2:=[Customers_Projects:9]Customerid:3
						[Finished_Goods:26]FG_KEY:47:=[Customers_Projects:9]Customerid:3+":"+$newCPN
						[Finished_Goods:26]Acctg_UOM:29:="M"
						[Finished_Goods:26]Status:14:="New"
						
						//• 8/18/97 cs start - clear art received information on duplicate of record  
						If ([Customers:16]ID:1#[Finished_Goods:26]CustID:2)  //if for some reason customer does not match finished good
							QUERY:C277([Customers:16]; [Customers:16]ID:1=[Finished_Goods:26]CustID:2)
						End if 
						//[Finished_Goods]HaveDisk:=Not([Customers]NotifyEmails)
						//[Finished_Goods]HaveBnW:=Not([Customers]CommissionPercent)
						[Finished_Goods:26]HaveSpecSht:55:=Not:C34([Customers:16]NeedSpecSheet:51)
						
					Else   //abort
						$newCPN:=""
					End if 
					
				Else   //• mlb - 6/28/02  16:31 don't execute if FG rec is locked
					If (Not:C34(fLockNLoad(->[Finished_Goods:26])))
						$newCPN:=""  //abort
						BEEP:C151
						ALERT:C41($newCPN+" was locked in FinishedGoods."; "Try later")
					End if 
				End if   //found fg          
				
				If (Length:C16($newCPN)>0)
					FG_dupInks("copy")
					
					DUPLICATE RECORD:C225([Finished_Goods_Specifications:98])
					
					[Finished_Goods_Specifications:98]CommentsFromImaging:20:=CorektBlank  // Added by: Garri Ogata (5/13/21) 
					
					[Finished_Goods_Specifications:98]ControlNumber:2:=FG_newControlNumber(pjtCustid)
					[Finished_Goods_Specifications:98]pk_id:78:=Generate UUID:C1066
					FG_dupInks("paste")
					[Finished_Goods_Specifications:98]ProductCode:3:=$newCPN
					[Finished_Goods_Specifications:98]FG_Key:1:=pjtCustid+":"+$newCPN
					[Finished_Goods_Specifications:98]ProjectNumber:4:=pjtId
					
					//[Finished_Goods_Specifications]RequestNumber:=$request
					[Finished_Goods_Specifications:98]DateSubmitted:5:=!00-00-00!
					[Finished_Goods_Specifications:98]DatePrepDone:6:=!00-00-00!
					[Finished_Goods_Specifications:98]DateProofRead:7:=!00-00-00!
					[Finished_Goods_Specifications:98]DateSentToCustomer:8:=!00-00-00!
					[Finished_Goods_Specifications:98]DateReturned:9:=!00-00-00!
					[Finished_Goods_Specifications:98]DateDirectFiled:66:=!00-00-00!
					//[FG_Specification]DateArtReceived:=4D_Current_date
					C_DATE:C307($received)  // • mel (2/6/04, 10:30:00)
					//$received:=Date(Request("When would you like to say art was received?";String($today;Short );"Set";"Today"))
					//Case of 
					//: ($received=!00/00/00!)
					//$received:=$today
					//
					//: (OK=0)
					$received:=$today
					//End case 
					[Finished_Goods_Specifications:98]DateArtEntered:71:=$today
					[Finished_Goods_Specifications:98]DateArtReceived:63:=$received
					[Finished_Goods_Specifications:98]Approved:10:=False:C215
					[Finished_Goods_Specifications:98]SizeAndStyleApproved:12:=""
					[Finished_Goods_Specifications:98]OriginalItem:13:=""
					[Finished_Goods_Specifications:98]CommentsFromPlanner:19:="Copied from "+$cpnOld+", Control# "+$ctrlNumOld+Char:C90(13)+[Finished_Goods_Specifications:98]CommentsFromPlanner:19
					[Finished_Goods_Specifications:98]InvoiceNumber:60:=0
					[Finished_Goods_Specifications:98]OrderNumber:59:=0
					[Finished_Goods_Specifications:98]PreflightBy:58:=""
					[Finished_Goods_Specifications:98]PrepBy:57:=""
					[Finished_Goods_Specifications:98]Hold:62:=False:C215
					[Finished_Goods_Specifications:98]Status:68:="1 Planning"
					If (Length:C16([Finished_Goods:26]OutLine_Num:4)>0)  //use existing number
						[Finished_Goods_Specifications:98]OutLine_Num:65:=[Finished_Goods:26]OutLine_Num:4
					End if 
					
					[Finished_Goods_Specifications:98]UPC_encoded:76:=[Finished_Goods:26]UPC:37
					
					//FG_PrepServiceProofReadDelete 
					FG_PrepServiceProofRead
					
					[Finished_Goods_Specifications:98]ServiceRequested:54:="1"
					// deleted 5/15/20: gns_ams_clear_sync_fields(->[Finished_Goods_Specifications]z_SYNC_ID;->[Finished_Goods_Specifications]z_SYNC_DATA)
					SAVE RECORD:C53([Finished_Goods_Specifications:98])
					
					$numChrgs:=FG_PrepAddCharges([Finished_Goods_Specifications:98]ControlNumber:2)
					
					[Finished_Goods:26]ArtReceivedDate:56:=$received
					[Finished_Goods:26]HaveArt:51:=True:C214
					JMI_CheckControlNumber([Finished_Goods:26]ControlNumber:61)
					[Finished_Goods:26]ControlNumber:61:=[Finished_Goods_Specifications:98]ControlNumber:2
					
					If (Length:C16([Finished_Goods:26]OutLine_Num:4)=0)
						[Finished_Goods:26]OutLine_Num:4:=[Finished_Goods_Specifications:98]OutLine_Num:65
					End if 
					
					If (Length:C16([Finished_Goods:26]ProjectNumber:82)=0)
						[Finished_Goods:26]ProjectNumber:82:=pjtId
					End if 
					
					SAVE RECORD:C53([Finished_Goods:26])
					If ([Finished_Goods:26]CustID:2#"")  // Added by: Mark Zinke (9/25/13) 
						VALIDATE TRANSACTION:C240
					Else 
						CANCEL TRANSACTION:C241
						utl_Logfile("server.log"; "[Finished_Goods]CustID was blank.")
						ALERT:C41("Customer ID is blank, record wasn't saved.")
					End if 
					
					REDUCE SELECTION:C351([Finished_Goods:26]; 0)
					
					<>EstNo:=[Finished_Goods_Specifications:98]ControlNumber:2
					If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
						
						QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ControlNumber:2=<>EstNo)
						CREATE SET:C116([Finished_Goods_Specifications:98]; "◊PassThroughSet")
						<>PassThrough:=True:C214
						UNLOAD RECORD:C212([Finished_Goods_Specifications:98])
						
					Else 
						
						SET QUERY DESTINATION:C396(Into set:K19:2; "◊PassThroughSet")
						QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ControlNumber:2=<>EstNo)
						SET QUERY DESTINATION:C396(Into current selection:K19:1)
						<>PassThrough:=True:C214
						
					End if   // END 4D Professional Services : January 2019 
					
					ViewSetter(2; ->[Finished_Goods_Specifications:98])
					
				Else 
					BEEP:C151
				End if 
				
			Else 
				BEEP:C151
			End if 
			
		Else 
			BEEP:C151
			ALERT:C41($ctrlNumOld+" could not be found.")
		End if 
		
	Else 
		BEEP:C151
		ALERT:C41($cpnOld+" could not be found in FinishedGoods item master.")
	End if 
End if 