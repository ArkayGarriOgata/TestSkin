Form:C1466.parts:=ds:C1482.Raw_Materials.query("Raw_Matl_Code = :1 OR VendorPartNum = :1 OR Description = :1  OR DepartmentID = :1 AND DepartmentID # :2"; vSearch2+"@"; "9999").orderBy("Raw_Matl_Code asc")
