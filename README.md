### Usage

1. Copy the code from this repositories **.ps1** file labeled **CreateLocalAdministrator.ps1**.
2. In NinjaRMM, go to Administration > Library > Automation > Add Automation > New Script
3. Paste the script contents directly inside of the NinjaRMM text editor.
4. Copy the script settings from the image below. (
   **Language**: Powershell,
   **Operating System**: Windows,
   **Architecture**: All,
   **RunAs**: System,
   
   **Script Variables:**
     **String/Text**: AUserName
     **String/Text**: NinjaProperty
)
5. You will need to create your device custom fields.  Please go to Administration > Devices > Device Custom Fields > Add Custom Field(
   **Type**: Text
   Enheritance > Enable Enheritance for Device
   Permissions > Automations: Read/Write
   Permissions > API: Read/Write
)

### Your NinjaONE RMM parameters should resemble the below.

<img width="576" height="1115" alt="image" src="https://github.com/user-attachments/assets/df643c7e-5fec-430a-8070-453df01e0018" />
