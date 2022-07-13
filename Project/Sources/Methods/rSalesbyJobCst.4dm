//%attributes = {"publishedWeb":true}
//(p) rSalesbyJobCst
//$1 - string - anything - flag, this is being called from MOS
//• 2/9/98 cs added parameter, ability to print from report menu
//•052899  mlb allow plant specification
//•071599  mlb  UPR 2050 add paramter api

C_DATE:C307(dDateBegin; $1; dDateEnd; $2)
C_BOOLEAN:C305(fSave; $OK)

If (Count parameters:C259=0)  //called from report menu in FG pallete
	uDialog("DateRangeAndPlant"; 245; 112)  //•052899  mlb  UPR   
	
	If (OK=1)
		util_PAGE_SETUP(->[Finished_Goods_Transactions:33]; "CostOfSales")
		PRINT SETTINGS:C106
	End if 
	$OK:=(OK=1)
	
Else 
	$OK:=True:C214
	dDateBegin:=$1
	dDateEnd:=$2
	Case of 
		: ($3="Haup")
			rb1:=0  //all
			rb2:=1  //haup
			rb3:=0  //roan
			rb4:=0  //payuse
			
			$location:="@"
		: ($3="Roan")
			rb1:=0  //all
			rb2:=0  //haup
			rb3:=1  //roan
			rb4:=0  //payuse
			
		: ($3="PayU")
			rb1:=0  //all
			rb2:=0  //haup
			rb3:=0  //roan
			rb4:=1  //pause      
			
		Else 
			rb1:=1  //all
			rb2:=0  //haup
			rb3:=0  //roan
			rb4:=0  //payuse      
			
	End case 
End if 

If ($OK)
	Case of 
		: (rb1=1)  //all
			$location:="@"
			t3:="FROM "+String:C10(dDateBegin; 1)+" TO "+String:C10(dDateEnd; 1)+" ALL LOCATIONS"
		: (rb2=1)  //h
			
			$location:="@"
			t3:="FROM "+String:C10(dDateBegin; 1)+" TO "+String:C10(dDateEnd; 1)+" HAUPPAUGE"
		: (rb3=1)  //r
			
			$location:="FG:R@"
			t3:="FROM "+String:C10(dDateBegin; 1)+" TO "+String:C10(dDateEnd; 1)+" ROANOKE"
		: (rb4=1)  //pu
			
			$location:="FG:AV@"
			t3:="FROM "+String:C10(dDateBegin; 1)+" TO "+String:C10(dDateEnd; 1)+" PAY-USE"
	End case 
	
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Ship"; *)
	QUERY:C277([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]XactionType:2="Return"; *)
	QUERY:C277([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]XactionType:2="RevShip"; *)  //10/11/94 upr 1269
	
	QUERY:C277([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]XactionType:2="B&H@"; *)  //• 2/5/98 cs added to include B&H
	
	If (rb2=1)  //•052899  mlb 
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]viaLocation:11=$location; *)  //pick up blnk b&h, cust, spl
		
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]viaLocation:11#"FG:R@"; *)
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]viaLocation:11#"FG:AV@"; *)
	Else 
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]viaLocation:11=$location; *)
	End if 
	QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3>=dDateBegin; *)
	QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<=dDateEnd)
	//mod 9/14/94 test and negate returns.              
	
	ORDER BY:C49([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]JobNo:4; >)
	
	BREAK LEVEL:C302(1)
	ACCUMULATE:C303([Finished_Goods_Transactions:33]Qty:6; rqty; real1; real2; real3; real4; real5; real6; real7; [Finished_Goods_Transactions:33]zCount:10)
	util_PAGE_SETUP(->[Finished_Goods_Transactions:33]; "CostOfSales")
	FORM SET OUTPUT:C54([Finished_Goods_Transactions:33]; "CostOfSales")
	PDF_setUp(<>pdfFileName)
	t2:="ANALYSIS OF SHIPPED SALES"
	t2b:="COST OF SALES BY JOB"
	
	If (fSave)
		SEND PACKET:C103(vDoc; String:C10(4D_Current_date; 2)+Char:C90(9)+Char:C90(9)+t2+Char:C90(13))
		SEND PACKET:C103(vDoc; String:C10(4d_Current_time; 5)+Char:C90(9)+Char:C90(9)+t2b+Char:C90(13))
		SEND PACKET:C103(vDoc; Char:C90(9)+Char:C90(9)+t3+Char:C90(13)+Char:C90(13))  //report title
		
		SEND PACKET:C103(vDoc; "Jobit"+Char:C90(9)+"item#"+Char:C90(9)+"Cust ID"+Char:C90(9)+"Cust Name"+Char:C90(9)+"SL"+Char:C90(9))
		SEND PACKET:C103(vDoc; "INV"+Char:C90(9)+"CL"+Char:C90(9)+"Quantity"+Char:C90(9)+"Invoice Amount"+Char:C90(9)+"Cost Matl"+Char:C90(9)+"Cost Labor")
		SEND PACKET:C103(vDoc; Char:C90(9)+"Cost Burden"+Char:C90(9)+"Total Cost"+Char:C90(9)+"G.P. Pct"+Char:C90(9)+"Scrap Cst"+Char:C90(13)+Char:C90(13))
	End if 
	
	PRINT SELECTION:C60([Finished_Goods_Transactions:33]; *)
	FORM SET OUTPUT:C54([Finished_Goods_Transactions:33]; "List")
	If (fSave)
		SEND PACKET:C103(vDoc; Char:C90(13)+Char:C90(13))  //•061495  MLB 
		
	End if 
End if 