//%attributes = {"publishedWeb":true}
//PM: util_patchSamples() -> 
//@author mlb - 4/19/01  11:00
//helper methods:
//     util_SelectionToText(->field)`create selection first 
//     util_ListMany 
//     util_GetMany 
//     EMAIL_Sender ("subject";"";t1;"melbohince@home.com")
//     util_stringBoolean(bool expr)
//     util_outerJoin (->findField;->likeField;{0=dontMsg})

//*look at an fg transaction
READ ONLY:C145([Finished_Goods_Transactions:33])
QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3=!2001-04-19!; *)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionNum:24=534165)
t1:="ExtendedPrice= "+String:C10([Finished_Goods_Transactions:33]ExtendedPrice:20)
t1:=t1+" PricePreM= "+String:C10([Finished_Goods_Transactions:33]PricePerM:19)
t1:=t1+" Qty= "+String:C10([Finished_Goods_Transactions:33]Qty:6)
t2:="Transaction-"+[Finished_Goods_Transactions:33]XactionNum:24
EMAIL_Sender(t2; ""; t1; "melbohince@home.com")
REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)

//*modify an fg transaction
READ WRITE:C146([Finished_Goods_Transactions:33])
QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3=!2001-04-19!; *)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionNum:24=534165)
[Finished_Goods_Transactions:33]ExtendedPrice:20:=852.03
[Finished_Goods_Transactions:33]PricePerM:19:=852.03
[Finished_Goods_Transactions:33]Qty:6:=1
SAVE RECORD:C53([Finished_Goods_Transactions:33])
REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)

//*add a mailing list
//READ WRITE([BatchEmailDistributions])
//QUERY([BatchEmailDistributions];[BatchEmailDistributions]BatchName="Purge File 
//«and Film")
//CREATE RECORD([y_batch_email_distributions])
//[y_batch_email_distributions]BatchName:="Purge File and Film"
//t1:="Email to notify "
//t1:=t1+"production that a new Control version"
//t1:=t1+"has been issued "
//t1:=t1+"that supercedes priors."
//[y_batch_email_distributions]Description:=t1
//t1:="Joan.Kepko@arkay.com"
//CREATE SUBRECORD([y_batch_email_distributions]DistributionList)
//:=t1
//SAVE RECORD([y_batch_email_distributions])
//UNLOAD RECORD([y_batch_email_distributions])


//*orderlines
READ ONLY:C145([Customers_Order_Lines:41])
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5="34-01555")
//t1:=String(Records in selection([OrderLines]))` do this first to know numRecs
t1:=[Customers_Order_Lines:41]OrderLine:3
NEXT RECORD:C51([Customers_Order_Lines:41])
t1:=t1+Char:C90(13)+[Customers_Order_Lines:41]OrderLine:3
REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
EMAIL_Sender("34-01555"; ""; t1; "melbohince@home.com")

//*orderlines
READ WRITE:C146([Customers_Order_Lines:41])
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3="94179.13")
[Customers_Order_Lines:41]SpecialBilling:37:=False:C215
SAVE RECORD:C53([Customers_Order_Lines:41])
t1:=[Customers_Order_Lines:41]OrderLine:3
t1:=t1+" spl billing set to "+String:C10(Num:C11([Customers_Order_Lines:41]SpecialBilling:37))
t1:=t1+" for cpn "+[Customers_Order_Lines:41]ProductCode:5
EMAIL_Sender("spl bill fix"; ""; t1; "melbohince@home.com,darlene.triglia@arkay.com")
REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)

//*customerOrders
READ ONLY:C145([Customers_Orders:40])
QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1=91784)
t1:=String:C10([Customers_Orders:40]OrderNumber:1)+" "+[Customers_Orders:40]Status:10
QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1=92339)
t1:=t1+Char:C90(13)+String:C10([Customers_Orders:40]OrderNumber:1)+" "+[Customers_Orders:40]Status:10
REDUCE SELECTION:C351([Customers_Orders:40]; 0)
EMAIL_Sender("Order Status"; ""; t1; "melbohince@home.com")

//*jobs
READ ONLY:C145([Jobs:15])
READ ONLY:C145([Job_Forms:42])
QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=79569)
t1:=String:C10([Jobs:15]JobNo:1)+" "+[Jobs:15]Status:4+Char:C90(13)
QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobNo:2=79569)
t1:=t1+String:C10(79569)+" has "+String:C10(Records in selection:C76([Job_Forms:42]))+" forms"+Char:C90(13)
REDUCE SELECTION:C351([Jobs:15]; 0)
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
	
	REDUCE SELECTION:C351([Job_Forms:42]; 0)
	
Else 
	
	//you don't need it see line 102
	
End if   // END 4D Professional Services : January 2019 

EMAIL_Sender("Job Status"; ""; t1; "melbohince@home.com")


READ ONLY:C145([Job_Forms:42])
QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobNo:2=79569)
t1:=[Job_Forms:42]Status:6
REDUCE SELECTION:C351([Job_Forms:42]; 0)
EMAIL_Sender("Job Status"; ""; t1; "melbohince@home.com")

