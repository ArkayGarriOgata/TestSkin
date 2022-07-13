//%attributes = {"publishedWeb":true}
//PM: JTB_Locate() -> 
//@author mlb - 2/7/02  14:45

ARRAY LONGINT:C221($ts; 0)
ARRAY TEXT:C222(aKey; 0)
ARRAY TEXT:C222(axRelTemp; 0)

If (Count parameters:C259=1)
	sCriterion1:=$1
End if 

OBJECT SET ENABLED:C1123(bMove; False:C215)
sCriterion2:=""
sCriterion3:=""
sCriterion4:=""
sCriterion5:=""
sCriterion6:=""
tTitle:=""
tMessage1:=""
sLocation:=""

Case of 
	: (Length:C16(sCriterion1)=6)
		READ WRITE:C146([JTB_Job_Transfer_Bags:112])
		READ ONLY:C145([JTB_Logs:114])
		QUERY:C277([JTB_Job_Transfer_Bags:112]; [JTB_Job_Transfer_Bags:112]ID:1=sCriterion1)
		If (Records in selection:C76([JTB_Job_Transfer_Bags:112])=1)
			If (fLockNLoad(->[JTB_Job_Transfer_Bags:112]))
				QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=[JTB_Job_Transfer_Bags:112]PjtNumber:2)
				If (Records in selection:C76([Customers_Projects:9])=1)
					OBJECT SET ENABLED:C1123(bMove; True:C214)
					sCriterion2:=[Customers_Projects:9]Name:2
					sCriterion3:=[Customers_Projects:9]CustomerName:4
					READ ONLY:C145([Jobs:15])
					SET QUERY LIMIT:C395(1)
					QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=(Num:C11(Substring:C12([JTB_Job_Transfer_Bags:112]Jobform:3; 1; 5))))
					SET QUERY LIMIT:C395(0)
					sCriterion4:=[Jobs:15]Line:3  //[Project]CustomerLine
					REDUCE SELECTION:C351([Jobs:15]; 0)
					sCriterion5:=[JTB_Job_Transfer_Bags:112]Jobform:3
					sCriterion6:=[JTB_Job_Transfer_Bags:112]Location:4
					tTitle:="Big Blue Portfolio"
					tMessage1:="Container for things required for this job."
					sLocation:=JTB_setLocation
					QUERY:C277([JTB_Logs:114]; [JTB_Logs:114]JTBid:1=sCriterion1)
					SELECTION TO ARRAY:C260([JTB_Logs:114]tsTimeStamp:2; $ts; [JTB_Logs:114]Description:3; axRelTemp)
					REDUCE SELECTION:C351([JTB_Logs:114]; 0)
					ARRAY TEXT:C222(aKey; Size of array:C274($ts))
					For ($i; 1; Size of array:C274($ts))
						aKey{$i}:=TS2String($ts{$i})
					End for 
					SORT ARRAY:C229($ts; aKey; axRelTemp; <)
					ARRAY LONGINT:C221($ts; 0)
					
				Else 
					sCriterion1:=""
					sCriterion2:="Un-assigned"
					tMessage1:="Un-assigned. (Go to Project Control Center to assign)"
					REDUCE SELECTION:C351([JTB_Job_Transfer_Bags:112]; 0)
					GOTO OBJECT:C206(sCriterion1)
				End if 
				
			Else 
				sCriterion1:=""
				sCriterion2:="Record Locked"
				tMessage1:="Try again later"
				REDUCE SELECTION:C351([JTB_Job_Transfer_Bags:112]; 0)
				GOTO OBJECT:C206(sCriterion1)
			End if 
			
		Else 
			BEEP:C151
			ALERT:C41(sCriterion1+" does not exist.")
			sCriterion1:=""
			GOTO OBJECT:C206(sCriterion1)
		End if 
		//
	: (Length:C16(sCriterion1)=8)  //jobformid
		READ WRITE:C146([JTB_Job_Transfer_Bags:112])
		READ ONLY:C145([JTB_Logs:114])
		QUERY:C277([JTB_Job_Transfer_Bags:112]; [JTB_Job_Transfer_Bags:112]Jobform:3=sCriterion1)
		If (Records in selection:C76([JTB_Job_Transfer_Bags:112])=0)  //>0)
			//SET QUERY DESTINATION(Into variable;$numJF)
			READ ONLY:C145([Job_Forms:42])
			QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=sCriterion1)
			//SET QUERY DESTINATION(Into current selection )
			If (Records in selection:C76([Job_Forms:42])>0)
				CREATE RECORD:C68([JTB_Job_Transfer_Bags:112])
				[JTB_Job_Transfer_Bags:112]ID:1:=sCriterion1
				[JTB_Job_Transfer_Bags:112]Jobform:3:=sCriterion1
				[JTB_Job_Transfer_Bags:112]PjtNumber:2:=[Job_Forms:42]ProjectNumber:56
				SAVE RECORD:C53([JTB_Job_Transfer_Bags:112])
				REDUCE SELECTION:C351([Job_Forms:42]; 0)
			Else 
				BEEP:C151
				zwStatusMsg("ERROR"; sCriterion1+" is not a valid jobform.")
				sCriterion1:=""
			End if 
		End if 
		
		If (fLockNLoad(->[JTB_Job_Transfer_Bags:112])) & (Length:C16(sCriterion1)=8)
			tTitle:="Manilla Job Envelope"
			tMessage1:="Good ole jobbag"
			QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=[JTB_Job_Transfer_Bags:112]PjtNumber:2)
			If (Records in selection:C76([Customers_Projects:9])=1)
				If (Records in selection:C76([JTB_Job_Transfer_Bags:112])>1)
					BEEP:C151
					ALERT:C41("Mutiple TransferBags are in use for jobform "+sCriterion1+"."+Char:C90(13)+"Check the "+[Customers_Projects:9]Name:2+" project for details.")
				End if 
				OBJECT SET ENABLED:C1123(bMove; True:C214)
				sCriterion1:=[JTB_Job_Transfer_Bags:112]ID:1
				sCriterion2:=[Customers_Projects:9]Name:2
				sCriterion3:=[Customers_Projects:9]CustomerName:4
				READ ONLY:C145([Jobs:15])
				SET QUERY LIMIT:C395(1)
				QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=(Num:C11(Substring:C12([JTB_Job_Transfer_Bags:112]Jobform:3; 1; 5))))
				SET QUERY LIMIT:C395(0)
				sCriterion4:=[Jobs:15]Line:3  //[Project]CustomerLine
				REDUCE SELECTION:C351([Jobs:15]; 0)
				sCriterion5:=[JTB_Job_Transfer_Bags:112]Jobform:3
				sCriterion6:=[JTB_Job_Transfer_Bags:112]Location:4
				sLocation:=JTB_setLocation
				QUERY:C277([JTB_Logs:114]; [JTB_Logs:114]JTBid:1=sCriterion1)
				SELECTION TO ARRAY:C260([JTB_Logs:114]tsTimeStamp:2; $ts; [JTB_Logs:114]Description:3; axRelTemp)
				REDUCE SELECTION:C351([JTB_Logs:114]; 0)
				ARRAY TEXT:C222(aKey; Size of array:C274($ts))
				For ($i; 1; Size of array:C274($ts))
					aKey{$i}:=TS2String($ts{$i})
				End for 
				SORT ARRAY:C229($ts; aKey; axRelTemp; <)
				ARRAY LONGINT:C221($ts; 0)
				
			Else 
				sCriterion1:=""
				sCriterion2:="Un-assigned"
				tMessage1:="Un-assigned. (Go to Project Control Center to assign)"
				REDUCE SELECTION:C351([JTB_Job_Transfer_Bags:112]; 0)
				GOTO OBJECT:C206(sCriterion1)
			End if 
			
		Else 
			sCriterion1:=""
			sCriterion2:="Record Locked"
			tMessage1:="Try again later"
			REDUCE SELECTION:C351([JTB_Job_Transfer_Bags:112]; 0)
			GOTO OBJECT:C206(sCriterion1)
		End if 
		
		//Else 
		//BEEP
		//ALERT(sCriterion1+" does not exist.")
		//sCriterion1:=""
		//GOTO AREA(sCriterion1)
		//End if 
		READ WRITE:C146([To_Do_Tasks:100])
		QUERY:C277([To_Do_Tasks:100]; [To_Do_Tasks:100]Jobform:1=sCriterion1)
		ORDER BY:C49([To_Do_Tasks:100]; [To_Do_Tasks:100]Task:3; >)
		
	: (Length:C16(sCriterion1)=7)
		READ WRITE:C146([JPSI_Job_Physical_Support_Items:111])
		READ ONLY:C145([JPSI_Logs:115])
		QUERY:C277([JPSI_Job_Physical_Support_Items:111]; [JPSI_Job_Physical_Support_Items:111]ID:1=sCriterion1)
		If (Records in selection:C76([JPSI_Job_Physical_Support_Items:111])=1)
			If (fLockNLoad(->[JPSI_Job_Physical_Support_Items:111]))
				QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=[JPSI_Job_Physical_Support_Items:111]PjtNumber:3)
				If (Records in selection:C76([Customers_Projects:9])=1)
					OBJECT SET ENABLED:C1123(bMove; True:C214)
					tTitle:=[JPSI_Job_Physical_Support_Items:111]ItemType:2
					tMessage1:=[JPSI_Job_Physical_Support_Items:111]Description:4
					sLocation:=JTB_setLocation
					sCriterion2:=[Customers_Projects:9]Name:2
					sCriterion3:=[Customers_Projects:9]CustomerName:4
					sCriterion4:=[Customers_Projects:9]CustomerLine:5
					sCriterion5:="Not Packed"
					If (Substring:C12([JPSI_Job_Physical_Support_Items:111]Location:5; 1; 6)#"Inside")
						sCriterion6:=[JPSI_Job_Physical_Support_Items:111]Location:5
					Else 
						READ ONLY:C145([JTB_Job_Transfer_Bags:112])
						QUERY:C277([JTB_Job_Transfer_Bags:112]; [JTB_Job_Transfer_Bags:112]ID:1=(Substring:C12([JPSI_Job_Physical_Support_Items:111]Location:5; 8)))
						sCriterion5:=[JTB_Job_Transfer_Bags:112]Jobform:3
						sCriterion6:=[JTB_Job_Transfer_Bags:112]Location:4
						REDUCE SELECTION:C351([JTB_Job_Transfer_Bags:112]; 0)
					End if 
					
					QUERY:C277([JPSI_Logs:115]; [JPSI_Logs:115]JPSIid:1=sCriterion1)
					SELECTION TO ARRAY:C260([JPSI_Logs:115]tsTimeStamp:2; $ts; [JPSI_Logs:115]Description:3; axRelTemp)
					REDUCE SELECTION:C351([JPSI_Logs:115]; 0)
					ARRAY TEXT:C222(aKey; Size of array:C274($ts))
					For ($i; 1; Size of array:C274($ts))
						aKey{$i}:=TS2String($ts{$i})
					End for 
					SORT ARRAY:C229($ts; aKey; axRelTemp; <)
					ARRAY LONGINT:C221($ts; 0)
					
				Else 
					sCriterion1:=""
					sCriterion2:="Un-assigned"
					tMessage1:="Un-assigned. (Go to Project Control Center to assign)"
					REDUCE SELECTION:C351([JPSI_Job_Physical_Support_Items:111]; 0)
					GOTO OBJECT:C206(sCriterion1)
				End if 
				
			Else 
				sCriterion1:=""
				sCriterion2:="Record Locked"
				tMessage1:="Try again later"
				REDUCE SELECTION:C351([JPSI_Job_Physical_Support_Items:111]; 0)
				GOTO OBJECT:C206(sCriterion1)
			End if 
			
		Else 
			BEEP:C151
			ALERT:C41(sCriterion1+" does not exist.")
			sCriterion1:=""
			GOTO OBJECT:C206(sCriterion1)
		End if 
		//    
		
	Else   //wrong length
		BEEP:C151
		ALERT:C41(sCriterion1+" is the wrong length")
		sCriterion1:=""
		GOTO OBJECT:C206(sCriterion1)
End case 

If (Length:C16(sCriterion5)=8)
	<>jobform:=sCriterion5
End if 