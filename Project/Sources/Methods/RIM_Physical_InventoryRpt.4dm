//%attributes = {}
//OBSOLETE, see RIM_Physical_InventoryRpt2 on the Phys Inv Report button on Roll stock reconcillliation screen

//  // Method: RIM_Physical_InventoryRpt   ( ) ->
//  // By: Mel Bohince @ 04/18/19, 11:16:40
//  // Description
//  // get the locations and the labels on one report
//  // ----------------------------------------------------
//READ ONLY([Raw_Materials_Locations])
//READ ONLY([Raw_Material_Labels])
//READ ONLY([Purchase_Orders_Items])

//C_TEXT($title;$text;$docName;$millidiff)
//C_LONGINT($millinow;$millithen)
//C_TIME($docRef)

//$title:=""
//$text:=""
//$docName:="ROLL_InventoryRpt"+fYYMMDD (4D_Current_date )+"_"+Replace string(String(4d_Current_time ;<>HHMM);":";"")+".csv"
//$docRef:=util_putFileName (->$docName)
//If ($docRef#?00:00:00?)

//QUERY([Raw_Materials_Locations];[Raw_Materials]IssueUOM="LF";*)
//QUERY([Raw_Materials_Locations]; & ;[Raw_Materials_Locations]QtyOH>0)
//SELECTION TO ARRAY([Raw_Materials_Locations]Commodity_Key;$rml_Commodity_Key;[Raw_Materials_Locations]Raw_Matl_Code;$rml_Raw_Matl_Code;[Raw_Materials_Locations]POItemKey;$rml_POItemKey;[Raw_Materials_Locations]QtyOH;$rml_QtyOH)
//MULTI SORT ARRAY($rml_Raw_Matl_Code;>;$rml_POItemKey;$rml_Commodity_Key;$rml_QtyOH)
//ARRAY TEXT($lbl_POItemKey;0)
//ARRAY LONGINT($lbl_Count;0)
//ARRAY LONGINT($lbl_Qty;0)
//Begin SQL
//select POItemKey, count(Label_id), sum(Qty) from Raw_Material_Labels where Qty > 0
//group by POItemKey
//into :$lbl_POItemKey, :$lbl_Count, :$lbl_Qty
//End SQL
//$numLabels:=Size of array($lbl_POItemKey)
//ARRAY LONGINT($lbl_used;$numLabels)  //this will be for cross check
//  //utl_LogIt ("init")

//$line:="Commodity"+","+"RawMaterialCode"+","+"POItem"+","+"QtyOH"+","+"ROLLS"+","+"QtyROLLS"+","+"Difference"
//For ($roll;1;40)
//$line:=$line+","+"Roll"+String($roll)
//end for
//$line:=$line+"\r"
//SEND PACKET($docRef;$line)
//  //utl_LogIt ($line
//C_LONGINT($i;$numElements)
//$numElements:=Size of array($rml_Commodity_Key)
//uThermoInit ($numElements;"Writting Report...")
//For ($i;1;$numElements)
//$line:=$rml_Commodity_Key{$i}+","+$rml_Raw_Matl_Code{$i}+","+$rml_POItemKey{$i}+","+String($rml_QtyOH{$i})+","
//$hit:=Find in array($lbl_POItemKey;$rml_POItemKey{$i})
//If ($hit>-1)
//$line:=$line+String($lbl_Count{$hit})+","+String($lbl_Qty{$hit})+","+String($rml_QtyOH{$i}-$lbl_Qty{$hit})+","
//$lbl_used{$hit}:=1
//Else 
//$line:=$line+"0\t"+"0\t"+String($rml_QtyOH{$i})+","
//End if 
//  // Modified by: Mel Bohince (11/15/21) 
//  //LOAD RECORD([Raw_Materials_Locations])
//  //RELATE MANY([Raw_Materials_Locations]pk_id)
//  //ORDER BY([Raw_Material_Labels];[Raw_Material_Labels]Label_id;>)
//$poi:=$rml_POItemKey{$i}
//ARRAY TEXT($_Label_id;0)
//Begin SQL
//select Label_id from Raw_Material_Labels where POItemKey = :$poi
//order by Label_id
//into :$_Label_id 
//End SQL

//C_COLLECTION($label_c)
//$label_c:=New collection
//ARRAY TO COLLECTION($label_c;$_Label_id)
//$line:=$line+$label_c.join(",")
//$line:=$line+"\r"
//  //end 11/15/21

//SEND PACKET($docRef;$line)
//  //utl_LogIt ($line)
//uThermoUpdate ($i)
//End for 
//uThermoClose 


//  //cross check, labels no location record
//For ($i;1;$numLabels)
//If ($lbl_used{$i}=0)  //not hit on above
//QUERY([Purchase_Orders_Items];[Purchase_Orders_Items]POItemKey=$lbl_POItemKey{$i})
//If (Records in selection([Purchase_Orders_Items])>0)
//$line:=[Purchase_Orders_Items]Commodity_Key+","+[Purchase_Orders_Items]Raw_Matl_Code
//Else 
//$line:="poitem n/f"+","+"???"
//End if 
//$line:=$line+","+$lbl_POItemKey{$i}+","+String(0)+","+String($lbl_Count{$i})+","+String($lbl_Qty{$i})+","+String($lbl_Qty{$i})+"\r"
//SEND PACKET($docRef;$line)
//  //utl_LogIt ($line)
//End if 
//End for 

//SEND PACKET($docRef;"\r\rReporting all RM_Label records and RM_Locations where [Raw_Materials]IssueUOM = LF")
//SEND PACKET($docRef;"\r\r------ END OF FILE ------")
//CLOSE DOCUMENT($docRef)

//  //// obsolete call, method deleted 4/28/20 uDocumentSetType ($docName)  //
//$err:=util_Launch_External_App ($docName)

//Else 
//BEEP
//ALERT("Could not save "+$docName)
//End if 
//  //utl_LogIt("show")