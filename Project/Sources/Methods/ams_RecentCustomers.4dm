//%attributes = {"publishedWeb":true}
//PM: ams_RecentCustomers() -> 
//@author mlb - 7/1/02  09:40
// recent customer is defined as having at least one:
//inventory
//bookings
//estimates
//jobs
//on or after the specified cutoff time
//the [cust]Active flag is set accordingly
// Modified by: Mel Bohince (6/14/16) add Size and Style test

C_TEXT:C284($inv_RecentSet; $booking_RecentSet; $job_RecentSet; $estimate_RecentSet; $art_RecentSet)
C_DATE:C307($inventoryCutOffDate; $estimateCutOffDate; $jobCutOffDate; $artCutOffDate)
C_LONGINT:C283($fiscalYearCutOff)

$inventoryCutOffDate:=<>cutOffDate3  //keep 2 plus current
$jobCutOffDate:=<>cutOffDate3  //keep 2 plus current
$estimateCutOffDate:=<>cutOffDate3  //keep 2 plus current
$artCutOffDate:=<>cutOffDate3  //keep 2 plus current
$fiscalYearCutOff:=Year of:C25(<>cutOffDate3)  //

MESSAGES OFF:C175
If (<>fContinue)
	//*Test inventory age by date glued
	
	$inv_RecentSet:=ams_RecentInventory($inventoryCutOffDate)
	USE SET:C118($inv_RecentSet)
	ARRAY TEXT:C222($aHasInventory; 0)
	DISTINCT VALUES:C339([Finished_Goods_Locations:35]CustID:16; $aHasInventory)
	REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
	$inv_RecentSet:=ams_RecentInventory  //clear set
	
End if 

If (<>fContinue)
	//*Test Booking by fiscal year
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 ams_DeleteWithoutHeaderRecord
		
		$booking_RecentSet:=ams_RecentBooking($fiscalYearCutOff)
		USE SET:C118($booking_RecentSet)
		ARRAY TEXT:C222($aHasBooking; 0)
		DISTINCT VALUES:C339([Customers_Bookings:93]Custid:1; $aHasBooking)
		REDUCE SELECTION:C351([Customers_Bookings:93]; 0)
		$booking_RecentSet:=ams_RecentBooking  //clear set
		
	Else 
		
		ARRAY TEXT:C222($aHasBooking; 0)
		QUERY:C277([Customers_Bookings:93]; [Customers_Bookings:93]FiscalYear:2>=$fiscalYearCutOff)
		DISTINCT VALUES:C339([Customers_Bookings:93]Custid:1; $aHasBooking)
		REDUCE SELECTION:C351([Customers_Bookings:93]; 0)
		
	End if   // END 4D Professional Services : January 2019 query selection
	
End if 

If (<>fContinue)
	//*Test  by date originated
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 ams_DeleteWithoutHeaderRecord
		
		$estimate_RecentSet:=ams_RecentEstimate($estimateCutOffDate)
		USE SET:C118($estimate_RecentSet)
		ARRAY TEXT:C222($aHasEstimate; 0)
		DISTINCT VALUES:C339([Estimates:17]Cust_ID:2; $aHasEstimate)
		REDUCE SELECTION:C351([Estimates:17]; 0)
		$estimate_RecentSet:=ams_RecentEstimate  //clear set
		
	Else 
		
		ARRAY TEXT:C222($aHasEstimate; 0)
		QUERY:C277([Estimates:17]; [Estimates:17]DateOriginated:19>=$estimateCutOffDate)
		DISTINCT VALUES:C339([Estimates:17]Cust_ID:2; $aHasEstimate)
		REDUCE SELECTION:C351([Estimates:17]; 0)
		
	End if   // END 4D Professional Services : January 2019 query selection
	
End if 

If (<>fContinue)
	//*Test  by date started or not started
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		$job_RecentSet:=ams_RecentJob($jobCutOffDate)
		USE SET:C118($job_RecentSet)
		READ ONLY:C145([Jobs:15])
		RELATE ONE SELECTION:C349([Job_Forms:42]; [Jobs:15])
		ARRAY TEXT:C222($aHasJob; 0)
		DISTINCT VALUES:C339([Jobs:15]CustID:2; $aHasJob)
		REDUCE SELECTION:C351([Job_Forms:42]; 0)
		REDUCE SELECTION:C351([Jobs:15]; 0)
		$job_RecentSet:=ams_RecentJob  //clear set
		
	Else 
		
		ARRAY TEXT:C222($aHasJob; 0)
		QUERY:C277([Jobs:15]; [Job_Forms:42]VersionDate:58>=$jobCutOffDate)
		DISTINCT VALUES:C339([Jobs:15]CustID:2; $aHasJob)
		REDUCE SELECTION:C351([Jobs:15]; 0)
		
	End if   // END 4D Professional Services : January 2019 query selection
	
