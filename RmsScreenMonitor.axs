//*********************************************************************
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 03/21/2019  AT: 17:24:37        *)
(***********************************************************)
//
//             AMX Resource Management Suite  (4.1.16)
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
MODULE_NAME='RmsScreenMonitor'(DEV vdvRMS,
                                             DEV dvMonitoredDevice)

(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

CHAR MONITOR_ASSET_NAME[]             = 'Albiral';


// This module's version information (for logging)
CHAR MONITOR_NAME[]       = 'RMS Screen Monitor';
CHAR MONITOR_DEBUG_NAME[] = 'RmsNlScreenMon';
CHAR MONITOR_VERSION[]    = '4.1.16';


CHAR MONITOR_ASSET_TYPE[] = 'MonitorLift';



// RMS Asset Properties (Optional)
CHAR MONITOR_ASSET_DESCRIPTION[]      = 'Monitor Lift';
CHAR MONITOR_ASSET_MANUFACTURERNAME[] = 'Albiral';
CHAR MONITOR_ASSET_MODELNAME[]        = '';
CHAR MONITOR_ASSET_MANUFACTURERURL[]  = '';
CHAR MONITOR_ASSET_MODELURL[]         = '';
CHAR MONITOR_ASSET_SERIALNUMBER[]     = '';
CHAR MONITOR_ASSET_FIRMWAREVERSION[]  = '';





// include RMS MONITOR COMMON AXI
#INCLUDE 'RmsMonitorCommon';

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
  // Client key must be unique for this master (recommended to leave it as DPS)
 // asset.clientKey         = RmsDevToString(dvMonitoredDevice);

  // These are recommended
  asset.name              = MONITOR_ASSET_NAME;
  asset.assetType         = MONITOR_ASSET_TYPE;

  // These are optional
  asset.description       = MONITOR_ASSET_DESCRIPTION;
  asset.manufacturerName  = MONITOR_ASSET_MANUFACTURERNAME;
  asset.modelName         = MONITOR_ASSET_MODELNAME;
  asset.manufacturerUrl   = MONITOR_ASSET_MANUFACTURERURL;
  asset.modelUrl          = MONITOR_ASSET_MODELURL;
  asset.serialNumber      = MONITOR_ASSET_SERIALNUMBER;
  asset.firmwareVersion   = MONITOR_ASSET_FIRMWAREVERSION;
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
  
  (*RmsAssetParameterEnqueueEnumeration(CHAR assetClientKey[],
                                                         CHAR parameterKey[],
                                                         CHAR parameterName[],
                                                         CHAR parameterDescription[],
                                                         CHAR reportingType[],
                                                         CHAR initialValue[],
                                                         CHAR enumeration[],
                                                         CHAR allowReset,
                                                         CHAR resetValue[],
                                                         CHAR trackChanges)
							 
							 *)
    RmsAssetParameterEnqueueEnumeration(assetClientKey,
                                                     
                                                         'monitor.state',
                                                         'Monitor State',
                                                         'State of the monitor',
                                                          RMS_ASSET_PARAM_TYPE_NONE,
                                                         'Up',
							 'Up|Down',
							 RMS_ALLOW_RESET_NO,
							 'Up',
							 RMS_TRACK_CHANGES_NO
							 )
							 
							 

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
  
  (*RmsAssetControlMethodEnqueue(CHAR assetClientKey[],
                                                  CHAR methodKey[],
                                                  CHAR methodName[],
                                                  CHAR methodDescription[])*)
  RmsAssetControlMethodEnqueue(assetClientKey,
                                                  'monitor.state',
                                                  'Select Monitor State',
                                                  'Change Monitor State')
						  
						  
  (*
    RmsAssetControlMethodArgumentEnum(CHAR assetClientKey[],
                                                       CHAR methodKey[],
                                                       INTEGER argumentOrdinal,
                                                       CHAR argumentName[],
                                                       CHAR argumentDescription[],
                                                       CHAR argumentDefaultValue[],
                                                       CHAR argumentEnumerationValues[])
  *)
						  
  RmsAssetControlMethodArgumentEnum(assetClientKey,
                                                       'monitor.state',
                                                       0,
                                                       'Select Monitor State',
                                                       'Select Monitor State',
                                                       'Up',
                                                       'Up|Down')

    RmsAssetControlMethodsSubmit(assetClientKey)						  
						  
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
  
  SWITCH(methodKey)
    {
	CASE 'monitor.state' :
	{
	    SWITCH(arguments)
	    {
		CASE 'Up':
		{
		    DO_PUSH_TIMED (dvMonitoredDevice, 34	, 1)
		}	
		CASE 'Down':
		{
		    DO_PUSH_TIMED (dvMonitoredDevice, 35	, 1)
		}
		
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
      SynchronizeAssetParameters()
    // no further action is needed here in the ONLINE
    // data event for the device online asset parameter
  }
  OFFLINE:
  {
    // update device online parameter value
    RmsAssetOnlineParameterUpdate(assetClientKey,DEVICE_ID(dvMonitoredDevice))
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
