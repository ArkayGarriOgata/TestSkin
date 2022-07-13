//%attributes = {"publishedWeb":true}
//sAskMeTotals
//•022597  MLB  use arrays
// • mel (8/25/04, 12:44:30) use jmi completed date for totaling

C_LONGINT:C283($i)
ARRAY LONGINT:C221($aOpen; 0)
ARRAY LONGINT:C221($aQty; 0)
ARRAY REAL:C219($aOR; 0)

//iitotal1:=Sum([OrderLines]Qty_Open)`planners want over run also
iitotal1:=0
iitotal2:=0
iitotal3:=0
iitotal4:=0
i3:=0

SELECTION TO ARRAY:C260([Customers_Order_Lines:41]Qty_Open:11; $aOpen; [Customers_Order_Lines:41]Quantity:6; $aQty; [Customers_Order_Lines:41]OverRun:25; $aOR; [Customers_Order_Lines:41]Status:9; $aStatus)
For ($i; 1; Size of array:C274($aOpen))
	If (Position:C15($aStatus{$i}; " Cancel Kill Closed ")=0)
		If ($aOpen{$i}>0)
			iitotal1:=iitotal1+$aOpen{$i}
			i3:=i3+($aOpen{$i}+($aQty{$i}*($aOR{$i}/100)))
		End if 
	End if 
End for 

ARRAY LONGINT:C221($aOpen; 0)
ARRAY LONGINT:C221($aQty; 0)
ARRAY REAL:C219($aOR; 0)
ARRAY LONGINT:C221($aOpen; 0)
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
	
	SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]OpenQty:16; $aOpen)
	For ($i; 1; Size of array:C274($aOpen))
		iitotal2:=iitotal2+$aOpen{$i}
	End for 
	
Else 
	
	iitotal2:=iitotal2+Sum:C1([Customers_ReleaseSchedules:46]OpenQty:16)
	
	
End if   // END 4D Professional Services : January 2019 

//iitotal2:=Sum([ReleaseSchedule]OpenQty)

ARRAY LONGINT:C221($aOpen; 0)

If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
	SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]QtyOH:9; $aOpen)
	For ($i; 1; Size of array:C274($aOpen))
		iitotal3:=iitotal3+$aOpen{$i}
	End for 
	
Else 
	iitotal3:=iitotal3+Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
	
End if   // END 4D Professional Services : January 2019 

ARRAY LONGINT:C221($aOpen; 0)
ARRAY LONGINT:C221($aQty; 0)
SELECTION TO ARRAY:C260([Job_Forms_Items:44]Qty_Yield:9; $aOpen; [Job_Forms_Items:44]Qty_Actual:11; $aQty; [Job_Forms_Items:44]Completed:39; $aDate)
For ($i; 1; Size of array:C274($aOpen))
	
	If ($aDate{$i}=!00-00-00!)  // • mel (8/25/04, 12:44:30)
		$openProduction:=$aOpen{$i}-$aQty{$i}
		If ($openProduction>0)
			iitotal4:=iitotal4+$openProduction
		End if 
	End if 
End for 

totalDemand:=iitotal1
totalSupply:=iitotal3+iitotal4
totalStatus:=totalSupply-totalDemand
totalStatOR:=totalSupply-i3

ARRAY LONGINT:C221($aOpen; 0)
ARRAY LONGINT:C221($aQty; 0)
ARRAY REAL:C219($aOR; 0)