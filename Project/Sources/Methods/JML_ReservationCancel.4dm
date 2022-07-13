//%attributes = {"publishedWeb":true}
//PM: JML_ReservationCancel() -> 
//@author mlb - 7/31/01  14:51
// • mel (8/17/04, 12:10:47) be more agressive, check orders

C_LONGINT:C283($i; $hit)
C_TEXT:C284($job)

If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
	
	CREATE EMPTY SET:C140([Job_Forms_Master_Schedule:67]; "noLongerReserved")
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4="@.**")
	
	SET QUERY DESTINATION:C396(Into variable:K19:4; $hit)
	
	For ($i; 1; Records in selection:C76([Job_Forms_Master_Schedule:67]))
		$job:=Substring:C12([Job_Forms_Master_Schedule:67]JobForm:4; 1; 5)+"@"
		//see if forms have been added
		QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=$job; *)
		QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]JobForm:4#($job+".**"))
		If ($hit>0)  //query dest
			ADD TO SET:C119([Job_Forms_Master_Schedule:67]; "noLongerReserved")
			
		Else   //see if order is still open
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
				
				QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]JobNo:44=Num:C11(Substring:C12([Job_Forms_Master_Schedule:67]JobForm:4; 1; 5)))
				QUERY SELECTION:C341([Customers_Orders:40]; [Customers_Orders:40]Status:10#"Closed"; *)
				QUERY SELECTION:C341([Customers_Orders:40];  & ; [Customers_Orders:40]Status:10#"Can@"; *)
				QUERY SELECTION:C341([Customers_Orders:40];  & ; [Customers_Orders:40]Status:10#"Kill@")
				
			Else 
				
				QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]JobNo:44=Num:C11(Substring:C12([Job_Forms_Master_Schedule:67]JobForm:4; 1; 5)); *)
				QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]Status:10#"Closed"; *)
				QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]Status:10#"Can@"; *)
				QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]Status:10#"Kill@")
				
			End if   // END 4D Professional Services : January 2019 First record
			
			If ($hit=0)  //no longer open order
				ADD TO SET:C119([Job_Forms_Master_Schedule:67]; "noLongerReserved")
			End if 
		End if 
		
		NEXT RECORD:C51([Job_Forms_Master_Schedule:67])
	End for 
	
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	USE SET:C118("noLongerReserved")
	CLEAR SET:C117("noLongerReserved")
	
Else 
	//laghzaoui remove add and set and next
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4="@.**")
	ARRAY TEXT:C222($_JobForm; 0)
	ARRAY LONGINT:C221($_record_numbers; 0)
	ARRAY LONGINT:C221($_noLongerReserved; 0)
	
	SELECTION TO ARRAY:C260([Job_Forms_Master_Schedule:67]JobForm:4; $_JobForm; \
		[Job_Forms_Master_Schedule:67]; $_record_numbers)
	
	SET QUERY DESTINATION:C396(Into variable:K19:4; $hit)
	
	For ($i; 1; Size of array:C274($_JobForm); 1)
		
		$job:=Substring:C12($_JobForm{$i}; 1; 5)+"@"
		QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=$job; *)
		QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]JobForm:4#($job+".**"))
		
		If ($hit>0)
			
			APPEND TO ARRAY:C911($_noLongerReserved; $_record_numbers{$i})
			
		Else   //see if order is still open
			
			QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]JobNo:44=Num:C11(Substring:C12($_JobForm{$i}; 1; 5)); *)
			QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]Status:10#"Closed"; *)
			QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]Status:10#"Can@"; *)
			QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]Status:10#"Kill@")
			
			
			If ($hit=0)  //no longer open order
				
				APPEND TO ARRAY:C911($_noLongerReserved; $_record_numbers{$i})
				
			End if 
		End if 
		
	End for 
	
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	
	CREATE SELECTION FROM ARRAY:C640([Customers_Orders:40]; $_noLongerReserved)
	
	
End if   // END 4D Professional Services : January 2019 

util_DeleteSelection(->[Job_Forms_Master_Schedule:67])
REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
