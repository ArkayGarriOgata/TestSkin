//%attributes = {}
// Method: WIP_comesBack () -> 
// ----------------------------------------------------
// by: mel: 07/15/05, 15:45:36
// ----------------------------------------------------
// Description:
// 
// Updates:

// ----------------------------------------------------
C_LONGINT:C283($numJMI; $3)
C_TEXT:C284($jobit; $2)


Case of 
	: (True:C214)
		ALERT:C41("Method: WIP_comesBack is not currently available. Call x3186")
		
	: ($1="F/G")
		$jobit:=$2
		$numJMI:=qryJMI($jobit)
		rReal1:=$3
		sCriterion1:=[Job_Forms_Items:44]ProductCode:3
		sCriterion2:=[Job_Forms_Items:44]CustId:15
		custNum:=sCriterion2  //although we don't need this BOL still stores it
		sCriterion3:="WiP"
		i1:=Num:C11(Substring:C12($jobit; 10; 2))  //•080495  MLB  UPR 1490
		sShipTo:="01666"
		sCriterion4:="FG:AV"+FG_Get_PayUse_Bin_Prefix(sShipTo)+"#"+[Customers_ReleaseSchedules:46]CustomerRefer:3
		sCriterion5:=Substring:C12($jobit; 1; 8)
		sCriterion6:="cayey"  //aOL2{$i}+"/"+String(aRel2{$i})
		sCriter10:="cayey"+fYYMMDD(4D_Current_date)+Replace string:C233(String:C10(4d_Current_time; HH MM SS:K7:1); ":"; "")
		bLastSkid1:=0
		bLastSkid2:=0
		$s:=FG_receive_from_WIP(0)
		
	: ($1="Flat")
		If ([WMS_SerializedShippingLabels:96]HumanReadable:5#$2)
			READ WRITE:C146([WMS_SerializedShippingLabels:96])
			QUERY:C277([WMS_SerializedShippingLabels:96]; [WMS_SerializedShippingLabels:96]HumanReadable:5=$2)
		End if 
		$jobit:=[WMS_SerializedShippingLabels:96]Jobit:3
		$numJMI:=qryJMI($jobit)
		If ($numJMI>0)
			zwStatusMsg("RECEIVE"; BarCode_HumanReadableSSCC([WMS_SerializedShippingLabels:96]HumanReadable:5))
			rReal1:=[WMS_SerializedShippingLabels:96]Quantity:4
			sCriterion1:=[Job_Forms_Items:44]ProductCode:3
			sCriterion2:=[Job_Forms_Items:44]CustId:15
			custNum:=sCriterion2  //although we don't need this BOL still stores it
			sCriterion3:="WiP"
			i1:=Num:C11(Substring:C12($jobit; 10; 2))  //•080495  MLB  UPR 1490
			//sShipTo:="01666"
			sCriterion4:="FG:AV-rama-flat"  //+fGetAvonBin (sShipTo)+"#"+[ReleaseSchedule]CustomerRefer
			sCriterion5:=Substring:C12($jobit; 1; 8)
			sCriterion6:=[Job_Forms_Items:44]OrderItem:2  //"cayey"  `aOL2{$i}+"/"+String(aRel2{$i})
			sCriter10:=Substring:C12([WMS_SerializedShippingLabels:96]HumanReadable:5; 11; 9)
			bLastSkid1:=0
			bLastSkid2:=0
			$s:=FG_receive_from_WIP(0)
			
			LOAD RECORD:C52([Finished_Goods_Transactions:33])
			[WMS_SerializedShippingLabels:96]FG_Receipt_Posted:21:=[Finished_Goods_Transactions:33]XactionNum:24
			If ([WMS_SerializedShippingLabels:96]FG_Receipt_Posted:21="")
				[WMS_SerializedShippingLabels:96]FG_Receipt_Posted:21:="xfer n/f"
			End if 
			SAVE RECORD:C53([WMS_SerializedShippingLabels:96])
			UNLOAD RECORD:C212([Finished_Goods_Transactions:33])
		End if 
		
	: ($1="Sheets")
		ALERT:C41("Can't return sheets, feature not available.")
End case 
