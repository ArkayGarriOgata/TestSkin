//(s) needdate
//• 2/18/97 -cs-  made mandatory on request by Lena
//• 2/26/97 -cs- temporarily removed manditory until status issue resolved 
//•120998  MLB Y2K Remediation 
sDateLimitor(->[Customers_Order_Lines:41]NeedDate:14; 365)
// Modified by: Mel Bohince (11/13/15) 
pendingChange:=pendingChange+"Needed Changed from "+String:C10(Old:C35([Customers_Order_Lines:41]NeedDate:14))+" to "+String:C10([Customers_Order_Lines:41]NeedDate:14)+Char:C90(Carriage return:K15:38)
