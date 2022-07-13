//%attributes = {"publishedWeb":true}
//gEstCountQtys()   -JML  9/29/93
//used by the Estimate Differential Generation dialogs(Estimate input-Diff Page.)
//This function returns the Number of Qty Scenarios which have been filled in by 
//the Salesperson or Estimator.

C_LONGINT:C283($0)
C_LONGINT:C283($Qty; $Num; $FldNum; $FileNum; $LastFld)
C_POINTER:C301($Ptr)

gEstimateLDWkSh
$FldNum:=Field:C253(->[Estimates_Carton_Specs:19]Qty1Temp:52)
$LastFld:=Field:C253(->[Estimates_Carton_Specs:19]Qty6Temp:57)
$FileNum:=Table:C252(->[Estimates_Carton_Specs:19])
$Num:=0
Repeat 
	$Ptr:=Field:C253($FileNum; $FldNum)
	$Qty:=Sum:C1($Ptr->)
	If ($Qty>0)
		$Num:=$Num+1
	End if 
	$FldNum:=$FldNum+1
Until (($Qty<1) | ($FldNum=($LastFld+1)))

$0:=$Num