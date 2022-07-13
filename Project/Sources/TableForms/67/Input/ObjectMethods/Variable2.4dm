//Script: b4New()  021898  MLB
//new Leaf n Emboss
Open window:C153(416; 417; 813; 571; 3; "")
FORM SET INPUT:C55([Purchase_Orders_Requisitions:80]; "Input")
Repeat 
	ADD RECORD:C56([Purchase_Orders_Requisitions:80]; *)
Until (ok=0)

QUERY:C277([Purchase_Orders_Requisitions:80]; [Purchase_Orders_Requisitions:80]id:1=[Job_Forms_Master_Schedule:67]ProjectNumber:26)
If (Length:C16([Job_Forms_Master_Schedule:67]JobForm:4)=8) & (Substring:C12([Job_Forms_Master_Schedule:67]JobForm:4; 7; 2)#"**")
	//SEARCH SELECTION([Leaf_n_Emboss];[Leaf_n_Emboss]JobForm=[JobMasterLog
	//«]Job_Number)
End if 
ORDER BY:C49([Purchase_Orders_Requisitions:80]; [Purchase_Orders_Requisitions:80]po_number:2; >; [Purchase_Orders_Requisitions:80]date_requisition:5; <)
CLOSE WINDOW:C154
//