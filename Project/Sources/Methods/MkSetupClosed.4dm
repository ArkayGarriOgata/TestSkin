//%attributes = {"publishedWeb":true}
//(p) MkSetupClosed
//set vars for printing for a closed order line
//• 1/15/98 cs created
//• 6/18/98 cs put Excess into avail to ship column also

C_TEXT:C284($1)
C_REAL:C285($2)

sCPN:=$1  //cpn
aSubtitle3:="Closed"
sDesc:=[Finished_Goods:26]CartonDesc:3
rReal1:=0  //ordered quantity
rReal2:=0  //allowable (sellable) ordered + overage allowance
rReal3:=-1  //qty produced - the -1 flags for text = 'Complete'`• 6/18/98 cs
rReal4:=0  //qty shipped = qty shipped (Shipped - returns)+Qty in Tx
rReal5:=0  //QA - quantity in CC
rReal6:=0  //Qty in Pay-use bin (Alford Tx)
rReal8:=0  //QtyDue = Ordered(w/Over) - (Netshipped + Payuse)
dDate1:=!00-00-00!
rReal7:=$2  //Net onhand - items in payuse  `• 6/18/98 cs
rReal9:=0  //Customer Resp =  Bal due+Payuse
rReal10:=0
rReal11:=$2  //Arkay excess