//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 08/18/09, 17:20:56
// ----------------------------------------------------
// Method: EDI_Map_EDIFACT_Order
// Description
// convert back to code based from the table driven mapping of edirk
//using loaded arrays:$numberOfSegments:=$cursor-1
//   ARRAY TEXT(aEDI_Tag;$numberOfSegments)
//     ARRAY TEXT(aEDI_Elements;$numberOfSegments)
// Parameters
//typical structure  
//UNB+UNOA:1+BEESL.ESL001:ZZ+001635622:01+030224:0148+001751++DELFOR’
//     UNH+0000001+DELFOR:D:95A:UN’
//          BGM+241+0000133+26’
//             DTM...
//             NAD+BY...
//             NAD+SE...
//             UNS+D'
//
//             NAD+DP...
//                LIN...
//                IMD...
//                  QTY...
//                  SCC...
//                  DTM...  
//                  REF...  
//             ...
//
//          UNS+S’
//     UNT+9304+0000001’ (numb of segmen including UNH and UNT plus section number
//     ''''''
//UNZ+3+001751’
// ----------------------------------------------------

C_BOOLEAN:C305(save_log_file)  //change this to an option, default false
C_POINTER:C301($1; $2; $datePtr; $buyerPtr)  //these are now pointers to arrays
C_TEXT:C284($_buyer_name)
C_LONGINT:C283($0; $numberOfSegments)
C_TEXT:C284($DELFOR_DATE)
C_TEXT:C284($r)
C_BOOLEAN:C305($inHeader)  //keep track of the level on indent

save_log_file:=True:C214
$datePtr:=$1
$buyerPtr:=$2
$0:=-99999
$DELFOR_DATE:="YYYYMMDD"
$r:=Char:C90(13)
$numberOfSegments:=Size of array:C274(aEDI_Tag)

uThermoInit($numberOfSegments; "Mapping DELFOR")

