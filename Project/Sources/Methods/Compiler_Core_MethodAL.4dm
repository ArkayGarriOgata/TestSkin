//%attributes = {}
//Method:  Compiler_Core_MethodAL
//Description:  This method is for the Core module

C_TEXT:C284(Core_4D_MaintenanceAndSecurity; $1)

C_POINTER:C301(Core_Array_Clear; $1)

C_POINTER:C301(Core_Array_ConvertToText; $1; $2)

C_BOOLEAN:C305(Core_Array_EqualSizeB; $0)
C_POINTER:C301(Core_Array_EqualSizeB; ${1})

C_LONGINT:C283(Core_Array_PositionN; $0)
C_POINTER:C301(Core_Array_PositionN; $1)
C_TEXT:C284(Core_Array_PositionN; $2; $3)

C_BOOLEAN:C305(Core_Component_ExistsB; $0)
C_TEXT:C284(Core_Component_ExistsB; $1)

C_REAL:C285(Core_Convert_NumberB; $1)
C_BOOLEAN:C305(Core_Convert_NumberB; $0)

C_TEXT:C284(Core_Database_BackupAlert; $1)

C_BOOLEAN:C305(Core_Development_WarnB; $0)
C_OBJECT:C1216(Core_Development_WarnB; $1)

C_TEXT:C284(Core_Document_GetExtensionT; $1; $0)

C_TEXT:C284(Core_Document_GetNameT; $1; $0)
C_LONGINT:C283(Core_Document_GetNameT; $2)

C_POINTER:C301(Core_Field_DocumentAscii; $1)

C_BOOLEAN:C305(Core_Group_IsGroupB; $0)
C_LONGINT:C283(Core_Group_IsGroupB; $1)

C_TEXT:C284(Core_HList_Clear; $1)
C_BOOLEAN:C305(Core_HList_Clear; $2)

C_LONGINT:C283(Core_HList_Create; $1)

C_TEXT:C284(Core_HList_GetKeyT; $0)
C_LONGINT:C283(Core_HList_GetKeyT; $1)
C_TEXT:C284(Core_HList_GetKeyT; $2)

C_LONGINT:C283(Core_HList_Initialize; $1)
C_POINTER:C301(Core_HList_Initialize; $2)
C_LONGINT:C283(Core_HList_Initialize; $3)
C_BOOLEAN:C305(Core_HList_Initialize; $4)

C_BOOLEAN:C305(Core_HList_IsFolderB; $0)
C_POINTER:C301(Core_HList_IsFolderB; $1)

C_LONGINT:C283(Core_HList_Load; $1)
C_POINTER:C301(Core_HList_Load; $2)
C_LONGINT:C283(Core_HList_Load; $3)
C_BOOLEAN:C305(Core_HList_Load; $4)
