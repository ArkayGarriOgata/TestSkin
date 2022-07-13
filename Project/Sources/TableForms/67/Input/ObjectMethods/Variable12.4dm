//•2/24/97 -cs- upr 1848 removed with addition of new included

QUERY:C277([Finished_Goods_Color_Submission:78]; [Finished_Goods_Color_Submission:78]JobForm:8=[Job_Forms_Master_Schedule:67]JobForm:4)
QUERY:C277([Purchase_Orders_Requisitions:80]; [Purchase_Orders_Requisitions:80]JobForm:7=[Job_Forms_Master_Schedule:67]JobForm:4)
ORDER BY:C49([Finished_Goods_Color_Submission:78]; [z_batch_run_dates:77]LastMachTicProc:2; >; [Finished_Goods_Color_Submission:78]Returned:5; <)
ORDER BY:C49([Purchase_Orders_Requisitions:80]; [Purchase_Orders_Requisitions:80]po_number:2; >; [Purchase_Orders_Requisitions:80]date_requisition:5; <)