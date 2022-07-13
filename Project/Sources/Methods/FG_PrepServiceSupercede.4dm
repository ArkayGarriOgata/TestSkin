//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 04/02/09, 15:14:31
// ----------------------------------------------------
// Method: FG_PrepServiceSupercede(old control #)
// Description
// 
//
// Parameters
// ----------------------------------------------------
$ctrlNumOld:=$1
$today:=4D_Current_date
$comment:=[Finished_Goods_Specifications:98]CommentsFromPlanner:19
If ([Finished_Goods_Specifications:98]DatePrepDone:6=!00-00-00!)
	READ WRITE:C146([Prep_Charges:103])  //• mlb - 8/22/02  14:23
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
		QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]ControlNumber:1=$ctrlNumOld; *)
		QUERY:C277([Prep_Charges:103];  & ; [Prep_Charges:103]OrderNumber:8=0; *)
		QUERY:C277([Prep_Charges:103];  & ; [Prep_Charges:103]QuantityActual:3>0)
		CREATE SET:C116([Prep_Charges:103]; "allPrepCharges")
		If (Records in selection:C76([Prep_Charges:103])>0) & False:C215
			ToDo_postTask(<>zResp; "Prep Work"; "Make Order->Suprcded Cntrl#: "+$ctrlNumOld; [Finished_Goods_Specifications:98]ProjectNumber:4; $today)
		End if 
		REDUCE SELECTION:C351([Prep_Charges:103]; 0)
		
		FG_PrepSetPrepDone($today)
		
	Else 
		SET QUERY DESTINATION:C396(Into set:K19:2; "allPrepCharges")
		QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]ControlNumber:1=$ctrlNumOld; *)
		QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]OrderNumber:8=0; *)
		QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]QuantityActual:3>0)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		
		C_DATE:C307($theDate)
		[Finished_Goods_Specifications:98]DatePrepDone:6:=$today
		
		
		READ WRITE:C146([Prep_Charges:103])
		
		QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]ControlNumber:1=$ctrlNumOld; *)
		QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]OrderNumber:8=0; *)
		QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]QuantityActual:3>0; *)
		QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]QuantityQuoted:2=0; *)
		QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]QuantityRevised:10=0; *)
		QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]QuantityActual:3=0)
		
		util_DeleteSelection(->[Prep_Charges:103])
		
		$theDate:=[Finished_Goods_Specifications:98]DatePrepDone:6
		QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]ControlNumber:1=$ctrlNumOld; *)
		QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]OrderNumber:8=0; *)
		QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]QuantityActual:3>0; *)
		QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]RequestSeries:13=1)
		
		APPLY TO SELECTION:C70([Prep_Charges:103]; [Prep_Charges:103]DateDone:14:=$theDate)
		REDUCE SELECTION:C351([Prep_Charges:103]; 0)
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	
End if 

If ([Finished_Goods_Specifications:98]DateSubmitted:5=!00-00-00!)
	[Finished_Goods_Specifications:98]DateSubmitted:5:=$today
End if 
If ([Finished_Goods_Specifications:98]DateProofRead:7=!00-00-00!)
	[Finished_Goods_Specifications:98]DateProofRead:7:=$today
End if 
If ([Finished_Goods_Specifications:98]DateDirectFiled:66=!00-00-00!)
	[Finished_Goods_Specifications:98]DateDirectFiled:66:=$today
End if 
If ([Finished_Goods_Specifications:98]DateSentToCustomer:8=!00-00-00!)
	[Finished_Goods_Specifications:98]DateSentToCustomer:8:=$today
End if 
If ([Finished_Goods_Specifications:98]DateReturned:9=!00-00-00!)
	[Finished_Goods_Specifications:98]DateReturned:9:=$today
End if 
If ([Finished_Goods_Specifications:98]Approved:10)
	[Finished_Goods_Specifications:98]Approved:10:=False:C215
End if 
If ([Finished_Goods_Specifications:98]Hold:62)
	[Finished_Goods_Specifications:98]Hold:62:=False:C215
End if 
[Finished_Goods_Specifications:98]CommentsFromPlanner:19:="S U P E R C E D E D "+String:C10($today; System date short:K1:1)+Char:C90(13)+$comment
[Finished_Goods_Specifications:98]Status:68:="6 Rejected"
SAVE RECORD:C53([Finished_Goods_Specifications:98])

$0:=$comment