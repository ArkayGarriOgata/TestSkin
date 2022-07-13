//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 02/01/07, 11:53:15
// ----------------------------------------------------
// Method: trigger_FinishedGoods()  --> 
// Modified by: Mel Bohince (9/12/13) dont set fgkey without a custid, messes up fTotalOrderLine
// Modified by: Mel Bohince (3/19/20) always set pkspec to outlinenum, and set the packing qty
// ----------------------------------------------------
C_LONGINT:C283($0)

$0:=0  //assume granted

Case of 
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)
		If ([Finished_Goods:26]Preflight:66)
			If ([Finished_Goods:26]PreflightAt:74=0)
				[Finished_Goods:26]PreflightAt:74:=TSTimeStamp
			End if 
			If ([Finished_Goods:26]PreflightDate:72#(TS2Date([Finished_Goods:26]PreflightAt:74)))
				[Finished_Goods:26]PreflightDate:72:=TS2Date([Finished_Goods:26]PreflightAt:74)
			End if 
		Else 
			[Finished_Goods:26]PreflightDate:72:=!00-00-00!
			[Finished_Goods_Specifications:98]PreflightBy:58:=""
			[Finished_Goods:26]PreflightBy:67:=""
			[Finished_Goods:26]PreflightAt:74:=0
		End if 
		
		If (Position:C15([Finished_Goods:26]Acctg_UOM:29; "ME")=0)  // Modified by: Mark Zinke (7/5/13) Replaced If below.
			[Finished_Goods:26]Acctg_UOM:29:="M"
		End if 
		[Finished_Goods:26]ProductCode:1:=Replace string:C233([Finished_Goods:26]ProductCode:1; "'"; "")  // Modified by: Mel Bohince (12/3/15) 
		
		If (Length:C16([Finished_Goods:26]CustID:2)=5)
			[Finished_Goods:26]FG_KEY:47:=[Finished_Goods:26]CustID:2+":"+[Finished_Goods:26]ProductCode:1  // Modified by: Mel Bohince (8/21/13)
		Else 
			[Finished_Goods:26]FG_KEY:47:=[Finished_Goods:26]ProductCode:1
		End if 
		
		If ([Finished_Goods:26]LastShipDate:19#!00-00-00!)  //[Finished_Goods]DateFirstShipped
			FG_setClosingMet([Finished_Goods:26]LastShipDate:19)
		End if 
		
		//If (Length([Finished_Goods]PackingSpecification)=0)// Modified by: Mel Bohince (3/19/20) always set pkspec to outlinenum
		[Finished_Goods:26]PackingSpecification:103:=[Finished_Goods:26]OutLine_Num:4
		[Finished_Goods:26]PackingQty:45:=-1
		C_OBJECT:C1216($pakSpec_es)
		$pakSpec_es:=ds:C1482.Finished_Goods_PackingSpecs.query("FileOutlineNum = :1"; [Finished_Goods:26]PackingSpecification:103)
		If ($pakSpec_es.length>0)
			[Finished_Goods:26]PackingQty:45:=$pakSpec_es[0].CaseCount
		Else 
			[Finished_Goods:26]PackingQty:45:=-2
		End if 
		//End if 
		
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		[Finished_Goods:26]ProductCode:1:=Replace string:C233([Finished_Goods:26]ProductCode:1; "'"; "")  // Modified by: Mel Bohince (12/3/15) this will mess up EDI segment delimiter
		[Finished_Goods:26]FG_KEY:47:=[Finished_Goods:26]CustID:2+":"+[Finished_Goods:26]ProductCode:1  // Modified by: Mel Bohince (8/21/13)
		//If (Length([Finished_Goods]PackingSpecification)=0)  // Modified by: Mel Bohince (3/19/20) always set pkspec to outlinenum
		[Finished_Goods:26]PackingSpecification:103:=[Finished_Goods:26]OutLine_Num:4
		// Added by: Mel Bohince (3/18/20) save #cases 
		[Finished_Goods:26]PackingQty:45:=-1
		$pakSpec_es:=ds:C1482.Finished_Goods_PackingSpecs.query("FileOutlineNum = :1"; [Finished_Goods:26]PackingSpecification:103)
		If ($pakSpec_es.length>0)
			[Finished_Goods:26]PackingQty:45:=$pakSpec_es[0].CaseCount
		Else 
			[Finished_Goods:26]PackingQty:45:=-2
		End if 
		//End if 
End case 