//JML   7/22/93
//this emulates many of Arkay's HP reports for finished Goods
//and Exmaming which show expected Yields and value/excess information.
// drop the field upr 1449 3/10/95

C_REAL:C285($Fac)
C_REAL:C285(xCostMat1; xCostLab1; xCostBurd1; xCostTtl1)
C_REAL:C285(xCostMat2; xCostLab2; xCostBurd2; xCostTtl2)
C_REAL:C285(xCostMat3; xCostLab3; xCostBurd3; xCostTtl3)
C_REAL:C285(xCostMat4; xCostLab4; xCostBurd4; xCostTtl4)
C_LONGINT:C283(xYield; $Qty)

If (Form event code:C388=On Printing Break:K2:19)
	xQty1t:=Subtotal:C97([Finished_Goods_Locations:35]QtyOH:9)
	xCostMat1t:=Subtotal:C97(xCostMat1)
	xCostLab1t:=Subtotal:C97(xCostLab1)
	xCostBurd1t:=Subtotal:C97(xCostBurd1)
	xCostTtl1t:=Subtotal:C97(xCostTtl1)
	
	xQty2t:=Subtotal:C97(xYield)
	xCostMat2t:=Subtotal:C97(xCostMat2)
	xCostLab2t:=Subtotal:C97(xCostLab2)
	xCostBurd2t:=Subtotal:C97(xCostBurd2)
	xCostTtl2t:=Subtotal:C97(xCostTtl2)
	
	xQty3t:=Subtotal:C97([Finished_Goods_Locations:35]QtyCommitted:10)
	xCostMat3t:=Subtotal:C97(xCostMat3)
	xCostLab3t:=Subtotal:C97(xCostLab3)
	xCostBurd3t:=Subtotal:C97(xCostBurd3)
	xCostTtl3t:=Subtotal:C97(xCostTtl3)
	
	xQty4t:=Subtotal:C97([Finished_Goods_Locations:35]QtyExcess:11)
	xCostMat4t:=Subtotal:C97(xCostMat4)
	xCostLab4t:=Subtotal:C97(xCostLab4)
	xCostBurd4t:=Subtotal:C97(xCostBurd4)
	xCostTtl4t:=Subtotal:C97(xCostTtl4)
	
End if 


If (Form event code:C388=On Header:K2:17)
	QUERY:C277([Customers:16]; [Customers:16]ID:1=[Finished_Goods_Locations:35]CustID:16)
	xCustName:=[Customers:16]Name:2
End if 

If (Form event code:C388=On Display Detail:K2:22)
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=[Finished_Goods_Locations:35]JobForm:19; *)
	QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]ProductCode:3=[Finished_Goods_Locations:35]ProductCode:1)
	
	xCostMat1:=[Job_Forms_Items:44]Cost_Mat:12*[Finished_Goods_Locations:35]QtyOH:9
	xCostLab1:=[Job_Forms_Items:44]Cost_LAB:13*[Finished_Goods_Locations:35]QtyOH:9
	xCostBurd1:=[Job_Forms_Items:44]Cost_Burd:14*[Finished_Goods_Locations:35]QtyOH:9
	xCostTtl1:=[Job_Forms_Items:44]ActCost_M:27*[Finished_Goods_Locations:35]QtyOH:9
	
	If (([Finished_Goods_Locations:35]Location:2="Ex@") & ([Finished_Goods_Locations:35]PercentYield:17#0))
		xYield:=[Finished_Goods_Locations:35]QtyOH:9*[Finished_Goods_Locations:35]PercentYield:17/100
		$Qty:=xYield
		xCostMat2:=[Job_Forms_Items:44]Cost_Mat:12*xYield
		xCostLab2:=[Job_Forms_Items:44]Cost_LAB:13*xYield
		xCostBurd2:=[Job_Forms_Items:44]Cost_Burd:14*xYield
		xCostTtl2:=[Job_Forms_Items:44]ActCost_M:27*xYield
		
	Else 
		$Qty:=[Finished_Goods_Locations:35]QtyOH:9  //used as bottom of quotients with valued & excess to prorate costs
		xYield:=0
		xCostMat2:=0
		xCostLab2:=0
		xCostBurd2:=0
		xCostTtl2:=0
	End if 
	//value & excess costs are dependent first on if xYield was defined
	//if so costs equal ration of xyield/onhand, otherise
	$Fac:=[Finished_Goods_Locations:35]QtyCommitted:10/$qty
	xCostMat3:=[Job_Forms_Items:44]Cost_Mat:12*$Fac
	xCostLab3:=[Job_Forms_Items:44]Cost_LAB:13*$Fac
	xCostBurd3:=[Job_Forms_Items:44]Cost_Burd:14*$Fac
	xCostTtl3:=[Job_Forms_Items:44]ActCost_M:27*$Fac
	
	$Fac:=[Finished_Goods_Locations:35]QtyExcess:11/$qty
	xCostMat4:=[Job_Forms_Items:44]Cost_Mat:12*$Fac
	xCostLab4:=[Job_Forms_Items:44]Cost_LAB:13*$Fac
	xCostBurd4:=[Job_Forms_Items:44]Cost_Burd:14*$Fac
	xCostTtl4:=[Job_Forms_Items:44]ActCost_M:27*$Fac
End if 
