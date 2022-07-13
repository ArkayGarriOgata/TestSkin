//%attributes = {"publishedWeb":true}
//Procedure: price:=SetContractCost(custid;cpn;{»costfield;»matlfield;»laborfield
//                                ;»burdenfield;»frfield};{msgs On?})  050396  MLB
//•111896    make sure $numFGs is current
//•101597  MLB suppress message option for batch usage 
//•061998  MLB  add rebate to forumula
//iterator for setting the price and costs of cspec 
//when passed an array of cpns

C_TEXT:C284($1; $custid)
C_TEXT:C284($2; $cpn)
C_POINTER:C301($3; $4; $5; $6; $7)  //price,matl,labor,burden return values
C_LONGINT:C283($8)  //if present, don't do any messagings
C_BOOLEAN:C305($doMsgs)
C_LONGINT:C283($numFGs)
C_REAL:C285($0; $matl; $labor; $burden; $freight; $price; $cost; $PV)

$custid:=$1
$cpn:=$2
$0:=0

If (Count parameters:C259>=8)  //•101597  MLB 
	$doMsgs:=False:C215
Else 
	$doMsgs:=True:C214
End if 

//*Select the FG record
If ([Finished_Goods:26]FG_KEY:47#($custid+":"+$cpn))
	READ ONLY:C145([Finished_Goods:26])
	$numFGs:=qryFinishedGood($custid; $cpn)
Else 
	$numFGs:=Records in selection:C76([Finished_Goods:26])  //•111896   
End if 

If ($numFGs=1) & ([Finished_Goods:26]RKContractPrice:49#0)
	$price:=[Finished_Goods:26]RKContractPrice:49
	$0:=$price  //*    Rtn the price
	//*  Select the Project record
	If (([Customers_Brand_Lines:39]CustID:1#$custid) | ([Customers_Brand_Lines:39]LineNameOrBrand:2#[Finished_Goods:26]Line_Brand:15))
		READ ONLY:C145([Customers_Brand_Lines:39])
		QUERY:C277([Customers_Brand_Lines:39]; [Customers_Brand_Lines:39]CustID:1=$custid; *)
		QUERY:C277([Customers_Brand_Lines:39];  & ; [Customers_Brand_Lines:39]LineNameOrBrand:2=[Finished_Goods:26]Line_Brand:15)
	End if 
	
	If (Records in selection:C76([Customers_Brand_Lines:39])=1) & ([Customers_Brand_Lines:39]ContractPV:7#0) & (([Customers_Brand_Lines:39]ContractPctMatl:10+[Customers_Brand_Lines:39]ContractPctLab:8+[Customers_Brand_Lines:39]ContractPctOH:9+[Customers_Brand_Lines:39]ContractPctFrt:11)>99) & (([Customers_Brand_Lines:39]ContractPctMatl:10+[Customers_Brand_Lines:39]ContractPctLab:8+[Customers_Brand_Lines:39]ContractPctOH:9+[Customers_Brand_Lines:39]ContractPctFrt:11)<101)
		//*     Calculate the total cost
		$PV:=[Customers_Brand_Lines:39]ContractPV:7
		$rebate:=fGetCustRebate($custid)
		$cost:=fProfitVariable("Cost"; 0; $price; $pv; $rebate)
		//$cost:=$price*(1-$PV)`•061998  MLB  
		
		//*     Calculate the component costs
		If (Count parameters:C259>2)
			$matl:=$cost*([Customers_Brand_Lines:39]ContractPctMatl:10/100)
			$labor:=$cost*([Customers_Brand_Lines:39]ContractPctLab:8/100)
			$burden:=$cost*([Customers_Brand_Lines:39]ContractPctOH:9/100)
			$freight:=$cost*([Customers_Brand_Lines:39]ContractPctFrt:11/100)
			//*     Rtn the component costs 
			$3->:=$cost
			$4->:=$matl
			$5->:=$labor
			$6->:=$burden
			$7->:=$freight
		End if 
		
	Else   //couldn't get 1 brand
		If ($doMsgs)  //•101597  MLB  
			//NewWindow (300;100;6;1;"Error")
			//BEEP
			ALERT:C41("Contract Cost could not be set on CPN: "+Char:C90(13)+$custid+":"+$cpn+Char:C90(13)+"Brand: "+[Finished_Goods:26]Line_Brand:15)
			//DELAY PROCESS(Current process;(5*60))
			//CLOSE WINDOW
		End if 
	End if 
	
Else   //couldnt get 1 f/g
	If ($doMsgs)  //•101597  MLB  
		//NewWindow (300;100;6;1;"Error")
		//BEEP
		ALERT:C41("Contract Price '"+String:C10([Finished_Goods:26]RKContractPrice:49)+"' & Cost could not be set on CPN: "+Char:C90(13)+$custid+":"+$cpn)
		//DELAY PROCESS(Current process;(5*60))
		//CLOSE WINDOW
	End if 
End if 