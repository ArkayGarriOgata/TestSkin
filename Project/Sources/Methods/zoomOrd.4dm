//%attributes = {"publishedWeb":true}
C_LONGINT:C283($1; $ord; $temp)  //zoomOrd
$ord:=$1
$temp:=iMode
iMode:=3
fromZoom:=True:C214
Case of 
	: (fChg=True:C214)
		READ ONLY:C145([Customers_Orders:40])
		QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1=$ord)
		If (Records in selection:C76([Customers_Orders:40])=1)
			Open window:C153(12; 50; 518; 348; 8; "Zoom Order:"+String:C10([Customers_Orders:40]OrderNumber:1)+" from Job")  //;"wCloseWinBox")  
			FORM SET INPUT:C55([Customers_Orders:40]; "ChgOrderZoom")
			DISPLAY SELECTION:C59([Customers_Orders:40])
			FORM SET INPUT:C55([Customers_Orders:40]; "Input")
			//uEnterOrder ([CustomerOrder]EstimateNo;[CustomerOrder]CaseScenario)
			fChg:=True:C214
		Else 
			BEEP:C151
			ALERT:C41("Mr.Programmer, how can that order not exist or be duplicated!")
		End if 
	Else 
		ALERT:C41("To access Order screen return to Customer Order screen!")
End case 
iMode:=$temp
fromZoom:=False:C215
//