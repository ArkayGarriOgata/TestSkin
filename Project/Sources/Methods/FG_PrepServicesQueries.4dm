//%attributes = {"publishedWeb":true}
//PM: FG_PrepServicesQueries() -> 
//@author mlb - 4/27/01  13:58
//mlb 7/9/01 loosen image search

C_LONGINT:C283(NumRecs1; OK)
C_TEXT:C284($1; $typeQuery)
C_BOOLEAN:C305($2; $useAlert)  //option to suppress alert box
C_DATE:C307($dateLimitor)
$dateLimitor:=Add to date:C393(Current date:C33; 0; -6; 0)
$typeQuery:=$1
If (Count parameters:C259>=2)
	$useAlert:=$2
Else 
	$useAlert:=True:C214
End if 

If (Length:C16($typeQuery)>2)
	QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]Status:68=$typeQuery; *)
	QUERY:C277([Finished_Goods_Specifications:98];  & ; [Finished_Goods_Specifications:98]DateArtReceived:63>=$dateLimitor)
	
Else 
	Case of 
		: ($typeQuery="3")  //need orders
			QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]DatePrepDone:6#!00-00-00!; *)
			QUERY:C277([Finished_Goods_Specifications:98];  & ; [Finished_Goods_Specifications:98]Status:68#"6 Rejected"; *)
			QUERY:C277([Finished_Goods_Specifications:98];  & ; [Finished_Goods_Specifications:98]DateProofRead:7=!00-00-00!)
			
		: ($typeQuery="5")  //need orders
			QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]DatePrepDone:6#!00-00-00!; *)
			QUERY:C277([Finished_Goods_Specifications:98];  & ; [Finished_Goods_Specifications:98]OrderNumber:59=0)
			
		: ($typeQuery="6")  //need invoiced called by FG_PrepServiceAutoInvoice
			QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]OrderNumber:59>0; *)
			QUERY:C277([Finished_Goods_Specifications:98];  & ; [Finished_Goods_Specifications:98]InvoiceNumber:60=0)
			OK:=1
			
		: ($typeQuery="7")  //need hold
			QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]Hold:62=True:C214; *)
			QUERY:C277([Finished_Goods_Specifications:98];  & ; [Finished_Goods_Specifications:98]DateArtReceived:63>=$dateLimitor)
			
		: ($typeQuery="8")  //
			QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]AdditionalReqs:69=True:C214)
			
		: ($typeQuery="9")  //not done
			QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]Status:68#"7 Filed"; *)
			QUERY:C277([Finished_Goods_Specifications:98];  & ; [Finished_Goods_Specifications:98]Status:68#"6 Rejected")
			
		: ($typeQuery="10")  //preflight required
			QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]DateSubmitted:5>$dateLimitor; *)
			QUERY:C277([Finished_Goods_Specifications:98];  & ; [Finished_Goods_Specifications:98]DatePrepDone:6=!00-00-00!; *)
			QUERY:C277([Finished_Goods_Specifications:98];  & ; [Finished_Goods_Specifications:98]DateProofRead:7=!00-00-00!; *)
			QUERY:C277([Finished_Goods_Specifications:98];  & ; [Finished_Goods_Specifications:98]DateSentToCustomer:8=!00-00-00!; *)
			QUERY:C277([Finished_Goods_Specifications:98];  & ; [Finished_Goods_Specifications:98]DatePreflighted:85=!00-00-00!)
			
		Else 
			SET AUTOMATIC RELATIONS:C310(True:C214; False:C215)
			NumRecs1:=fSelectBy
			SET AUTOMATIC RELATIONS:C310(False:C215; False:C215)
	End case 
End if 

User_AllowedSelection(->[Finished_Goods_Specifications:98])
NumRecs1:=Records in selection:C76([Finished_Goods_Specifications:98])
If (NumRecs1>0)
	OK:=1
Else 
	If ($useAlert)
		ALERT:C41("You have no Prep Service Work Orders in status "+$typeQuery)
	Else 
		BEEP:C151
		zwStatusMsg("PREP QUERY"; "You have no Prep Service Work Orders in status "+$typeQuery)
	End if 
End if 

CREATE SET:C116([Finished_Goods_Specifications:98]; "anyPressDate")