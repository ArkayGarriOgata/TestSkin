//Garri added to trap errors
//.  Later this can be added to ams_trigger_sync_record

e_OnTriggerError(CorektTriggerPre; Current method name:C684)

ON ERR CALL:C155("e_OnTriggerError")

ams_trigger_sync_record("trigger_RM_xfers")

e_OnTriggerError(CorektTriggerPost)
