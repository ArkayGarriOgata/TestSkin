//%attributes = {"publishedWeb":true}
//(p)rRptOrderAckno
//•100496  MLB  make sure all items are selected
//•090602  mlb  UPR 

C_TEXT:C284(sPONum2)

a1:=1
a2:=0
SAVE RECORD:C53([Customers_Orders:40])

If (Length:C16([Customers_Orders:40]Contact_Agent:36)>0)  //•090602  mlb  UPR 
	If ([Customers_Orders:40]Contact_Agent:36#"Unknown")
		CONFIRM:C162("Email the Acknowledge also?"; "Send"; "Print Only")
		If (ok=1)
			$sendEmail:=True:C214
		Else 
			$sendEmail:=False:C215
		End if 
	Else 
		$sendEmail:=False:C215
	End if 
Else 
	$sendEmail:=False:C215
End if 
$sendEmail:=True:C214

Text2:=fGetAddressText([Customers_Orders:40]defaultBillTo:5)
dDate:=[Customers_Orders:40]DateOpened:6
sFOB:=[Customers_Orders:40]FOB:25
sTerms:=[Customers_Orders:40]Terms:23
sShipVia:=[Customers_Orders:40]ShipVia:24
sEntBy:=[Customers_Orders:40]EnteredBy:7
sPOnum2:=[Customers_Orders:40]PONumber:11
If ((sPOnum2="") | (sPOnum2="N/A"))
	sPOnum2:="_______"
End if 

QUERY:C277([Salesmen:32]; [Salesmen:32]ID:1=[Customers_Orders:40]SalesRep:13)
sSalesman:=[Salesmen:32]FirstName:3+" "+[Salesmen:32]LastName:2+", "+[Salesmen:32]BusTitle:7

QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=[Customers_Orders:40]EstimateNo:3)
//QUERY([Work_Orders];[Work_Orders]id=[Estimates]EstimateNo)

//$numShiptos:=Records in selection([Work_Orders])
//$releases:=Sum([Work_Orders]Started)
//If ($releases<$numShiptos)
//$releases:=$numShiptos
//End if 
tRelSchd:=""  //String($numShiptos)+" 'ship to' locations , "+String($releases)+" releases total."

QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=[Estimates:17]EstimateNo:1; *)
QUERY:C277([Estimates_Carton_Specs:19];  & ; [Estimates_Carton_Specs:19]diffNum:11=[Customers_Orders:40]CaseScenario:4)
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	
	RELATE ONE SELECTION:C349([Estimates_Carton_Specs:19]; [Process_Specs:18])
	FIRST RECORD:C50([Process_Specs:18])
	
Else 
	
	RELATE ONE SELECTION:C349([Estimates_Carton_Specs:19]; [Process_Specs:18])
	
End if   // END 4D Professional Services : January 2019 First record
// 4D Professional Services : after Order by , query or any query type you don't need First record  

