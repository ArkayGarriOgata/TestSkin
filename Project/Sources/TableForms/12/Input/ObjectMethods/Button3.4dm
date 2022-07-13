$relNumber:=[Purchase_Orders_Items:12]PONo:2+"."+[Purchase_Orders_Items:12]ItemNo:3+"."+[Purchase_Orders_Releases:79]RelNumber:4
Case of 
	: ([Purchase_Orders_Releases:79]Schd_Qty:2=0)
		BEEP:C151
		ALERT:C41("Release "+$relNumber+" has no quantity specified.")
	: ([Purchase_Orders_Releases:79]Schd_Date:3=!00-00-00!)
		BEEP:C151
		ALERT:C41("Release "+$relNumber+" has no scheduled date specified.")
	: ([Purchase_Orders_Releases:79]Actual_Date:5#!00-00-00!)
		BEEP:C151
		ALERT:C41("Release "+$relNumber+" has already been received.")
		
	Else 
		
		$vendID:=Vend_getVendorRecord([Purchase_Orders_Items:12]VendorID:39)
		$to:=Vend_getEmailAddress([Purchase_Orders_Items:12]VendorID:39)
		
		$cr:="%0D"  //"%1D%1A"
		$t:="        "
		$lb:="%23"  //#
		$cc:=Replace string:C233(Current user:C182; " "; ".")+"@arkay.com"
		$inline:=Uppercase:C13("Arkay Packaging Corporation")+$cr
		$inline:=$inline+"Board Release Notification reference "+$relNumber+$cr+$cr
		$inline:=$inline+"Attention: "+[Purchase_Orders:11]AttentionOf:28+":"+$cr
		$inline:=$inline+[Vendors:7]Name:2+$cr+$cr
		
		$inline:=$inline+"Please ship "+String:C10([Purchase_Orders_Releases:79]Schd_Qty:2; "###,###,##0")+" "+[Purchase_Orders_Items:12]UM_Arkay_Issue:28+" of "+$cr
		$inline:=$inline+$t+$t+"Our item number: "+[Purchase_Orders_Items:12]Raw_Matl_Code:15+$cr
		$inline:=$inline+$t+$t+"Your item number: "+[Purchase_Orders_Items:12]VendPartNo:6+$cr+$cr
		$inline:=$inline+"by "+String:C10([Purchase_Orders_Releases:79]Schd_Date:3; System date abbreviated:K1:2)+$cr+$cr
		$inline:=$inline+"to: "+$cr
		$inline:=$inline+$t+$t+[Purchase_Orders:11]ShipTo1:34+$cr
		$inline:=$inline+$t+$t+[Purchase_Orders:11]ShipTo2:35+$cr
		$inline:=$inline+$t+$t+[Purchase_Orders:11]ShipTo3:36+$cr
		$inline:=$inline+$t+$t+[Purchase_Orders:11]ShipTo4:37+$cr
		$inline:=$inline+$t+$t+[Purchase_Orders:11]ShipTo5:38+$cr+$cr
		
		
		READ ONLY:C145([Raw_Materials_Locations:25])
		QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]POItemKey:19=[Purchase_Orders_Items:12]POItemKey:1; *)
		QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]Location:2=(Vend_getPrefixInitials($vendID)))
		$balance:=Sum:C1([Raw_Materials_Locations:25]QtyOH:9)
		If ($balance>0)
			$inline:=$inline+"Our records show that mill# "+[Raw_Materials_Locations:25]MillNumber:25+" balance is "+String:C10($balance; "###,###,##0")+" "+[Purchase_Orders_Items:12]UM_Arkay_Issue:28+$cr
		End if 
		
		$closing:=$cr+$cr
		$closing:=$closing+"Craig Bradley, Inventory Manager"+$cr
		$closing:=$closing+"Arkay Packaging Corporation"+$cr
		$closing:=$closing+"350 East Park Drive"+$cr
		$closing:=$closing+"Roanoke, VA 24019  USA"+$cr+$cr
		$closing:=$closing+"Ph: 540.977.3031 x 106"+$cr
		$closing:=$closing+"Fx: 540.977.2503"+$cr
		
		util_OpenEmailClient($to; $cc; ""; "Board Release "+$relNumber+" for Arkay Pkg Corp "; $inline+$closing)
		
End case 