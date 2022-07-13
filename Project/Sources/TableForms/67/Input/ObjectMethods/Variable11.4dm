//•2/24/97 -cs- upr 1848 removed with addition of new included
//SEARCH([Art_Dyloxes];[Art_Dyloxes]ProjectNo=[JobMasterLog]ProjectNo)
//SEARCH([TempSizeStyle];[TempSizeStyle]ProjectNo=[JobMasterLog]ProjectNo)
//SORT SELECTION([Art_Dyloxes];[Art_Dyloxes]CPN;>;[Art_Dyloxes]Dylox_Rtn;<)
//SORT SELECTION([TempSizeStyle];[TempSizeStyle]CPN;>;[TempSizeStyle]S_n_S
//«_Recd;<)
QUERY:C277([Finished_Goods_Color_Submission:78]; [Finished_Goods_Color_Submission:78]ProjectNo:1=[Job_Forms_Master_Schedule:67]ProjectNumber:26)
QUERY:C277([Purchase_Orders_Requisitions:80]; [Purchase_Orders_Requisitions:80]id:1=[Job_Forms_Master_Schedule:67]ProjectNumber:26)
ORDER BY:C49([Finished_Goods_Color_Submission:78]; [z_batch_run_dates:77]LastMachTicProc:2; >; [Finished_Goods_Color_Submission:78]Returned:5; <)
ORDER BY:C49([Purchase_Orders_Requisitions:80]; [Purchase_Orders_Requisitions:80]po_number:2; >; [Purchase_Orders_Requisitions:80]date_requisition:5; <)