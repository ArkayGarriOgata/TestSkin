//%attributes = {"publishedWeb":true}
//(p) MkDetailPrint3
//send the detail line of the Mary Kay report to disk
//$1 - boolean - print this report to disk y/n
//$2 - longint - number of lines printed so far
//$3 - Longint - max number of lines allowed for one page of paper
//$4 - string - order line status
//$5 - longint - total on hand count for Order
//$6 - longint - calced excess
//$7 - date - production date
//• 1/15/98 cs created
//• 6/18/98 cs mark closed production as complete

C_LONGINT:C283($j; $2; $3; $Max; $Printed; $0)
C_POINTER:C301($ConvertPtr)
C_TEXT:C284(xText)
C_TEXT:C284($Format; $DolFormat)
C_TEXT:C284($t; $Cr)
C_BOOLEAN:C305($1; $Print2Disk)

If ($4="Closed") & (rReal11=0)  //this is  excess but does not tie to orderline through JMI
	//these are most likely proofs  
	//do nothing no printing
	$0:=$2
Else 
	$Print2Disk:=$1
	
	If ($Print2Disk)
		$0:=0
		$Format:="###,###,##0"
		$DolFormat:="###,##0.00"
		$T:=Char:C90(9)
		$Cr:=Char:C90(13)
		
		xText:=$T+$T+aSubtitle3  //PO
		xText:=xText+$T+sCPN  //CPN
		xText:=xText+$T+sDesc  //Description
		$ConvertPtr:=Get pointer:C304("rReal"+String:C10(12))
		xText:=xText+$T+String:C10($ConvertPtr->; $DolFormat)
		
		For ($j; 1; 11)  //quantities & $
			$ConvertPtr:=Get pointer:C304("rReal"+String:C10($j))
			
			Case of 
				: ($j=3)  //qty produced
					
					Case of 
						: ($ConvertPtr->=0) & (aSubTitle3#"Closed")  //donot put 'I/P' if order is close
							xText:=xText+$T+"I/P"
						: ($ConvertPtr-><0) & (aSubTitle3="Closed")  //• 6/18/98 cs do put 'Complete' if order is closed
							xText:=xText+$T+"Complete"
						Else 
							xText:=xText+$T+String:C10($ConvertPtr->; $Format)
					End case   //qty produced = 0
				: ($j=7)  //qty avail to ship
					xText:=xText+$T+String:C10($5; $Format)  //add actual on hand          
					xText:=xText+$T+String:C10($ConvertPtr->; $Format)
				: ($j=10)  //customer Resp $          
					xText:=xText+$T+String:C10($ConvertPtr->; $DolFormat)
				: ($j=11)  //Excess
					xText:=xText+$T+String:C10($ConvertPtr->; $Format)
					xText:=xText+$T+String:C10($6; $Format)  //add calced excess          
				Else 
					xText:=xText+$T+String:C10($ConvertPtr->; $Format)
			End case   //is this item qty produced
		End for 
		xText:=xText+$T+String:C10(dDate1; 1)  //last ship date      
		xText:=xText+$T+String:C10($7; 1)+$Cr  //production date     
		SEND PACKET:C103(vDoc; xText)
	Else 
		$Max:=$3
		$Printed:=$2
		$IsRoom:=($Printed<=$Max)
		
		If ($IsRoom)
			Print form:C5([Finished_Goods:26]; "rMaryKay.d")
			$0:=$Printed+1
		Else 
			PAGE BREAK:C6(>)
			iPage:=iPage+1
			Print form:C5([Finished_Goods:26]; "rMaryKay.h")
			Print form:C5([Finished_Goods:26]; "rMaryKay.d")
			$0:=1
		End if   //is room to print
	End if 
End if 