For ($segment; 1; $numberOfSegments)
	$errMsg:=util_TextParser(7; aEDI_Elements{$segment}; iElementDelimitor; iSegmentDelimitor)
	$tag:=aEDI_Tag{$segment}
	If (save_log_file)
		utl_Logfile("EDI_MAPPING"; (aEDI_Tag{$segment}+"+"+aEDI_Elements{$segment}))
	End if 
	Case of 
		: ($tag="UNB")
			$_ICN:=util_TextParser(5)
			$message_type:=util_TextParser(7)
			$_Msg_Date:=util_TextParser(4)
			Senders_ID:=util_TextParser(2)  //domestic and ovel use the same id for delfor
			
		: ($tag="UNH")
			$_GCN:=util_TextParser(1)
			
		: ($tag="BGM")
			$inHeader:=True:C214
			$_delfor:=util_TextParser(2)
			
		: ($tag="DTM") & ($inHeader)
			$errMsg:=util_TextParser(3; util_TextParser(1); iSubElementDelimitor; iSegmentDelimitor)
			$DELFOR_DATE:=util_TextParser(2)  //util_dateFromYYYYMMDD (util_TextParser (2))
			APPEND TO ARRAY:C911($datePtr->; $DELFOR_DATE)
			//$datePtr->:=$DELFOR_DATE
			
		: ($tag="DTM") & (Not:C34($inHeader))
			$errMsg:=util_TextParser(3; util_TextParser(1); iSubElementDelimitor; iSegmentDelimitor)
			$dateZone:=util_TextParser(1)  //2=delivery requesed, 55=confirmed
			$date_type:=util_TextParser(3)
			Case of 
				: ($date_type="102")  //a date
					[Finished_Goods_DeliveryForcasts:145]DateDock:4:=util_dateFromYYYYMMDD(util_TextParser(2))
				: ($date_type="616")  //a week
					$date_value:=util_TextParser(2)
					$january:=Date:C102("01/01/"+$date_value[[1]]+$date_value[[2]]+$date_value[[3]]+$date_value[[4]])
					$week:=Num:C11($date_value[[5]]+$date_value[[6]])
					[Finished_Goods_DeliveryForcasts:145]DateDock:4:=Add to date:C393($january; 0; 0; ($week*7))
				: ($date_type="610")  //a month
					$date_value:=util_TextParser(2)
					$dateDue:=$date_value[[5]]+$date_value[[6]]+"/01/"+$date_value[[1]]+$date_value[[2]]+$date_value[[3]]+$date_value[[4]]
					[Finished_Goods_DeliveryForcasts:145]DateDock:4:=Date:C102($dateDue)
			End case 
			
			//adjust dock date to scheduled date
			//$lead_time_in_days:=ADDR_getLeadTime ($Destination)
			//[Finished_Goods_DeliveryForcasts]DateDock:=[Finished_Goods_DeliveryForcasts]DateDock-$lead_time_in_days
			
			[Finished_Goods_DeliveryForcasts:145]refer:3:=$_ref+fYYMMDD([Finished_Goods_DeliveryForcasts:145]DateDock:4)+"."+$_cpn
			SAVE RECORD:C53([Finished_Goods_DeliveryForcasts:145])  //may not be a RFF segment
			
		: ($tag="NAD")
			$_Qualifier:=util_TextParser(1)
			$el_addree_id:=util_TextParser(2)
			$address_name:=util_TextParser(3)
			$errMsg:=util_TextParser(3; $el_addree_id; iSubElementDelimitor; iSegmentDelimitor)
			$aMs_id:=ADDR_CrossIndexLauder("GET_AMS"; util_TextParser(1))
			Case of 
				: ($_Qualifier="BY")  //BillTo ->NAD+BY+5411111000033::92+Estee Lauder Whitman UK
					$OrderedBy:=$aMs_id
					$_buyer_name:=$address_name  //one-time per message
					APPEND TO ARRAY:C911($buyerPtr->; $_buyer_name)
					//$buyerPtr->:=$_buyer_name
					//remove all prior forecasts for this buyer
					READ WRITE:C146([Customers_ReleaseSchedules:46])
					QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]edi_buyer:47=$_buyer_name; *)
					QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3="<@")
					If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
						//util_DeleteSelection (->[Customers_ReleaseSchedules])
						//try to preserve comments and date of orgination
						APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]EDI_Disposition:36:="OMIT")
					End if 
					
				: ($_Qualifier="SE")  //Supplier ->NAD+SU+0010011470::92+ARKAY PACKAGING CORP
					If (Position:C15("arkay"; $address_name)=0)
						uConfirm("Looks like this order isn't for Arkay! "+aEDI_Elements{$segment}; "Call EL"; "Help")
					End if 
				: ($_Qualifier="DP")  //ShipTo ->NAD+ST+3530::92+UK HUB:Fulfood Road:Havant, HA PO0 5AX GB
					$Destination:=$aMs_id  //multiple-times per message
			End case 
			
		: ($tag="UNS")
			Case of 
				: (util_TextParser(1)="D")
					$inHeader:=False:C215
					
				: (util_TextParser(1)="S")
					$inHeader:=True:C214
					
			End case 
			
		: ($tag="LIN")  //beginning a repeated group
			$_id:=util_TextParser(1)
			$_cpn:=ELC_CPN_Format(Replace string:C233(util_TextParser(3); ":IN"; ""))
			$numfg:=qryFinishedGood("#CPN"; $_cpn)
			$_Custid:=[Finished_Goods:26]CustID:2
			
			//If ($_cpn="WHX8-01-0221")
			//TRACE
			//End if 
			
		: ($tag="IMD")
			$_obsolete_flag:=util_TextParser(2)
			//$_Desc:="description" in util_TextParser (3;4), but not needed for orderline
			
		: ($tag="QTY")
			CREATE RECORD:C68([Finished_Goods_DeliveryForcasts:145])
			[Finished_Goods_DeliveryForcasts:145]id:1:=$_id
			[Finished_Goods_DeliveryForcasts:145]ProductCode:2:=$_cpn
			[Finished_Goods_DeliveryForcasts:145]ShipTo:8:=$Destination
			[Finished_Goods_DeliveryForcasts:145]BillTo:16:=$OrderedBy
			[Finished_Goods_DeliveryForcasts:145]asOf:9:=$DELFOR_DATE
			[Finished_Goods_DeliveryForcasts:145]Custid:12:=$_Custid
			[Finished_Goods_DeliveryForcasts:145]Is_Obsolete:13:=($_obsolete_flag="67")
			[Finished_Goods_DeliveryForcasts:145]edi_ICN:14:=$_ICN
			[Finished_Goods_DeliveryForcasts:145]edi_buyer:15:=$_buyer_name
			$errMsg:=util_TextParser(3; util_TextParser(1); iSubElementDelimitor; iSegmentDelimitor)
			$zone:=util_TextParser(1)  //187=plnnd, 66=commit, 21=ordered
			Case of 
				: ($zone="187")
					$_ref:="<FP"
				: ($zone="66")
					$_ref:="<FC"
				: ($zone="21")
					$_ref:="<FF"
				Else 
					$_ref:="<F"
			End case 
			
			[Finished_Goods_DeliveryForcasts:145]QtyOpen:7:=Num:C11(util_TextParser(2))
			[Finished_Goods_DeliveryForcasts:145]QtyReceived:6:=0
			[Finished_Goods_DeliveryForcasts:145]QtyWanted:5:=[Finished_Goods_DeliveryForcasts:145]QtyOpen:7
			
		: ($tag="SCC")
			$scc:=util_TextParser(1)  // 1=firm, 2=commit, 4=planned
			Case of 
				: ($scc="1")
					$_ref:=$_ref+"F>"
				: ($scc="2")
					$_ref:=$_ref+"C>"
				: ($scc="4")
					$_ref:=$_ref+"P>"
				Else 
					$_ref:=$_ref+"P>"
			End case 
			
		: ($tag="RFF")  //optional
			$errMsg:=util_TextParser(2; util_TextParser(1); iSubElementDelimitor; iSegmentDelimitor)
			[Finished_Goods_DeliveryForcasts:145]refer:3:=Replace string:C233(util_TextParser(2); "/"; ".")
			If (Position:C15("00999"; [Finished_Goods_DeliveryForcasts:145]refer:3)>0)
				//[Finished_Goods_DeliveryForcasts]refer:="<F>"+[Finished_Goods_DeliveryForcasts]refer
				[Finished_Goods_DeliveryForcasts:145]refer:3:=$_ref+[Finished_Goods_DeliveryForcasts:145]refer:3
			End if 
			If (Substring:C12([Finished_Goods_DeliveryForcasts:145]refer:3; 1; 2)="BP")
				[Finished_Goods_DeliveryForcasts:145]refer:3:=Insert string:C231([Finished_Goods_DeliveryForcasts:145]refer:3; "."; (Length:C16([Finished_Goods_DeliveryForcasts:145]refer:3)-2))
			End if 
			SAVE RECORD:C53([Finished_Goods_DeliveryForcasts:145])
			
		: ($tag="UNT")
			//nothing worthy
			
		: ($tag="UNZ")
			//nothing worthy
	End case 
	
	
	$errMsg:=util_TextParser
	uThermoUpdate($segment)
End for 
uThermoClose

$0:=0

UNLOAD RECORD:C212([Finished_Goods_DeliveryForcasts:145])
UNLOAD RECORD:C212([Customers_ReleaseSchedules:46])