//%attributes = {"publishedWeb":true}
//CUST_ApplyNameChange formerly know as (S) sCustNameChg:
//1/11/95
//1/12/95  upr 1392
//5/4/95 upr 1520 chip
//• 4/16/97 cs upr 1794 - some records, when customer name is changed, not updated
//   re-write - use process vars (allready existing) instead of locals
//   call procedure to change field while handling locked record (not done before)
//•051999  mlb  UPR 
//5/5/05 - DJC - added code for the [CorrectiveAction]CustomerName field

C_TEXT:C284(sCustID)
C_TEXT:C284(sName)
C_TEXT:C284(sCustomer)

SET MENU BAR:C67(<>DefaultMenu)
sCustID:=<>Cust  //setup local process vars
sName:=<>Name
sCustomer:=<>OldName
<>Cust:=""  //clear interprocess 'parameters'
<>Name:=""
<>OldName:=""
NewWindow(350; 60; 3; -722; "Updating Customers")
//HIDE PROCESS(Current process)
BRING TO FRONT:C326(<>lProcess)

uChangeField(->[Estimates:17]Cust_ID:2; ->sCustID; ->[Estimates:17]CustomerName:47; ->sName)  //• 4/16/97 cs created this procedure to handle changing field values 
uChangeField(->[Jobs:15]CustID:2; ->sCustId; ->[Jobs:15]CustomerName:5; ->sName)  //•051999  mlb  UPR 
uChangeField(->[Customers_Order_Lines:41]CustID:4; ->sCustId; ->[Customers_Order_Lines:41]CustomerName:24; ->sName)
uChangeField(->[Customers_Orders:40]CustID:2; ->sCustId; ->[Customers_Orders:40]CustomerName:39; ->sName)
uChangeField(->[WMS_Label_Tracking:75]CustId:2; ->sCustId; ->[WMS_Label_Tracking:75]CustName:1; ->sName)
uChangeField(->[Customers_Projects:9]Customerid:3; ->sCustId; ->[Customers_Projects:9]CustomerName:4; ->sName)  //• mlb - 6/6/01  16:33
uChangeField(->[Contacts:51]Company:3; ->sCustomer; ->[Contacts:51]Company:3; ->sName)
uChangeField(->[ProductionSchedules:110]Customer:11; ->sCustomer; ->[ProductionSchedules:110]Customer:11; ->sName)
uChangeField(->[QA_Corrective_Actions:105]Custid:5; ->sCustID; ->[QA_Corrective_Actions:105]CustomerName:31; ->sName)

uChangeField(->[Customers_Bookings:93]Custid:1; ->sCustID; ->[Customers_Bookings:93]CustomerName:18; ->sName)
uChangeField(->[Customers_OnTimeStats:122]CustId:1; ->sCustID; ->[Customers_OnTimeStats:122]CustomerName:2; ->sName)


CLOSE WINDOW:C154