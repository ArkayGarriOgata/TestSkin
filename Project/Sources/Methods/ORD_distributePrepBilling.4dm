//%attributes = {"publishedWeb":true}
//ORD_distributePrepBilling 9/11/01 mlb(hq)
//take the dollar value of a prep orderline and 
//spread it over selected FG_Specs of the same project

C_REAL:C285(rAvailable; rAcctTotal; rDistributed)
C_LONGINT:C283($i; $numOL; vOrd)

zwStatusMsg("DISTRIBUTING"; "Order dollars to Prep charges")

vOrd:=[Customers_Orders:40]OrderNumber:1
$pjt:=[Customers_Orders:40]ProjectNumber:53

If (Length:C16($pjt)=0)
	$pjt:=Pjt_PickFromList([Customers_Orders:40]CustID:2)
	[Customers_Orders:40]ProjectNumber:53:=$pjt
	SAVE RECORD:C53([Customers_Orders:40])
End if 

CUT NAMED SELECTION:C334([Customers_Order_Lines:41]; "before")

rAvailable:=ORD_distributePrepAvailable(vOrd)
rAcctTotal:=ORD_distributePrepConsumed(vOrd)

rDistributed:=rAvailable-rAcctTotal
If (rDistributed>0)
	READ WRITE:C146([Prep_Charges:103])
	READ ONLY:C145([Finished_Goods_Specifications:98])
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ProjectNumber:4=$pjt)
		RELATE MANY SELECTION:C340([Prep_Charges:103]ControlNumber:1)
		QUERY SELECTION:C341([Prep_Charges:103]; [Prep_Charges:103]OrderNumber:8=0; *)
		QUERY SELECTION:C341([Prep_Charges:103];  | [Prep_Charges:103]OrderNumber:8=vOrd)  //so you can back outhe amount
		
		
	Else 
		
		
		QUERY BY FORMULA:C48([Prep_Charges:103]; \
			(\
			([Prep_Charges:103]OrderNumber:8=0)\
			 | ([Prep_Charges:103]OrderNumber:8=vOrd)\
			)\
			 & ([Finished_Goods_Specifications:98]ProjectNumber:4=$pjt)\
			)
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	SELECTION TO ARRAY:C260([Prep_Charges:103]; aRecNum; [Prep_Charges:103]ControlNumber:1; aControlNum; [Prep_Charges:103]PrepItemNumber:4; aServiceItem; [Prep_Charges:103]PriceActual:5; aCost; [Prep_Charges:103]QuantityActual:3; aIssueQTY; [Prep_Charges:103]OrderNumber:8; aOrder)  //AISSUEQTY
	SORT ARRAY:C229(aControlNum; aRecNum; aServiceItem; aCost; aIssueQTY; aOrder; >)
	
	$numItems:=Size of array:C274(aRecNum)
	ARRAY TEXT:C222(aBullet; $numItems)
	ARRAY TEXT:C222(aCPN; $numItems)
	ARRAY TEXT:C222(aServiceName; $numItems)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		For ($i; 1; $numItems)
			QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ControlNumber:2=aControlNum{$i})
			aCPN{$i}:=[Finished_Goods_Specifications:98]ProductCode:3
			QUERY:C277([Prep_CatalogItems:102]; [Prep_CatalogItems:102]ItemNumber:1=aServiceItem{$i})
			aServiceName{$i}:=[Prep_CatalogItems:102]Description:2
			If (aOrder{$i}=0)
				aBullet{$i}:=""
			Else 
				aBullet{$i}:="•"
			End if 
		End for 
		
	Else 
		
		ARRAY TEXT:C222($_ProductCode; 0)
		ARRAY TEXT:C222($_Description; 0)
		ARRAY TEXT:C222($_ControlNumber; 0)
		ARRAY TEXT:C222($_ItemNumber; 0)
		
		
		QUERY WITH ARRAY:C644([Finished_Goods_Specifications:98]ControlNumber:2; aControlNum)
		SELECTION TO ARRAY:C260([Finished_Goods_Specifications:98]ProductCode:3; $_ProductCode; \
			[Finished_Goods_Specifications:98]ControlNumber:2; $_ControlNumber\
			)
		QUERY WITH ARRAY:C644([Prep_CatalogItems:102]ItemNumber:1; aServiceItem)
		SELECTION TO ARRAY:C260([Prep_CatalogItems:102]Description:2; $_Description; \
			[Prep_CatalogItems:102]ItemNumber:1; $_ItemNumber\
			)
		C_LONGINT:C283($position)
		
		For ($i; 1; $numItems)
			$position:=Find in array:C230($_ControlNumber; aControlNum{$i})
			If ($position#-1)
				aCPN{$i}:=$_ProductCode{$position}
			End if 
			
			$position:=Find in array:C230($_ItemNumber; aServiceItem{$i})
			
			If ($position#-1)
				QUERY:C277([Prep_CatalogItems:102]; [Prep_CatalogItems:102]ItemNumber:1=aServiceItem{$i})
				aServiceName{$i}:=$_Description{$position}
			End if 
			If (aOrder{$i}=0)
				aBullet{$i}:=""
			Else 
				aBullet{$i}:="•"
			End if 
		End for 
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	If ($numItems>0)
		$winRef:=Open form window:C675([Prep_Charges:103]; "Distribution_dialog"; 8; Horizontally centered:K39:1; Vertically centered:K39:4)
		DIALOG:C40([Prep_Charges:103]; "Distribution_dialog")
		CLOSE WINDOW:C154($winRef)
		READ WRITE:C146([Finished_Goods_Specifications:98])
		If (OK=1)
			For ($i; 1; $numItems)
				GOTO RECORD:C242([Prep_Charges:103]; aRecNum{$i})
				If (aBullet{$i}="•")
					[Prep_Charges:103]OrderNumber:8:=vOrd
				Else 
					[Prep_Charges:103]OrderNumber:8:=0
				End if 
				SAVE RECORD:C53([Prep_Charges:103])
			End for 
		End if 
		
	Else 
		BEEP:C151
		ALERT:C41("No open prep charges for this project.")
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("This order has been completely distrubuted to Prep Charges")
End if 

USE NAMED SELECTION:C332("before")
REDUCE SELECTION:C351([Prep_Charges:103]; 0)