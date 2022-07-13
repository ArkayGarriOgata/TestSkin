//READ WRITE([Finished_Goods])

//$hit:=qryFinishedGood ([JobMakesItem]CustId;[JobMakesItem]ProductCode)

//If ($hit=1)

//[Finished_Goods]OrderCategory:=[JobMakesItem]Category

//SAVE RECORD([Finished_Goods])

//End if 

[Job_Forms_Items:44]Category:31:=[Finished_Goods:26]OriginalOrRepeat:71
