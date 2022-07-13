//%attributes = {"publishedWeb":true}
//(p) qryFgBins(cpn|jf;custid;item;jobit)
//Used by Notifier to determine if there are negative bins
//returns (might be useful) number of records found
//• 8/22/97 cs created
//•091198  MLB  add some options

C_LONGINT:C283($0)
C_TEXT:C284($1)  //cpn or form
C_TEXT:C284($4)  //jobit
C_TEXT:C284($2)  //custid
C_LONGINT:C283($3; $option)  //jobit

$option:=Count parameters:C259

Case of 
	: ($option=1)
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=$1)
	: ($option=2)
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=$1; *)
		QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]CustID:16=$2)
	: ($option=3)
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33=(JMI_makeJobIt($1; $3)))
		//QUERY([Finished_Goods_Locations]; & ;[Finished_Goods_Locations]JobFormItem=$3)
	: ($option=4)
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33=$4)
	Else 
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]QtyOH:9<0)
End case 

$0:=Records in selection:C76([Finished_Goods_Locations:35])