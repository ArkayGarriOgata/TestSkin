//%attributes = {"publishedWeb":true}
//PM:  JMI_findDefaultOrderPeg  2/23/01  mlb
//04/11/12 rewrite because used in loop making multiple querys

C_BOOLEAN:C305(is_lauder)
C_LONGINT:C283($job)
C_TEXT:C284($1)

Case of 
	: ($1="init")
		is_lauder:=ELC_isEsteeLauderCompany([Job_Forms_Items:44]CustId:15)  //possible Delfor peg
		
		$job:=Num:C11(Substring:C12([Job_Forms_Items:44]JobForm:1; 1; 5))
		QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]JobNo:44=$job)  //find the default order to link
		
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderNumber:1=[Customers_Orders:40]OrderNumber:1; *)
		QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Qty_Open:11>0)
		//cache the candidates
		ARRAY TEXT:C222(aOL_CPN; 0)
		ARRAY TEXT:C222(aOL_Orderline; 0)
		SELECTION TO ARRAY:C260([Customers_Order_Lines:41]ProductCode:5; aOL_CPN; [Customers_Order_Lines:41]OrderLine:3; aOL_Orderline)
		REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
		REDUCE SELECTION:C351([Customers_Orders:40]; 0)
		
	: ($1="peg")
		If (Length:C16([Job_Forms_Items:44]OrderItem:2)=0)  //not assigned
			$hit:=Find in array:C230(aOL_CPN; [Job_Forms_Items:44]ProductCode:3)
			If ($hit>-1)
				[Job_Forms_Items:44]OrderItem:2:=aOL_Orderline{$hit}
			End if 
		End if   //not assigned
		
		//•020499  MLB  allow shortcut for Lauder jobs
		If (Length:C16([Job_Forms_Items:44]OrderItem:2)=0)  //still not assigned
			If (is_lauder)
				[Job_Forms_Items:44]OrderItem:2:="DFmmddyy"
			End if 
		End if 
		
	: ($1="done")
		ARRAY TEXT:C222(aOL_CPN; 0)
		ARRAY TEXT:C222(aOL_Orderline; 0)
		is_lauder:=False:C215
End case 