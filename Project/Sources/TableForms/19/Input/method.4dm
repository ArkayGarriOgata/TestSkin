//[c-spec]input(LP)
//upr 1365 12/21/94
//4/26/95 fix logic of obsolete cpn
//•061395  MLB  UPR 1637 disable window stuff
//•120695  MLB  UPR 234 chg method of primary keying CartonSpec records
//•1/10/97 -cs- changes to allow multiple customers on one job
Case of 
	: (Form event code:C388=On Load:K2:1)
		BeforeCartSpec
		
	: (Form event code:C388=On Validate:K2:3)
		If ([Estimates_Carton_Specs:19]OriginalOrRepeat:9="Original") & (Length:C16([Estimates_Carton_Specs:19]ObsoleteCPN:63)>0) & ([Estimates_Carton_Specs:19]ProductCode:5#[Estimates_Carton_Specs:19]ObsoleteCPN:63)
			
			READ WRITE:C146([Finished_Goods:26])
			qryFinishedGood([Estimates_Carton_Specs:19]CustID:6; [Estimates_Carton_Specs:19]ObsoleteCPN:63)
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Finished_Goods:26]ProductCode:1; *)
			QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]CustID:16=[Finished_Goods:26]CustID:2)
			If (Records in selection:C76([Finished_Goods:26])=1)
				CONFIRM:C162([Finished_Goods:26]ProductCode:1+" has Onhand inventory of "+String:C10(Sum:C1([Finished_Goods_Locations:35]QtyOH:9); "###,###,##0")+". Make obsolete?")
				If (ok=1)
					[Finished_Goods:26]Status:14:="Superceded, Obsolete"
					SAVE RECORD:C53([Finished_Goods:26])
				End if 
			End if 
			
		End if   //obsolete should be entered    
		
		[Estimates_Carton_Specs:19]ModDate:39:=4D_Current_date
		[Estimates_Carton_Specs:19]ModWho:40:=<>zResp
		
	: (Form event code:C388=On Unload:K2:2)
		wWindowTitle("pop")
End case 
//