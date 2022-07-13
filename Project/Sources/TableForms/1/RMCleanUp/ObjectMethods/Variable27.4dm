//OM:  bPrint  052699  mlb
//drill down for commodity table
<>PassThrough:=True:C214
ALL RECORDS:C47([Raw_Material_Commodities:54])
CREATE SET:C116([Raw_Material_Commodities:54]; "◊PassThroughSet")


ViewSetter(2; ->[Raw_Material_Commodities:54])
//