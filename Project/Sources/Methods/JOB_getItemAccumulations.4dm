//%attributes = {"publishedWeb":true}
//PM:  JOB_getItemAccumulations  2/22/01  mlb
//collection of values to set from jmi to jf
//• mlb - 1/11/02  16:00 check for locked state

C_LONGINT:C283($1; $option; $i; $3; $4; $5)
C_TEXT:C284($2)

$option:=Count parameters:C259

Case of 
	: ($option=1)  //size arrays
		ARRAY TEXT:C222(aJF; $1)
		ARRAY LONGINT:C221(aQty; $1)
		ARRAY LONGINT:C221(aQty2; $1)
		ARRAY LONGINT:C221(iNumUp; $1)
		ARRAY LONGINT:C221(aCartonUp; $1)
		ARRAY LONGINT:C221(aRecNum; $1)
		For ($i; 1; $1)
			aJF{$i}:=""
			aRecNum{$i}:=-3
			aQty{$i}:=0
			aQty2{$i}:=0
			aCartonUp{$i}:=0
			iNumUp{$i}:=0
		End for 
		
	: ($option=4)  //init array
		aJF{$1}:=$2
		aRecNum{$1}:=$3
		iNumUp{$1}:=$4
		
	: ($option=5)  //accumulate
		$hit:=Find in array:C230(aJF; $2)
		If ($hit>-1)
			If (iNumUp{$hit}=0)  //number up hasn't been over-riden upr 60  
				aCartonUp{$hit}:=aCartonUp{$hit}+$4
			End if 
			aQty{$hit}:=aQty{$hit}+$3  //aka want
			aQty2{$hit}:=aQty2{$hit}+$5
		End if 
		
	: ($option=0)  //store the result
		For ($i; 1; Size of array:C274(aRecNum))
			If (aRecNum{$i}#-3)
				GOTO RECORD:C242([Job_Forms:42]; aRecNum{$i})
				If (fLockNLoad(->[Job_Forms:42]))  //• mlb - 1/11/02  16:00
					If (aCartonUp{$i}>0)
						[Job_Forms:42]NumberUp:26:=aCartonUp{$i}
					End if 
					[Job_Forms:42]QtyWant:22:=aQty{$i}
					[Job_Forms:42]QtyYield:30:=aQty2{$i}
					[Job_Forms:42]EstCost_M:29:=uNANCheck(([Job_Forms:42]Pld_CostTtl:14/[Job_Forms:42]QtyWant:22)*1000)
					SAVE RECORD:C53([Job_Forms:42])
				Else 
					BEEP:C151
					ALERT:C41("Form was locked, changes not saved.")
				End if 
			End if 
		End for 
		
End case 