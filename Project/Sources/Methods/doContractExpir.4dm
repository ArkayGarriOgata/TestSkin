//%attributes = {"publishedWeb":true}
//Procedure: doContractExpir()  090895  MLB
//•090895  MLB  UPR 993 Automate the sending of 
//. Avon Contract Expiration Information by
//. creating a text file that Exsiting FileMakerPro 
//. application can import and print on custom form.
//091295 change from date complete to opened & permitt varing the months
//•011996  MLB  Scott said the Mitchel said that SteveO said to use need date 
//                  rather than open date
//•012596  mBohince  HTK wants total stock, not just for perticular order,
//          The user of the FMpro must then determine allocations
//•031397  mBohince  fix search
//•071697  mBohince  add custid and name to export
//•080897  mBohince  add custid and name heading to export
//•082997  MLB  add payuse
//051198  mBohince patty says use need date, not OpenedDate

MESSAGES OFF:C175

C_LONGINT:C283($i; $numCust; $openOLs; $expirations; $priorNotice; $hit; $balance; $TotalStock; $months; $expireMths)
C_TIME:C306($textDoc)
C_TEXT:C284($parentCorp)
C_TEXT:C284($t; $cr)
C_TEXT:C284($payUse)
C_DATE:C307($cutOffDate)

$priorNotice:=0
$expireMths:=9
$t:=Char:C90(9)
$cr:=Char:C90(13)
$payUse:=""
$months:=Num:C11(Request:C163("How many months old should the target contracts be?"; String:C10($expireMths)))
If ((OK=0) | ($months<1))
	BEEP:C151
	ALERT:C41(String:C10($expireMths)+" months will be used for cut off.")
	$months:=$expireMths
End if 

$cutOffDate:=4D_Current_date-(365*($months/12))
ARRAY TEXT:C222($aDest; 7)
$aDest{1}:="Suffern"
$aDest{2}:="Springdale"
$aDest{3}:="Morton Grove"
$aDest{4}:="U.K."
$aDest{5}:="Germany"
$aDest{6}:="Canada"
//$aDest{7}:="Jeweler"
$aDest{7}:="Other"
ARRAY TEXT:C222($aDestId; 9)
$aDestId{1}:="00492"
$aDestId{2}:="00561"
$aDestId{3}:="00562"
$aDestId{4}:="00621"
$aDestId{5}:="00668"  //|01053 see below at 9
$aDestId{6}:="00550"  //|00580 see below at 10
//$aDestId{7}:="@"
$aDestId{7}:="@"
$aDestId{8}:="01053"
$aDestId{9}:="00580"
ARRAY LONGINT:C221($aOrdered; 7)
ARRAY LONGINT:C221($aShipped; 7)
READ ONLY:C145([Customers:16])
READ WRITE:C146([Customers_Order_Lines:41])
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
	
	CREATE EMPTY SET:C140([Customers_Order_Lines:41]; "OpenNiners")
	CREATE EMPTY SET:C140([Customers_Order_Lines:41]; "TheseToo")
	CREATE EMPTY SET:C140([Customers_Order_Lines:41]; "Expirations")
	
	
Else 
	
	
End if   // END 4D Professional Services : January 2019 

//*Interrogate user before long process begins

