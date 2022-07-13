//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 10/04/06, 14:56:24
// ----------------------------------------------------
// Method: Ord_CheckItemsForConsistency
// ----------------------------------------------------
//*   Check if any of the carton item numbers are duplicated
// Modified by: Mel Bohince (6/18/13) allow multi-pricing of items

C_TEXT:C284($setNameForCartonDiffs; $3)
C_LONGINT:C283($problem; $0)

$setNameForCartonDiffs:=$3
$problem:=0  // it'll work

MESSAGE:C88(Char:C90(13)+" Checking c-spec items...")  //upr 1437 2/20/95  
USE SET:C118($setNameForCartonDiffs)
$numRecs:=Records in selection:C76([Estimates_Carton_Specs:19])
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	
	ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1; >)
	FIRST RECORD:C50([Estimates_Carton_Specs:19])
	
	
Else 
	
	ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1; >)
	
End if   // END 4D Professional Services : January 2019 First record
// 4D Professional Services : after Order by , query or any query type you don't need First record  
ARRAY TEXT:C222($aitems; 0)
DISTINCT VALUES:C339([Estimates_Carton_Specs:19]Item:1; $aitems)
If (Size of array:C274($aitems)<$numRecs)  //some items are on multiforms
	//*.      if there are duplicates, chk the cpn and price for consistency    
	$lastItem:=""
	$lastCPN:=""
	$lastPrice:=0  //3/13/95 jb request
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		
		For ($i; 1; $numRecs)
			If ($lastItem=[Estimates_Carton_Specs:19]Item:1)
				
				If ($lastCPN#[Estimates_Carton_Specs:19]ProductCode:5)
					$problem:=1
					uConfirm("Process canceled."+Char:C90(13)+"An item number is duplicated with different CPNs."; "OK"; "Help")
					$i:=$i+$numRecs  //break
				Else 
					
					Case of 
						: (True:C214)  // Modified by: Mel Bohince (6/18/13) allow multi-pricing of items
							//allow multi pricing
							
						: (rb1=1)
							If ($lastPrice#[Estimates_Carton_Specs:19]PriceWant_Per_M:28)
								$problem:=2
								uConfirm("Process canceled."+Char:C90(13)+"An item number is duplicated with different want prices."; "OK"; "Help")
								$i:=$i+$numRecs  //break
							End if 
						: (rb2=1)
							If ($lastPrice#[Estimates_Carton_Specs:19]PriceYield_PerM:30)
								$problem:=3
								uConfirm("Process canceled."+Char:C90(13)+"An item number is duplicated with different yield prices."; "OK"; "Help")
								$i:=$i+$numRecs  //break
							End if 
					End case 
					
				End if 
				
			Else 
				$lastItem:=[Estimates_Carton_Specs:19]Item:1
				$lastCPN:=[Estimates_Carton_Specs:19]ProductCode:5
				Case of 
					: (rb1=1)
						$lastPrice:=[Estimates_Carton_Specs:19]PriceWant_Per_M:28  //3/13/95 jb request
					: (rb2=1)
						$lastPrice:=[Estimates_Carton_Specs:19]PriceYield_PerM:30  //3/13/95 jb request              
				End case 
			End if 
			
			NEXT RECORD:C51([Estimates_Carton_Specs:19])
		End for 
		
	Else 
		
		ARRAY REAL:C219($_PriceYield_PerM; 0)
		ARRAY REAL:C219($_PriceWant_Per_M; 0)
		ARRAY TEXT:C222($_ProductCode; 0)
		ARRAY TEXT:C222($_Item; 0)
		
		
		SELECTION TO ARRAY:C260([Estimates_Carton_Specs:19]PriceYield_PerM:30; $_PriceYield_PerM; [Estimates_Carton_Specs:19]PriceWant_Per_M:28; $_PriceWant_Per_M; [Estimates_Carton_Specs:19]ProductCode:5; $_ProductCode; [Estimates_Carton_Specs:19]Item:1; $_Item)
		
		
		For ($i; 1; $numRecs; 1)
			If ($lastItem=$_Item{$i})
				
				If ($lastCPN#$_ProductCode{$i})
					$problem:=1
					uConfirm("Process canceled."+Char:C90(13)+"An item number is duplicated with different CPNs."; "OK"; "Help")
					$i:=$i+$numRecs  //break
				Else 
					
					Case of 
						: (True:C214)  // Modified by: Mel Bohince (6/18/13) allow multi-pricing of items
							//allow multi pricing
							
						: (rb1=1)
							If ($lastPrice#$_PriceWant_Per_M{$i})
								$problem:=2
								uConfirm("Process canceled."+Char:C90(13)+"An item number is duplicated with different want prices."; "OK"; "Help")
								$i:=$i+$numRecs  //break
							End if 
						: (rb2=1)
							If ($lastPrice#$_PriceYield_PerM{$i})
								$problem:=3
								uConfirm("Process canceled."+Char:C90(13)+"An item number is duplicated with different yield prices."; "OK"; "Help")
								$i:=$i+$numRecs  //break
							End if 
					End case 
					
				End if 
				
			Else 
				$lastItem:=$_Item{$i}
				$lastCPN:=$_ProductCode{$i}
				Case of 
					: (rb1=1)
						$lastPrice:=$_PriceWant_Per_M{$i}  //3/13/95 jb request
					: (rb2=1)
						$lastPrice:=$_PriceYield_PerM{$i}  //3/13/95 jb request              
				End case 
			End if 
			
		End for 
		
	End if   // END 4D Professional Services : January 2019 query selection
	
End if 
ARRAY TEXT:C222($aitems; 0)
$0:=$problem