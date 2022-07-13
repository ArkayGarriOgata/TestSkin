//MESSAGE(" Searching releases shipped on "+String(dDate;1)+"...")
//• 5/1/97 cs replaced thermoset
$Event:=Form event code:C388

Case of 
	: ($Event=On Data Change:K2:15)
		
		C_LONGINT:C283($ship)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7=dDate)
		$ship:=Records in selection:C76([Customers_ReleaseSchedules:46])
		
		If ($ship>0)
			ARRAY BOOLEAN:C223(ListBox1; $ship)
			ARRAY TEXT:C222(aOL; $ship)
			ARRAY TEXT:C222(aPO; $ship)
			ARRAY TEXT:C222(aRep; $ship)
			ARRAY LONGINT:C221(aLi1; $ship)
			ARRAY LONGINT:C221(aLi2; $ship)
			ARRAY LONGINT:C221(aLi3; $ship)
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
				
				FIRST RECORD:C50([Customers_ReleaseSchedules:46])
				uThermoInit($ship; "Processing Shipped Releases…")  //• 5/1/97 cs replaced thermoset
				For ($i; 1; $ship)
					aOL{$i}:=[Customers_ReleaseSchedules:46]OrderLine:4
					If (real1=1)
						RELATE ONE:C42([Customers_ReleaseSchedules:46]OrderLine:4)
						aRep{$i}:=[Customers_Order_Lines:41]SalesRep:34
					Else 
						aRep{$i}:=""
					End if 
					
					aPO{$i}:=[Customers_ReleaseSchedules:46]CustomerRefer:3
					aLi1{$i}:=[Customers_ReleaseSchedules:46]Sched_Date:5-[Customers_ReleaseSchedules:46]Actual_Date:7
					aLi2{$i}:=[Customers_ReleaseSchedules:46]Actual_Qty:8-[Customers_ReleaseSchedules:46]OriginalRelQty:24
					aLi3{$i}:=Num:C11([Customers_ReleaseSchedules:46]LastRelease:20)
					uThermoUpdate($i)  //• 5/1/97 cs replaced thermoset
					NEXT RECORD:C51([Customers_ReleaseSchedules:46])
				End for 
				
			Else 
				DELETE FROM ARRAY:C228(aOL; 1; Size of array:C274(aOL))
				DELETE FROM ARRAY:C228(aPO; 1; Size of array:C274(aOL))
				DELETE FROM ARRAY:C228(aRep; 1; Size of array:C274(aOL))
				DELETE FROM ARRAY:C228(aLi1; 1; Size of array:C274(aOL))
				DELETE FROM ARRAY:C228(aLi2; 1; Size of array:C274(aOL))
				DELETE FROM ARRAY:C228(aLi3; 1; Size of array:C274(aOL))
				
				
				ARRAY TEXT:C222($_OrderLine; 0)
				ARRAY TEXT:C222($_CustomerRefer; 0)
				ARRAY DATE:C224($_Sched_Date; 0)
				ARRAY DATE:C224($_Actual_Date; 0)
				ARRAY LONGINT:C221($_Actual_Qty; 0)
				ARRAY LONGINT:C221($_OriginalRelQty; 0)
				ARRAY TEXT:C222($_SalesRep; 0)
				ARRAY TEXT:C222($_OrderLine2; 0)
				ARRAY BOOLEAN:C223($_LastRelease; 0)
				
				GET FIELD RELATION:C920([Customers_ReleaseSchedules:46]OrderLine:4; $lienAller; $lienRetour)
				SET FIELD RELATION:C919([Customers_ReleaseSchedules:46]OrderLine:4; Automatic:K51:4; Do not modify:K51:1)
				
				SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]OrderLine:4; $_OrderLine; [Customers_ReleaseSchedules:46]CustomerRefer:3; $_CustomerRefer; [Customers_ReleaseSchedules:46]Sched_Date:5; $_Sched_Date; [Customers_ReleaseSchedules:46]Actual_Date:7; $_Actual_Date; [Customers_ReleaseSchedules:46]Actual_Qty:8; $_Actual_Qty; [Customers_ReleaseSchedules:46]LastRelease:20; $_LastRelease; [Customers_ReleaseSchedules:46]OriginalRelQty:24; $_OriginalRelQty; [Customers_Order_Lines:41]SalesRep:34; $_SalesRep; [Customers_Order_Lines:41]OrderLine:3; $_OrderLine2)
				
				SET FIELD RELATION:C919([Customers_ReleaseSchedules:46]OrderLine:4; $lienAller; $lienRetour)
				
				uThermoInit($ship; "Processing Shipped Releases…")  //• 5/1/97 cs replaced thermoset
				For ($i; 1; Size of array:C274($_OrderLine); 1)
					APPEND TO ARRAY:C911(aOL; $_OrderLine{$i})
					If (real1=1)
						APPEND TO ARRAY:C911(aRep; $_SalesRep{$i})
					Else 
						APPEND TO ARRAY:C911(aRep; "")
					End if 
					
					APPEND TO ARRAY:C911(aPO; $_CustomerRefer{$i})
					APPEND TO ARRAY:C911(aLi1; $_Sched_Date{$i}-$_Actual_Date{$i})
					APPEND TO ARRAY:C911(aLi2; $_Actual_Qty{$i}-$_OriginalRelQty{$i})
					APPEND TO ARRAY:C911(aLi3; Num:C11($_LastRelease{$i}))
					uThermoUpdate($i)  //• 5/1/97 cs replaced thermoset
					
				End for 
				
			End if   // END 4D Professional Services : January 2019 First record
			
			uThermoClose  //• 5/1/97 cs replaced thermoset
			
		Else 
			BEEP:C151
			ALERT:C41("No shipments were entered on "+String:C10(dDate; 1)+".")
		End if 
		//
End case 