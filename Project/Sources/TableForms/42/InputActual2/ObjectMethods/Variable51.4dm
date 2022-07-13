//[JobForm]InputActual'bAddMatl
//12/13/94 upr 1360
//• 10/21/97 cs delete new record if user cancels dialog
//• 6/22/98 cs collect additional information
//•2/02/00  mlb  UPR 2075
wWindowTitle("push"; "Issue R/M to WIP")
OpenSheetWindow(->[Raw_Materials_Transactions:23]; "IssueShortForm")
DIALOG:C40([Raw_Materials_Transactions:23]; "IssueShortForm")  //get  rQty and rCost
CLOSE WINDOW:C154

If (OK=1)
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
		
		CREATE SET:C116([Raw_Materials_Transactions:23]; "Hold")  //• 6/22/98 cs
		
	Else 
		
		ARRAY LONGINT:C221($_Hold; 0)
		SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]; $_Hold)
		
	End if   // END 4D Professional Services : January 2019 
	
	If (sCriterion2#"33-SubComponentFG")  //normal rm issue
		rReal1:=rReal1*-1
		rReal2:=rReal2*-1
		CREATE RECORD:C68([Raw_Materials_Transactions:23])  //• 6/22/98 cs start
		[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=sCriterion1
		[Raw_Materials_Transactions:23]Xfer_Type:2:="Issue"
		[Raw_Materials_Transactions:23]XferDate:3:=4D_Current_date
		[Raw_Materials_Transactions:23]JobForm:12:=[Job_Forms:42]JobFormID:5
		[Raw_Materials_Transactions:23]ReferenceNo:14:=sRefNo
		[Raw_Materials_Transactions:23]Location:15:="WIP"
		[Raw_Materials_Transactions:23]DepartmentID:21:=DeptCode
		[Raw_Materials_Transactions:23]ExpenseCode:26:=sExpCode
		[Raw_Materials_Transactions:23]CompanyID:20:=sComp
		[Raw_Materials_Transactions:23]viaLocation:11:="ShortForm"
		[Raw_Materials_Transactions:23]Qty:6:=rReal1
		[Raw_Materials_Transactions:23]ActCost:9:=uNANCheck(rReal2/rReal1)
		[Raw_Materials_Transactions:23]ActExtCost:10:=rReal2
		[Raw_Materials_Transactions:23]zCount:16:=1
		[Raw_Materials_Transactions:23]ModDate:17:=4D_Current_date
		[Raw_Materials_Transactions:23]ModWho:18:=<>zResp
		[Raw_Materials_Transactions:23]Commodity_Key:22:=sCriterion2
		[Raw_Materials_Transactions:23]CommodityCode:24:=Num:C11(Substring:C12(sCriterion2; 1; 2))
		SAVE RECORD:C53([Raw_Materials_Transactions:23])
		
	Else   //backflush a fg component
		CUT NAMED SELECTION:C334([Job_Forms_Materials:55]; "beforeBackflush")
		QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Raw_Matl_Code:7=sCriterion1; *)
		QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]JobForm:1=[Job_Forms:42]JobFormID:5)
		[Job_Forms_Materials:55]Actual_Qty:14:=[Job_Forms_Materials:55]Actual_Qty:14+rReal1
		[Job_Forms_Materials:55]Actual_Price:15:=[Job_Forms_Materials:55]Actual_Price:15+Job_price_component(sCriterion1; "inventoried"; rReal1; [Job_Forms:42]JobFormID:5)
		SAVE RECORD:C53([Job_Forms_Materials:55])
		USE NAMED SELECTION:C332("beforeBackflush")
	End if 
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
		
		ADD TO SET:C119([Raw_Materials_Transactions:23]; "Hold")
		USE SET:C118("Hold")
		CLEAR SET:C117("Hold")
		
	Else 
		
		APPEND TO ARRAY:C911($_Hold; Record number:C243([Raw_Materials_Transactions:23]))
		CREATE SELECTION FROM ARRAY:C640([Raw_Materials_Transactions:23]; $_Hold)
		
	End if   // END 4D Professional Services : January 2019 
	
	ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Sequence:13; >)  //• 6/22/98 cs end
	COPY NAMED SELECTION:C331([Raw_Materials_Transactions:23]; "rmXfers")
End if 
//EOS