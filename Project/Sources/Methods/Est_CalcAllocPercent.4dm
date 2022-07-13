//%attributes = {"publishedWeb":true}
//PM:  Est_CalcAllocPercentstnum;diffnum)->totalSqin  090899  mlb
//return greater than zero would be success
//determine the percent of total job cost that an
//item will receive based on square inch allocation
//•••call Est_CollectionCartons ("Load";[ESTIMATE]EstimateNo;diff) before thismeth
//see also Job_CalcAllocPercent

C_REAL:C285($TotalSqIn; $TotalSqInYD; $0)
C_LONGINT:C283($i; $hit; $numFormCartons; $numCartons; $next)
C_TEXT:C284($1)
C_TEXT:C284($2)

utl_Trace
If (Count parameters:C259>0)
	$estimate:=$1
	$differential:=$2
Else 
	$estimate:=[Estimates:17]EstimateNo:1
	$differential:=[Estimates_Differentials:38]diffNum:3
End if 
//*   Get the cartons on this job for qty component of total sqin calc
QUERY:C277([Estimates_FormCartons:48]; [Estimates_FormCartons:48]DiffFormID:2=$estimate+$differential+"@")  //3-0144.00AA...
ARRAY TEXT:C222($aFormCarton; 0)  //•120695  MLB  UPR 234 chg method of primary keying CartonSpec records
ARRAY LONGINT:C221($aFormYldQty; 0)
ARRAY LONGINT:C221($aFormWntQty; 0)
SELECTION TO ARRAY:C260([Estimates_FormCartons:48]Carton:1; $aFormCarton; [Estimates_FormCartons:48]MakesQty:5; $aFormYldQty; [Estimates_FormCartons:48]FormWantQty:9; $aFormWntQty)  //8/26/94
$numFormCartons:=Size of array:C274($aFormCarton)
SORT ARRAY:C229($aFormCarton; $aFormYldQty; $aFormWntQty; >)
REDUCE SELECTION:C351([Estimates_FormCartons:48]; 0)

//*Determine the total sqin on the job, for varible allocation
$TotalSqIn:=0
$TotalSqInYD:=0
For ($i; 1; $numFormCartons)  //calc total sqIn for the job
	$inches:=Est_CollectionCartons("SquareInches"; $aFormCarton{$i})
	If ($inches>0)
		$TotalSqInYD:=$TotalSqInYD+($inches*$aFormYldQty{$i})
		$TotalSqIn:=$TotalSqIn+($inches*$aFormWntQty{$i})
	Else   //carton doesn't have sqin specified, so fail
		$TotalSqIn:=-1
		$TotalSqInYD:=0
		$i:=$i+$numFormCartons
	End if 
End for 

//*Determine eachs items participation
If ($TotalSqIn>0)
	$err:=Est_CollectionCartons("Set"; "TotalSqIn"; ""; $TotalSqIn)
	$err:=Est_CollectionCartons("Set"; "TotalSqInYld"; ""; $TotalSqInYD)
	$wantQty:=0
	$yldQty:=0
	$currCarton:=$aFormCarton{1}
	For ($i; 1; $numFormCartons)  //calc total sqIn for the job
		If ($currCarton#$aFormCarton{$i})
			$err:=Est_CollectionCartons("Set"; "AllocPct"; $currCarton; $wantQty)
			$err:=Est_CollectionCartons("Set"; "AllocPctYld"; $currCarton; $yldQty)
			$wantQty:=0
			$yldQty:=0
			$currCarton:=$aFormCarton{$i}
		End if 
		$wantQty:=$wantQty+$aFormWntQty{$i}
		$yldQty:=$yldQty+$aFormYldQty{$i}
	End for 
	$err:=Est_CollectionCartons("Set"; "AllocPct"; $currCarton; $wantQty)
	$err:=Est_CollectionCartons("Set"; "AllocPctYld"; $currCarton; $yldQty)
	//*Store the results
	$err:=Est_CollectionCartons("Store"; "AllocPct")
	
End if   //total sqin

$0:=$TotalSqIn  //greater than zero would be success