//*.   Open a text file
$textDoc:=Create document:C266("")
If (OK=1)
	//send column headers
	SEND PACKET:C103($textDoc; "cpn"+$t+"desc"+$t+"po"+$t+"NeedDate"+$t+"dateExpired"+$t+"price"+$t)
	For ($i; 1; 7)
		SEND PACKET:C103($textDoc; $aDest{$i}+"-"+$aDestId{$i}+" order&shipped"+$t+$t)
	End for 
	SEND PACKET:C103($textDoc; "balance"+$t+"stock"+$t)
	SEND PACKET:C103($textDoc; "CustId"+$t+"CustName"+$t)  //•080897  mBohince  add custid and name heading to export
	SEND PACKET:C103($textDoc; "PayUse")  //•082997  mBohince  add payuse and name heading to export
	SEND PACKET:C103($textDoc; $cr)
	//*.   Set spl options
	$parentCorp:=Request:C163("What is the parent corporation?"; "Avon Companies")
	If (OK=1)
		NewWindow(350; 75; 3; -722; "Contract Expirations")
		//*Get the Avon companies
		MESSAGE:C88(" Searching for the subsidaries of "+$parentCorp)
		$numCust:=qryCustomer(->[Customers:16]ParentCorp:19; $parentCorp)
		If ($numCust>0)
			SELECTION TO ARRAY:C260([Customers:16]ID:1; $aCustId)
			//*Get the Avon orders nine months and older
			MESSAGE:C88($cr+" Searching for the open orderlines older than "+String:C10(($cutOffDate+1); <>SHORTDATE))
			qryOpenOrdLines("*")
			//SEARCH([OrderLines]; & [OrderLines]DateOpened<=$cutOffDate)  `091295`•031397  mB
			QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]NeedDate:14<=$cutOffDate)  //051198  mBohince 
			$openOLs:=Records in selection:C76([Customers_Order_Lines:41])  // these are the over nine month opens
			If ($openOLs>0)
				If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
					
					CREATE SET:C116([Customers_Order_Lines:41]; "OpenNiners")
					MESSAGE:C88($cr+" Searching those orderlines for ones belonging to "+$parentCorp)
					For ($i; 1; $numCust)  //pick out the orderlines that belong to this parent corp
						USE SET:C118("OpenNiners")
						QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4=$aCustId{$i})
						If (Records in selection:C76([Customers_Order_Lines:41])>0)
							CREATE SET:C116([Customers_Order_Lines:41]; "TheseToo")
							UNION:C120("Expirations"; "TheseToo"; "Expirations")
						End if 
						
					End for 
					USE SET:C118("Expirations")
					
				Else 
					
					
					MESSAGE:C88($cr+" Searching those orderlines for ones belonging to "+$parentCorp)
					QUERY SELECTION WITH ARRAY:C1050([Customers_Order_Lines:41]CustID:4; $aCustId)
					
				End if   // END 4D Professional Services : January 2019 
				
				$expirations:=Records in selection:C76([Customers_Order_Lines:41])
				If ($expirations>0)
					//*For each candidate order:
					
					MESSAGE:C88($cr+" Processing "+String:C10($expirations)+" expirations...")
					uThermoInit($expirations; "Exporting Contract Expiratons")
					For ($i; 1; $expirations)
						//*.   Exclude ones that have already been notified
						If ([Customers_Order_Lines:41]_NotifiedOfExpir:39=!00-00-00!)
							//*.   Get the header infomation
							qryFinishedGood([Customers_Order_Lines:41]CustID:4; [Customers_Order_Lines:41]ProductCode:5)
							$custName:=[Customers_Order_Lines:41]CustomerName:24  //•071697  mBohince  
							$custid:=[Customers_Order_Lines:41]CustID:4  //•071697  mBohince 
							If ([Customers_Order_Lines:41]PayUse:47)  //•082997  MLB 
								$payUse:="True"
							Else 
								$payUse:="False"
							End if 
							$cpn:=[Customers_Order_Lines:41]ProductCode:5
							$desc:=[Finished_Goods:26]CartonDesc:3
							$po:=[Customers_Order_Lines:41]PONumber:21
							$dateOpened:=String:C10([Customers_Order_Lines:41]NeedDate:14; <>SHORTDATE)  //String([OrderLines]DateOpened;◊SHORTDATE)
							$price:=String:C10([Customers_Order_Lines:41]Price_Per_M:8)
							$dateExpired:=String:C10(([Customers_Order_Lines:41]NeedDate:14+(365*($expireMths/12))); <>SHORTDATE)  //String(([OrderLines]DateOpened+(365*($expireMths/12)));◊SHORTDATE)
							//*.   Determine past shipment info
							ARRAY LONGINT:C221($aOrdered; 0)
							ARRAY LONGINT:C221($aShipped; 0)
							ARRAY LONGINT:C221($aOrdered; 7)
							ARRAY LONGINT:C221($aShipped; 7)
							
							$hit:=Find in array:C230($aDestId; [Customers_Order_Lines:41]defaultShipTo:17)
							Case of   //other or alternate shipto
								: ($hit<1)
									$hit:=7
								: ($hit=8)
									$hit:=5
								: ($hit=9)
									$hit:=6
							End case 
							$aOrdered{$hit}:=[Customers_Order_Lines:41]Quantity:6
							$aShipped{$hit}:=([Customers_Order_Lines:41]Qty_Shipped:10-[Customers_Order_Lines:41]Qty_Returned:35)
							
							//*.   Determine open balance
							If ($aOrdered{$hit}>$aShipped{$hit})
								$balance:=$aOrdered{$hit}-$aShipped{$hit}
							Else 
								$balance:=0
							End if 
							//*.   Determine Total stock for this p•• (see also [OL]InventoryReport.(LP)
							$TotalStock:=0  //•081195  MLB  make sure $TotalStock is init for each orderline
							
							If (False:C215)  //•012596  mBohince  ••don't limit stock to just this po, per HTK
								QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]OrderItem:2=[Customers_Order_Lines:41]OrderLine:3)
								If (Records in selection:C76([Job_Forms_Items:44])>0)
									//•080295  MLB  UPR 1490
									//*.      °Find all the inventory which can be attributed to this orderline
									ARRAY TEXT:C222($aforms; 0)
									DISTINCT VALUES:C339([Job_Forms_Items:44]JobForm:1; $aforms)
									CREATE EMPTY SET:C140([Finished_Goods_Locations:35]; "stock")
									CREATE EMPTY SET:C140([Finished_Goods_Locations:35]; "oneForm")
									
									For ($j; 1; Size of array:C274($aforms))
										QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Customers_Order_Lines:41]ProductCode:5; *)
										QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]JobForm:19=$aforms{$j}; *)
										QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2="FG:@")
										CREATE SET:C116([Finished_Goods_Locations:35]; "oneForm")
										UNION:C120("stock"; "oneForm"; "stock")
									End for 
									USE SET:C118("stock")
									CLEAR SET:C117("stock")
									CLEAR SET:C117("oneForm")
									ARRAY LONGINT:C221($aQtyOH; 0)
									SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]QtyOH:9; $aQtyOH)
									//*.       °Tally up the inventory
									For ($j; 1; Size of array:C274($aQtyOH))
										$TotalStock:=$TotalStock+$aQtyOH{$j}
									End for 
									
									ARRAY TEXT:C222($aforms; 0)
									ARRAY LONGINT:C221($aQtyOH; 0)
									
								Else   //no job links
									uClearSelection(->[Finished_Goods_Locations:35])
								End if   //jobs linked to this order 
								
							Else   //*    Include ALL stock for this cpn
								QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Customers_Order_Lines:41]ProductCode:5)
								If (Records in selection:C76([Finished_Goods_Locations:35])>0)
									$TotalStock:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
								End if 
							End if 
							
							//*.   Write data to text file
							SEND PACKET:C103($textDoc; $cpn+$t+$desc+$t+$po+$t+$dateOpened+$t+$dateExpired+$t+$price+$t)
							For ($j; 1; 7)
								SEND PACKET:C103($textDoc; String:C10($aOrdered{$j})+$t+String:C10($aShipped{$j})+$t)
							End for 
							SEND PACKET:C103($textDoc; String:C10($balance)+$t+String:C10($TotalStock)+$t)
							SEND PACKET:C103($textDoc; $custid+$t+$custName+$t)  //•071697  mBohince  
							SEND PACKET:C103($textDoc; $payUse)  //•082997  MLB 
							SEND PACKET:C103($textDoc; $cr)
							//*.   Mark the orderline with a date of notification
							If ($months=$expireMths)
								[Customers_Order_Lines:41]_NotifiedOfExpir:39:=4D_Current_date
								SAVE RECORD:C53([Customers_Order_Lines:41])
							End if 
							
						Else   //notice given prior
							$priorNotice:=$priorNotice+1
						End if   //no notice given  
						NEXT RECORD:C51([Customers_Order_Lines:41])
						uThermoUpdate($i)
					End for 
					uThermoClose
					BEEP:C151
					BEEP:C151
					ALERT:C41("This run had "+String:C10($expirations-$priorNotice)+" new expirations, "+String:C10($priorNotice)+" prior expirations.")
					
				Else   //this corp has no orderlines
					BEEP:C151
					ALERT:C41("No expiration were found for "+$parentCorp)
				End if 
				
			Else   //no open orders
				BEEP:C151
				ALERT:C41("No open orderline were found older than "+String:C10(($cutOffDate+1); <>SHORTDATE))
			End if   //open orders       
			
		Else   //no customers
			BEEP:C151
			ALERT:C41($parentCorp+" has not been used as a parent corporation name.")
		End if   //found customers
		CLOSE WINDOW:C154
	End if   //entered a parent corp
	//*Cleanup
	CLOSE DOCUMENT:C267($textDoc)
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
		
		CLEAR SET:C117("OpenNiners")
		CLEAR SET:C117("TheseToo")
		CLEAR SET:C117("Expirations")
		UNLOAD RECORD:C212([Customers_Order_Lines:41])
		REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
		
		
	Else 
		
		REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
		
		
	End if   // END 4D Professional Services : January 2019 
	REDUCE SELECTION:C351([Customers:16]; 0)
	uClearSelection(->[Finished_Goods_Locations:35])
	READ ONLY:C145([Customers_Order_Lines:41])
	MESSAGES ON:C181
End if   //create document