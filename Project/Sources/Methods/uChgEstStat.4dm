//%attributes = {"publishedWeb":true}
//uChgEstStat                 uses optimistic status change

//(s)[Estimate].Input_Status

//upr 1230 9/22/94

//11/21/94 UPR 1328 chip

//12/8/94 UPR 1353 Chip

//upr1138b 2/15/95

//5/3/95 upr 1487

//•060195  MLB  UPR 184

//•012596  MLB  UPR 184, add contract pricing during status change

//•050396  MLB  UPR 184 continued, add costing

//• 8/14/97 cs remove safety on searches 

//• 4/9/98 cs nan checking/removal

//•070198  MLB  warn if high OOP costs 

//•010699  MLB  rewrite to case structure 

C_TEXT:C284($oldStat; $1; $newStatus)  //upr1138b 2/15/95

$newStatus:=[Estimates:17]Status:30
If (Count parameters:C259=1)
	$oldStat:=$1
Else 
	$oldStat:=Old:C35([Estimates:17]Status:30)
End if 

C_TEXT:C284($MachItems; $MatItems)
$MachItems:=""
$MatItems:=""

Case of 
	: ($newStatus="Quote@")
		Case of 
			: (Position:C15("Price"; $oldStat)#0)  //cool
				
				[Estimates:17]DateQuoted:61:=4D_Current_date
			: (Position:C15("Excess"; $oldStat)#0)  //cool
				
				[Estimates:17]DateQuoted:61:=4D_Current_date
			Else 
				[Estimates:17]Status:30:=$oldStat
				BEEP:C151
				ALERT:C41("Must be Priced or Excess before being changed to Quoted.")
		End case 
		
	: ($newStatus="Estimated")
		Case of 
			: (User in group:C338(Current user:C182; "PriceManager"))  //cool
				
				//[ESTIMATE]PriceDate:=4D_Current_date
				
			Else 
				[Estimates:17]Status:30:=$oldStat
				BEEP:C151
				ALERT:C41("Must be a PriceManager to change to Estimated.")
		End case 
		
	: ($newStatus="Price@")
		Case of 
			: (User in group:C338(Current user:C182; "PriceManager"))  //cool
				
				//[ESTIMATE]PriceDate:=4D_Current_date
				
			Else 
				[Estimates:17]Status:30:=$oldStat
				BEEP:C151
				ALERT:C41("Must be a PriceManager to change to Priced.")
		End case 
		
	: ($newStatus="Excess")
		Case of 
			: (User in group:C338(Current user:C182; "PriceManager"))  //cool
				
			Else 
				[Estimates:17]Status:30:=$oldStat
				BEEP:C151
				ALERT:C41("Must be a PriceManager to change to Excess.")
		End case 
		
	: ($newStatus="New")
		If ($oldStat="RFQ")  //5/3/95 upr 1487
			
			[Estimates:17]DateRFQ:52:=!00-00-00!
			[Estimates:17]DateRFQTime:53:=?00:00:00?
		End if 
		
	: ($newStatus="RFQ")
		
		If (uChkMissingInfo([Estimates:17]EstimateNo:1; "RFQ")=0)
			//uChgPSpecStat ([ESTIMATE]EstimateNo)`• mlb - 10/25/02  14:16
			
			//[ESTIMATE]RFQDate:=4D_Current_date  `UPR 1353
			
			//[ESTIMATE]RFQTime:=4d_Current_time
			
		Else 
			[Estimates:17]Status:30:=$oldStat
			BEEP:C151
			ALERT:C41("Supply the missing information before setting status to RFQ")
		End if 
		gEstimateLDWkSh("Wksht")
		
	: ($newStatus="CONTRACT")  //•060195  MLB  UPR 184
		
		If (uChkMissingInfo([Estimates:17]EstimateNo:1; "Contract")=0)
			//uChgPSpecStat ([ESTIMATE]EstimateNo)
			
			//[ESTIMATE]RFQDate:=4D_Current_date  `UPR 1353
			
			//[ESTIMATE]RFQTime:=4d_Current_time
			
			If (False:C215)  //•010699  MLB  avoid sort
				
				gEstimateLDWkSh("Both")
			End if 
			[Estimates:17]PricedBy:15:=uContractPrice([Estimates:17]EstimateNo:1)
		Else 
			[Estimates:17]Status:30:=$oldStat
			BEEP:C151
			ALERT:C41("Supply the missing information before setting status to Contract")
		End if   //nothing missing
		
		gEstimateLDWkSh("Wksht")
		
	: ($newStatus="Budget@")
		uChkHighOOP
		uChkMissingCost([Estimates:17]EstimateNo:1)
		
	: ($newStatus="Estimated@")
		uChkHighOOP
		uChkMissingCost([Estimates:17]EstimateNo:1)
		
	: ($newStatus="Priced@")
		uChkHighOOP
		uChkMissingCost([Estimates:17]EstimateNo:1)
		
	: ($newStatus="Kill@")  //• mlb - 7/31/01  16:29
		
		[Estimates:17]JobNo:50:=0
		[Estimates:17]OrderNo:51:=0
End case 
//