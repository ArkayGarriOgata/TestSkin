//%attributes = {"publishedWeb":true}
//uFGjob_N_order
//5/4/95

If (([Job_Forms_Items:44]JobForm:1#sCriterion5) | ([Job_Forms_Items:44]ItemNumber:7#i1))  //•051796  MLB  was cpn
	$i:=qryJMI(sCriterion5; i1)  //5/4/95
End if 

RELATE ONE:C42([Job_Forms_Items:44]OrderItem:2)  //job may have cpns from diff customers
RELATE ONE:C42([Customers_Order_Lines:41]OrderNumber:1)  //therefore, traverse back through the order