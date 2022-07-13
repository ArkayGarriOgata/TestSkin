//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 08/05/10, 12:40:14
// ----------------------------------------------------
// Method: FG_William_Lea_Rpt
// Description
// arden extract for their spreadsheet completion
// ----------------------------------------------------

C_LONGINT:C283($i; $numFG; $numJMI; $volume)
C_TEXT:C284($t; $cr)
C_TEXT:C284(xTitle; xText; xRemark)
C_TIME:C306($docRef)
C_BOOLEAN:C305($continue)

$t:=Char:C90(9)
$cr:=Char:C90(13)

READ ONLY:C145([Customers:16])
QUERY:C277([Customers:16])
If (Records in selection:C76([Customers:16])>0)
	
	If (Not:C34(<>modification4D_10_05_19))  // BEGIN 4D Professional Services : Query With array
		SELECTION TO ARRAY:C260([Customers:16]ID:1; $aCustId)
		REDUCE SELECTION:C351([Customers:16]; 0)
		
		READ ONLY:C145([Finished_Goods:26])
		QUERY WITH ARRAY:C644([Finished_Goods:26]CustID:2; $aCustId)
		
	Else 
		
		READ ONLY:C145([Finished_Goods:26])
		RELATE MANY SELECTION:C340([Finished_Goods:26]CustID:2)
		REDUCE SELECTION:C351([Customers:16]; 0)
		
	End if   // END 4D Professional Services : January 2019 
	
	$numFG:=Records in selection:C76([Finished_Goods:26])
	If ($numFG>0)
		
		uConfirm(String:C10($numFG)+" finished good records found, extract all or refine search?"; "Refine"; "All")
		If (OK=1)
			QUERY SELECTION:C341([Finished_Goods:26])
			$numFG:=Records in selection:C76([Finished_Goods:26])
			If ($numFG>0)
				$continue:=True:C214
			Else 
				$continue:=False:C215
				BEEP:C151
				ALERT:C41("No finished goods were found with that criterian.")
			End if 
		Else 
			$continue:=True:C214
		End if 
		
		If ($continue)
			ORDER BY:C49([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1; >)
			
			docName:="William_Lea_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
			$docRef:=util_putFileName(->docName)
			If (OK=1)
				xTitle:="William Lea Extract - "+fYYMMDD(4D_Current_date)+$cr
				SEND PACKET:C103($docRef; xTitle)
				xText:="Promo_or_Basic"+$t+"SKU"+$t+"Brand"+$t+"Sub_Brand"+$t+"Item_Description"+$t+"Grouping"+$t+"Volume"+$t+"Runs"+$t+"Length"+$t+"Width"+$t+"Height"+$t+"Style"+$t
				xText:=xText+"SizeABC"+$t+"Board"+$t+"Caliper"+$t+"Method"+$t+"Colors_Front"+$t+"Colors_Back"+$t+"Coat_Lam"+$t+"Colors_Stamp"+$t+"Embossing"+$t+"DieCut"+$t
				xText:=xText+"Windowing"+$t+"WindowSize"+$t+"WindowMatl"+$t+"ShipTo"+$t+"Comments"
				xText:=xText+$cr
				pattern_LoopRecords
				
				uThermoInit($numFG; "Updating Records")
				If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
					
					
					For ($i; 1; $numFG)
						$promo:=Substring:C12([Finished_Goods:26]OrderType:59; 1; 1)
						If ($promo="R")
							$promo:="B"  //convert to their terms
						End if 
						
						xRemark:=[Finished_Goods:26]CartonDesc:3
						xRemark:=Replace string:C233(xRemark; $cr; "<cr>")
						xRemark:=Replace string:C233(xRemark; $t; "<tab>")
						xRemark:=Replace string:C233(xRemark; Char:C90(Double quote:K15:41); "<q>")
						txt_Gremlinizer(->xRemark)
						
						READ ONLY:C145([Job_Forms_Items:44])
						$beginDate:=Add to date:C393(4D_Current_date; -1; 0; 0)
						QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=[Finished_Goods:26]ProductCode:1; *)
						QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Glued:33>=$beginDate; *)
						QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Glued:33<4D_Current_date)
						$numJMI:=Records in selection:C76([Job_Forms_Items:44])
						If ($numJMI>0)
							$volume:=Sum:C1([Job_Forms_Items:44]Qty_Want:24)
						Else 
							$volume:=0
						End if 
						
						READ ONLY:C145([Process_Specs:18])
						QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=[Finished_Goods:26]ProcessSpec:33; *)
						QUERY:C277([Process_Specs:18];  & ; [Process_Specs:18]Cust_ID:4=[Finished_Goods:26]CustID:2)
						$front:=[Process_Specs:18]ColorsFlexo:37+[Process_Specs:18]ColorsNumLineOS:28+[Process_Specs:18]ColorsNumProcOS:30+[Process_Specs:18]ColorsNumScreen:34
						$back:=[Process_Specs:18]iColorLL:56+[Process_Specs:18]iColorLP:57+[Process_Specs:18]iColorsSS:58
						$num_stamping_colors:=""  //[Process_Specs]LeafColor1
						$embossing:="n"  //[Process_Specs]Embossing
						$die_cutting:="n"
						$coating:=""
						
						If (Length:C16([Process_Specs:18]LeafColor1:44)#0)
							$num_stamping_colors:=String:C10(Num:C11($num_stamping_colors)+1)
						End if 
						If (Length:C16([Process_Specs:18]LeafColor2:45)#0)
							$num_stamping_colors:=String:C10(Num:C11($num_stamping_colors)+1)
						End if 
						If (Length:C16([Process_Specs:18]LeafColor3:46)#0)
							$num_stamping_colors:=String:C10(Num:C11($num_stamping_colors)+1)
						End if 
						
						If (([Process_Specs:18]Embossing:77) | ([Process_Specs:18]Embossing2:89))
							$embossing:="y"
						End if 
						
						If ([Process_Specs:18]DieCut:51)
							$die_cutting:="y"
						End if 
						
						If ([Process_Specs:18]SpotCoat1:73) | ([Process_Specs:18]SpotCoat2:74) | ([Process_Specs:18]SpotCoat3:75)
							$coating:="spot "
						End if 
						
						If (Length:C16([Process_Specs:18]Coat1Matl:14)>0)
							$coating:=$coating+[Process_Specs:18]Coat1Matl:14
						End if 
						If (Length:C16([Process_Specs:18]Coat2Matl:16)>0)
							$coating:=$coating+" "+[Process_Specs:18]Coat2Matl:16
						End if 
						If (Length:C16([Process_Specs:18]Coat3Matl:18)>0)
							$coating:=$coating+" "+[Process_Specs:18]Coat3Matl:18
						End if 
						
						READ ONLY:C145([Customers_ReleaseSchedules:46])
						QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=[Finished_Goods:26]ProductCode:1; *)
						QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Shipto:10#"")
						$shiptoID:=[Customers_ReleaseSchedules:46]Shipto:10
						READ ONLY:C145([Addresses:30])
						QUERY:C277([Addresses:30]; [Addresses:30]ID:1=$shiptoID)
						$shipto:=[Addresses:30]Name:2
						
						READ ONLY:C145([Finished_Goods_SizeAndStyles:132])
						QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]FileOutlineNum:1=[Finished_Goods:26]OutLine_Num:4)
						
						$windowed:="n"
						$window_size:=""
						$window_matl:=""
						If ([Finished_Goods:26]WindowGauge:40#0) | ([Finished_Goods:26]WindowHth:42#0) | ([Finished_Goods:26]WindowHth:42#0) | (Length:C16([Finished_Goods:26]WindowMatl:39)#0)
							$windowed:="y"
							$window_size:=String:C10([Finished_Goods:26]WindowHth:42)+"x"+String:C10([Finished_Goods:26]WindowWth:41)
							$window_matl:=[Finished_Goods:26]WindowMatl:39
						End if 
						
						$comment:=[Finished_Goods:26]ControlNumber:61+"/"+[Finished_Goods:26]OutLine_Num:4+"/"+[Finished_Goods:26]ProcessSpec:33
						$comment:=Replace string:C233($comment; $cr; "<cr>")
						$comment:=Replace string:C233($comment; $t; "<tab>")
						$comment:=Replace string:C233($comment; Char:C90(Double quote:K15:41); "<q>")
						txt_Gremlinizer(->$comment)
						
						xText:=xText+$promo+$t+[Finished_Goods:26]ProductCode:1+$t+[Finished_Goods:26]Line_Brand:15+$t+"n/a"+$t+xRemark+$t+"n/a"+$t+String:C10($volume)+$t+String:C10($numJMI)+$t
						xText:=xText+[Finished_Goods_SizeAndStyles:132]Dim_A:17+$t+[Finished_Goods_SizeAndStyles:132]Dim_B:18+$t+[Finished_Goods_SizeAndStyles:132]Dim_Ht:19+$t+[Finished_Goods_SizeAndStyles:132]Style:14+$t+"n/a"+$t+Replace string:C233([Finished_Goods_SizeAndStyles:132]StockType:20; Char:C90(Double quote:K15:41); "<q>")+$t+String:C10([Finished_Goods_SizeAndStyles:132]StockCaliper:21)+$t
						xText:=xText+"offset"+$t+String:C10($front)+$t+String:C10($back)+$t+$coating+$t+$num_stamping_colors+$t+$embossing+$t+$die_cutting+$t+$windowed+$t+$window_size+$t+$window_matl+$t+$shipto+$t+[Finished_Goods:26]ControlNumber:61+"/"+[Finished_Goods:26]OutLine_Num:4+"/"+[Finished_Goods:26]ProcessSpec:33
						xText:=xText+$cr
						
						If (Length:C16(xText)>20000)
							SEND PACKET:C103($docRef; xText)
							xText:=""
						End if 
						
						NEXT RECORD:C51([Finished_Goods:26])
						uThermoUpdate($i)
					End for 
					
					
				Else 
					ARRAY TEXT:C222($_OrderType; 0)
					ARRAY TEXT:C222($_CartonDesc; 0)
					ARRAY TEXT:C222($_ProductCode; 0)
					ARRAY TEXT:C222($_ProcessSpec; 0)
					ARRAY TEXT:C222($_CustID; 0)
					ARRAY TEXT:C222($_ProductCode; 0)
					ARRAY TEXT:C222($_Line_Brand; 0)
					ARRAY TEXT:C222($_OutLine_Num; 0)
					ARRAY REAL:C219($_WindowGauge; 0)
					ARRAY REAL:C219($_WindowHth; 0)
					ARRAY TEXT:C222($_WindowMatl; 0)
					ARRAY REAL:C219($_WindowWth; 0)
					ARRAY TEXT:C222($_OutLine_Num; 0)
					ARRAY TEXT:C222($_ProcessSpec; 0)
					ARRAY TEXT:C222($_Line_Brand; 0)
					ARRAY TEXT:C222($_ControlNumber; 0)
					
					
					SELECTION TO ARRAY:C260([Finished_Goods:26]OrderType:59; $_OrderType; \
						[Finished_Goods:26]CartonDesc:3; $_CartonDesc; \
						[Finished_Goods:26]ProductCode:1; $_ProductCode; \
						[Finished_Goods:26]ProcessSpec:33; $_ProcessSpec; \
						[Finished_Goods:26]CustID:2; $_CustID; \
						[Finished_Goods:26]ProductCode:1; $_ProductCode; \
						[Finished_Goods:26]Line_Brand:15; $_Line_Brand; \
						[Finished_Goods:26]OutLine_Num:4; $_OutLine_Num; \
						[Finished_Goods:26]WindowGauge:40; $_WindowGauge; \
						[Finished_Goods:26]WindowHth:42; $_WindowHth; \
						[Finished_Goods:26]WindowMatl:39; $_WindowMatl; \
						[Finished_Goods:26]WindowWth:41; $_WindowWth; \
						[Finished_Goods:26]OutLine_Num:4; $_OutLine_Num; \
						[Finished_Goods:26]ProcessSpec:33; $_ProcessSpec; \
						[Finished_Goods:26]Line_Brand:15; $_Line_Brand; \
						[Finished_Goods:26]ControlNumber:61; $_ControlNumber)
					
					
					For ($i; 1; $numFG; 1)
						$promo:=Substring:C12($_OrderType{$i}; 1; 1)
						If ($promo="R")
							$promo:="B"  //convert to their terms
						End if 
						
						xRemark:=$_CartonDesc{$i}
						xRemark:=Replace string:C233(xRemark; $cr; "<cr>")
						xRemark:=Replace string:C233(xRemark; $t; "<tab>")
						xRemark:=Replace string:C233(xRemark; Char:C90(Double quote:K15:41); "<q>")
						txt_Gremlinizer(->xRemark)
						
						READ ONLY:C145([Job_Forms_Items:44])
						$beginDate:=Add to date:C393(4D_Current_date; -1; 0; 0)
						QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=$_ProductCode{$i}; *)
						QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Glued:33>=$beginDate; *)
						QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Glued:33<4D_Current_date)
						$numJMI:=Records in selection:C76([Job_Forms_Items:44])
						If ($numJMI>0)
							$volume:=Sum:C1([Job_Forms_Items:44]Qty_Want:24)
						Else 
							$volume:=0
						End if 
						
						READ ONLY:C145([Process_Specs:18])
						QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=$_ProcessSpec{$i}; *)
						QUERY:C277([Process_Specs:18];  & ; [Process_Specs:18]Cust_ID:4=$_CustID{$i})
						$front:=[Process_Specs:18]ColorsFlexo:37+[Process_Specs:18]ColorsNumLineOS:28+[Process_Specs:18]ColorsNumProcOS:30+[Process_Specs:18]ColorsNumScreen:34
						$back:=[Process_Specs:18]iColorLL:56+[Process_Specs:18]iColorLP:57+[Process_Specs:18]iColorsSS:58
						$num_stamping_colors:=""  //[Process_Specs]LeafColor1
						$embossing:="n"  //[Process_Specs]Embossing
						$die_cutting:="n"
						$coating:=""
						
						If (Length:C16([Process_Specs:18]LeafColor1:44)#0)
							$num_stamping_colors:=String:C10(Num:C11($num_stamping_colors)+1)
						End if 
						If (Length:C16([Process_Specs:18]LeafColor2:45)#0)
							$num_stamping_colors:=String:C10(Num:C11($num_stamping_colors)+1)
						End if 
						If (Length:C16([Process_Specs:18]LeafColor3:46)#0)
							$num_stamping_colors:=String:C10(Num:C11($num_stamping_colors)+1)
						End if 
						
						If (([Process_Specs:18]Embossing:77) | ([Process_Specs:18]Embossing2:89))
							$embossing:="y"
						End if 
						
						If ([Process_Specs:18]DieCut:51)
							$die_cutting:="y"
						End if 
						
						If ([Process_Specs:18]SpotCoat1:73) | ([Process_Specs:18]SpotCoat2:74) | ([Process_Specs:18]SpotCoat3:75)
							$coating:="spot "
						End if 
						
						If (Length:C16([Process_Specs:18]Coat1Matl:14)>0)
							$coating:=$coating+[Process_Specs:18]Coat1Matl:14
						End if 
						If (Length:C16([Process_Specs:18]Coat2Matl:16)>0)
							$coating:=$coating+" "+[Process_Specs:18]Coat2Matl:16
						End if 
						If (Length:C16([Process_Specs:18]Coat3Matl:18)>0)
							$coating:=$coating+" "+[Process_Specs:18]Coat3Matl:18
						End if 
						
						READ ONLY:C145([Customers_ReleaseSchedules:46])
						QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$_ProductCode{$i}; *)
						QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Shipto:10#"")
						$shiptoID:=[Customers_ReleaseSchedules:46]Shipto:10
						READ ONLY:C145([Addresses:30])
						QUERY:C277([Addresses:30]; [Addresses:30]ID:1=$shiptoID)
						$shipto:=[Addresses:30]Name:2
						
						READ ONLY:C145([Finished_Goods_SizeAndStyles:132])
						QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]FileOutlineNum:1=$_OutLine_Num{$i})
						
						$windowed:="n"
						$window_size:=""
						$window_matl:=""
						If ($_WindowGauge{$i}#0) | ($_WindowHth{$i}#0) | ($_WindowHth{$i}#0) | (Length:C16($_WindowMatl{$i})#0)
							$windowed:="y"
							$window_size:=String:C10($_WindowHth{$i})+"x"+String:C10($_WindowWth)
							$window_matl:=$_WindowMatl{$i}
						End if 
						
						$comment:=$_ControlNumber{$i}+"/"+$_OutLine_Num{$i}+"/"+$_ProcessSpec{$i}
						$comment:=Replace string:C233($comment; $cr; "<cr>")
						$comment:=Replace string:C233($comment; $t; "<tab>")
						$comment:=Replace string:C233($comment; Char:C90(Double quote:K15:41); "<q>")
						txt_Gremlinizer(->$comment)
						
						xText:=xText+$promo+$t+$_ProductCode{$i}+$t+$_Line_Brand{$i}+$t+"n/a"+$t+xRemark+$t+"n/a"+$t+String:C10($volume)+$t+String:C10($numJMI)+$t
						xText:=xText+[Finished_Goods_SizeAndStyles:132]Dim_A:17+$t+[Finished_Goods_SizeAndStyles:132]Dim_B:18+$t+[Finished_Goods_SizeAndStyles:132]Dim_Ht:19+$t+[Finished_Goods_SizeAndStyles:132]Style:14+$t+"n/a"+$t+Replace string:C233([Finished_Goods_SizeAndStyles:132]StockType:20; Char:C90(Double quote:K15:41); "<q>")+$t+String:C10([Finished_Goods_SizeAndStyles:132]StockCaliper:21)+$t
						xText:=xText+"offset"+$t+String:C10($front)+$t+String:C10($back)+$t+$coating+$t+$num_stamping_colors+$t+$embossing+$t+$die_cutting+$t+$windowed+$t+$window_size+$t+$window_matl+$t+$shipto+$t+$_ControlNumber{$i}+"/"+$_OutLine_Num{$i}+"/"+$_ProcessSpec{$i}
						xText:=xText+$cr
						
						If (Length:C16(xText)>20000)
							SEND PACKET:C103($docRef; xText)
							xText:=""
						End if 
						
						uThermoUpdate($i)
					End for 
					
					
				End if   // END 4D Professional Services : January 2019 
				uThermoClose
				
				SEND PACKET:C103($docRef; xText)
				CLOSE DOCUMENT:C267($docRef)
				// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
				$err:=util_Launch_External_App(docName)
				BEEP:C151
				BEEP:C151
				
			Else 
				BEEP:C151
				ALERT:C41("Couldn't save document.")
			End if   //open doc
			
		End if   //continue
		
	Else 
		BEEP:C151
		ALERT:C41("Report cancelled, no finished goods found for the customer entered.")
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("Report cancelled, enter the search criteria for a customer and click OK.")
End if   //did search
REDUCE SELECTION:C351([Finished_Goods:26]; 0)