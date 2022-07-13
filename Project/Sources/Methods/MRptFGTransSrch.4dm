//%attributes = {"publishedWeb":true}
//mRptFGTransSrch()  -JML  7/15/93
//called by mFGRptTrans()
//mod 6/1/94 fix bug and add cc:
//This searching interface can be compromised if the location information
//is inputted incorrectly.  For example, Finished good bin locastions should
//be inputted with an FG prefix-if not, the computer can't find them.  
//• 6/11/98 cs changed the way - the 'all transactions' functions
//  it will now recognize & respect entered date ranges
//• mlb - 3/15/02  14:56 add adjustment repot

DIALOG:C40([Finished_Goods_Transactions:33]; "FGWhatTrans")
ERASE WINDOW:C160
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	If (OK=1)
		If (cFGTrans10=1)  //• 6/11/98 cs 
			QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=dDateBegin; *)
			QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<=dDateEnd)
		Else 
			CREATE EMPTY SET:C140([Finished_Goods_Transactions:33]; "FGSet")
			QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=dDateBegin; *)
			QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<=dDateEnd)
			CREATE SET:C116([Finished_Goods_Transactions:33]; "DateSet")
			
			If (cFGTrans11=1)  //• mlb - 3/15/02  14:56
				USE SET:C118("DateSet")
				QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Adjust")
				CREATE SET:C116([Finished_Goods_Transactions:33]; "NewSet")
				UNION:C120("FGSet"; "NewSet"; "FGSet")
			End if 
			
			If (cFGTrans1=1)
				USE SET:C118("DateSet")
				QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11="WIP")
				QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9="Ex@")
				CREATE SET:C116([Finished_Goods_Transactions:33]; "NewSet")
				UNION:C120("FGSet"; "NewSet"; "FGSet")
			End if 
			
			If (cFGTrans2=1)
				USE SET:C118("DateSet")
				QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11="WIP")
				QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9="FG@")
				CREATE SET:C116([Finished_Goods_Transactions:33]; "NewSet")
				UNION:C120("FGSet"; "NewSet"; "FGSet")
			End if 
			
			If (cFGTrans2b=1)
				USE SET:C118("DateSet")
				QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11="WIP")
				QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9="CC@")
				CREATE SET:C116([Finished_Goods_Transactions:33]; "NewSet")
				UNION:C120("FGSet"; "NewSet"; "FGSet")
			End if 
			
			If (cFGTrans3=1)
				USE SET:C118("DateSet")
				QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11="Ex@")
				QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9="Sc@")
				CREATE SET:C116([Finished_Goods_Transactions:33]; "NewSet")
				UNION:C120("FGSet"; "NewSet"; "FGSet")
			End if 
			
			If (cFGTrans4=1)
				USE SET:C118("DateSet")
				QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11="Ex@")
				QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9="FG@")
				CREATE SET:C116([Finished_Goods_Transactions:33]; "NewSet")
				UNION:C120("FGSet"; "NewSet"; "FGSet")
			End if 
			
			If (cFGTrans5=1)
				USE SET:C118("DateSet")
				QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11="FG@")
				QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9="Sc@")
				CREATE SET:C116([Finished_Goods_Transactions:33]; "NewSet")
				UNION:C120("FGSet"; "NewSet"; "FGSet")
			End if 
			
			If (cFGTrans6=1)
				USE SET:C118("DateSet")
				QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11="FG@")
				QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9="Customer")
				CREATE SET:C116([Finished_Goods_Transactions:33]; "NewSet")
				UNION:C120("FGSet"; "NewSet"; "FGSet")
			End if 
			
			If (cFGTrans7=1)
				USE SET:C118("DateSet")
				QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11="FG@")
				QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9="Ex@")
				CREATE SET:C116([Finished_Goods_Transactions:33]; "NewSet")
				UNION:C120("FGSet"; "NewSet"; "FGSet")
			End if 
			
			If (cFGTrans8=1)
				USE SET:C118("DateSet")
				QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11="Customer")
				QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9="Ex@")
				CREATE SET:C116([Finished_Goods_Transactions:33]; "NewSet")
				UNION:C120("FGSet"; "NewSet"; "FGSet")
			End if 
			
			If (cFGTrans9=1)
				USE SET:C118("DateSet")
				QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11="Customer")
				QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9="FG@")
				CREATE SET:C116([Finished_Goods_Transactions:33]; "NewSet")
				UNION:C120("FGSet"; "NewSet"; "FGSet")
			End if 
			
			USE SET:C118("FGSet")
			CLEAR SET:C117("FGSet")
			CLEAR SET:C117("NewSet")
			CLEAR SET:C117("DateSet")
		End if 
	End if 
	
	
