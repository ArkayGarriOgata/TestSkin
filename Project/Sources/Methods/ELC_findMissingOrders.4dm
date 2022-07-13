//%attributes = {}
// -------
// Method: ELC_findMissingOrders   ( ) ->
// By: Mel Bohince @ 01/15/19, 10:39:10
// Description
// utility function, no UI
// ----------------------------------------------------

READ ONLY:C145([Customers_ReleaseSchedules:46])
READ ONLY:C145([Finished_Goods_DeliveryForcasts:145])

$criteria:=ELC_getName
QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Customers:16]ParentCorp:19=$criteria)

//ELC_query (->[Finished_Goods_DeliveryForcasts]Custid;1)
ORDER BY:C49([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]asOf:9; <)
$latest:=[Finished_Goods_DeliveryForcasts:145]asOf:9
QUERY SELECTION:C341([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]asOf:9=$latest)
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
	
	CREATE SET:C116([Finished_Goods_DeliveryForcasts:145]; "recentDelfor")
	
Else 
	
	
End if   // END 4D Professional Services : January 2019 

DISTINCT VALUES:C339([Finished_Goods_DeliveryForcasts:145]ProductCode:2; $aDelforCPNs)
SORT ARRAY:C229($aDelforCPNs; >)


//ELC_query (->[Customers_ReleaseSchedules]CustID;1)
//QUERY selection([Customers_ReleaseSchedules];[Customers_ReleaseSchedules]Actual_Date=!00-00-00!)

QUERY:C277([Customers_ReleaseSchedules:46]; [Customers:16]ParentCorp:19=$criteria; *)
QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
CREATE SET:C116([Customers_ReleaseSchedules:46]; "openReleases")
DISTINCT VALUES:C339([Customers_ReleaseSchedules:46]ProductCode:11; $aOurCPNs)

SORT ARRAY:C229($aOurCPNs; >)

// merge arrays
For ($i; 1; Size of array:C274($aOurCPNs))
	$hit:=Find in array:C230($aDelforCPNs; $aOurCPNs{$i})
	If ($hit=-1)
		APPEND TO ARRAY:C911($aDelforCPNs; $aOurCPNs{$i})
		SORT ARRAY:C229($aDelforCPNs; >)
	End if 
End for 

C_TEXT:C284($title; $text; $docName; $millidiff)
C_LONGINT:C283($millinow; $millithen)
C_TIME:C306($docRef)

$title:=""
$text:="CPN"+"\t"+"THEIRS"+"\t"+"OURS"+"\t"+"DIFF"+"\t"+"RECENT_SHIPPED"+"\r"
$docName:="DELFOR_Compare_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"

$docRef:=util_putFileName(->$docName)

If ($docRef#?00:00:00?)
	SEND PACKET:C103($docRef; $title+"\r\r")
	$latestDate:=Date:C102(Substring:C12($latest; 5; 2)+"-"+Substring:C12($latest; 7; 2)+"-"+Substring:C12($latest; 1; 4))
	$twoWeeks:=$latestDate-14
	
	For ($i; 1; Size of array:C274($aDelforCPNs))
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			USE SET:C118("recentDelfor")
			QUERY SELECTION:C341([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]ProductCode:2=$aDelforCPNs{$i})
			
		Else 
			
			QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Customers:16]ParentCorp:19=$criteria; *)
			QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]asOf:9=$latest; *)
			QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]ProductCode:2=$aDelforCPNs{$i})
			
		End if   // END 4D Professional Services : January 2019 
		
		If (Records in selection:C76([Finished_Goods_DeliveryForcasts:145])>0)
			$delfor:=Sum:C1([Finished_Goods_DeliveryForcasts:145]QtyOpen:7)
		Else 
			$delfor:=0
		End if 
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			USE SET:C118("openReleases")
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$aDelforCPNs{$i})
			
		Else 
			
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers:16]ParentCorp:19=$criteria; *)
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!; *)
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$aDelforCPNs{$i})
			
		End if   // END 4D Professional Services : January 2019 
		
		If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
			$releases:=Sum:C1([Customers_ReleaseSchedules:46]OpenQty:16)
		Else 
			$releases:=0
		End if 
		
		$dif:=$delfor-$releases
		
		If ($dif>1000)
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$aDelforCPNs{$i}; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7>$twoWeeks)
			If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
				$shipped:=Sum:C1([Customers_ReleaseSchedules:46]Actual_Qty:8)
			Else 
				$shipped:=0
			End if 
		Else 
			$shipped:=-1
		End if 
		
		$text:=$text+$aDelforCPNs{$i}+"\t"+String:C10($delfor)+"\t"+String:C10($releases)+"\t"+String:C10($dif)+"\t"+String:C10($shipped)+"\r"
		
	End for 
	
	SEND PACKET:C103($docRef; $text)
	SEND PACKET:C103($docRef; "\r\r------ END OF FILE ------")
	CLOSE DOCUMENT:C267($docRef)
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		CLEAR SET:C117("recentDelfor")
		USE SET:C118("openReleases")
		
	Else 
		
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers:16]ParentCorp:19=$criteria; *)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
		
	End if   // END 4D Professional Services : January 2019 
	
	$err:=util_Launch_External_App($docName)
End if 