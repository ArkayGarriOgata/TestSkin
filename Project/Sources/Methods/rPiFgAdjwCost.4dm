//%attributes = {"publishedWeb":true}
//(p) rPiFgAdjwCost
//Created 3/5/97 cs upr 1858
//codifying a quick report Melissa usesd for Cycle count/Phys Inventory
//•3/25/97 cs report would not print correctly using print selection
//so I had to rewrite report to use a print layout.

C_TIME:C306(vDoc)
C_LONGINT:C283(Index; $Detail; $Header; $Footer; $Break; $Max; $SoFar; $Count; lPage)
C_TEXT:C284($CurrentCpn)
C_TEXT:C284($CurrentLoc)
C_TEXT:C284(xText; t2)

xText:=""
rReal1:=0
rReal4:=0
rReal4a:=0
rReal5:=0
rReal5a:=0
t2:=""

vDoc:=?00:00:00?
uClearSelection(->[Finished_Goods_Transactions:33])
uDialog("SelectFgType"; 270; 220)

If (OK=1)
	util_PAGE_SETUP(->[Finished_Goods_Transactions:33]; "PiFgAdj.h")
	PRINT SETTINGS:C106
	If (OK=1)
		Case of 
			: (rbAll=1)  //all locations
				Case of 
					: (brbBoth=1)  //both divisions
						t2:="All Locations"
					: (brbRoanoke=1)
						QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9="@:R@"; *)
						t2:="All Roanoke"
					Else 
						QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9#"@:R@"; *)
						t2:="All Hauppauge"
				End case 
				
			: (rbFg=1)  //just FG:
				Case of 
					: (sLocation#"All") & (Not:C34((Length:C16(sLocation)=1) & (Character code:C91(sLocation)=Character code:C91("@"))))  //• 4/9/97 cs user wants specific location
						QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9=sLocation; *)
						t2:="Location = "+sLocation
					: (brbBoth=1)
						QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9="FG:@"; *)
						t2:="All FG:"
					: (brbRoanoke=1)
						QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9="FG:R@"; *)
						t2:="Roanoke FG:"
					Else 
						QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9#"FG:R@"; *)
						QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9="FG:@"; *)
						t2:="Hauppauge FG:"
				End case 
				
			: (rbCC=1)  //just CC:
				Case of 
					: (brbBoth=1)
						QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9="CC:@"; *)
						t2:="All CC:"
					: (brbRoanoke=1)
						QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9="CC:R@"; *)
						t2:="Roanoke CC:"
					Else 
						QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9#"CC:R@"; *)
						QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9="CC:@"; *)
						t2:="Hauppauge CC:"
				End case 
				
			: (rbEx=1)  //just Ex:
				Case of 
					: (brbBoth=1)
						QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9="EX:@"; *)
						t2:="All EX:"
					: (brbRoanoke=1)
						QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9="EX:R@"; *)
						t2:="Roanoke EX:"
					Else 
						QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9#"EX:R@"; *)
						QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9="EX:@"; *)
						t2:="Hauppauge EX:"
				End case 
				
			: (rbBH=1)  //just BH:
				Case of 
					: (brbBoth=1)
						QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9="BH:@"; *)
						t2:="All BH:"
					: (brbRoanoke=1)
						QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9="BH:R@"; *)
						t2:="Roanoke BH:"
					Else 
						QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9#"BH:R@"; *)
						QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9="BH:@"; *)
						t2:="Hauppauge BH:"
				End case   //just xc:
				
			: (rbXc=1)
				Case of 
					: (brbBoth=1)
						QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9="XC:@"; *)
						t2:="All XC:"
					: (brbRoanoke=1)
						QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9="XC:R@"; *)
						t2:="Roanoke XC:"
					Else 
						QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9#"XC:R@"; *)
						QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9="XC:@"; *)
						t2:="Hauppauge XC:"
				End case 
		End case 
		
		If (rbAll=1) & (brbBoth=1)  //all locations, all divisions
			QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=dDateBegin; *)  //physical inventory for date range entered
		Else 
			QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3>=dDateBegin; *)  //physical inventory for date range entered
		End if 
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<=dDateEnd; *)
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Reason:26="Tag@")
		
		If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
			t2:="Phys Inv F/G Adjusts w/Costs for '"+t2+"' "+String:C10(dDateBegin)+" thru "+String:C10(dDateEnd)
			
			If (fSave)  //user wants to save to disk      
				vDoc:=Create document:C266("PiFgAdjRpt")
				SEND PACKET:C103(vDoc; t2+Char:C90(13))
				SEND PACKET:C103(vDoc; "XActionType"+Char:C90(9)+"XActionDate"+Char:C90(9)+"Product Code"+Char:C90(9)+"JobForm"+Char:C90(9)+"Quantity"+Char:C90(9)+"Location"+"Extended Value"+Char:C90(9)+"Mod Who"+Char:C90(13))
				
			Else 
				vDoc:=?00:00:00?
			End if 
			//SORT SELECTION([FG_Transactions];[FG_Transactions]Location;>;[FG
			//«_Transactions]ProductCode;>)
			ORDER BY:C49([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ProductCode:1; >; [Finished_Goods_Transactions:33]Location:9; >)
			$Count:=Records in selection:C76([Finished_Goods_Transactions:33])
			ARRAY TEXT:C222(aCPN; $Count)  //move to arrays for printing, •3/25/97 cs for print layout
			ARRAY TEXT:C222(aJobs; $Count)
			ARRAY DATE:C224(aDate; $Count)
			ARRAY REAL:C219(aActCost; $Count)
			ARRAY LONGINT:C221(aQuantity; $Count)
			ARRAY TEXT:C222(aLocation; $Count)
			ARRAY TEXT:C222(AOL; $Count)  //reused 'aol' for xactiontype
			ARRAY TEXT:C222(aRep; $Count)  //reused for Modwho
			SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]Location:9; aLocation; [Finished_Goods_Transactions:33]ProductCode:1; aCPN; [Finished_Goods_Transactions:33]Qty:6; aQuantity; [Finished_Goods_Transactions:33]CoGSExtended:8; aActCost; [Finished_Goods_Transactions:33]XactionType:2; AOL; [Finished_Goods_Transactions:33]XactionDate:3; aDate; [Finished_Goods_Transactions:33]JobForm:5; aJobs; [Finished_Goods_Transactions:33]ModWho:18; aRep)
			$Header:=40  //•3/25/97 cs for print layout
			$Detail:=18
			$Break:=20
			$Footer:=20
			$Max:=800
			$CurrentLoc:=aLocation{1}
			$CurrentCpn:=aCpn{1}
			lPage:=1
			Print form:C5([Finished_Goods_Transactions:33]; "PiFgAdj.h")
			$SoFar:=$Header
			
			//• 3/25/97 cs run print layout because print selection would NOT function.     
			For (Index; 1; $Count)
				Case of 
					: ($CurrentCpn#aCpn{Index})  //location change
						Case of 
							: ($SoFar+$Break>$Max)  //no room for break line
								PAGE BREAK:C6(>)
								lPage:=lPage+1
								Print form:C5([Finished_Goods_Transactions:33]; "PiFgAdj.h")
								xText:="Subtotal for Cpn: "+$CurrentCpn
								Print form:C5([Finished_Goods_Transactions:33]; "PiFgAdj.b")
								rReal4:=0
								rReal5:=0
								Print form:C5([Finished_Goods_Transactions:33]; "PiFgAdj.d")
								$SoFar:=$Header+$Break+$Detail
								
							: ($SoFar+$Break+$Detail>$Max)  //no room for detail & break
								xText:="Subtotal for Cpn: "+$CurrentCpn
								Print form:C5([Finished_Goods_Transactions:33]; "PiFgAdj.b")
								rReal4:=0
								rReal5:=0
								PAGE BREAK:C6(>)
								lPage:=lPage+1
								Print form:C5([Finished_Goods_Transactions:33]; "PiFgAdj.h")
								Print form:C5([Finished_Goods_Transactions:33]; "PiFgAdj.d")
								$SoFar:=$Header+$Detail
							Else   //room for both print them
								xText:="Subtotal for Cpn: "+$CurrentCpn
								Print form:C5([Finished_Goods_Transactions:33]; "PiFgAdj.b")
								rReal4:=0
								rReal5:=0
								Print form:C5([Finished_Goods_Transactions:33]; "PiFgAdj.d")
								$SoFar:=$SoFar+$Break+$Detail
						End case 
						$CurrentCpn:=aCpn{Index}
						
					: ($SoFar+$Detail>$Max)  //no room for detail line
						PAGE BREAK:C6(>)
						lPage:=lPage+1
						Print form:C5([Finished_Goods_Transactions:33]; "PiFgAdj.h")
						Print form:C5([Finished_Goods_Transactions:33]; "PiFgAdj.d")
						$SoFar:=$Header+$Detail
					Else   //there is room, just print it
						Print form:C5([Finished_Goods_Transactions:33]; "PiFgAdj.d")
						$SoFar:=$SoFar+$Detail
				End case 
			End for 
			
			If ($SoFar+$Footer+$Break>$Max)
				PAGE BREAK:C6(>)
				lPage:=lPage+1
				Print form:C5([Finished_Goods_Transactions:33]; "PiFgAdj.h")
				xText:="Subtotal for Cpn: "+$CurrentCpn
				Print form:C5([Finished_Goods_Transactions:33]; "PiFgAdj.b")
				rReal4:=0
				rReal5:=0
				xText:="Totals for Report:"
				Print form:C5([Finished_Goods_Transactions:33]; "PiFgAdj.f")
			Else 
				xText:="Subtotal for Cpn: "+$CurrentCpn
				Print form:C5([Finished_Goods_Transactions:33]; "PiFgAdj.b")
				rReal4:=0
				rReal5:=0
				xText:="Totals for Report:"
				Print form:C5([Finished_Goods_Transactions:33]; "PiFgAdj.f")
			End if 
			PAGE BREAK:C6
			$Count:=0  //clear arrays
			ARRAY TEXT:C222(aCPN; $Count)  //move to arrays for printing
			ARRAY TEXT:C222(aJobs; $Count)
			ARRAY DATE:C224(aDate; $Count)
			ARRAY REAL:C219(aActCost; $Count)
			ARRAY LONGINT:C221(aQuantity; $Count)
			ARRAY TEXT:C222(aLocation; $Count)
			ARRAY TEXT:C222(AOL; $Count)  //reused 'aol' for xactiontype
			ARRAY TEXT:C222(aRep; $Count)  //reused for Modwho
			uClearSelection(->[Finished_Goods_Transactions:33])
		Else 
			ALERT:C41("No Transactions currently exist for your request.")
		End if 
		uClearSelection(->[Finished_Goods_Transactions:33])
	End if 
End if 

If (vDoc#?00:00:00?)
	CLOSE DOCUMENT:C267(vDoc)
End if 