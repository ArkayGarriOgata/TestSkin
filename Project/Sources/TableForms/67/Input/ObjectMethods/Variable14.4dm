//Script: b2New()  021898  MLB
//*Create a new color submission
Open window:C153(15; 417; 412; 571; 3; "")
FORM SET INPUT:C55([Finished_Goods_Color_Submission:78]; "Input")
Repeat 
	ADD RECORD:C56([Finished_Goods_Color_Submission:78]; *)
Until (ok=0)
//*Restore the selection
QUERY:C277([Finished_Goods_Color_Submission:78]; [Finished_Goods_Color_Submission:78]ProjectNo:1=[Job_Forms_Master_Schedule:67]ProjectNumber:26)
If (Length:C16([Job_Forms_Master_Schedule:67]JobForm:4)=8) & (Substring:C12([Job_Forms_Master_Schedule:67]JobForm:4; 7; 2)#"**")
	//SEARCH SELECTION([ColorSubmission];[ColorSubmission]JobForm=
	//«[JobMasterLog]Job_Number)
End if 
//•3/11/97 cs removed art dylox reference upr 1848 .
//SORT SELECTION([ColorSubmission];[Art_Dyloxes]CPN;>;[ColorSubmission]Approved;<)
ORDER BY:C49([Finished_Goods_Color_Submission:78]; [Finished_Goods_Color_Submission:78]Color:2; >; [Finished_Goods_Color_Submission:78]Returned:5; <)
CLOSE WINDOW:C154
//