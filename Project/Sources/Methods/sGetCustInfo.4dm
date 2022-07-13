//%attributes = {"publishedWeb":true}
//(p) sGetCustInfo
//upr 1307
//•051596  MLB  add customer contact link, and contact whose
//READ WRITE([ESTIMATE])
//• 9/15/97 cs rewriting layout
//• 10/1/97 cs moved from script to proc
//$1 - index into arrays (longint)
//$2 - string anything used as flag -do not change bullet array status
C_TEXT:C284($2)
C_LONGINT:C283($1)
t1:=""

If ($1>0)
	QUERY:C277([Customers:16]; [Customers:16]ID:1=aCustId{$1})
	t1:=[Customers:16]Name:2
	$OldRep:=[Customers:16]SalesmanID:3
	QUERY:C277([Salesmen:32]; [Salesmen:32]ID:1=$OldRep)
	t1:=t1+Char:C90(13)+"Current salesrep is : "+$OldRep+", "+[Salesmen:32]FirstName:3+" "+[Salesmen:32]MI:4+" "+[Salesmen:32]LastName:2+Char:C90(13)
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]Customer:2=aCustId{$1})
	t1:=t1+String:C10(Records in selection:C76([Job_Forms_Master_Schedule:67]))+" JobMasterLog records "+Char:C90(13)
	QUERY:C277([Estimates:17]; [Estimates:17]Cust_ID:2=aCustId{$1})
	t1:=t1+String:C10(Records in selection:C76([Estimates:17]))+" Estimate records. "+Char:C90(13)
	QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]CustID:2=aCustId{$1})  //upr 1307
	t1:=t1+String:C10(Records in selection:C76([Customers_Orders:40]))+" CustomerOrder records. "+Char:C90(13)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4=aCustId{$1})
	t1:=t1+String:C10(Records in selection:C76([Customers_Order_Lines:41]))+" OrderLines records. "+Char:C90(13)
	QUERY:C277([Customers_Contacts:52]; [Customers_Contacts:52]CustID:1=aCustId{$1})  //•051596  MLB  
	t1:=t1+String:C10(Records in selection:C76([Customers_Contacts:52]))+" CustContLink records. "+Char:C90(13)
	
	
	If (Count parameters:C259=1)  //2 parameters = call from arrow keys
		aBullet{$1}:=("x"*Num:C11(aBullet{$1}=""))+(""*Num:C11(aBullet{$1}="x"))
	End if 
Else 
	t1:=""
	aBullet{$1}:=""
End if 
//