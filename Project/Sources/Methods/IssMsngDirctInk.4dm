//%attributes = {"publishedWeb":true}
//(p) IssMsngDirctInk

//It has been found that there are occasionally 

//consingment Inks used (INX), which are NOT budgeted for

//since these inks are setup as being Direct bill, this

//routine allows the missing INk to be issued.

//It also back populates the budget & estimate in case they

//are ever duplicated so the Ink is already setup

//it will create a record in each of following places:

//[Rm_xfer] - issue

//[Rm_xfer] - receipt

//[PO_Items] - order

//[Material_Job] - budget

//[material_Est] - estimate

//• 8/11/98 cs created

C_TEXT:C284(sRmCode)
C_TEXT:C284(sJobForm)
C_REAL:C285(rReal1)
C_LONGINT:C283($ItemNo)
C_TEXT:C284(xText)
READ ONLY:C145([Job_Forms:42])
READ ONLY:C145([Raw_Materials:21])  //these will be made read write later


Repeat 
	NewWindow(200; 120; 6; 5; "Enter Missing Ink")
	DIALOG:C40([zz_control:1]; "DirectBillInk")
	CLOSE WINDOW:C154
	
	If (OK=1)
		uMsgWindow("Creating Material Estimate..."+Char:C90(13))
		READ WRITE:C146([Raw_Materials_Transactions:23])
		READ WRITE:C146([Purchase_Orders_Items:12])
		READ WRITE:C146([Job_Forms_Materials:55])
		READ WRITE:C146([Estimates_Materials:29])
		//setup vars for call to receiving code
		
		CREATE RECORD:C68([Estimates_Materials:29])  //* create Estimate material 
		
		[Estimates_Materials:29]Raw_Matl_Code:4:=[Raw_Materials:21]Raw_Matl_Code:1
		[Estimates_Materials:29]EstimateNo:5:=[Job_Forms:42]EstimateNo:47
		[Estimates_Materials:29]Commodity_Key:6:=[Raw_Materials:21]Commodity_Key:2
		[Estimates_Materials:29]DiffFormID:1:=[Job_Forms:42]CaseFormID:9
		[Estimates_Materials:29]UOM:8:=[Raw_Materials:21]IssueUOM:10
		[Estimates_Materials:29]Qty:9:=rReal1
		[Estimates_Materials:29]ModWho:21:=<>zResp
		[Estimates_Materials:29]ModDate:22:=4D_Current_date
		SAVE RECORD:C53([Estimates_Materials:29])
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
			
			CREATE SET:C116([Estimates_Materials:29]; "MatEstNew")
			
		Else 
			
			ARRAY LONGINT:C221($_MatEstNew; 0)
			LONGINT ARRAY FROM SELECTION:C647([Estimates_Materials:29]; $_MatEstNew)
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		MESSAGE:C88("Creating Budget Material..."+Char:C90(13))
		CREATE RECORD:C68([Job_Forms_Materials:55])  //* create budget material 
		
		[Job_Forms_Materials:55]Raw_Matl_Code:7:=[Raw_Materials:21]Raw_Matl_Code:1
		[Job_Forms_Materials:55]JobForm:1:=[Job_Forms:42]JobFormID:5
		[Job_Forms_Materials:55]Commodity_Key:12:=[Raw_Materials:21]Commodity_Key:2
		[Job_Forms_Materials:55]UOM:5:=[Raw_Materials:21]IssueUOM:10
		[Job_Forms_Materials:55]Planned_Qty:6:=rReal1
		[Job_Forms_Materials:55]Actual_Qty:14:=rReal1
		[Job_Forms_Materials:55]Actual_Price:15:=[Purchase_Orders_Items:12]UnitPrice:10
		[Job_Forms_Materials:55]ModWho:11:=<>zResp
		[Job_Forms_Materials:55]ModDate:10:=4D_Current_date
		[Job_Forms_Materials:55]CompanyId:23:=uDivFromRunLoc([Job_Forms:42]Run_Location:55)
		[Job_Forms_Materials:55]DepartmentID:24:="9999"
		[Job_Forms_Materials:55]ExpenseCode:25:="1122"
		[Job_Forms_Materials:55]Comments:4:="Non-budgeted item. Found at Receiving"
		SAVE RECORD:C53([Job_Forms_Materials:55])
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
			
			CREATE SET:C116([Job_Forms_Materials:55]; "MatJobNew")
			
			
		Else 
			
			ARRAY LONGINT:C221($_MatJobNew; 0)
			LONGINT ARRAY FROM SELECTION:C647([Job_Forms_Materials:55]; $_MatJobNew)
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		//* create po/po item to setup for receiving system to handle direct billing
		
		
		MESSAGE:C88("Creating PO/Item..."+Char:C90(13))
		QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]PONo:1=[Job_Forms:42]InkPONumber:54)
		
		If (Records in selection:C76([Purchase_Orders:11])=0)
			InkPoCreate  //* create PO if needed
			
		End if 
		RELATE MANY:C262([Purchase_Orders:11]PONo:1)
		ORDER BY:C49([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]ItemNo:3; <)
		$ItemNo:=Num:C11([Purchase_Orders_Items:12]ItemNo:3)+1
		ARRAY TEXT:C222(aSubGroup; 1)  //for po item creation
		
		aSubgroup{1}:=[Raw_Materials:21]SubGroup:31
		//InkPOItemCreate ([Purchase_Orders]PONo;$ItemNo;"*")  //* create PO item  
		
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
			
			USE SET:C118("MatJobNew")  //* update with costs - determined during PO item creation
			
		Else 
			
			CREATE SELECTION FROM ARRAY:C640([Job_Forms_Materials:55]; $_MatJobNew)
		End if   // END 4D Professional Services : January 2019 query selection
		
		[Job_Forms_Materials:55]Actual_Price:15:=[Purchase_Orders_Items:12]UnitPrice:10*[Job_Forms_Materials:55]Actual_Qty:14
		SAVE RECORD:C53([Job_Forms_Materials:55])
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
			CLEAR SET:C117("MatJobNew")
			
			USE SET:C118("MatEstNew")
			
		Else 
			CREATE SELECTION FROM ARRAY:C640([Estimates_Materials:29]; $_MatEstNew)
		End if   // END 4D Professional Services : January 2019 query selection
		
		[Estimates_Materials:29]Cost:11:=[Purchase_Orders_Items:12]UnitPrice:10*[Estimates_Materials:29]Qty:9
		SAVE RECORD:C53([Estimates_Materials:29])
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
			
			CLEAR SET:C117("MatEstNew")
			
		Else 
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		//* setup for call to Receiving screen post code  
		
		//arrays  
		
		ARRAY TEXT:C222(aRMCode; 1)
		aRmCode{1}:=sRmCode
		ARRAY TEXT:C222(aRMPONum; 1)
		aRmPoNum{1}:=[Purchase_Orders:11]PONo:1
		ARRAY TEXT:C222(aRMPOItem; 1)
		aRmPoItem{1}:=String:C10($ItemNo; "00")
		ARRAY TEXT:C222(aRmCompany; 1)
		aRmCompany{1}:=[Job_Forms_Materials:55]CompanyId:23
		ARRAY REAL:C219(aRmPOQty; 1)
		aRMPOQty{1}:=rReal1
		ARRAY REAL:C219(aRmStdPrice; 1)
		aRMStdPrice{1}:=[Purchase_Orders_Items:12]UnitPrice:10
		ARRAY REAL:C219(aRmPOPrice; 1)
		aRmPOPrice{1}:=[Purchase_Orders_Items:12]UnitPrice:10
		ARRAY TEXT:C222(aRMBinNo; 1)
		aRmBinNo{1}:=("Arkay"*Num:C11([Job_Forms_Materials:55]CompanyId:23="1"))+("Roanoke"*Num:C11([Job_Forms_Materials:55]CompanyId:23="2"))
		ARRAY REAL:C219(aRmStkQty; 1)
		aRMStkQty{1}:=rReal1
		dDate:=4D_Current_date
		ARRAY LONGINT:C221(aRmRecNo; 1)
		aRmRecNo{1}:=999999
		ARRAY TEXT:C222(aRMType; 1)
		aRmType{1}:="Receipt"
		//* receiving posting routine
		
		sPostReceipts
		<>RMBarCodePO:=""
		<>RMPOICount:=0
		ARRAY TEXT:C222(aRMPONum; 0)
		ARRAY TEXT:C222(aRMPOItem; 0)
		ARRAY TEXT:C222(aRMCode; 0)
		ARRAY TEXT:C222(aRMBinNo; 0)
		ARRAY REAL:C219(aRMPOQty; 0)
		ARRAY REAL:C219(aRMSTKQty; 0)
		ARRAY REAL:C219(aRMPOPrice; 0)
		ARRAY REAL:C219(aRMStdPrice; 0)
		ARRAY LONGINT:C221(aRMRecNo; 0)
		ARRAY TEXT:C222(aRMType; 0)
		ARRAY TEXT:C222(aRmCompany; 0)
	End if 
	CLOSE WINDOW:C154
Until (OK=0)
//