Else 
	
	If (OK=1)
		If (cFGTrans10=1)  //• 6/11/98 cs 
			QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=dDateBegin; *)
			QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<=dDateEnd)
		Else 
			$fgset_created:=False:C215
			$newset_created:=False:C215
			
			SET QUERY DESTINATION:C396(Into set:K19:2; "DateSet")
			QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=dDateBegin; *)
			QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<=dDateEnd)
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			
			If (cFGTrans11=1)  //• mlb - 3/15/02  14:56
				USE SET:C118("DateSet")
				SET QUERY DESTINATION:C396(Into set:K19:2; "FGSet")
				QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Adjust")
				SET QUERY DESTINATION:C396(Into current selection:K19:1)
				$fgset_created:=True:C214
			End if 
			
			ARRAY TEXT:C222($_location; 0)
			If (cFGTrans1=1)
				APPEND TO ARRAY:C911($_location; "Ex@")
			End if 
			If (cFGTrans2=1)
				APPEND TO ARRAY:C911($_location; "FG@")
			End if 
			If (cFGTrans2b=1)
				APPEND TO ARRAY:C911($_location; "CC@")
			End if 
			
			If (Size of array:C274($_location)>0)
				USE SET:C118("DateSet")
				QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11="WIP")
				QUERY SELECTION WITH ARRAY:C1050([Finished_Goods_Transactions:33]Location:9; $_location)
				If (Not:C34($fgset_created))
					CREATE SET:C116([Finished_Goods_Transactions:33]; "FGSet")
					$fgset_created:=True:C214
				Else 
					CREATE SET:C116([Finished_Goods_Transactions:33]; "NewSet")
					UNION:C120("FGSet"; "NewSet"; "FGSet")
					$newset_created:=True:C214
				End if 
			End if 
			
			ARRAY TEXT:C222($_location; 0)
			If (cFGTrans3=1)
				APPEND TO ARRAY:C911($_location; "Sc@")
			End if 
			If (cFGTrans4=1)
				APPEND TO ARRAY:C911($_location; "FG@")
			End if 
			
			If (Size of array:C274($_location)>0)
				USE SET:C118("DateSet")
				QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11="Ex@")
				QUERY SELECTION WITH ARRAY:C1050([Finished_Goods_Transactions:33]Location:9; $_location)
				If (Not:C34($fgset_created))
					CREATE SET:C116([Finished_Goods_Transactions:33]; "FGSet")
					$fgset_created:=True:C214
				Else 
					CREATE SET:C116([Finished_Goods_Transactions:33]; "NewSet")
					UNION:C120("FGSet"; "NewSet"; "FGSet")
					$newset_created:=True:C214
				End if 
			End if 
			
			
			ARRAY TEXT:C222($_location; 0)
			If (cFGTrans5=1)
				APPEND TO ARRAY:C911($_location; "Sc@")
			End if 
			If (cFGTrans6=1)
				APPEND TO ARRAY:C911($_location; "Customer")
			End if 
			If (cFGTrans7=1)
				APPEND TO ARRAY:C911($_location; "Ex@")
			End if 
			
			If (Size of array:C274($_location)>0)
				USE SET:C118("DateSet")
				QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11="FG@")
				QUERY SELECTION WITH ARRAY:C1050([Finished_Goods_Transactions:33]Location:9; $_location)
				If (Not:C34($fgset_created))
					CREATE SET:C116([Finished_Goods_Transactions:33]; "FGSet")
					$fgset_created:=True:C214
				Else 
					CREATE SET:C116([Finished_Goods_Transactions:33]; "NewSet")
					UNION:C120("FGSet"; "NewSet"; "FGSet")
					$newset_created:=True:C214
				End if 
			End if 
			
			ARRAY TEXT:C222($_location; 0)
			If (cFGTrans8=1)
				APPEND TO ARRAY:C911($_location; "Ex@")
			End if 
			If (cFGTrans9=1)
				APPEND TO ARRAY:C911($_location; "FG@")
			End if 
			
			If (Size of array:C274($_location)>0)
				USE SET:C118("DateSet")
				QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11="Customer")
				QUERY SELECTION WITH ARRAY:C1050([Finished_Goods_Transactions:33]Location:9; $_location)
				If (Not:C34($fgset_created))
					CREATE SET:C116([Finished_Goods_Transactions:33]; "FGSet")
					$fgset_created:=True:C214
				Else 
					CREATE SET:C116([Finished_Goods_Transactions:33]; "NewSet")
					UNION:C120("FGSet"; "NewSet"; "FGSet")
					$newset_created:=True:C214
				End if 
			End if 
			
			If ($fgset_created)
				USE SET:C118("FGSet")
				CLEAR SET:C117("FGSet")
			Else 
				REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)
			End if 
			If ($newset_created)
				CLEAR SET:C117("NewSet")
			End if 
			CLEAR SET:C117("DateSet")
			
		End if 
	End if 
	
	
End if   // END 4D Professional Services : January 2019 query selection
If (Records in selection:C76([Finished_Goods_Transactions:33])=0)
	ALERT:C41("Sorry, No Finished Goods records met the criterion.")
	OK:=0
End if 
