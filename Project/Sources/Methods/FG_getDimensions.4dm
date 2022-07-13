//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 08/22/12, 12:11:41
// ----------------------------------------------------
// Method: FG_getDimensions(->$)
// Description
// use the better of A#'s dimensions, fg's, or carton-specs
// ----------------------------------------------------


C_POINTER:C301($1; $2; $3; $targetA; $targetB; $targetHt)
C_TEXT:C284($4; $file_outline_number; $cpn; $5)
C_BOOLEAN:C305($0)  //true if succesfull

$targetA:=$1
$targetB:=$2
$targetHt:=$3
//init receiving variables
$targetA->:=""
$targetB->:=""
$targetHt->:=""
$file_outline_number:=$4
$cpn:=$5

//1st choice is S&S spec
If (Length:C16($file_outline_number)>5)  //look up a#
	QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]FileOutlineNum:1=$file_outline_number)
	If (Records in selection:C76([Finished_Goods_SizeAndStyles:132])=1)
		$targetA->:=[Finished_Goods_SizeAndStyles:132]Dim_A:17
		$targetB->:=[Finished_Goods_SizeAndStyles:132]Dim_B:18
		$targetHt->:=[Finished_Goods_SizeAndStyles:132]Dim_Ht:19
	End if 
End if 

If (Length:C16($targetA->)=0)  //didnt get it from S&S
	If ([Finished_Goods:26]ProductCode:1#$cpn)
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=$cpn)
	End if 
	//2nd choice is fg record
	If ([Finished_Goods:26]ProductCode:1=$cpn)
		$targetA->:=[Finished_Goods:26]Width:7
		$targetB->:=[Finished_Goods:26]Depth:8
		$targetHt->:=[Finished_Goods:26]Height:9
		
	Else   //fall back is to the carton spec
		If ([Estimates_Carton_Specs:19]ProductCode:5=$cpn)
			$targetA->:=[Estimates_Carton_Specs:19]Width:17
			$targetB->:=[Estimates_Carton_Specs:19]Depth:18
			$targetHt->:=[Estimates_Carton_Specs:19]Height:19
		End if 
	End if 
End if 

If (Length:C16($targetA->)>0)
	$0:=True:C214
Else 
	$0:=False:C215
End if 