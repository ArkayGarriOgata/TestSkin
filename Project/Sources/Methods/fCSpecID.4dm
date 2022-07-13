//%attributes = {"publishedWeb":true}
//Procedure: fCSpecID()  120695  MLB
//Get a primary key for a carton spec record
//base on fGetNextID
//•120695  MLB  UPR 234

C_TEXT:C284($0)
C_LONGINT:C283($nextID)

$nextID:=-3
$0:=app_GetPrimaryKey  //app_set_id_as_string (Table(->[Estimates_Carton_Specs]);"000000")  `$server+String($nextID;"000000")