//%attributes = {"publishedWeb":true}
//Procedure: CPi_Shipping()  UPR1915 012198  MLB
//Customer Perception Index - Shipping
//apply a strick measure of Arkays performance
//of shipping with in a specified time period
//and email the results.
//•033098  MLB  change formula
//•061798  MLB  conceal the truth from the masses per FG
//                 mgmt whinning about having their performance graded
//•081098  MLB  remove Fred from distribution
//101105 tighten it up since its my person view and concern. get rid of simple method

C_DATE:C307($1; $from; $2; $to)
C_TEXT:C284($3; $custName)
C_LONGINT:C283($numRels; $i; $cpi; $total; $volume; $numShipped)
C_REAL:C285($price; $dollarsLost; $dollarsMfg; $valueThis; $dollarsPln)
C_TEXT:C284($dist)
C_TEXT:C284($cr; $t)

$cr:=Char:C90(13)
$t:=Char:C90(9)

If (Count parameters:C259>0)
	$from:=$1
	$to:=$2
	$custName:=$3
	$dist:=Current user:C182+$t
	
Else   //from Batch_Runner
	$from:=4D_Current_date-1
	$to:=$from
	$custName:="All Customers"
	//$dist:="Fred Golden"+$t+"Howard Kaneff"+$t+"Mitchell Kaneff"+$t+"Craig Bradley"+
	// $dist:="Fred Golden"+$t+"Walter Shiels"+$t  `•061798  MLB 
	//$dist:="Brian Burton"+$t  `•081098  MLB  
	//$dist:=$dist+"Vince Cundari"+$t  `•04/14/99  MLB  UPR 
	$dist:=distributionList
End if 

REL_noticeOfMissedShipment

READ ONLY:C145([Customers_ReleaseSchedules:46])
READ ONLY:C145([Customers:16])
READ ONLY:C145([Customers_Order_Lines:41])
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	If ($custName#"All Customers")
		QUERY:C277([Customers:16]; [Customers:16]Name:2=$custName)
		uRelateSelect(->[Customers_ReleaseSchedules:46]CustID:12; ->[Customers:16]ID:1; 1)
		REDUCE SELECTION:C351([Customers:16]; 0)
	Else 
		ALL RECORDS:C47([Customers_ReleaseSchedules:46])
	End if 
	$rating:=0
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5>=$from; *)
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<F@"; *)
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5<=$to)
	
Else 
	
	If ($custName#"All Customers")
		
		zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Customers_ReleaseSchedules:46])+" file. Please Wait...")
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers:16]Name:2=$custName; *)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5>=$from; *)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<F@"; *)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5<=$to)
		zwStatusMsg(""; "")
		
	Else 
		
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5>=$from; *)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<F@"; *)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5<=$to)
		
	End if 
	$rating:=0
	
End if   // END 4D Professional Services : January 2019 query selection

