//READ WRITE([JobMakesItem])

//QUERY([JobMakesItem];[JobMakesItem]ProductCode=[Finished_Goods]ProductCode;*)

//QUERY([JobMakesItem]; & ;[JobMakesItem]Glued=!00/00/00!)

//If (Records in selection([JobMakesItem])>0)

//APPLY TO SELECTION([JobMakesItem];[JobMakesItem]Category:=[Finished_Goods]OrderCategory)

//End if 

//REDUCE SELECTION([JobMakesItem];0)