$numRel:=Records in selection:C76([Purchase_Orders_Releases:79])
CREATE RECORD:C68([Purchase_Orders_Releases:79])
[Purchase_Orders_Releases:79]POitemKey:1:=[Purchase_Orders_Items:12]POItemKey:1
[Purchase_Orders_Releases:79]RelNumber:4:=String:C10(($numRel+1); "000")
[Purchase_Orders_Releases:79]RM_Code:7:=[Purchase_Orders_Items:12]Raw_Matl_Code:15
[Purchase_Orders_Releases:79]Schd_Date:3:=Add to date:C393(Current date:C33; 0; 0; 7)
SAVE RECORD:C53([Purchase_Orders_Releases:79])

QUERY:C277([Purchase_Orders_Releases:79]; [Purchase_Orders_Releases:79]POitemKey:1=[Purchase_Orders_Items:12]POItemKey:1)
ORDER BY:C49([Purchase_Orders_Releases:79]; [Purchase_Orders_Releases:79]Schd_Date:3; >)

//REDRAW LIST(iRelListBox)