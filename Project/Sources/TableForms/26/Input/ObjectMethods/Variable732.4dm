//TRACE
If ([Customers_Brand_Lines:39]LineNameOrBrand:2#[Finished_Goods:26]Line_Brand:15)
	QUERY:C277([Customers_Brand_Lines:39]; [Customers_Brand_Lines:39]LineNameOrBrand:2=[Finished_Goods:26]Line_Brand:15; *)
	QUERY:C277([Customers_Brand_Lines:39];  & [Customers_Brand_Lines:39]CustID:1=[Finished_Goods:26]CustID:2)
End if 

$err:=0
If ([Finished_Goods:26]RKContractPrice:49=0)
	$err:=$err+1
	ALERT:C41("[Finished_Goods]RKContractPrice is not set, please enter a positive number.")
End if 

If ([Finished_Goods:26]OrderType:59="")
	$err:=$err+1
	ALERT:C41("[Finished_Goods]OrderType is not set, please enter regular or promotional.")
End if 

If (Records in selection:C76([Customers_Brand_Lines:39])#1)
	$err:=$err+1
	ALERT:C41("One and only one [Brand_Lines] record needs to be set up.")
	
Else 
	If ([Customers_Brand_Lines:39]ContractPV:7=0)
		$err:=$err+1
		ALERT:C41("[Brand_Lines]ContractPV is not set, please enter a positive number.")
	End if 
	
	If (([Customers_Brand_Lines:39]ContractPctMatl:10+[Customers_Brand_Lines:39]ContractPctLab:8+[Customers_Brand_Lines:39]ContractPctOH:9+[Customers_Brand_Lines:39]ContractPctFrt:11)<99) | (([Customers_Brand_Lines:39]ContractPctMatl:10+[Customers_Brand_Lines:39]ContractPctLab:8+[Customers_Brand_Lines:39]ContractPctOH:9+[Customers_Brand_Lines:39]ContractPctFrt:11)>101)
		$err:=$err+1
		ALERT:C41("[Brand_Lines]ContractPctMatl, [Brand_Lines]ContractPctLab,  [Brand_Lines]Contrac"+" must equal 100.")
	End if 
End if 

If ($err=0)
	$price:=[Finished_Goods:26]RKContractPrice:49
	$PV:=[Customers_Brand_Lines:39]ContractPV:7
	$rebate:=fGetCustRebate([Finished_Goods:26]CustID:2)
	$cost:=fProfitVariable("Cost"; 0; $price; $pv; $rebate)
	$matl:=$cost*([Customers_Brand_Lines:39]ContractPctMatl:10/100)
	$labor:=$cost*([Customers_Brand_Lines:39]ContractPctLab:8/100)
	$burden:=$cost*([Customers_Brand_Lines:39]ContractPctOH:9/100)
	$freight:=$cost*([Customers_Brand_Lines:39]ContractPctFrt:11/100)
	ALERT:C41("PV="+String:C10($PV)+", Cost/M="+String:C10($cost; "$##,##0.00")+Char:C90(13)+" matl="+String:C10($matl; "$##,##0.00")+", labor="+String:C10($labor; "$##,##0.00")+", burden="+String:C10($burden; "$##,##0.00")+", freight="+String:C10($freight; "$##,##0.00")+Char:C90(13)+"Also check Orderline PO, Classification and Brand.")
Else 
	BEEP:C151
End if 
