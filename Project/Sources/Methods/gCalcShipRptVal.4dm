//%attributes = {"publishedWeb":true}
//(p) gcalcShipRptVal
//does needed calulations for each customer, for analysis report
//all rReal values print on layout

If ((Records in set:C195("Printing")+Records in set:C195("Returns"))>0)
	USE SET:C118("Printing")
	rReal1:=Sum:C1([Finished_Goods_Transactions:33]ExtendedPrice:20)
	rReal2:=Sum:C1([Finished_Goods_Transactions:33]CoGSExtended:8)
	QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=dDateBegin; *)  //reduce to the current month
	QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<=dDateEnd)  //dDatexxx from mnthendsuite dlog
	rReal5:=Sum:C1([Finished_Goods_Transactions:33]ExtendedPrice:20)
	rReal6:=Sum:C1([Finished_Goods_Transactions:33]CoGSExtended:8)
	
	USE SET:C118("Returns")  //returned items
	If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
		rReal1:=rReal1-Sum:C1([Finished_Goods_Transactions:33]ExtendedPrice:20)
		rReal2:=rReal2-Sum:C1([Finished_Goods_Transactions:33]CoGSExtended:8)
		QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=dDateBegin; *)  //reduce to the current month
		QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<=dDateEnd)  //dDatexxx from mnthendsuite dlog
		rReal5:=rReal5-Sum:C1([Finished_Goods_Transactions:33]ExtendedPrice:20)
		rReal6:=rReal6-Sum:C1([Finished_Goods_Transactions:33]CoGSExtended:8)
	End if 
	
	rReal3:=rReal1-rReal2  //margin -> (selling - cost)/selling
	If (rReal1#0)
		rReal4:=Round:C94((rReal3/rReal1)*100; 2)  //% margin -> margin / selling*100
	Else 
		rReal4:=0
	End if 
	rReal7:=rReal5-rReal6  //margin -> selling - cost
	If (rReal5#0)
		rReal8:=Round:C94((rReal7/rReal5)*100; 2)  //% margin -> margin / selling*100
	Else 
		rReal8:=0
	End if 
	
	rReal1t:=rReal1t+rReal1  //sum line totals
	rReal2t:=rReal2t+rReal2
	rReal3t:=rReal1t-rReal2t  //margin -> selling - cost
	If (rReal1t#0)
		rReal4t:=Round:C94((rReal3t/rReal1t)*100; 2)  //% margin -> margin / selling*100
	Else 
		rReal4t:=0
	End if 
	rReal5t:=rReal5t+rReal5
	rReal6t:=rReal6t+rReal6
	rReal7t:=rReal5t-rReal6t  //margin -> selling - cost
	If (rReal5t#0)
		rReal8t:=Round:C94((rReal7t/rReal5t)*100; 2)  //% margin -> margin / selling*100
	Else 
		rReal8t:=0
	End if 
	
	If (Count parameters:C259=1)  //called from sale sorted printing
		rReal1a:=rReal1a+rReal1  //sum line subtotals
		rReal2a:=rReal2a+rReal2
		rReal3a:=rReal1a-rReal2a  //margin -> selling - cost
		If (rReal1a#0)
			rReal4a:=Round:C94((rReal3a/rReal1a)*100; 2)  //% margin -> margin / selling*100
		Else 
			rReal4a:=0
		End if 
		rReal5a:=rReal5a+rReal5
		rReal6a:=rReal6a+rReal6
		rReal7a:=rReal5a-rReal6a  //margin -> selling - cost
		If (rReal5a#0)
			rReal8a:=Round:C94((rReal7a/rReal5a)*100; 2)  //% margin -> margin / selling*100  
		Else 
			rReal8a:=0
		End if 
	End if 
Else   //no records clear values
	rReal1:=0
	rReal2:=0
	rReal3:=0
	rReal4:=0
	rReal5:=0
	rReal6:=0
	rReal7:=0
	rReal8:=0
End if 