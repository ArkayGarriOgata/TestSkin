//%attributes = {"publishedWeb":true}
//PM: FG_PrepServiceSetStatus() -> 
//@author mlb - 1/22/03  16:11
//this is mainly to help searches
// Modified by: Mel Bohince (12/18/18) add preflight

Case of 
	: ([Finished_Goods_Specifications:98]Hold:62)
		[Finished_Goods_Specifications:98]Status:68:="0n Hold"
		
	: ([Finished_Goods_Specifications:98]Approved:10)
		[Finished_Goods_Specifications:98]Status:68:="7 Filed"
		util_setDateIfNull(->[Finished_Goods_Specifications:98]DateReturned:9; 4D_Current_date)
		util_setDateIfNull(->[Finished_Goods_Specifications:98]DateArtReceived:63; [Finished_Goods_Specifications:98]DateReturned:9)
		util_setDateIfNull(->[Finished_Goods_Specifications:98]DateSubmitted:5; [Finished_Goods_Specifications:98]DateReturned:9)
		util_setDateIfNull(->[Finished_Goods_Specifications:98]DatePrepDone:6; [Finished_Goods_Specifications:98]DateReturned:9)
		
	: ([Finished_Goods_Specifications:98]DateReturned:9#!00-00-00!)
		[Finished_Goods_Specifications:98]Status:68:="6 Rejected"
		util_setDateIfNull(->[Finished_Goods_Specifications:98]DateArtReceived:63; [Finished_Goods_Specifications:98]DateReturned:9)
		util_setDateIfNull(->[Finished_Goods_Specifications:98]DateSubmitted:5; [Finished_Goods_Specifications:98]DateReturned:9)
		util_setDateIfNull(->[Finished_Goods_Specifications:98]DatePrepDone:6; [Finished_Goods_Specifications:98]DateReturned:9)
		util_setDateIfNull(->[Finished_Goods_Specifications:98]DateSentToCustomer:8; [Finished_Goods_Specifications:98]DateReturned:9)
		
	: ([Finished_Goods_Specifications:98]DateSentToCustomer:8#!00-00-00!)  //also means prepDone
		[Finished_Goods_Specifications:98]Status:68:="5 Customer"
		
	: ([Finished_Goods_Specifications:98]DateProofRead:7#!00-00-00!)  //this is shortstopped by sent2cust
		[Finished_Goods_Specifications:98]Status:68:="4 Mail Room"
		
	: ([Finished_Goods_Specifications:98]DatePrepDone:6#!00-00-00!)  //this is shortstopped by sent2cust
		[Finished_Goods_Specifications:98]Status:68:="3 Quality"
		util_setDateIfNull(->[Finished_Goods_Specifications:98]DateArtReceived:63; [Finished_Goods_Specifications:98]DatePrepDone:6)
		util_setDateIfNull(->[Finished_Goods_Specifications:98]DateSubmitted:5; [Finished_Goods_Specifications:98]DatePrepDone:6)
		util_setDateIfNull(->[Finished_Goods_Specifications:98]DateSentToCustomer:8; [Finished_Goods_Specifications:98]DatePrepDone:6)
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]ControlNumber:1=[Finished_Goods_Specifications:98]ControlNumber:2)
			QUERY SELECTION:C341([Prep_Charges:103]; [Prep_Charges:103]QuantityQuoted:2=0; *)
			QUERY SELECTION:C341([Prep_Charges:103];  & ; [Prep_Charges:103]QuantityRevised:10=0; *)
			QUERY SELECTION:C341([Prep_Charges:103];  & ; [Prep_Charges:103]QuantityActual:3=0)
			If (False:C215)  //zwstatusmsg messes up server
				util_DeleteSelection(->[Prep_Charges:103])
			End if 
			DELETE SELECTION:C66([Prep_Charges:103])
			
			QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]ControlNumber:1=[Finished_Goods_Specifications:98]ControlNumber:2)
			QUERY SELECTION:C341([Prep_Charges:103]; [Prep_Charges:103]RequestSeries:13=1)
			APPLY TO SELECTION:C70([Prep_Charges:103]; [Prep_Charges:103]DateDone:14:=[Finished_Goods_Specifications:98]DatePrepDone:6)
			REDUCE SELECTION:C351([Prep_Charges:103]; 0)
			
		Else 
			//you need "LockedSet"
			
			QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]ControlNumber:1=[Finished_Goods_Specifications:98]ControlNumber:2; *)
			QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]QuantityQuoted:2=0; *)
			QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]QuantityRevised:10=0; *)
			QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]QuantityActual:3=0)
			DELETE SELECTION:C66([Prep_Charges:103])
			
			QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]ControlNumber:1=[Finished_Goods_Specifications:98]ControlNumber:2; *)
			QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]RequestSeries:13=1)
			//you need "LockedSet"
			APPLY TO SELECTION:C70([Prep_Charges:103]; [Prep_Charges:103]DateDone:14:=[Finished_Goods_Specifications:98]DatePrepDone:6)
			
		End if   // END 4D Professional Services : January 2019 query selection
		
	: ([Finished_Goods_Specifications:98]DateSubmitted:5#!00-00-00!) & ([Finished_Goods_Specifications:98]DatePreflighted:85=!00-00-00!)  // Modified by: Mel Bohince (12/18/18) add preflight
		[Finished_Goods_Specifications:98]Status:68:="10 Preflight"
		
	: ([Finished_Goods_Specifications:98]DateSubmitted:5#!00-00-00!) & ([Finished_Goods_Specifications:98]DatePreflighted:85#!00-00-00!)
		[Finished_Goods_Specifications:98]Status:68:="2 Imaging"
		util_setDateIfNull(->[Finished_Goods_Specifications:98]DateArtReceived:63; [Finished_Goods_Specifications:98]DateSubmitted:5)
		
	Else 
		[Finished_Goods_Specifications:98]Status:68:="1 Planning"
End case 

//zwStatusMsg ("STATUS";" Now "+[FG_Specification]Status)