If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
	ARRAY DATE:C224($aSchDate; 0)
	ARRAY LONGINT:C221($aSchQty; 0)
	ARRAY DATE:C224($aActDate; 0)
	ARRAY LONGINT:C221($aActQty; 0)
	ARRAY TEXT:C222($aDR; 0)
	ARRAY INTEGER:C220($aPayUse; 0)
	ARRAY LONGINT:C221($aTHC; 0)  //zero or one means that we had inventory
	SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]Sched_Date:5; $aSchDate; [Customers_ReleaseSchedules:46]Sched_Qty:6; $aSchQty; [Customers_ReleaseSchedules:46]Actual_Date:7; $aActDate; [Customers_ReleaseSchedules:46]Actual_Qty:8; $aActQty; [Customers_ReleaseSchedules:46]VarianceComment:13; $aDR; [Customers_ReleaseSchedules:46]OrderLine:4; $aOL; [Customers_ReleaseSchedules:46]PayU:31; $aPayUse; [Customers_ReleaseSchedules:46]THC_State:39; $aTHC)
	REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
	$numRels:=Size of array:C274($aSchDate)
	$numShipped:=0
	$total:=0
	$cpi:=0
	$volume:=0
	$dollars:=0
	$dollarsLost:=0
	$price:=0
	$billings:=0
	
	For ($i; 1; $numRels)
		If ($aPayUse{$i}#1) & ($aDR{$i}#"DR") & ($aDR{$i}#"AD")  //exclude Delinquents 
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$aOL{$i})
			If (Records in selection:C76([Customers_Order_Lines:41])>0)
				$price:=[Customers_Order_Lines:41]Price_Per_M:8/1000
				REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
			Else 
				$price:=0
			End if 
			$billings:=$billings+($aActQty{$i}*$price)
			$numShipped:=$numShipped+1
			$volume:=$volume+$aSchQty{$i}  //potential in units
			$timing:=$aActDate{$i}-$aSchDate{$i}  //negative is early
			$coverage:=($aActQty{$i}/$aSchQty{$i})*100  //percent of scheduled qty
			$valueThis:=$aSchQty{$i}*$price
			$total:=$total+$valueThis  //release's potential
			
			Case of 
				: ($aActDate{$i}=!00-00-00!)  //missed release
					//$cpi:=$cpi+0  
					If ($aTHC{$i}<2)  //we had inventory
						$dollarsLost:=$dollarsLost+($aSchQty{$i}*$price)
					Else   //production backlog
						If ($aTHC{$i}=2) | ($aTHC{$i}=3) | ($aTHC{$i}=6)
							$dollarsMfg:=$dollarsMfg+($aSchQty{$i}*$price)
						Else 
							$dollarsPln:=$dollarsPln+($aSchQty{$i}*$price)
						End if 
					End if 
					
				: ($aSchDate{$i}=!00-00-00!) & ($aSchQty{$i}=0)  //looks like a return
					// $cpi:=$cpi-10          
					
				: ($timing<-1)  //early 7, 8, or 9
					Case of 
						: ($coverage<98)  //short
							$cpi:=$cpi+(0.5*$valueThis)
						: ($coverage>102)  //over
							$cpi:=$cpi+(0.6*$valueThis)
						Else 
							$cpi:=$cpi+(0.7*$valueThis)
					End case 
					
				: ($timing=1)  //late 5, 6, or 7
					Case of 
						: ($coverage<98)  //short
							$cpi:=$cpi+(0.2*$valueThis)
						: ($coverage>102)  //over
							$cpi:=$cpi+(0.3*$valueThis)
						Else 
							$cpi:=$cpi+(0.4*$valueThis)
					End case 
					
				: ($timing>1)  //treat as a miss
					//$cpi:=$cpi+0  
					If ($aTHC{$i}<2)  //we had inventory
						$dollarsLost:=$dollarsLost+($aSchQty{$i}*$price)
					Else   //production backlog
						If ($aTHC{$i}=2) | ($aTHC{$i}=3) | ($aTHC{$i}=6)
							$dollarsMfg:=$dollarsMfg+($aSchQty{$i}*$price)
						Else 
							$dollarsPln:=$dollarsPln+($aSchQty{$i}*$price)
						End if 
					End if 
					
				Else   //ontime 8, 9, or 10
					Case of 
						: ($coverage<98)  //short
							$cpi:=$cpi+(0.8*$valueThis)
						: ($coverage>102)  //over
							$cpi:=$cpi+(0.9*$valueThis)
						Else 
							$cpi:=$cpi+(1*$valueThis)
					End case 
			End case 
		End if   //exclude
	End for 
	
	$rating:=Round:C94(($cpi/$total*100); 0)
	//*Set up for logfile dump
	xTitle:="CPI - Shipping Performance "+String:C10($rating)+"%"
	xText:="____________________________________________"+$CR
	xText:=xText+"CPI - SHIPPING PERFORMANCE"+$cr
	xText:=xText+" for "+$custName+$cr
	xText:=xText+" for the period from "+String:C10($from; <>MIDDATE)+" to "+String:C10($to; <>MIDDATE)+" Run on "+String:C10(4D_Current_date; <>LONGDATE)+$cr+$cr
	xText:=xText+"CPI-SP = "+String:C10($rating)+" %   ("+String:C10($cpi)+"/"+String:C10($total)+")*100"+$cr
	xText:=xText+" on a volume of "+String:C10($volume; "###,###,###")+" cartons occuring in "+String:C10($numShipped; "###,##0")+" releases."+$cr
	xText:=xText+" amounting to billings of "+String:C10($billings; "$###,###,###")+"."+$cr+$cr
	xText:=xText+"Shipping left "+String:C10($dollarsLost; "$###,###,##0.00")+" dollars on the table in this time period. (THC=0 &1)"+$cr
	xText:=xText+"Manufacturing left "+String:C10($dollarsMfg; "$###,###,##0.00")+" dollars on the table in this time period. (THC=2,3 &6)"+$cr
	xText:=xText+"Planning left "+String:C10($dollarsPln; "$###,###,##0.00")+" dollars on the table in this time period. (THC=4,5,7 &8)"+$cr+$cr
	xText:=xText+"____________________________________________"+$CR
	xText:=xText+"The CPI is calculated by finding all the releases SCHEDULED in the target"+$CR
	xText:=xText+"time period. The revenue of each of these releases is multiplied by a weight"+$CR
	xText:=xText+"between 0 and 10, then added to the total. The CPI is stated as a percent of"+$CR
	xText:=xText+"the total achievable revenue times 10. The weight is assigned based on "+$CR
	xText:=xText+"timeliness and quantity coverage, where 'On-time' is ±1 days† of the"+$CR
	xText:=xText+"scheduled date and coverage is ±2% of scheduled quantity. "+$CR
	xText:=xText+"Pay-use's are omitted since they generate $0 revenue."+$CR
	xText:=xText+"Delinquent releases are omitted since they would have been "+$CR
	xText:=xText+"scored on a previous day. "+$CR
	xText:=xText+"Weighting is as follows:"+$CR
	xText:=xText+"10 = On-time, Correct quantity"+$CR
	xText:=xText+" 9 = On-time, Over quantity or Early Correct quantity"+$CR
	xText:=xText+" 8 = On-time, Short quantity or Early Over quantity"+$CR
	xText:=xText+" 7 = Early, Correct quantity"+$CR
	xText:=xText+" 6 = Early, Over quantity"+$CR
	xText:=xText+" 5 = Early, Short quantity"+$CR
	xText:=xText+" 4 = Late,  Correct quantity"+$CR
	xText:=xText+" 3 = Late, Over quantity"+$CR
	xText:=xText+" 2 = Late, Short quantity"+$CR
	xText:=xText+" 0 = Missed release"+$CR+$cr
	xText:=xText+"You may run this calculation for a specific date range by running"+$CR
	xText:=xText+"this report from the F/G Palette's Report popup and selecting"+$CR
	xText:=xText+"Month End Suite. Also, the DBA may run this report for a specific"+$CR
	xText:=xText+"customer by using the Execute button and entering in the format:"+$CR
	xText:=xText+"CPi_Shipping (!1/1/98!;!1/30/98!;'Len Ron@')"+$CR
	xText:=xText+"using double quotes rather than single quotes."+$CR
	//xText:=xText+"†Note: +5 tolerance only applies if end date is 5 days ago."+$CR
Else 
	xTitle:="CPI - Shipping Performance"
	xText:="____________________________________________"+$CR
	xText:=xText+"CPI - SHIPPING PERFORMANCE"+$cr
	xText:=xText+" for "+$custName+$cr
	xText:=xText+" for the period from "+String:C10($from; <>MIDDATE)+" to "+String:C10($to; <>MIDDATE)+" Run on "+String:C10(4D_Current_date; <>LONGDATE)+$cr+$cr
	xText:=xText+"NO RELEASES FOUND"+$cr
	
End if   //there are releases in range 

xText:=xText+"_______________ END OF REPORT ______________"
//TRACE
//QM_Sender (xTitle;"";xText;$dist)
EMAIL_Transporter(xTitle; ""; xText; $dist)
//*Print a list of what happened on this run
//rPrintText ("CPI_SHIPPING"+fYYMMDD (4D_Current_date)+"_"+Replace 
//«string(String(4d_Current_time;◊HHMM);":";""))

xTitle:=""
xText:=""