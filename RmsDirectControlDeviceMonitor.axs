//*********************************************************************
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 05/08/2019  AT: 10:34:51        *)
(***********************************************************)
//
//             AMX Resource Management Suite  (4.6.7)
//
//*********************************************************************
/*
 *  Legal Notice :
 *
 *     Copyright, AMX LLC, 2011
 *
 *     Private, proprietary information, the sole property of AMX LLC.  The
 *     contents, ideas, and concepts expressed herein are not to be disclosed
 *     except within the confines of a confidential relationship and only
 *     then on a need to know basis.
 *
 *     Any entity in possession of this AMX Software shall not, and shall not
 *     permit any other person to, disclose, display, loan, publish, transfer
 *     (whether by sale, assignment, exchange, gift, operation of law or
 *     otherwise), license, sublicense, copy, or otherwise disseminate this
 *     AMX Software.
 *
 *     This AMX Software is owned by AMX and is protected by United States
 *     copyright laws, patent laws, international treaty provisions, and/or
 *     state of Texas trade secret laws.
 *
 *     Portions of this AMX Software may, from time to time, include
 *     pre-release code and such code may not be at the level of performance,
 *     compatibility and functionality of the final code. The pre-release code
 *     may not operate correctly and may be substantially modified prior to
 *     final release or certain features may not be generally released. AMX is
 *     not obligated to make or support any pre-release code. All pre-release
 *     code is provided "as is" with no warranties.
 *
 *     This AMX Software is provided with restricted rights. Use, duplication,
 *     or disclosure by the Government is subject to restrictions as set forth
 *     in subparagraph (1)(ii) of The Rights in Technical Data and Computer
 *     Software clause at DFARS 252.227-7013 or subparagraphs (1) and (2) of
 *     the Commercial Computer Software Restricted Rights at 48 CFR 52.227-19,
 *     as applicable.
*/
MODULE_NAME='RmsDirectControlDeviceMonitor'(DEV vdvRMS,
                                             DEV dvMonitoredDevice)
					     

