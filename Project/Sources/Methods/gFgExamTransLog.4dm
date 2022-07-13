//%attributes = {"publishedWeb":true}
//(p) gFGExamTransLog
//$1 long int, index into mthendsuite array
//•121495 MLB

C_LONGINT:C283($i; $1)

$i:=$1

Case of 
	: (<>MthEndSuite{$i}="F/G Trans Log - WIP to CC")
		t_Via:="WIP"
		t_Location:="CERTIFICATION"
		s_Via:="WIP"
		s_Location:="CC:@"
		
	: (<>MthEndSuite{$i}="F/G Trans Log - CC to FG")
		t_Via:="CERTIFICATION"
		t_Location:="FINISHED GOODS"
		s_Via:="CC:@"
		s_Location:="FG:@"
		
	: (<>MthEndSuite{$i}="F/G Trans Log - FG to SC")
		t_Via:="FINISHED GOODS"
		t_Location:="SCRAP"
		s_Via:="FG:@"
		s_Location:="Sc@"
		
	: (<>MthEndSuite{$i}="F/G Trans Log - CC to SC")
		t_Via:="CERTIFICATION"
		t_Location:="SCRAP"
		s_Via:="CC:@"
		s_Location:="Sc@"
		
	: (<>MthEndSuite{$i}="F/G Trans Log - CC to EX")
		t_Via:="CERTIFICATION"
		t_Location:="EXAMINING"
		s_Via:="CC:@"
		s_Location:="EX:@"
		
	: (<>MthEndSuite{$i}="F/G Trans Log - EX to SC")
		t_Via:="EXAMINING"
		t_Location:="SCRAP"
		s_Via:="Ex:@"
		s_Location:="Sc@"
		
	: (<>MthEndSuite{$i}="F/G Trans Log - EX to XC")
		t_Via:="EXAMINING"
		t_Location:="RECERTIFICATION"  //•121495 MLB
		s_Via:="Ex:@"
		s_Location:="XC:@"
		
	: (<>MthEndSuite{$i}="F/G Trans Log - XC to SC")
		t_Via:="RECERTIFICATION"
		t_Location:="SCRAP"
		s_Via:="XC:@"
		s_Location:="Sc@"
		
	: (<>MthEndSuite{$i}="F/G Trans Log - XC to FG")  //upr 1333 2/13/95
		t_Via:="RECERTIFICATION"  //transposed on 2/22/95
		t_Location:="FINISHED GOODS"
		s_Via:="XC:@"
		s_Location:="FG:@"
		
	: (<>MthEndSuite{$i}="F/G Trans Log - XC to EX")
		t_Via:="RECERTIFICATION"
		t_Location:="EXAMINING"
		s_Via:="XC:@"
		s_Location:="EX:@"
		
	: (<>MthEndSuite{$i}="F/G Trans Log CustOvership-SC")
		t_Via:="CUSTOMER"
		t_Location:="SCRAP"
		s_Via:="Cust@"
		s_Location:="SC:@"  //upr 999 chip 
		
	: (<>MthEndSuite{$i}="F/G Trans Log - Customer to EX")
		t_Via:="CUST0MER"
		t_Location:="EXAMINING"
		s_Via:="Cust@"
		s_Location:="Ex:@"
		
	: (<>MthEndSuite{$i}="F/G Trans Log - Customer to FG")
		t_Via:="CUSTOMER"
		t_Location:="FINISHED GOODS"
		s_Via:="Cust@"
		s_Location:="FG:@"
		
End case 

QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=dDateBegin; *)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<=dDateEnd; *)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9=s_Location; *)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]viaLocation:11=s_Via)
ORDER BY:C49([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]JobNo:4; >; [Finished_Goods_Transactions:33]JobForm:5; >)

BREAK LEVEL:C302(0)
ACCUMULATE:C303([Finished_Goods_Transactions:33]Qty:6; real1; real2; real3; real4; [Finished_Goods_Transactions:33]zCount:10)
util_PAGE_SETUP(->[Finished_Goods_Transactions:33]; "TransactionLog")
FORM SET OUTPUT:C54([Finished_Goods_Transactions:33]; "TransactionLog")
t2:="FINISHED GOODS TRANSACTION LOG"
t2b:="FROM "+String:C10(dDateBegin; 1)+" TO "+String:C10(dDateEnd; 1)
t3:="TRANSFERS FROM "+t_Via+" TO "+t_Location
PDF_setUp(<>pdfFileName)
PRINT SELECTION:C60([Finished_Goods_Transactions:33]; *)
FORM SET OUTPUT:C54([Finished_Goods_Transactions:33]; "List")