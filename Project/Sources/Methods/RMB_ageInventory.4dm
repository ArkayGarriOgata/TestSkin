//%attributes = {"publishedWeb":true}
//PM: RMB_ageInventory(poitem;onhand;30ptr;60ptr;90ptr;120ptr;unknownptr) -> 
//@author Mel - 5/15/03  14:56

C_TEXT:C284($1)
C_REAL:C285($onHand; $2)
C_DATE:C307($today; $age30; $age60; $age90; $age120; $ageOver120; $ageUnknown)
C_POINTER:C301($3; $4; $5; $6; $7; $ptr30; $ptr60; $ptr90; $ptr120; $ptrUnkn)

$ptr30:=$3
$ptr60:=$4
$ptr90:=$5
$ptr120:=$6
$ptrUnkn:=$7
$ptr30->:=0
$ptr60->:=0
$ptr90->:=0
$ptr120->:=0
$ptrUnkn->:=0
$today:=4D_Current_date
$age30:=Add to date:C393($today; 0; 0; -30)
$age60:=Add to date:C393($today; 0; 0; -60)
$age90:=Add to date:C393($today; 0; 0; -90)
$age120:=Add to date:C393($today; 0; 0; -120)
$ageOver120:=Add to date:C393($today; -10; 0; 0)
$ageUnknown:=!00-00-00!
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
	
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]POItemKey:4=$1; *)
	QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Receipt")
	ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3; <)
	$eof:=Records in selection:C76([Raw_Materials_Transactions:23])
	$onHand:=$2
	
	While ($onHand>0) & ($eof>0)
		$eof:=$eof-1
		//how much this old
		Case of 
			: ([Raw_Materials_Transactions:23]Qty:6>$onHand)  //entire amount is this old
				$dollars:=$onHand*[Raw_Materials_Transactions:23]ActCost:9
				$onHand:=0
			: ([Raw_Materials_Transactions:23]Qty:6<=$onHand)  //some is this old
				$dollars:=[Raw_Materials_Transactions:23]Qty:6*[Raw_Materials_Transactions:23]ActCost:9
				$onHand:=$onHand-[Raw_Materials_Transactions:23]Qty:6
			Else 
				$dollars:=0
		End case 
		
		Case of 
			: ($dollars=0)
				//skip      
			: ([Raw_Materials_Transactions:23]XferDate:3=$ageUnknown)
				$ptrUnkn->:=$ptrUnkn->+$dollars
			: ([Raw_Materials_Transactions:23]XferDate:3>=$age30)
				$ptr30->:=$ptr30->+$dollars
			: ([Raw_Materials_Transactions:23]XferDate:3>=$age60)
				$ptr60->:=$ptr60->+$dollars
			: ([Raw_Materials_Transactions:23]XferDate:3>=$age90)
				$ptr90->:=$ptr90->+$dollars
			: ([Raw_Materials_Transactions:23]XferDate:3>=$age120)
				$ptr120->:=$ptr120->+$dollars
			Else 
				$ptrUnkn->:=$ptrUnkn->+$dollars
		End case 
		
		If ($eof>0)
			NEXT RECORD:C51([Raw_Materials_Transactions:23])
		End if 
	End while 
	
Else 
	
	//remove next and ordre by
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]POItemKey:4=$1; *)
	QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Receipt")
	$eof:=Records in selection:C76([Raw_Materials_Transactions:23])
	$onHand:=$2
	
	ARRAY DATE:C224($_XferDate; 0)
	ARRAY REAL:C219(_Qty; 0)
	ARRAY REAL:C219($_ActCost; 0)
	
	SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]XferDate:3; $_XferDate; \
		[Raw_Materials_Transactions:23]Qty:6; $_Qty; \
		[Raw_Materials_Transactions:23]ActCost:9; $_ActCost)
	
	SORT ARRAY:C229($_XferDate; $_Qty; $_ActCost; <)
	C_LONGINT:C283($Iter)
	$Iter:=1
	
	
	While ($onHand>0) & ($eof>0)
		$eof:=$eof-1
		
		Case of 
			: ($_Qty{$Iter}>$onHand)  //entire amount is this old
				$dollars:=$onHand*$_ActCost{$Iter}
				$onHand:=0
			: ($_Qty{$Iter}<=$onHand)  //some is this old
				$dollars:=$_Qty{$Iter}*$_ActCost{$Iter}
				$onHand:=$onHand-$_Qty{$Iter}
			Else 
				$dollars:=0
		End case 
		
		Case of 
			: ($dollars=0)
				//skip      
			: ($_XferDate{$Iter}=$ageUnknown)
				$ptrUnkn->:=$ptrUnkn->+$dollars
			: ($_XferDate{$Iter}>=$age30)
				$ptr30->:=$ptr30->+$dollars
			: ($_XferDate{$Iter}>=$age60)
				$ptr60->:=$ptr60->+$dollars
			: ($_XferDate{$Iter}>=$age90)
				$ptr90->:=$ptr90->+$dollars
			: ($_XferDate{$Iter}>=$age120)
				$ptr120->:=$ptr120->+$dollars
			Else 
				$ptrUnkn->:=$ptrUnkn->+$dollars
		End case 
		
		If ($eof>0)
			$Iter:=$Iter+1
		End if 
	End while 
	
End if   // END 4D Professional Services : January 2019 
