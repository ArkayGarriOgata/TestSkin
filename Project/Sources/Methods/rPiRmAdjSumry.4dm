//%attributes = {"publishedWeb":true}
//(p) rPiRmAdjSumry
//Created 2/28/97 cs upr 1858
//codifying a quick report Melissa usesd for Cycle count/Phys Inventory
//this became a print layout
// Modified by: Mel Bohince (12/18/15) fix the missing dialog and save to disk
C_LONGINT:C283($SoFar; $Header; $Detail; $Break; $Division; $Max)
C_LONGINT:C283(Index; rbAll; rbArkay; rbRoanoke; rbLabel; cbAllComm)
C_REAL:C285(rReal1; rReal2; rReal3; rReal4; rReal5; rReal6; rReal7; rReal8; rReal9; rReal10)  //subtotals for break sections
C_REAL:C285(rReal4a; rReal4t; rReal5a; rReal5t; rReal6a; rReal6t; rReal7a; rReal8a; rReal9a)
C_TEXT:C284($CurrentDiv; $LastDiv; $CurrentCom; $LastCom)
C_TEXT:C284(t2; sCommkey)
C_TIME:C306($docRef)

t2:=""
$docRef:=?00:00:00?
uClearSelection(->[Raw_Materials_Locations:25])
//uDialog ("SelectDivision";250;200)  //§Ask user what to print
rbAll:=1  // Modified by: Mel Bohince (12/18/15) 
cbAllComm:=1
ok:=1
If (OK=1)
	util_PAGE_SETUP(->[Raw_Materials_Locations:25]; "PIRMAdjSumry.h")
	PRINT SETTINGS:C106
	
	If (OK=1)
		t2:=""
		Case of   //§locate records to print
			: (rbAll=1)
				If (cbAllComm=1)
					ALL RECORDS:C47([Raw_Materials_Locations:25])
					t2:="All Divisions"
				Else 
					t2:="Commodity: "+sCommKey+" in All Divisions"
				End if 
			: (rbArkay=1)
				If (cbAllComm=1)
					QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]CompanyID:27="1")
					t2:="Hauppauge Only"
				Else 
					QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]CompanyID:27="1"; *)
					t2:="Commodity: "+sCommKey+" in Hauppauge Only"
				End if 
			: (rbRoanoke=1)
				If (cbAllComm=1)
					QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]CompanyID:27="2")
					t2:="Roanoke Only"
				Else 
					QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]CompanyID:27="2"; *)
					t2:="Commodity: "+sCommKey+" in Roanoke Only"
				End if 
			: (rbLabel=1)
				If (cbAllComm=1)
					QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]CompanyID:27="3")
					t2:="Labels Only"
				Else 
					QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]CompanyID:27="3"; *)
					t2:="Commodity: "+sCommKey+" in Labels Only"
				End if 
		End case 
		
		Case of 
			: (cbAllComm=1) & (rbAll=0)  //specified location, all commodities
				QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]Commodity_Key:12=sCommkey+"@")
			: (cbAllComm=0) & (rbAll=1)  //specified commodity, all locations
				QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Commodity_Key:12=sCommkey+"@")
			: (cbAllComm=0)  //specified location, specified commodity
				QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]Commodity_Key:12=sCommkey+"@")
		End case 
		
		If (Records in selection:C76([Raw_Materials_Locations:25])>0)  //§If records found
			t2:="RM Phys Inv Summary for "+t2
			ORDER BY:C49([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]CompanyID:27; >; [Raw_Materials_Locations:25]Commodity_Key:12; >; [Raw_Materials_Locations:25]Raw_Matl_Code:1; >)  //§ sort
			NewWindow(500; 400; 0; 8; t2)
			$Count:=Records in selection:C76([Raw_Materials_Locations:25])
			ARRAY TEXT:C222(aRmCode; $Count)
			ARRAY REAL:C219(aActCost; $Count)
			ARRAY REAL:C219(arQuantity; $Count)
			ARRAY REAL:C219(arNewQty; $Count)
			ARRAY TEXT:C222(aComm; $Count)
			ARRAY TEXT:C222(aCompany; $Count)  //§ move to arrays for printing
			SELECTION TO ARRAY:C260([Raw_Materials_Locations:25]CompanyID:27; aCompany; [Raw_Materials_Locations:25]Commodity_Key:12; aComm; [Raw_Materials_Locations:25]Raw_Matl_Code:1; aRmCode; [Raw_Materials_Locations:25]QtyOH:9; arQuantity; [Raw_Materials_Locations:25]PiFreezeQty:23; arNewQty; [Raw_Materials_Locations:25]ActCost:18; aActCost)
			uClearSelection(->[Raw_Materials_Locations:25])
			//§- 
			//§print
			If (fSave)  //user wants to save to disk   
				$docName:="PiRmAdjSumry_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
				$docRef:=util_putFileName(->$docName)
				SEND PACKET:C103($docRef; t2+Char:C90(13))
				SEND PACKET:C103($docRef; "Commodity Key"+Char:C90(9)+"Rm Code"+Char:C90(9)+"Final Qty    -"+Char:C90(9)+"   Start Qty  ="+Char:C90(9)+"Difference"+Char:C90(9)+"Cost Ea."+Char:C90(9)+"Extended"+Char:C90(13))
			Else 
				$docRef:=?00:00:00?
			End if 
			
			rReal1:=0
			rReal2:=0
			rReal3:=0
			rReal4a:=0
			rReal4t:=0
			rReal4:=0
			rReal5a:=0
			rReal5t:=0
			rReal5:=0
			rReal6a:=0
			rReal6t:=0
			rReal6:=0
			rReal7a:=0
			rReal7:=0
			rReal8a:=0
			rReal8:=0
			rReal9a:=0
			rReal9:=0
			rReal10:=0
			lPage:=0
			$Max:=750  //§ prime sizes and break controlers
			$Header:=50
			$Detail:=16
			$Division:=20
			$Footer:=20
			$Break:=16
			$CurrentDiv:=aCompany{1}
			$LastDiv:=$CurrentDiv
			$CurrentCom:=Substring:C12(aComm{1}; 1; 2)
			$LastCom:=$CurrentCom
			
			For (Index; 1; $Count)  //§ For each record 
				$CurrentDiv:=aCompany{Index}  //get current value printing
				$CurrentCom:=Substring:C12(aComm{Index}; 1; 2)  //§ 
				Case of 
					: (Index=1)
						$SoFar:=$Header+$Division
						Print form:C5([Raw_Materials_Locations:25]; "PIRMAdjSumry.h")  //print header
						Print form:C5([Raw_Materials_Locations:25]; "PIRMAdjSumry.v")  //division    
						
						If ($docRef#?00:00:00?)  //saving report to disk
							SEND PACKET:C103($docRef; t2+String:C10(4D_Current_date)+Char:C90(13))
							SEND PACKET:C103($docRef; "Commodity"+Char:C90(9)+"RM Code"+Char:C90(9)+"Final Quantity"+Char:C90(9)+"Start Quantity"+Char:C90(9)+"DIfference"+Char:C90(9)+"Cost each"+Char:C90(9)+"Extended"+Char:C90(13))
						End if 
						
					: ($LastDiv#$CurrentDiv)  //§ Change in Division
						If ($SoFar+$Break+$Break+$Division<=$Max)  //§  room for 2 breaks + Division header
							Print form:C5([Raw_Materials_Locations:25]; "PIRMAdjSumry.b1")  //§   print Commodity break
							Print form:C5([Raw_Materials_Locations:25]; "PIRMAdjSumry.b2")  //§   print Division break
							Print form:C5([Raw_Materials_Locations:25]; "PIRMAdjSumry.v")  //§   print Division Header
							$SoFar:=$SoFar+$Break+$Break+$Division
						Else   //§  not enough room for 2 breaks
							PAGE BREAK:C6(>)  //§   new page
							$SoFar:=$Header
							Print form:C5([Raw_Materials_Locations:25]; "PIRMAdjSumry.h")  //§   print header
							Print form:C5([Raw_Materials_Locations:25]; "PIRMAdjSumry.b1")  //§   print Commodity break
							Print form:C5([Raw_Materials_Locations:25]; "PIRMAdjSumry.b2")  //§   print Division break
							Print form:C5([Raw_Materials_Locations:25]; "PIRMAdjSumry.v")  //§   print Division Header
							$SoFar:=$SoFar+$Break+$Break+$Division
						End if 
						$LastCom:=$CurrentCom  //§  increment break controlers 
						$LastDIv:=$CurrentDiv
						Index:=Index-1  //reiterate loop, to print detail, now that break is printed between commodities  
						//§ 
					: ($LastCom#$CurrentCom)  //§ Change in Commodity
						If ($SoFar+$Break<=$Max)  //§  room for break
							Print form:C5([Raw_Materials_Locations:25]; "PIRMAdjSumry.b1")  //§   print Commodity break
							$SoFar:=$SoFar+$Break
						Else   //§  no room for break
							PAGE BREAK:C6(>)  //§  New Page
							$SoFar:=$Header  //print header& detail
							Print form:C5([Raw_Materials_Locations:25]; "PIRMAdjSumry.h")  //§   print header
							Print form:C5([Raw_Materials_Locations:25]; "PIRMAdjSumry.b1")  //§   print Commodity break
							$SoFar:=$SoFar+$Break
						End if 
						$LastCom:=$CurrentCom  //§   increment break controler
						Index:=Index-1  //reiterate loop, to print detail, now that break is printed between commodities 
						//§ 
					Else   //§ Print Detail
						If ($SoFar+$Detail<=$Max)  //§  enough room
							Print form:C5([Raw_Materials_Locations:25]; "PIRMAdjSumry.d")  //§   Print detail
							$SoFar:=$SoFar+$Detail
							
						Else   //§  Not enough room
							PAGE BREAK:C6(>)  //§   new page
							$SoFar:=$Header  //print header& detail
							Print form:C5([Raw_Materials_Locations:25]; "PIRMAdjSumry.h")  //§   Print header
							Print form:C5([Raw_Materials_Locations:25]; "PIRMAdjSumry.d")  //§   Print detail
							$SoFar:=$SoFar+$Detail
						End if 
						
						If ($docRef#?00:00:00?)  // Modified by: Mel Bohince (12/18/15)  this was missing
							SEND PACKET:C103($docRef; sCommKey+Char:C90(9)+sRmCode+Char:C90(9)+String:C10(rQtyOh)+Char:C90(9)+String:C10(rQtym)+Char:C90(9)+String:C10(rReal1)+Char:C90(9)+String:C10(rReal2)+Char:C90(9)+String:C10(rReal3)+Char:C90(13))
						End if 
						
				End case 
			End for 
			//§-      
			//§ last record printed, print breaks
			If ($SoFar+$Break+$Break+$Break<=$Max)  //§  room for 3 breaks
				Print form:C5([Raw_Materials_Locations:25]; "PIRMAdjSumry.b1")  //§   print Commodity break
				Print form:C5([Raw_Materials_Locations:25]; "PIRMAdjSumry.b2")  //§   print Division break
				Print form:C5([Raw_Materials_Locations:25]; "PIRMAdjSumry.b3")  //§   print final totals
			Else   //§  not enough room for 3 breaks
				PAGE BREAK:C6(>)  //§   new page
				$SoFar:=$Header
				Print form:C5([Raw_Materials_Locations:25]; "PIRMAdjSumry.h")  //§   print header
				Print form:C5([Raw_Materials_Locations:25]; "PIRMAdjSumry.b1")  //§   print Commodity break
				Print form:C5([Raw_Materials_Locations:25]; "PIRMAdjSumry.b2")  //§   print Division break
				Print form:C5([Raw_Materials_Locations:25]; "PIRMAdjSumry.b3")  //§   print final totals
			End if 
			PAGE BREAK:C6  //§end printing    
			uClearSelection(->[Raw_Materials_Locations:25])
		Else 
			ALERT:C41("No Bins currently exist for your request.")
		End if 
	End if 
End if 

If ($docRef#?00:00:00?)
	CLOSE DOCUMENT:C267($docRef)
End if 