sStock:=""
sStamping:=""
sEmboss:="None"
iColors:=0
sCoating:=""
sPacking:=""
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
	
	While (Not:C34(End selection:C36([Process_Specs:18])))
		
		iColors:=iColors+[Process_Specs:18]ColorsNumGravur:25+[Process_Specs:18]ColorsNumLineOS:28+[Process_Specs:18]ColorsNumProcOS:30+[Process_Specs:18]ColorsNumScreen:34
		iColors:=iColors+Num:C11([Process_Specs:18]iAKcover:36)+Num:C11([Process_Specs:18]AKcover:39)
		iColors:=iColors+[Process_Specs:18]iColorGrav:55+[Process_Specs:18]iColorLL:56+[Process_Specs:18]iColorLP:57+[Process_Specs:18]iColorsSS:58
		
		$stock:=String:C10([Process_Specs:18]Caliper:8; "0.000#")+" "+[Process_Specs:18]Stock:7
		If (Position:C15($stock; sStock)=0)
			sStock:=sStock+$stock+"; "
		End if 
		
		If (([Process_Specs:18]Stamp1:41="") | ([Process_Specs:18]Stamp1:41=" "))
			//do nothing
		Else 
			sStamping:=sStamping+[Process_Specs:18]Stamp1:41
			If (([Process_Specs:18]LeafColor1:44="") | ([Process_Specs:18]LeafColor1:44=" "))
				sStamping:=sStamping+"; "
			Else 
				sStamping:=sStamping+"/"+[Process_Specs:18]LeafColor1:44+"; "
			End if 
		End if 
		
		If (([Process_Specs:18]Stamp2:42="") | ([Process_Specs:18]Stamp2:42=" "))
			//do nothing
		Else 
			sStamping:=sStamping+[Process_Specs:18]Stamp2:42
			If (([Process_Specs:18]LeafColor2:45="") | ([Process_Specs:18]LeafColor2:45=" "))
				sStamping:=sStamping+"; "
			Else 
				sStamping:=sStamping+"/"+[Process_Specs:18]LeafColor2:45+"; "
			End if 
		End if 
		If (([Process_Specs:18]Stamp3:43="") | ([Process_Specs:18]Stamp3:43=" "))
			//do nothing
		Else 
			sStamping:=sStamping+[Process_Specs:18]Stamp3:43
			If (([Process_Specs:18]LeafColor3:46="") | ([Process_Specs:18]LeafColor3:46=" "))
				sStamping:=sStamping+"; "
			Else 
				sStamping:=sStamping+"/"+[Process_Specs:18]LeafColor3:46+"; "
			End if 
		End if 
		
		If (sEmboss="None")
			If (([Process_Specs:18]Embossing:77) | ([Process_Specs:18]Embossing2:89))
				sEmboss:="Yes"
			End if 
		End if 
		
		If (([Process_Specs:18]Coat1Matl:14#"") & (Position:C15([Process_Specs:18]Coat1Matl:14; sCoating)=0))
			sCoating:=sCoating+[Process_Specs:18]Coat1Matl:14+"; "
		End if 
		If (([Process_Specs:18]Coat2Matl:16#"") & (Position:C15([Process_Specs:18]Coat2Matl:16; sCoating)=0))
			sCoating:=sCoating+[Process_Specs:18]Coat2Matl:16+"; "
		End if 
		If (([Process_Specs:18]Coat3Matl:18#"") & (Position:C15([Process_Specs:18]Coat3Matl:18; sCoating)=0))
			sCoating:=sCoating+[Process_Specs:18]Coat3Matl:18+"; "
		End if 
		If (([Process_Specs:18]iCoat1Matl:20#"") & (Position:C15([Process_Specs:18]iCoat1Matl:20; sCoating)=0))
			sCoating:=sCoating+[Process_Specs:18]iCoat1Matl:20+"; "
		End if 
		If (([Process_Specs:18]iCoat2Matl:22#"") & (Position:C15([Process_Specs:18]iCoat2Matl:22; sCoating)=0))
			sCoating:=sCoating+[Process_Specs:18]iCoat2Matl:22+"; "
		End if 
		If (([Process_Specs:18]iCoat3Matl:24#"") & (Position:C15([Process_Specs:18]iCoat3Matl:24; sCoating)=0))
			sCoating:=sCoating+[Process_Specs:18]iCoat3Matl:24+"; "
		End if 
		
		QUERY:C277([Process_Specs_Materials:56]; [Process_Specs_Materials:56]ProcessSpec:1=[Process_Specs:18]ID:1; *)
		QUERY:C277([Process_Specs_Materials:56];  & ; [Process_Specs_Materials:56]Commodity_Key:8="06@")
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			For ($i; 1; Records in selection:C76([Process_Specs_Materials:56]))
				$pack:=Substring:C12([Process_Specs_Materials:56]Commodity_Key:8; 4)
				If (Position:C15($pack; sPacking)=0)
					sPacking:=sPacking+$pack+"; "
				End if 
				NEXT RECORD:C51([Process_Specs_Materials:56])
			End for 
			
		Else 
			
			ARRAY TEXT:C222($_Commodity_Key; 0)
			SELECTION TO ARRAY:C260([Process_Specs_Materials:56]Commodity_Key:8; $_Commodity_Key)
			
			For ($i; 1; Size of array:C274($_Commodity_Key); 1)
				$pack:=Substring:C12($_Commodity_Key{$i}; 4)
				If (Position:C15($pack; sPacking)=0)
					sPacking:=sPacking+$pack+"; "
				End if 
				
			End for 
			
		End if   // END 4D Professional Services : January 2019 First record
		
		NEXT RECORD:C51([Process_Specs:18])
	End while 
	
Else 
	
	ARRAY BOOLEAN:C223($_iAKcover; 0)
	ARRAY BOOLEAN:C223($_AKcover; 0)
	ARRAY BOOLEAN:C223($_Embossing; 0)
	ARRAY BOOLEAN:C223($_Embossing2; 0)
	ARRAY TEXT:C222($_ID; 0)
	ARRAY TEXT:C222($_iCoat1Matl; 0)
	ARRAY TEXT:C222($_iCoat2Matl; 0)
	ARRAY TEXT:C222($_iCoat3Matl; 0)
	ARRAY TEXT:C222($_Coat1Matl; 0)
	ARRAY TEXT:C222($_Coat2Matl; 0)
	ARRAY TEXT:C222($_Coat3Matl; 0)
	ARRAY TEXT:C222($_LeafColor1; 0)
	ARRAY TEXT:C222($_LeafColor2; 0)
	ARRAY TEXT:C222($_LeafColor3; 0)
	ARRAY TEXT:C222($_Stamp1; 0)
	ARRAY TEXT:C222($_Stamp2; 0)
	ARRAY TEXT:C222($_Stamp3; 0)
	ARRAY TEXT:C222($_Stock; 0)
	ARRAY INTEGER:C220($_iColorGrav; 0)
	ARRAY INTEGER:C220($_iColorLL; 0)
	ARRAY INTEGER:C220($_iColorLP; 0)
	ARRAY INTEGER:C220($_iColorsSS; 0)
	ARRAY INTEGER:C220($_ColorsNumGravur; 0)
	ARRAY INTEGER:C220($_ColorsNumLineOS; 0)
	ARRAY INTEGER:C220($_ColorsNumProcOS; 0)
	ARRAY INTEGER:C220($_ColorsNumScreen; 0)
	ARRAY REAL:C219($_Caliper; 0)
	
	SELECTION TO ARRAY:C260([Process_Specs:18]ID:1; $_ID; \
		[Process_Specs:18]iCoat1Matl:20; $_iCoat1Matl; \
		[Process_Specs:18]iCoat2Matl:22; $_iCoat2Matl; \
		[Process_Specs:18]iCoat3Matl:24; $_iCoat3Matl; \
		[Process_Specs:18]Coat1Matl:14; $_Coat1Matl; \
		[Process_Specs:18]Coat2Matl:16; $_Coat2Matl; \
		[Process_Specs:18]Coat3Matl:18; $_Coat3Matl; \
		[Process_Specs:18]Embossing:77; $_Embossing; \
		[Process_Specs:18]Embossing2:89; $_Embossing2; \
		[Process_Specs:18]LeafColor1:44; $_LeafColor1; \
		[Process_Specs:18]LeafColor2:45; $_LeafColor2; \
		[Process_Specs:18]LeafColor3:46; $_LeafColor3; \
		[Process_Specs:18]Stamp1:41; $_Stamp1; \
		[Process_Specs:18]Stamp2:42; $_Stamp2; \
		[Process_Specs:18]Stamp3:43; $_Stamp3; \
		[Process_Specs:18]Caliper:8; $_Caliper; \
		[Process_Specs:18]Stock:7; $_Stock; \
		[Process_Specs:18]iColorGrav:55; $_iColorGrav; \
		[Process_Specs:18]iColorLL:56; $_iColorLL; \
		[Process_Specs:18]iColorLP:57; $_iColorLP; \
		[Process_Specs:18]iColorsSS:58; $_iColorsSS; \
		[Process_Specs:18]iAKcover:36; $_iAKcover; \
		[Process_Specs:18]AKcover:39; $_AKcover; \
		[Process_Specs:18]ColorsNumGravur:25; $_ColorsNumGravur; \
		[Process_Specs:18]ColorsNumLineOS:28; $_ColorsNumLineOS; \
		[Process_Specs:18]ColorsNumProcOS:30; $_ColorsNumProcOS; \
		[Process_Specs:18]ColorsNumScreen:34; $_ColorsNumScreen)
	
	For ($Iter; 1; Size of array:C274($_AKcover); 1)
		
		
		
		iColors:=iColors+$_ColorsNumGravur{$Iter}+$_ColorsNumLineOS{$Iter}+$_ColorsNumProcOS{$Iter}+$_ColorsNumScreen{$Iter}
		iColors:=iColors+Num:C11($_iAKcover{$Iter})+Num:C11($_AKcover{$Iter})
		iColors:=iColors+$_iColorGrav{$Iter}+$_iColorLL{$Iter}+$_iColorLP{$Iter}+$_iColorsSS{$Iter}
		
		$stock:=String:C10($_Caliper{$Iter}; "0.000#")+" "+$_Stock{$Iter}
		If (Position:C15($stock; sStock)=0)
			sStock:=sStock+$stock+"; "
		End if 
		
		If (($_Stamp1{$Iter}="") | ($_Stamp1{$Iter}=" "))
			//do nothing
		Else 
			sStamping:=sStamping+$_Stamp1{$Iter}
			If (($_LeafColor1{$Iter}="") | ($_LeafColor1{$Iter}=" "))
				sStamping:=sStamping+"; "
			Else 
				sStamping:=sStamping+"/"+$_LeafColor1{$Iter}+"; "
			End if 
		End if 
		
		If (($_Stamp2{$Iter}="") | ($_Stamp2{$Iter}=" "))
			//do nothing
		Else 
			sStamping:=sStamping+$_Stamp2{$Iter}
			If (($_LeafColor2{$Iter}="") | ($_LeafColor2{$Iter}=" "))
				sStamping:=sStamping+"; "
			Else 
				sStamping:=sStamping+"/"+$_LeafColor2{$Iter}+"; "
			End if 
		End if 
		If (($_Stamp3{$Iter}="") | ($_Stamp3{$Iter}=" "))
			//do nothing
		Else 
			sStamping:=sStamping+$_Stamp3{$Iter}
			If (($_LeafColor3{$Iter}="") | ($_LeafColor3{$Iter}=" "))
				sStamping:=sStamping+"; "
			Else 
				sStamping:=sStamping+"/"+$_LeafColor3{$Iter}+"; "
			End if 
		End if 
		
		If (sEmboss="None")
			If (($_Embossing{$Iter}) | ($_Embossing2{$Iter}))
				sEmboss:="Yes"
			End if 
		End if 
		
		If (($_Coat1Matl{$Iter}#"") & (Position:C15($_Coat1Matl{$Iter}; sCoating)=0))
			sCoating:=sCoating+$_Coat1Matl{$Iter}+"; "
		End if 
		If (($_Coat2Matl{$Iter}#"") & (Position:C15($_Coat2Matl{$Iter}; sCoating)=0))
			sCoating:=sCoating+$_Coat2Matl{$Iter}+"; "
		End if 
		If (($_Coat3Matl{$Iter}#"") & (Position:C15($_Coat3Matl{$Iter}; sCoating)=0))
			sCoating:=sCoating+$_Coat3Matl{$Iter}+"; "
		End if 
		If (($_iCoat1Matl{$Iter}#"") & (Position:C15($_iCoat1Matl{$Iter}; sCoating)=0))
			sCoating:=sCoating+$_iCoat1Matl{$Iter}+"; "
		End if 
		If (($_iCoat2Matl{$Iter}#"") & (Position:C15($_iCoat2Matl{$Iter}; sCoating)=0))
			sCoating:=sCoating+$_iCoat2Matl{$Iter}+"; "
		End if 
		If (($_iCoat3Matl{$Iter}#"") & (Position:C15($_iCoat3Matl{$Iter}; sCoating)=0))
			sCoating:=sCoating+$_iCoat3Matl{$Iter}+"; "
		End if 
		
		QUERY:C277([Process_Specs_Materials:56]; [Process_Specs_Materials:56]ProcessSpec:1=$_ID{$Iter}; *)
		QUERY:C277([Process_Specs_Materials:56];  & ; [Process_Specs_Materials:56]Commodity_Key:8="06@")
		ARRAY TEXT:C222($_Commodity_Key; 0)
		SELECTION TO ARRAY:C260([Process_Specs_Materials:56]Commodity_Key:8; $_Commodity_Key)
		
		For ($i; 1; Size of array:C274($_Commodity_Key); 1)
			$pack:=Substring:C12($_Commodity_Key{$i}; 4)
			If (Position:C15($pack; sPacking)=0)
				sPacking:=sPacking+$pack+"; "
			End if 
			
		End for 
		
	End for 
	
End if   // END 4D Professional Services : January 2019 


If (sStamping="")
	sStamping:="None."
End if 

QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderNumber:1=[Customers_Orders:40]OrderNumber:1)  //•100496  MLB  
ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3; >)  //•100496  MLB 

lTotQty:=Sum:C1([Customers_Order_Lines:41]Quantity:6)
rTotal:=[Customers_Orders:40]OrderSalesTotal:19
TRACE:C157
FORM SET OUTPUT:C54([Customers_Orders:40]; "RptOrderAckn")
util_PAGE_SETUP(->[Customers_Orders:40]; "RptOrderAckn")
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	COPY NAMED SELECTION:C331([Customers_Orders:40]; "RptOrdAckn")
	
	
Else 
	
	ARRAY LONGINT:C221($_RptOrdAckn; 0)
	LONGINT ARRAY FROM SELECTION:C647([Customers_Orders:40]; $_RptOrdAckn)
	
	
End if   // END 4D Professional Services : January 2019 
ONE RECORD SELECT:C189([Customers_Orders:40])
//INPUT LAYOUT([CustomerOrder];"OrderAcknMissin")
//MODIFY RECORD([CustomerOrder];"OrderAcknMissin")
// The above line is used for identifying missing Items.
If (OK=1)
	i:=0
	PRINT SELECTION:C60([Customers_Orders:40])
	If ($sendEmail)
		FIRST RECORD:C50([Customers_Orders:40])
		Order_Ack_Email
	End if 
End if 
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	USE NAMED SELECTION:C332("RptOrdAckn")
	CLEAR NAMED SELECTION:C333("RptOrdAckn")
	
Else 
	
	CREATE SELECTION FROM ARRAY:C640([Customers_Orders:40]; $_RptOrdAckn)
	LOAD RECORD:C52([Customers_Orders:40])  // Added by: Mel Bohince (4/21/19) 
	
End if   // END 4D Professional Services : January 2019 

//INPUT LAYOUT([CustomerOrder];"Input")
FORM SET OUTPUT:C54([Customers_Orders:40]; "List")