//%attributes = {}
// ----------------------------------------------------
// Method: RM_receive_direct_purchase   ( ) -> success
// By: Mel Bohince @ 03/02/16, 14:01:49
// Description
// receive with immediate issue to a job
// ----------------------------------------------------
// Modified by: Mel Bohince (3/11/16) cancel transaction is jobform not found, after seeing a poi with bad [Purchase_Orders_Job_forms] record

C_BOOLEAN:C305($0)
$0:=True:C214

[Raw_Materials_Transactions:23]Reason:5:=[Raw_Materials_Transactions:23]Reason:5+" direct purchase"
SAVE RECORD:C53([Raw_Materials_Transactions:23])

RM_PostReceiptPOupdate


QUERY:C277([Purchase_Orders_Job_forms:59]; [Purchase_Orders_Job_forms:59]POItemKey:1=[Raw_Materials_Transactions:23]POItemKey:4; *)
QUERY:C277([Purchase_Orders_Job_forms:59];  & ; [Purchase_Orders_Job_forms:59]JobFormID:2#"")
If (Records in selection:C76([Purchase_Orders_Job_forms:59])>0)  //BAK 10/12/94 - Do not create Budget if no Job#
	QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=[Purchase_Orders_Job_forms:59]JobFormID:2)
	$jobform:=[Purchase_Orders_Job_forms:59]JobFormID:2
Else 
	$jobform:=""
End if 



QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$jobform)
If (Records in selection:C76([Job_Forms:42])>0)  //give it an issue, else cancel transaction
	
	If (Records in selection:C76([Job_Forms:42])>0) & ([Job_Forms:42]Status:6="Close@")
		utl_Logfile("RMX.log"; String:C10([Raw_Materials_Transactions:23]ReceivingNum:23)+" - "+[Raw_Materials_Transactions:23]Raw_Matl_Code:1+" "+[Raw_Materials_Transactions:23]POItemKey:4+" Issued to Closed job")
	End if 
	
	//not that critical as job rollup will recalc anyway
	If (Records in selection:C76([Job_Forms_Materials:55])>0)  //• 6/30/98 cs 
		CREATE SET:C116([Job_Forms_Materials:55]; "matl")
		// ******* Verified  - 4D PS - January  2019 ********
		
		QUERY SELECTION:C341([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Raw_Matl_Code:7=[Raw_Materials_Transactions:23]Raw_Matl_Code:1)
		
		// ******* Verified  - 4D PS - January 2019 (end) *********
		
		If (Records in selection:C76([Job_Forms_Materials:55])=0)
			USE SET:C118("matl")
			// ******* Verified  - 4D PS - January  2019 ********
			
			QUERY SELECTION:C341([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Commodity_Key:12=[Raw_Materials:21]Commodity_Key:2)
			
			// ******* Verified  - 4D PS - January 2019 (end) *********
			
			If (Records in selection:C76([Job_Forms_Materials:55])=0)  //• 6/30/98 cs cant locate a specific comm key - try for a more general match
				USE SET:C118("Matl")
				// ******* Verified  - 4D PS - January  2019 ********
				
				QUERY SELECTION:C341([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Commodity_Key:12=String:C10([Raw_Materials:21]CommodityCode:26; "00")+"@")
				
				// ******* Verified  - 4D PS - January 2019 (end) *********
				
				If (Records in selection:C76([Job_Forms_Materials:55])=0)  //• 6/30/98 cs still nothing found
					If (False:C215)  //see below also • mlb - 11/21/02  11:51
						MESSAGE:C88(Char:C90(13)+"    creating job budget")
						CREATE RECORD:C68([Job_Forms_Materials:55])
						[Job_Forms_Materials:55]JobForm:1:=[Purchase_Orders_Job_forms:59]JobFormID:2
						[Job_Forms_Materials:55]Sequence:3:=0  //? make zero
						[Job_Forms_Materials:55]Comments:4:="Non-budgeted item. Found at Receiving"
						[Job_Forms_Materials:55]ModDate:10:=4D_Current_date
						[Job_Forms_Materials:55]ModWho:11:=<>zResp
						[Job_Forms_Materials:55]Raw_Matl_Code:7:=[Raw_Materials_Transactions:23]Raw_Matl_Code:1
					End if   //false
				End if   //by comm code
			End if   //by comm key
		End if   //by rm code
		
		If (Records in selection:C76([Job_Forms_Materials:55])#0)  //• mlb - 11/21/02  11:53
			$sequence:=[Job_Forms_Materials:55]Sequence:3
			[Job_Forms_Materials:55]Actual_Qty:14:=uNANCheck([Job_Forms_Materials:55]Actual_Qty:14+[Raw_Materials_Transactions:23]Qty:6)
			[Job_Forms_Materials:55]Actual_Price:15:=[Job_Forms_Materials:55]Actual_Price:15+[Raw_Materials_Transactions:23]ActExtCost:10
			SAVE RECORD:C53([Job_Forms_Materials:55])
		Else 
			$sequence:=0
		End if 
		
		CLEAR SET:C117("matl")
		UNLOAD RECORD:C212([Job_Forms_Materials:55])
		
	End if   //no JFM's found
	
	//make the issue transaction
	$bin:=[Raw_Materials_Transactions:23]Location:15  //will become the via 
	
	$recno:=Record number:C243([Raw_Materials_Transactions:23])  //push
	DUPLICATE RECORD:C225([Raw_Materials_Transactions:23])
	[Raw_Materials_Transactions:23]pk_id:32:=Generate UUID:C1066
	[Raw_Materials_Transactions:23]Xfer_Type:2:="Issue"
	[Raw_Materials_Transactions:23]Xfer_State:33:="Posted"
	[Raw_Materials_Transactions:23]JobForm:12:=[Purchase_Orders_Job_forms:59]JobFormID:2
	[Raw_Materials_Transactions:23]Sequence:13:=$sequence
	[Raw_Materials_Transactions:23]ReferenceNo:14:=""
	[Raw_Materials_Transactions:23]ActExtCost:10:=-1*[Raw_Materials_Transactions:23]ActExtCost:10
	[Raw_Materials_Transactions:23]viaLocation:11:=$bin
	[Raw_Materials_Transactions:23]Location:15:="WIP"
	[Raw_Materials_Transactions:23]Qty:6:=-1*[Raw_Materials_Transactions:23]POQty:8
	[Raw_Materials_Transactions:23]ReferenceNo:14:="Direct Bill"  //• 6/15/98 cs added so that from closeout screeen can determine where issue occur
	[Raw_Materials_Transactions:23]Reason:5:=[Raw_Materials_Transactions:23]Reason:5+" Issue"  //• 11/6/97 cs 
	SAVE RECORD:C53([Raw_Materials_Transactions:23])
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
		UNLOAD RECORD:C212([Raw_Materials_Transactions:23])
		GOTO RECORD:C242([Raw_Materials_Transactions:23]; $recno)  //pop
		
	Else 
		GOTO RECORD:C242([Raw_Materials_Transactions:23]; $recno)  //pop
		
	End if   // END 4D Professional Services : January 2019 
	
	$success:=uVerifyJobStart([Purchase_Orders_Job_forms:59]JobFormID:2)  //• 8/4/98 cs insure that the jobform start date has been set
	If (Not:C34($success))
		$body:="Job form record for "+[Purchase_Orders_Job_forms:59]JobFormID:2+" was locked at the time of direct purchase receipt. Please set the Started date manually so WIP inventory reflects the issue."
		$from:=Email_WhoAmI
		distributionList:=Batch_GetDistributionList(""; "ACCTG")
		$subject:="Stock Received Not Set for "+[Purchase_Orders_Job_forms:59]JobFormID:2
		EMAIL_Sender($subject; ""; $body; distributionList; ""; $from; $from)
	End if 
	
	If (Substring:C12([Raw_Materials_Transactions:23]Commodity_Key:22; 1; 2)="01") | ([Raw_Materials_Groups:22]Commodity_Code:1=20)  //receiving board  // Modified by: Mel Bohince (2/23/16) direct purchase of sheet initiative
		$success:=JML_setStockReceivedSheeted([Purchase_Orders_Job_forms:59]JobFormID:2; [Purchase_Orders_Items:12]UM_Arkay_Issue:28)
		If (Not:C34($success))
			$body:="Job Master Log record for "+[Purchase_Orders_Job_forms:59]JobFormID:2+" was locked at the time of Stock receipt. Please set the date manually so schedules show green."
			$from:=Email_WhoAmI
			distributionList:=Batch_GetDistributionList(""; "PROD")
			$subject:="Stock Received Not Set for "+[Purchase_Orders_Job_forms:59]JobFormID:2
			EMAIL_Sender($subject; ""; $body; distributionList; ""; $from; $from)
		End if 
	End if   //comm=1
	
	OS_receivedQty([Raw_Materials_Transactions:23]POItemKey:4; [Raw_Materials_Transactions:23]POQty:8)  // Modified by: Mel Bohince (3/3/16) as of today, looks like not used
	
Else 
	utl_Logfile("RMX.log"; String:C10([Raw_Materials_Transactions:23]ReceivingNum:23)+" - "+[Raw_Materials_Transactions:23]Raw_Matl_Code:1+" "+[Raw_Materials_Transactions:23]POItemKey:4+" jobform not found, no issue")
	$0:=False:C215
End if 
