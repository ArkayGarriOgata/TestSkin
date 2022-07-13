//%attributes = {"publishedWeb":true}
//gEstimateLdWksh()   -JML    9/29/93
//This procedure is used by various procedures in the Estimating
//module for loading in the Carton spec records which make up the 
//Estimate.  IT can load the Qty worksheet, All Carton records, or
//the last selection of Carton records.

C_TEXT:C284($1; $What; $lastDiff)  //  Possible Values:  "Wksht"    "Last"    "All"
C_TEXT:C284(sQtyTitle1; sQtyTitle2; sQtyTitle3; sQtyTitle4; sQtyTitle5; sQtyTitle6)

If (Count parameters:C259=0)
	$What:="Wksht"
Else   //params
	$What:=$1
	If ($What="Last")  //Redisplay last selection of records
		If (sCartonTtle="WORKSHEET")
			$What:="Wksht"
		Else 
			If (sCartonTtle="DIFFERENTIAL CARTONS")
				$What:="Diff"
			Else 
				$What:="All"
			End if 
		End if   //worksheet
	End if   //last
End if   //params

OBJECT SET ENABLED:C1123(bAddCarton; False:C215)
OBJECT SET ENABLED:C1123(bDupCarton; False:C215)
//OBJECT SET ENABLED(bDelCarton;False)

Case of 
	: ($What="Both")  //display all Cartons of all Diffs & worksheet of this Estimate    012596
		QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=[Estimates:17]EstimateNo:1)
		ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]diffNum:11; >; [Estimates_Carton_Specs:19]Item:1; >)
		
	: ($What="All")  //display all Cartons of all Diffs of this Estimate
		QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=[Estimates:17]EstimateNo:1; *)  //find Estimate Qty worksheet
		QUERY:C277([Estimates_Carton_Specs:19];  & ; [Estimates_Carton_Specs:19]diffNum:11#<>sQtyWorksht)
		sCartonTtle:="CARTONS-All Differentials"
		CShowWkSh:=0
		CShowAll:=1
		sQtyTitle1:="Want qty"
		sQtyTitle2:="Want qty"
		sQtyTitle3:=""
		sQtyTitle4:=""
		sQtyTitle5:=""
		sQtyTitle6:=""
		ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]diffNum:11; >; [Estimates_Carton_Specs:19]Item:1; >)
		
	: ($What="this")
		$lastDiff:=util_base26([Estimates:17]Last_Differential_Number:31-1)
		$this:=Substring:C12(Request:C163("See Cartons for which Differential?"; $lastDiff; "Find"; "Cancel"); 1; 2)
		If (OK=1) & (Length:C16($this)=2)
			QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=[Estimates:17]EstimateNo:1; *)  //find Estimate Qty worksheet
			QUERY:C277([Estimates_Carton_Specs:19];  & ; [Estimates_Carton_Specs:19]diffNum:11=$this)
			CShowWkSh:=0
			CShowAll:=0
			sCartonTtle:="DIFFERENTIAL CARTONS"
			sQtyTitle1:="Want qty"
			sQtyTitle2:="Want qty"
			sQtyTitle3:=""
			sQtyTitle4:=""
			sQtyTitle5:=""
			sQtyTitle6:=""
			ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1; >)
		Else 
			BEEP:C151
		End if 
		
	: ($What="Diff")
		QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=[Estimates_Differentials:38]estimateNum:2; *)  //find Estimate Qty worksheet
		QUERY:C277([Estimates_Carton_Specs:19];  & ; [Estimates_Carton_Specs:19]diffNum:11=[Estimates_Differentials:38]diffNum:3)
		CShowWkSh:=0
		CShowAll:=0
		sCartonTtle:="DIFFERENTIAL CARTONS"
		sQtyTitle1:="Want qty"
		sQtyTitle2:=""
		sQtyTitle3:=""
		sQtyTitle4:=""
		sQtyTitle5:=""
		sQtyTitle6:=""
		ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1; >)
		
	Else   //Wksht
		QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=[Estimates:17]EstimateNo:1; *)  //find Estimate Qty worksheet
		QUERY:C277([Estimates_Carton_Specs:19];  & ; [Estimates_Carton_Specs:19]diffNum:11=<>sQtyWorksht)
		CShowWkSh:=1
		CShowAll:=0
		sCartonTtle:="WORKSHEET"
		sQtyTitle1:="Qty 1"
		sQtyTitle2:="Qty 2"
		sQtyTitle3:="Qty 3"
		sQtyTitle4:="Qty 4"
		sQtyTitle5:="Qty 5"
		sQtyTitle6:="Qty 6"
		OBJECT SET ENABLED:C1123(bAddCarton; True:C214)
		OBJECT SET ENABLED:C1123(bDupCarton; True:C214)
		//OBJECT SET ENABLED(bDelCarton;True)
		C_LONGINT:C283(nextItem)
		ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1; >)
		SELECTION TO ARRAY:C260([Estimates_Carton_Specs:19]Item:1; $aItems)
		nextItem:=Num:C11($aItems{Size of array:C274($aItems)})+1
End case 