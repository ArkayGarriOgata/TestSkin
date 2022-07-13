Form:C1466.parts:=ds:C1482.Raw_Materials.query("Commodity_Key = :1 AND DepartmentID # :2"; "@Parts"; "9999").orderBy("Raw_Matl_Code asc")
//[Raw_Materials]Commodity_Key