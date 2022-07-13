//%attributes = {"publishedWeb":true}
//qryOpenOrdLines({"*"};{"*"})  2/23/95
//if parameter 1 = "*" the search will be left open
//if there are two parameters, search selection will be used rather than search
//see also 
//03/29/95 upr 1444
//•080195  MLB 1490
//•092795  MLB  UPR 232
//     get the open orderlines but exclude spl billing types
//     called by gPrintXMonthly & doFGRptRecords & rBackLogRpt
//see simalar filter in the uGetJobCost series
//• 1/15/97 -cs- try to speed up server processing of the Aged FG report
//  by changing search & search selection to one search
//•121197  MLB  UPR 1906 Added * comments
//•5/04/99  MLB  excluded rejected

C_TEXT:C284($1; $2)  //If * then leave search open; use seach selection
C_LONGINT:C283($0)

If (Count parameters:C259<2)  //*Less than 2 parameters
	//*  Start with all Open Orderlines
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Qty_Open:11>0; *)  //see also same search in doFGRptRecords
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Closed"; *)  //•080195  MLB 1490
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Cancel"; *)  //•080195  MLB 1490
	
	
	
	If (Count parameters:C259=1)  //*  One params omits spl bill'g and leaves search open
		//SEARCH SELECTION([OrderLines];[OrderLines]SpecialBilling=False;*)
		//• 1/15/97 -cs - made this a continuation of above searches for speed (maybe)
		QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]SpecialBilling:37=False:C215; *)
		$0:=-4
	Else   //*  Zero params omits spl bill'g and closes search
		//SEARCH SELECTION([OrderLines];[OrderLines]SpecialBilling=False)
		//• 1/15/97 -cs - made this a continuation of above searches for speed (maybe)
		QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]SpecialBilling:37=False:C215)
		$0:=Records in selection:C76([Customers_Order_Lines:41])
	End if 
	
Else   //*2 or more parameters 
	//*  Start with current selection of Orderlines 
	//*     Restrict to only Open Orderlines in that selection
	QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Qty_Open:11>0; *)  //see also same search in doFGRptRecords
	QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Closed"; *)  //•080195  MLB 1490
	QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Cancel"; *)  //•080195  MLB 1490
	
	
	If ($1="*")  //*        If param 1=*, omits spl bill'g and leaves SEARCH SELECTION open
		QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]SpecialBilling:37=False:C215; *)
		//• 1/15/97 -cs - made this a continuation of above searches for speed (maybe)
		$0:=-4
	Else   //*        else, omits spl bill'g and close SEARCH SELECTION
		QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]SpecialBilling:37=False:C215)
		//• 1/15/97 -cs - made this a continuation of above searches for speed (maybe)
		$0:=Records in selection:C76([Customers_Order_Lines:41])
	End if 
End if 