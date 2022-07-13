//%attributes = {"publishedWeb":true}
//PM: JML_getCustInfo() -> 
//@author mlb - 3/4/02  12:20

READ ONLY:C145([Jobs:15])
READ ONLY:C145([Customers_Orders:40])
READ ONLY:C145([Customers_Order_Lines:41])

C_TEXT:C284($jobform; $1)

$jobform:=$1
$job:=Num:C11(Substring:C12($jobform; 1; 5))

QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=$job)  //**      Get Customer, Line, and Est #
[Job_Forms_Master_Schedule:67]Customer:2:=[Jobs:15]CustomerName:5
[Job_Forms_Master_Schedule:67]Line:5:=[Jobs:15]Line:3
If (Length:C16([Job_Forms_Master_Schedule:67]ProjectNumber:26)=0)
	[Job_Forms_Master_Schedule:67]ProjectNumber:26:=[Jobs:15]ProjectNumber:18  //2/8/95
End if 

//*   Load Order
//zwStatusMsg ("JobMaster Update";" Getting the Order...")
QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1=[Jobs:15]OrderNo:15)  //**      Get PO and EnterOrder date
[Job_Forms_Master_Schedule:67]PO_No:3:=[Customers_Orders:40]PONumber:11
[Job_Forms_Master_Schedule:67]EnterOrderDate:9:=ndTestDates([Customers_Orders:40]DateOpened:6; [Job_Forms_Master_Schedule:67]EnterOrderDate:9; "'Enter Order' ")
[Job_Forms_Master_Schedule:67]Salesman:1:=[Customers_Orders:40]SalesRep:13  //**      Get the Salesman id
//*   Load Orderlines
//zwStatusMsg ("JobMaster Update";" Getting the Orderlines...")
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderNumber:1=[Jobs:15]OrderNo:15)  //**      Get the earliest want date from orderlines
ARRAY DATE:C224($aDate; 0)
If (Records in selection:C76([Customers_Order_Lines:41])>0)
	SELECTION TO ARRAY:C260([Customers_Order_Lines:41]NeedDate:14; $aDate)
	SORT ARRAY:C229($aDate; >)
	For ($i; 1; Size of array:C274($aDate))  //added for loop because sort will bring 00/00/00 dates to top, need to find
		If ($aDate{$i}#!00-00-00!)  //first Non-Zerodate
			[Job_Forms_Master_Schedule:67]CustWantDate:10:=$aDate{$i}
			$i:=Size of array:C274($aDate)+1  //break
		End if 
	End for 
End if 