//%attributes = {"publishedWeb":true}
//PM: JTB_Contents() -> 
//@author mlb - 2/7/02  14:46

ARRAY TEXT:C222(aKey; 0)
ARRAY TEXT:C222(axRelTemp; 0)

OBJECT SET ENABLED:C1123(bPrint; False:C215)
OBJECT SET ENABLED:C1123(rb1; False:C215)

<>jobform:=""
sCriterion2:=""
sCriterion3:=""
sCriterion4:=""
sCriterion5:=""
sCriterion6:=""

If (Length:C16(sCriterion1)=6) | (Length:C16(sCriterion1)=8)
	READ ONLY:C145([JTB_Job_Transfer_Bags:112])
	QUERY:C277([JTB_Job_Transfer_Bags:112]; [JTB_Job_Transfer_Bags:112]ID:1=sCriterion1)
	If (Records in selection:C76([JTB_Job_Transfer_Bags:112])=1)
		QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=[JTB_Job_Transfer_Bags:112]PjtNumber:2)  //• mlb - 10/2/02  14:55
		If (Records in selection:C76([Customers_Projects:9])=1)
			sCriterion2:=[Customers_Projects:9]Name:2
			sCriterion3:=[Customers_Projects:9]CustomerName:4
			READ ONLY:C145([Jobs:15])
			SET QUERY LIMIT:C395(1)
			QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=(Num:C11(Substring:C12([JTB_Job_Transfer_Bags:112]Jobform:3; 1; 5))))
			SET QUERY LIMIT:C395(0)
			sCriterion4:=[Jobs:15]Line:3  //[Project]CustomerLine
			REDUCE SELECTION:C351([Jobs:15]; 0)
		End if 
		sCriterion5:=[JTB_Job_Transfer_Bags:112]Jobform:3
		<>jobform:=sCriterion5
		sCriterion6:=[JTB_Job_Transfer_Bags:112]Location:4
		OBJECT SET ENABLED:C1123(bPrint; True:C214)
		
		QUERY:C277([JTB_Contents:113]; [JTB_Contents:113]BagID:1=sCriterion1)
		If (Records in selection:C76([JTB_Contents:113])>0)
			SELECTION TO ARRAY:C260([JTB_Contents:113]JPSIid:2; aKey)
			ARRAY TEXT:C222(axRelTemp; Size of array:C274(aKey))
			READ ONLY:C145([JPSI_Job_Physical_Support_Items:111])
			For ($i; 1; Size of array:C274(aKey))
				QUERY:C277([JPSI_Job_Physical_Support_Items:111]; [JPSI_Job_Physical_Support_Items:111]ID:1=aKey{$i})
				If (Records in selection:C76([JPSI_Job_Physical_Support_Items:111])=1)
					axRelTemp{$i}:=Substring:C12([JPSI_Job_Physical_Support_Items:111]ItemType:2+" "+[JPSI_Job_Physical_Support_Items:111]Description:4; 1; 80)
				Else 
					axRelTemp{$i}:="not found"
				End if 
			End for 
			REDUCE SELECTION:C351([JPSI_Job_Physical_Support_Items:111]; 0)
			REDUCE SELECTION:C351([JTB_Contents:113]; 0)
			SORT ARRAY:C229(axRelTemp; aKey; >)
		End if 
		
	Else 
		BEEP:C151
		ALERT:C41(sCriterion1+" was not found")
		sCriterion1:=""
		GOTO OBJECT:C206(sCriterion1)
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("Scan a Job Transfer Bag's barcode")
	sCriterion1:=""
	GOTO OBJECT:C206(sCriterion1)
End if 