(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
TL1 = 1
CHAR MONITOR_NAME[]       = 'RMS Direct Control Monitor '; // * exactly 27 characters
CHAR MONITOR_DEBUG_NAME[] = 'RmsDirCntrlMon';
CHAR MONITOR_VERSION[]    = '4.6.7';
CHAR MONITOR_ASSET_TYPE[] = 'Touchpanel';
CHAR MONITOR_ASSET_NAME[] = 'iPad'; // populate this property to override the asset name
                                // leave it empty to auto-populate the device name


(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE
LONG TimeArray[1] = 30000	

    volatile char assetName[50];

    

// include RMS MONITOR COMMON AXI
#DEFINE INCLUDE_RMS_EVENT_CUSTOM_COMMAND_CALLBACK // Enable Proxy command callback
#INCLUDE 'RmsMonitorCommon';

// CALLBACK METHOD FOR USER PROXY COMMANDS
DEFINE_FUNCTION RmsEventCustomCommand(CHAR header[], CHAR data[])
{
    debug("'RmsEventCustomCommand(',header,',',data,')'");
    remove_string(header, '@', 1);
    debug("'(',header,' == ',assetClientKey,') = ',itoa(header == assetClientKey)");
    //@<d:p:s>-key,value
    if(header == RmsDevToString(dvMonitoredDevice)) // This is meant for this monitor module - can't use assetClientKey because it hasn't been set yet
    {
	stack_var char iKey[DUET_MAX_PARAM_LEN], iValue[DUET_MAX_PARAM_LEN];
	
	iKey = DuetParseCmdParam(data);
	iValue = DuetParseCmdParam(data);
	debug("'iKey = ',iKey,' iValue = ',iValue");
	switch(upper_string(iKey))
	{
	    case 'RMS-ASSET-NAME':
	    {
		assetName = iValue;
	    }
	}
    }
}
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE


(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)


(***********************************************************)
(* Name:  RegisterAsset                                    *)
(* Args:  RmsAsset asset data object to be registered .    *)
(*                                                         *)
(* Desc:  This is a callback method that is invoked by     *)
(*        RMS to notify this module that it is time to     *)
(*        register this asset.                             *)
(*                                                         *)
(*        This method should not be invoked/called         *)
(*        by any user implementation code.                 *)
(***********************************************************)
DEFINE_FUNCTION RegisterAsset(RmsAsset asset)
{
  // setup optional asset properties
  asset.name        = assetName;
  //asset.description = 'Asset Description Goes Here!';

  // perform registration of this
  // AMX Device as a RMS Asset
  //
  // (registering this asset as an 'AMX' asset
  //  will pre-populate all available asset
  //  data fields with information obtained
  //  from a NetLinx DeviceInfo query.)
  RmsAssetRegisterAmxDevice(dvMonitoredDevice, asset);
}


(***********************************************************)
(* Name:  RegisterAssetParameters                          *)
(* Args:  -none-                                           *)
(*                                                         *)
(* Desc:  This is a callback method that is invoked by     *)
(*        RMS to notify this module that it is time to     *)
(*        register this asset's parameters to be monitored *)
(*        by RMS.                                          *)
(*                                                         *)
(*        This method should not be invoked/called         *)
(*        by any user implementation code.                 *)
(***********************************************************)
DEFINE_FUNCTION RegisterAssetParameters()
{
  // register all asset monitoring parameters now.

  // register the default "Device Online" parameter
  RmsAssetOnlineParameterEnqueue(assetClientKey,DEVICE_ID(dvMonitoredDevice));

  RmsAssetParameterEnqueueString(assetClientKey,
                                        'system.mode',
                                        'System State', 'Current system mode',
                                        RMS_ASSET_PARAM_TYPE_NONE,
                                        '', '', RMS_ALLOW_RESET_NO, 'Reset',
                                        RMS_TRACK_CHANGES_NO);	
  RmsAssetParameterEnqueueString(assetClientKey,
                                        'input.source',
                                        'Source State', 'Current input source',
                                        RMS_ASSET_PARAM_TYPE_NONE,
                                        '', '', RMS_ALLOW_RESET_NO, '',
                                        RMS_TRACK_CHANGES_NO);						
    RmsAssetParameterEnqueueString(assetClientKey,
                                      'Wallvolume.mute',
                                      'Wall Volume Mute', 'The current wall volume mute state',
                                      RMS_ASSET_PARAM_TYPE_NONE,
                                      '', '', RMS_ALLOW_RESET_NO, '',
                                      RMS_TRACK_CHANGES_NO);
    RmsAssetParameterEnqueueString(assetClientKey,
                                      'Ceilingvolume.mute',
                                      'Ceiling Volume Mute', 'The current ceiling volume mute state',
                                      RMS_ASSET_PARAM_TYPE_NONE,
                                   '', '', RMS_ALLOW_RESET_NO, '',
                                      RMS_TRACK_CHANGES_NO);						
				      
  // submit all parameter registrations
  RmsAssetParameterSubmit(assetClientKey);
}


(***********************************************************)
(* Name:  SynchronizeAssetParameters                       *)
(* Args:  -none-                                           *)
(*                                                         *)
(* Desc:  This is a callback method that is invoked by     *)
(*        RMS to notify this module that it is time to     *)
(*        update/synchronize this asset parameter values   *)
(*        with RMS.                                        *)
(*                                                         *)
(*        This method should not be invoked/called         *)
(*        by any user implementation code.                 *)
(***********************************************************)
DEFINE_FUNCTION SynchronizeAssetParameters()
{
  // This callback method is invoked when either the RMS server connection
  // has been offline or this monitored device has been offline from some
  // amount of time.   Since the monitored parameter state values could
  // be out of sync with the RMS server, we must perform asset parameter
  // value updates for all monitored parameters so they will be in sync.
  // Update only asset monitoring parameters that may have changed in value.

  // update device online parameter value
  RmsAssetOnlineParameterUpdate(assetClientKey, DEVICE_ID(dvMonitoredDevice));
}


(***********************************************************)
(* Name:  ResetAssetParameterValue                         *)
(* Args:  parameterKey   - unique parameter key identifier *)
(*        parameterValue - new parameter value after reset *)
(*                                                         *)
(* Desc:  This is a callback method that is invoked by     *)
(*        RMS to notify this module that an asset          *)
(*        parameter value has been reset by the RMS server *)
(*                                                         *)
(*        This method should not be invoked/called         *)
(*        by any user implementation code.                 *)
(***********************************************************)
DEFINE_FUNCTION ResetAssetParameterValue(CHAR parameterKey[],CHAR parameterValue[])
{
  // if your monitoring module performs any parameter
  // value tracking, then you may want to update the
  // tracking value based on the new reset value
  // received from the RMS server.
}


(***********************************************************)
(* Name:  RegisterAssetMetadata                            *)
(* Args:  -none-                                           *)
(*                                                         *)
(* Desc:  This is a callback method that is invoked by     *)
(*        RMS to notify this module that it is time to     *)
(*        register this asset's metadata properties with   *)
(*        RMS.                                             *)
(*                                                         *)
(*        This method should not be invoked/called         *)
(*        by any user implementation code.                 *)
(***********************************************************)
DEFINE_FUNCTION RegisterAssetMetadata()
{
  // register all asset metadata properties now.
}


(***********************************************************)
(* Name:  SynchronizeAssetMetadata                         *)
(* Args:  -none-                                           *)
(*                                                         *)
(* Desc:  This is a callback method that is invoked by     *)
(*        RMS to notify this module that it is time to     *)
(*        update/synchronize this asset metadata properties *)
(*        with RMS if needed.                              *)
(*                                                         *)
(*        This method should not be invoked/called         *)
(*        by any user implementation code.                 *)
(***********************************************************)
DEFINE_FUNCTION SynchronizeAssetMetadata()
{
  // This callback method is invoked when either the RMS server connection
  // has been offline or this monitored device has been offline from some
  // amount of time.   Traditionally, asset metadata is relatively static
  // information and thus does not require any synchronization of values.
  // However, this callback method does provide the opportunity to perform
  // any necessary metadata updates if your implementation does include
  // any dynamic metadata values.
}


(***********************************************************)
(* Name:  RegisterAssetControlMethods                      *)
(* Args:  -none-                                           *)
(*                                                         *)
(* Desc:  This is a callback method that is invoked by     *)
(*        RMS to notify this module that it is time to     *)
(*        register this asset's control methods with RMS.  *)
(*                                                         *)
(*        This method should not be invoked/called         *)
(*        by any user implementation code.                 *)
(***********************************************************)
DEFINE_FUNCTION RegisterAssetControlMethods()
{
  // register all asset control methods now.
    RmsAssetOnlineParameterEnqueue(assetClientKey,DEVICE_ID(dvMonitoredDevice));

    RmsAssetControlMethodEnqueue        (assetClientKey,  'system.mode', 'Set Mode', 'Modify the system');
    RmsAssetControlMethodArgumentEnum   (assetClientKey,  'system.mode', 0,
							'System State', 'Select the system mode to apply',
							'',
							'System Off|System On|Wall Volume Up|Wall Volume Down|Wall Volume Mute|Ceiling Volume Up|Ceiling Volume Down|Ceiling Volume Mute|All Monitors Up|All Monitors Down|PC 1|PC 2|Cable Cubby|Clickshare|No Input|Reboot');
    RmsAssetControlMethodsSubmit(assetClientKey);
 
}


(***********************************************************)
(* Name:  ExecuteAssetControlMethod                        *)
(* Args:  methodKey - unique method key that was executed  *)
(*        arguments - array of argument values invoked     *)
(*                    with the execution of this method.   *)
(*                                                         *)
(* Desc:  This is a callback method that is invoked by     *)
(*        RMS to notify this module that it should         *)
(*        fullfill the execution of one of this asset's    *)
(*        control methods.                                 *)
(*                                                         *)
(*        This method should not be invoked/called         *)
(*        by any user implementation code.                 *)
(***********************************************************)
DEFINE_FUNCTION ExecuteAssetControlMethod(CHAR methodKey[], CHAR arguments[])
{
  DEBUG("'<<< EXECUTE CONTROL METHOD : [',methodKey,'] args=',arguments,' >>>'");
  if(methodKey == 'system.mode')
  {
    SWITCH(arguments)
    {
        CASE 'System Off'  :
        {
	    DO_PUSH_TIMED (dvMonitoredDevice, 7	, 1)
	}
	CASE 'System On'  :
        {
	    DO_PUSH_TIMED (dvMonitoredDevice, 1	, 1)
	}
        CASE 'Wall Volume Up'  :
        {
	    DO_PUSH_TIMED (dvMonitoredDevice, 43	, 1)
	}
	CASE 'Wall Volume Down'  :
        {
	    DO_PUSH_TIMED (dvMonitoredDevice, 44	, 1)
	}
	CASE 'Wall Volume Mute'  :
        {
	    DO_PUSH_TIMED (dvMonitoredDevice, 45	, 1)
	}
        CASE 'Ceiling Volume Up'  :
        {
	    DO_PUSH_TIMED (dvMonitoredDevice, 41	, 1)
	}
	CASE 'Ceiling Volume Down'  :
        {
	    DO_PUSH_TIMED (dvMonitoredDevice, 42	, 1)
	}
	CASE 'Ceiling Volume Mute'  :
        {
	    DO_PUSH_TIMED (dvMonitoredDevice, 11	, 1)
	}
	CASE 'All Monitors Up'  :
        {
	    DO_PUSH_TIMED (dvMonitoredDevice, 34	, 1)
	}
	CASE 'All Monitors Down'  :
        {
	    DO_PUSH_TIMED (dvMonitoredDevice, 35	, 1)
	}
        CASE 'PC 1'  :
        {
	    DO_PUSH_TIMED (dvMonitoredDevice, 21	, 1)
	}
	CASE 'PC 2'  :
        {
	    DO_PUSH_TIMED (dvMonitoredDevice, 25	, 1)
	}
	CASE 'Cable Cubby'  :
        {
	    DO_PUSH_TIMED (dvMonitoredDevice, 22	, 1)
	}
	CASE 'Clickshare'  :
        {
	    DO_PUSH_TIMED (dvMonitoredDevice, 23	, 1)
	}
	CASE 'No Input'  :
        {
	    DO_PUSH_TIMED (dvMonitoredDevice, 24	, 1)
	}
	CASE 'Reboot'  :
        {
	    REBOOT (0:1:0)
	}	
    }
   }
 
}



(***********************************************************)
(* Name:  SystemPowerChanged                               *)
(* Args:  powerOn - boolean value representing ON/OFF      *)
(*                                                         *)
(* Desc:  This is a callback method that is invoked by     *)
(*        RMS to notify this module that the SYSTEM POWER  *)
(*        state has changed states.                        *)
(*                                                         *)
(*        This method should not be invoked/called         *)
(*        by any user implementation code.                 *)
(***********************************************************)
DEFINE_FUNCTION SystemPowerChanged(CHAR powerOn)
{
  // optionally implement logic based on
  // system power state.
}


(***********************************************************)
(* Name:  SystemModeChanged                                *)
(* Args:  modeName - string value representing mode change *)
(*                                                         *)
(* Desc:  This is a callback method that is invoked by     *)
(*        RMS to notify this module that the SYSTEM MODE   *)
(*        state has changed states.                        *)
(*                                                         *)
(*        This method should not be invoked/called         *)
(*        by any user implementation code.                 *)
(***********************************************************)
DEFINE_FUNCTION SystemModeChanged(CHAR modeName[])
{
  // optionally implement logic based on
  // newly selected system mode name.
}


(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START
TIMELINE_CREATE(TL1, TimeArray, 1, TIMELINE_ABSOLUTE,TIMELINE_REPEAT)
(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

//
// monitor device online/offline status
//
DATA_EVENT[dvMonitoredDevice]
{
  ONLINE:
  {
    // the device online parameter is updated to
    // the ONLINE state in the callback method:
    //   SynchronizeAssetParameters()
    // no further action is needed here in the ONLINE
    // data event for the device online asset parameter
  }
  OFFLINE:
  {
    // update device online parameter value
    RmsAssetOnlineParameterUpdate(assetClientKey,DEVICE_ID(dvMonitoredDevice))
  }

}
TIMELINE_EVENT[TL1] // capture all events for Timeline 1

{
    if ([dvMonitoredDevice,1])
    {
	RmsAssetParameterSetValue(assetClientKey,'asset.power','Off');
    }else if ([dvMonitoredDevice,2])
    {
	RmsAssetParameterSetValue(assetClientKey,'asset.power','On');
    }
    if ([dvMonitoredDevice,3])
    {
	RmsAssetParameterSetValue(assetClientKey,'input.source','HDMI 1');
    }else if ([dvMonitoredDevice,4])
    {
	RmsAssetParameterSetValue(assetClientKey,'input.source','HDMI 2');
    }
    else if ([dvMonitoredDevice,6])
    {
	RmsAssetParameterSetValue(assetClientKey,'input.source','PC');
    }

}


(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