End if 

If (<>fContinue)
	//*Test art by date recieved
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 ams_DeleteWithoutHeaderRecord
		
		$art_RecentSet:=ams_RecentArt($artCutOffDate)
		USE SET:C118($art_RecentSet)
		ARRAY TEXT:C222($aHasArt; 0)
		ARRAY TEXT:C222($aFGKEY; 0)
		SELECTION TO ARRAY:C260([Finished_Goods_Specifications:98]FG_Key:1; $aFGKEY)
		REDUCE SELECTION:C351([Finished_Goods_Specifications:98]; 0)
		$art_RecentSet:=ams_RecentArt  //clear set
		
	Else 
		
		QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]DateArtReceived:63>=$artCutOffDate)
		ARRAY TEXT:C222($aHasArt; 0)
		ARRAY TEXT:C222($aFGKEY; 0)
		SELECTION TO ARRAY:C260([Finished_Goods_Specifications:98]FG_Key:1; $aFGKEY)
		REDUCE SELECTION:C351([Finished_Goods_Specifications:98]; 0)
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	For ($i; 1; Size of array:C274($aFGKEY))
		$cust:=Substring:C12($aFGKEY{$i}; 1; 5)
		$hit:=Find in array:C230($aHasArt; $cust)
		If ($hit=-1)
			APPEND TO ARRAY:C911($aHasArt; $cust)
		End if 
	End for 
	ARRAY TEXT:C222($aFGKEY; 0)
End if 

If (<>fContinue)  // Modified by: Mel Bohince (6/14/16) 
	//*Test S&S by date created
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 ams_DeleteWithoutHeaderRecord
		
		$sns_RecentSet:=ams_RecentSnS($artCutOffDate)
		USE SET:C118($sns_RecentSet)
		ARRAY TEXT:C222($aHasSnS; 0)
		DISTINCT VALUES:C339([Finished_Goods_SizeAndStyles:132]CustID:52; $aHasSnS)
		REDUCE SELECTION:C351([Finished_Goods_SizeAndStyles:132]; 0)
		$sns_RecentSet:=ams_RecentSnS  //clear set
		
	Else 
		
		QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]DateCreated:3>=$artCutOffDate)
		ARRAY TEXT:C222($aHasSnS; 0)
		DISTINCT VALUES:C339([Finished_Goods_SizeAndStyles:132]CustID:52; $aHasSnS)
		REDUCE SELECTION:C351([Finished_Goods_SizeAndStyles:132]; 0)
		
	End if   // END 4D Professional Services : January 2019 query selection
	
End if 

If (<>fContinue)
	READ WRITE:C146([Customers:16])
	ALL RECORDS:C47([Customers:16])
	$numCust:=Records in selection:C76([Customers:16])
	uThermoInit($numCust; "Marking Active Customers")
	For ($i; 1; $numCust)
		$active:=False:C215
		$cust:=[Customers:16]ID:1
		$hit:=Find in array:C230($aHasInventory; $cust)
		If ($hit>-1)
			$active:=True:C214
		Else 
			$hit:=Find in array:C230($aHasBooking; $cust)
			If ($hit>-1)
				$active:=True:C214
			Else 
				$hit:=Find in array:C230($aHasEstimate; $cust)
				If ($hit>-1)
					$active:=True:C214
				Else 
					$hit:=Find in array:C230($aHasJob; $cust)
					If ($hit>-1)
						$active:=True:C214
					Else 
						$hit:=Find in array:C230($aHasArt; $cust)
						If ($hit>-1)
							$active:=True:C214
						Else 
							$hit:=Find in array:C230($aHasSnS; $cust)  // Modified by: Mel Bohince (6/14/16) 
							If ($hit>-1)
								$active:=True:C214
							End if 
						End if 
					End if 
				End if 
			End if 
		End if 
		
		If ($active)
			[Customers:16]Active:15:=True:C214
		Else 
			[Customers:16]Active:15:=False:C215
		End if 
		
		If ([Customers:16]ID:1="00001")  //protect the arkay record
			[Customers:16]Active:15:=True:C214
		End if 
		
		SAVE RECORD:C53([Customers:16])
		NEXT RECORD:C51([Customers:16])
		uThermoUpdate($i)
		
		If (Not:C34(<>fContinue))
			$i:=1+$numCust
		End if 
	End for 
	uThermoClose
End if 