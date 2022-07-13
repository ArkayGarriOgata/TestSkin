//%attributes = {}
//Method:  Core_PlugIn_0000Explain
//Description:  This method explains how plugin access works

//Follow these steps to add a Plugin

//1. From Users and Groups 4D interface
//     a. Create a group called plugin name (see Core_PlugIn_GetNameT for name)
//          4DViewlicense and 4DWritelicense are examples of plugin name

//     b. Make sure to click on the checkbox that assigns the plugin to the group
//          Now only people in this group will use a license
//          otherwise anyone that logs in uses a license
//          (see http://kb.4d.com/search/assetid=41633)

//2. Run Core_Dialog_VdVl (Core_Dialog_VdVl)
//      a.  Category:  PlugIn
//      b.  Identifier: 4DViewLicense or 4DWriteLicense
//            (See Core_PlugIn_GetNameT for name)
//      c.  Valid Identifier:  UserName
//      d.  Value:  Available


//Here is how it works:

//1.  Simply add Core_PlugIn_Access to the form method of the plugin form
//     See notes in Core_PlugIn_Access to set form events

//2.  Core_PlugIn_Access

//      Form event:  On Load

//          Finds plugin in Core_ValidValue

//           If a value for UserName is Available then 
//           It will replace Available with the username|mmddyyyy|hhmmss|formname
//           It will add the user to the PlugIn group. User now has access to plugin.

//     Form event: On Close Box

//          Finds plugin in Core_ValidValue

//           If a value for UserName contains current user then 
//           It will replace username|mmddyyyy|hhmmss|formname with Available
//           It will remove the user from the PlugIn group. User now does not have access to plugin.






