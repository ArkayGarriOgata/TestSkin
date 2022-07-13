//%attributes = {"publishedWeb":true}
//PM: REL_getAvailableToPromise() -> date
//@author mlb - 2/6/03  10:18
//• mlb - 3/11/03 base on ProductCode, not pegged orderline

C_TEXT:C284($1)
C_TEXT:C284($2)  //now productcode, was orderline
C_DATE:C307($0)
C_BOOLEAN:C305($continue)
C_LONGINT:C283($THCcommit)

$continue:=True:C214

Case of 
	: ([Customers_ReleaseSchedules:46]THC_State:39=0)
		$0:=4D_Current_date
		$continue:=False:C215
		
	Else 
		READ ONLY:C145([Finished_Goods_Locations:35])
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]FG_Key:34=([Customers_ReleaseSchedules:46]CustID:12+":"+[Customers_ReleaseSchedules:46]ProductCode:11); *)
		QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2="FG@")
		If (Records in selection:C76([Finished_Goods_Locations:35])>0)
			$onHand:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
			If ($onHand>=[Customers_ReleaseSchedules:46]Sched_Qty:6)
				SET QUERY DESTINATION:C396(Into variable:K19:4; $THCcommit)
				QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=[Customers_ReleaseSchedules:46]ProductCode:11; *)
				QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
				QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39=0)
				SET QUERY DESTINATION:C396(Into current selection:K19:1)
				If ($THCcommit=0)
					$0:=4D_Current_date
					$continue:=False:C215
				End if 
			End if 
		End if 
		
		If ($continue)
			READ ONLY:C145([Job_Forms_Items:44])
			//QUERY([JobMakesItem];[JobMakesItem]OrderItem=$2;*)`• mlb 3/11/03 allow cross shi
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=$2; *)  //• mlb - cross shipping
			QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Qty_Actual:11=0; *)
			QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]MAD:37>=4D_Current_date)
			If (Records in selection:C76([Job_Forms_Items:44])>0)
				If ([Job_Forms_Items:44]MAD:37#!00-00-00!)
					$0:=[Job_Forms_Items:44]MAD:37+1
					$continue:=False:C215
				End if 
			End if 
		End if 
		
		If ($continue)
			READ ONLY:C145([Job_Forms_Master_Schedule:67])
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=$2; *)  //• mlb - cross shipping
			QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]FormClosed:5=False:C215)
			QUERY SELECTION BY FORMULA:C207([Job_Forms_Items:44]; [Job_Forms_Items:44]Qty_Actual:11<[Job_Forms_Items:44]Qty_Yield:9)
			If (Records in selection:C76([Job_Forms_Items:44])>0)
				QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=[Job_Forms_Items:44]JobForm:1; *)
				QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!)
				If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
					If ([Job_Forms_Master_Schedule:67]OrigRevDate:20#!00-00-00!)  //• mlb - 3/11/03  15:50
						$0:=[Job_Forms_Master_Schedule:67]OrigRevDate:20
						$continue:=False:C215
					Else 
						If ([Job_Forms_Master_Schedule:67]MAD:21#!00-00-00!)
							$0:=[Job_Forms_Master_Schedule:67]MAD:21+3
							$continue:=False:C215
						End if 
					End if 
					
					If (Not:C34($continue))  //date was set
						If ($0<4D_Current_date)
							$0:=4D_Current_date+3
						End if 
					End if 
				End if 
			End if 
		End if 
		
		If ($continue)
			If ([Customers:16]ID:1#$1)
				READ ONLY:C145([Customers:16])  //••      
				QUERY:C277([Customers:16]; [Customers:16]ID:1=[Customers_ReleaseSchedules:46]CustID:12)
			End if 
			If ([Customers:16]DefaultLeadTime:56>0)
				$0:=(7*[Customers:16]DefaultLeadTime:56)+4D_Current_date
			Else 
				$0:=(7*8)+4D_Current_date
			End if 
		End if 
		
End case 