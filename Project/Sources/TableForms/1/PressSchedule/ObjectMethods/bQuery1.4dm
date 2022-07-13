SET AUTOMATIC RELATIONS:C310(True:C214; True:C214)
QUERY:C277([ProductionSchedules:110])
SET AUTOMATIC RELATIONS:C310(False:C215; False:C215)

//User_AllowedSelection (Current form table)

CREATE SET:C116([ProductionSchedules:110]; "◊LastSelection"+String:C10(Table:C252(->[ProductionSchedules:110])))
sFile:="ProductionSchedules"
SET WINDOW TITLE:C213(fNameWindow(->[ProductionSchedules:110]))
pressBackLog:=Sum:C1([ProductionSchedules:110]DurationSeconds:9)/3600