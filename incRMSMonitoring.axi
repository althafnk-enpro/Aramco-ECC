PROGRAM_NAME='incRMSMonitoring'
(***********************************************************)
(*  FILE CREATED ON: 01/30/2023  AT: 10:26:06              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 02/14/2023  AT: 09:30:40        *)
(***********************************************************)
DEFINE_VARIABLE


(***********************************************************)
(*                INCLUDE DEFINITIONS GO BELOW             *)
(***********************************************************)

// Include the RMS API constants & helper functions
// only if you need to interface/interact directly
// with the RMS client API.
#INCLUDE 'RmsApi';

(***********************************************************)
(*                MODULE CODE GOES BELOW                   *)
(***********************************************************)

//
// RMS Client - NetLinx Adapter Module
//
//  - This module includes the RMS client module
//    and enables communication via SEND_COMMAND,
//    SEND_STRINGS, CHANNELS, and LEVELS with the
//    RMS Client.
//
//  ATTENTION!
//
//  - The RMS NetLinx Adapter Module must be declared first
//    so that the RMS core sevices are loaded before any other
//    RMS application or device monitoring modules.
//
define_module 'RmsNetLinxAdapter_dr4_0_0' mdlRMSNetLinx(vdvRMS);


(*********************************)
(*  RMS NetLinx Device Monitors  *)
(*********************************)

//
// AMX Control System Master
//
// - include only one of these control system device monitoring modules.
//   this is intended to serve as an extension point for creating
//   system wide control methods and system level monitoring parameters.
//
define_module 'RmsControlSystemMonitor' mdlRmsControlSystemMonitorMod(vdvRMS,dvMaster);

define_module 'RmsTouchPanelMonitor' mdlRmsTouchPanelMonitorMod(vdvRMS,vTPMain_RMS,dvTPMT_Main);

define_module 'RmsClientGui_dr4_0_0' mdlRMSGUI(vdvRMSGui,dvRMSTP,dvRMSTP_Base);


(***********************************)
(*  RMS Device Monitoring Modules  *)
(***********************************)

//
// RMS device monitoring modules
//
// - a RMS device monitoring module is required for each device
//   you wish for RMS to register and monitor.  These NetLinx-based monitoring
//   modules include default implementations for monitored parameters,
//   control methods, and metadata properties based on the SNAPI API.
//   Your NetLinx implementation code should emulate the SNAPI commands
//   channels and levels for each device type on the device virtual device
//   interface.  If you emulate the necessary SNAPI commands, channel, and
//   levels, these monitoring modules will perform all the RMS integration
//   on behalf of each device type.
//
//   The NetLinx-based RMS monitoring modules are all open source.

define_module 'RmsNlAudioConferencerMonitor' mdlRmsNIAudioConferencerMonitor(vdvRMS, vdvBiampTesira_RMS, dvBiampTesira);
//define_module 'RmsDuetAudioConferencerMonitor' mdlRmsDuetAudioConferencerMonitor(vdvRMS, vdvBiampTesira, dvBiampTesira);
define_module 'RmsNlSwitcherMonitor' mdlRmsNlSwitcherMonitor(vdvRMS, vdvVideoSwitcher_RMS, dvAMXPR_Switcher);
define_module 'RmsNlVideoConferencerMonitor' mdlRmsNlVideoConferencerMonitor(vdvRMS, vdvCisco_RMS, dvCiscoVC);
define_module 'RmsRelayDeviceMonitor' mdlRelayMonitorMod(vdvRMS, dvRelay);


DEFINE_EVENT

data_event[vdvRMS]
{
    online:
    {
	// Config master RMS widget settings
	// From page 128 Programmer Guide
	send_command data.device,'CONFIG.CLIENT.ENABLED-true';
	send_command data.device,'CONFIG.SERVER.URL-http://192.168.1.106:8080/rms';
	
	RmsSetDeviceAutoRegister(TRUE); // RmsApi.axi function
	
	// Configure monitor modules with the Proxy
	//send_command data.device,"'@',RmsDevToString(vdvTP),'-RMS-Asset-Name,iPad'";

	// Last thing!!!!
	send_command data.device, 'CLIENT.REINIT';
    }
}    

data_event[dvBiampTesira]
{
    online:
    {
	ON[vdvBiampTesira_RMS,252]
	ON[vdvBiampTesira_RMS,251]
    }
    offline:
    {
	Off[vdvBiampTesira_RMS,252]
	Off[vdvBiampTesira_RMS,251]
    }
}

data_event[dvCiscoVC]
{
    online:
    {
	ON[vdvCisco_RMS,252]
	ON[vdvCisco_RMS,251]
    }
    offline:
    {
	Off[vdvCisco_RMS,252]
	Off[vdvCisco_RMS,251]
    }
}
