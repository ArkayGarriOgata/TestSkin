//%attributes = {"publishedWeb":true}
//PM:  Est_FormCartonAllocation  110499  mlb
//formerly sRunEstCartnCst()-JML8/18/93, mlb 11 9 93 Computes the cost of cartons 
//on this form
//8/22/94 change algo            FROM:
//1 - calculate per sheet cost of the form.
//2-determine total # up for for &
//3 - determine total sq inches for form
//                                               TO
//1 calc sqin
//2 find cost per sqin on form
//3 take item sqin*cost/sqin
//9/22/94 fill in
//10/15/94 fill in
//• 4/10/98 cs Nan Checking

utl_Trace

C_LONGINT:C283($i; $numFormCartons)
C_REAL:C285($inches; $TotalSqIn; $TotalSqInYD)
ARRAY TEXT:C222($aFormCarton; 0)  //•120695  MLB  UPR 234 chg method of primary keying CartonSpec records
ARRAY LONGINT:C221($aFormYldQty; 0)
ARRAY LONGINT:C221($aFormWntQty; 0)

//$SheetCost:=[CaseForm]CostTTL/[CaseForm]NumberSheets  `1 - calculate per sheet c
//$numSheets:=[CaseForm]NumberSheets
//*get the total cost of the job
$otCost:=[Estimates_DifferentialsForms:47]Cost_Overtime:25
$laborCost:=[Estimates_DifferentialsForms:47]CostTtlLabor:15+$otCost  //•042397  MLB 
$burdonCost:=[Estimates_DifferentialsForms:47]CostTtlOH:16
$matlCost:=[Estimates_DifferentialsForms:47]CostTtlMatl:17
$scrapCost:=[Estimates_DifferentialsForms:47]Cost_Scrap:24
$yieldCost:=[Estimates_DifferentialsForms:47]Cost_Yield_Adds:27

//*   see if the plates, dupes, & dies are priced separtely
$breakouts:=Round:C94(uNANCheck([Estimates_DifferentialsForms:47]Cost_Dups:20+[Estimates_DifferentialsForms:47]Cost_Plates:21+[Estimates_DifferentialsForms:47]Cost_Dies:22); 0)  //•041797  mBohince 
If ($Breakouts>0)  //• 4/23/97 cs insure that breakouts are not negative, from data entry, & not Nans
	$laborCost:=$laborCost-($breakouts*0.3)  //assume some distributions`•042397  MLB change / to *
	$burdonCost:=$burdonCost-($breakouts*0.1)
	$matlCost:=$matlCost-($breakouts*0.6)
Else 
	$breakouts:=0  //assertion  
End if 

READ WRITE:C146([Estimates_FormCartons:48])
QUERY:C277([Estimates_FormCartons:48]; [Estimates_FormCartons:48]DiffFormID:2=[Estimates_DifferentialsForms:47]DiffFormId:3)

SELECTION TO ARRAY:C260([Estimates_FormCartons:48]Carton:1; $aFormCarton; [Estimates_FormCartons:48]MakesQty:5; $aFormYldQty; [Estimates_FormCartons:48]FormWantQty:9; $aFormWntQty)  //8/26/94
$numFormCartons:=Size of array:C274($aFormCarton)
ARRAY REAL:C219($aFormAllocPct; $numFormCartons)
ARRAY REAL:C219($aFormAllocPctYld; $numFormCartons)
ARRAY REAL:C219($aFormCartonMatl; $numFormCartons)
ARRAY REAL:C219($aFormCartonLabor; $numFormCartons)
ARRAY REAL:C219($aFormCartonBurden; $numFormCartons)
ARRAY REAL:C219($aFormCartonTotal; $numFormCartons)

$TotalSqIn:=0
$TotalSqInYD:=0
For ($i; 1; $numFormCartons)  //calc total sqIn for the job
	$inches:=Est_CollectionCartons("SquareInches"; $aFormCarton{$i})
	$TotalSqIn:=$TotalSqIn+($inches*$aFormWntQty{$i})
	$TotalSqInYD:=$TotalSqInYD+($inches*$aFormYldQty{$i})
End for 

For ($i; 1; $numFormCartons)  //calc total sqIn for the job
	$inches:=Est_CollectionCartons("SquareInches"; $aFormCarton{$i})
	$aFormAllocPctYld{$i}:=uNANCheck(($inches*$aFormYldQty{$i})/$TotalSqInYD)
	$aFormAllocPct{$i}:=uNANCheck(($inches*$aFormWntQty{$i})/$TotalSqIn)
	$aFormCartonMatl{$i}:=$aFormAllocPct{$i}*$matlCost/$aFormWntQty{$i}*1000  //base on want qty
	$aFormCartonLabor{$i}:=$aFormAllocPct{$i}*$laborCost/$aFormWntQty{$i}*1000
	$aFormCartonBurden{$i}:=$aFormAllocPct{$i}*$burdonCost/$aFormWntQty{$i}*1000
	$aFormCartonTotal{$i}:=$aFormCartonMatl{$i}+$aFormCartonLabor{$i}+$aFormCartonBurden{$i}
End for 

ARRAY TO SELECTION:C261($aFormAllocPct; [Estimates_FormCartons:48]AllocationPercent:11; $aFormAllocPctYld; [Estimates_FormCartons:48]AllocationPrctYield:12; $aFormCartonMatl; [Estimates_FormCartons:48]CostMatl:13; $aFormCartonLabor; [Estimates_FormCartons:48]CostLabor:14; $aFormCartonBurden; [Estimates_FormCartons:48]CostBurden:15; $aFormCartonTotal; [Estimates_FormCartons:48]ItemCost_Per_M:6)