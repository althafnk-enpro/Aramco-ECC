﻿//*********************************************************************
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 02/14/2023  AT: 09:33:12        *)
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
MODULE_NAME='RmsNlSwitcherMonitor'(DEV vdvRMS,
                                   DEV vdvDeviceModule,
                                   DEV dvMonitoredDevice)

(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
// This compiler directive is provided as a clue so that other include
// files can provide SNAPI specific behavior if needed.
#DEFINE SNAPI_MONITOR_MODULE;

//
// Has-Properties
//
#DEFINE HAS_SWITCHER
#DEFINE HAS_VOLUME
#DEFINE HAS_GAIN
#DEFINE HAS_POWER

DEFINE_DEVICE

dvSwitcher		= 0:5:0

vdvDeviceBiamp1	= 41002:1:0
vdvDeviceBiamp2	= 41002:2:0

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

// RMS Asset Properties (Recommended)
CHAR MONITOR_ASSET_NAME[]             = 'Switcher';


// RMS Asset Properties (Optional)
CHAR MONITOR_ASSET_DESCRIPTION[]      = '';
CHAR MONITOR_ASSET_MANUFACTURERNAME[] = 'AMX';
CHAR MONITOR_ASSET_MODELNAME[]        = 'PR-WP-412';
CHAR MONITOR_ASSET_MANUFACTURERURL[]  = '';
CHAR MONITOR_ASSET_MODELURL[]         = '';
CHAR MONITOR_ASSET_SERIALNUMBER[]     = '';
CHAR MONITOR_ASSET_FIRMWAREVERSION[]  = '';


// This module's version information (for logging)
CHAR MONITOR_NAME[]       = 'RMS Switcher Monitor';
CHAR MONITOR_DEBUG_NAME[] = 'RmsNlSwitcherMon';
CHAR MONITOR_VERSION[]    = '4.6.7';


(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

// RMS Metadata Property Values
#IF_DEFINED HAS_SWITCHER
    METADATA_PROPERTY_SWITCHER_INPUT_COUNT     = 8;
    METADATA_PROPERTY_SWITCHER_OUTPUT_COUNT    = 16;
    CHAR METADATA_PROPERTY_SWITCHER_LEVELS[20] = 'All|Video|Audio';

    METADATA_PROPERTY_SWITCHER_PRESET_COUNT    = 5;
#END_IF

#IF_DEFINED HAS_VOLUME
    SLONG   METADATA_PROPERTY_VOL_LVL_MIN     = 0;
    SLONG   METADATA_PROPERTY_VOL_LVL_MAX     = 255;
    INTEGER METADATA_PROPERTY_VOL_LVL_STEP    = 1;
    SLONG   METADATA_PROPERTY_VOL_LVL_INIT    = 0;
    SLONG   METADATA_PROPERTY_VOL_LVL_RESET   = 0;
    CHAR    METADATA_PROPERTY_VOL_LVL_UNITS[] = '';
#END_IF

#IF_DEFINED HAS_GAIN
    SLONG   METADATA_PROPERTY_GAIN_LVL_MIN     = 0;
    SLONG   METADATA_PROPERTY_GAIN_LVL_MAX     = 255;
    INTEGER METADATA_PROPERTY_GAIN_LVL_STEP    = 1;
    SLONG   METADATA_PROPERTY_GAIN_LVL_INIT    = 0;
    SLONG   METADATA_PROPERTY_GAIN_LVL_RESET   = 0;
    CHAR    METADATA_PROPERTY_GAIN_LVL_UNITS[] = '';
#END_IF


char SwitcherPresets[10][50] = {  
						    'set video mode:matrix',
						    'set video mode:quad',
						    'set video mode:3stack',
						    'set video mode:pip'
						}


(***********************************************************)
(*               INCLUDE DEFINITIONS GO BELOW              *)
(***********************************************************)

// include RMS MONITOR COMMON AXI
#INCLUDE 'RmsMonitorCommon';

// include SNAPI
#INCLUDE 'SNAPI';

#INCLUDE 'RmsNlSnapiComponents';


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
  asset.clientKey         = RmsDevToString(dvMonitoredDevice);

  // These are recommended
  asset.name              = MONITOR_ASSET_NAME;
  asset.assetType         = RMS_ASSET_TYPE_SWITCHER;

  // These are optional
  asset.description       = MONITOR_ASSET_DESCRIPTION;
  asset.manufacturerName  = MONITOR_ASSET_MANUFACTURERNAME;
  asset.modelName         = MONITOR_ASSET_MODELNAME;
  asset.manufacturerUrl   = MONITOR_ASSET_MANUFACTURERURL;
  asset.modelUrl          = MONITOR_ASSET_MODELURL;
  asset.serialNumber      = MONITOR_ASSET_SERIALNUMBER;
  asset.firmwareVersion   = MONITOR_ASSET_FIRMWAREVERSION;

  // perform registration of this asset
  RmsAssetRegister(dvMonitoredDevice, asset);
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
  //Register all snapi HAS_xyz components
  RegisterAssetParametersSnapiComponents(assetClientKey);

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

  //Synchronize all snapi HAS_xyz components
  IF(SynchronizeAssetParametersSnapiComponents(assetClientKey))
    RmsAssetParameterSubmit (assetClientKey)
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
  //Register all snapi HAS_xyz components
  RegisterAssetMetadataSnapiComponents(assetClientKey);

  RmsAssetMetadataSubmit(assetClientKey);
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
  //Register all snapi HAS_xyz components
  IF(SynchronizeAssetMetadataSnapiComponents(assetClientKey))
    RmsAssetMetadataSubmit(assetClientKey);
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
  //Register all snapi HAS_xyz components
  RegisterAssetControlMethodsSnapiComponents(assetClientKey);

  // when done enqueuing all asset control methods and
  // arguments for this asset, we just need to submit
  // them to finalize and register them with the RMS server
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
STACK_VAR
  CHAR cValue1[RMS_MAX_PARAM_LEN]
  INTEGER nValue1
{
  DEBUG("'<<< EXECUTE CONTROL METHOD : [',methodKey,'] args=',arguments,' >>>'");

  cValue1 = RmsParseCmdParam(arguments)
  nValue1 = ATOI(cValue1)

  SWITCH(LOWER_STRING(methodKey))
  {
#IF_DEFINED HAS_SWITCHER
    CASE 'switcher.switch' :
    {
      STACK_VAR INTEGER nInp
      STACK_VAR INTEGER nOut

      nInp = ATOI(RmsParseCmdParam(arguments))
      nOut = ATOI(RmsParseCmdParam(arguments))

      SWITCH(LOWER_STRING(cValue1))
      {
        CASE 'all' :
        {
        //  SEND_COMMAND vdvDeviceModule,"'CI',ITOA(nInp),'O',ITOA(nOut)"
	  
	  send_string dvSwitcher,"'set switch CI',itoa(nInp),'O1',$0A,$0D"
        }
        CASE 'video' :
        {
          send_command vdvDeviceModule,"'VI',ITOA(nInp),'O',ITOA(nOut)"
        }
        CASE 'audio' :
        {
          send_command vdvDeviceModule,"'AI',ITOA(nInp),'O',ITOA(nOut)"
        }
      }
    }
    CASE 'switcher.preset' :
    {
      //SEND_COMMAND vdvDeviceModule,"'SWITCHPRESET-',ITOA(nValue1)"
      send_string dvSwitcher,"SwitcherPresets[nValue1],$0A,$0D"
      send_string 0,"SwitcherPresets[nValue1],$0A,$0D"
    }
#END_IF



#IF_DEFINED HAS_VOLUME
    CASE 'volume.mute' :
    {
      SWITCH(nValue1)
      {
        CASE TRUE  :
        {
         // PULSE[vdvDeviceBiamp1,VOL_MUTE_ON]
	//  PULSE[vdvDeviceBiamp2,VOL_MUTE_ON]
	pulse[vdvDeviceBiamp1,26]
	pulse[vdvDeviceBiamp2,26]
        }
        CASE FALSE :
        {
         // IF([vdvDeviceBiamp1,VOL_MUTE_FB])
        //    PULSE[vdvDeviceBiamp1,VOL_MUTE]
	//    PULSE[vdvDeviceBiamp2,VOL_MUTE]
	pulse[vdvDeviceBiamp1,26]
	pulse[vdvDeviceBiamp2,26]
        }
      }
    }
    CASE 'volume.level' :
    {
    //  SEND_LEVEL vdvDeviceBiamp1, VOL_LVL, nValue1
    //   SEND_LEVEL vdvDeviceBiamp2, VOL_LVL, nValue1
    }
#END_IF
/*
#IF_DEFINED HAS_GAIN
    CASE 'gain.mute' :
    {
      SWITCH(nValue1)
      {
        CASE TRUE  :
        {
          PULSE[vdvDeviceModule,GAIN_MUTE_ON]
        }
        CASE FALSE :
        {
          IF([vdvDeviceModule,GAIN_MUTE_FB])
            PULSE[vdvDeviceModule,GAIN_MUTE]
        }
      }
    }
    CASE 'gain.level' :
    {
      SEND_LEVEL vdvDeviceModule, GAIN_LVL, nValue1
    }
#END_IF
*/
#IF_DEFINED HAS_POWER
    CASE 'asset.power' :
    {
      SWITCH(LOWER_STRING(cValue1))
      {
        CASE 'on'  :
        {
        //  PULSE[vdvDeviceModule,PWR_ON]
	 send_string dvSwitcher,"'set vidout mute:off',$0A,$0D"
        }
        CASE 'off' :
        {
         // PULSE[vdvDeviceModule,PWR_OFF]
	  send_string dvSwitcher,"'set vidout mute:on',$0A,$0D"
        }
      }
    }
#END_IF

    DEFAULT :
    {
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
// (VIRTUAL DEVICE EVENT HANDLERS)
//
DATA_EVENT[vdvDeviceModule]
{
  ONLINE:
  {
    SEND_COMMAND vdvDeviceModule, "'PROPERTY-RMS-Type,Asset'"
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
