PROGRAM_NAME='MainProgram'
(***********************************************************)
(*  FILE CREATED ON: 01/17/2023  AT: 13:50:00              *)
(***********************************************************)
(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 01/24/2024  AT: 15:18:50        *)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
    $History: $
*)
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

dvMaster			= 0:1:0

dvAMXPR_Switcher		= 5001:1:0

dvDisplay			= 5001:2:0
vdvDisplay_RMS			= 33010:1:0

dvBiampTesira			= 5001:4:0
vdvBiampTesira			= 41003:1:0
vdvBiampTesira_RMS		= 33011:1:0

dvCiscoVC			= 5001:3:0
vdvCiscoSX80			= 41005:1:0	 // The COMM module should use this as its duet device
vdvCiscoSX802 			= 41005:2:0  	// Line 2
vdvCiscoSX803 			= 41005:3:0  	// Line 3
vdvCiscoSX804 			= 41005:4:0  	// Line 4	
vdvCisco_RMS			= 33012:1:0

dvMAG_IPTV			= 5001:11:0

dvRelay				= 5001:21:0

dvTPMT_Main			=  10001:1:0
dvTPMD_Main			=  10002:1:0
dvTPIPad_Main			=  10003:1:0
vTPMain				=  35001:1:0
vTPMain_RMS			=  33013:1:0

dvTPMT_Switching		=  10001:2:0
dvTPMD_Switching		=  10002:2:0
dvTPIPad_Switching		=  10003:2:0
vTPSwitching			=  35002:1:0

dvTPMT_Audio			=  10001:3:0
dvTPMD_Audio			=  10002:3:0
dvIPad_Audio			=  10003:3:0
vTPAudio			=  35003:1:0

dvTPMT_CiscoVC			=  10001:4:0
dvTPMD_CiscoVC			=  10002:4:0
dvIPad_CiscoVC			=  10003:4:0
vTPCiscoVC			=  35004:1:0

dvTPMT_CiscoControls		=   10001:5:0
dvTPMD_CiscoControls		=   10002:5:0
dvIPAD_CiscoControls		=   10003:5:0
vTPCiscoControls		=   35005:1:0

dvTPMT_Display			=   10001:6:0
dvTPMD_Display			=   10001:6:0
dvIPAD_Display			=   10003:6:0
vTPDisplay			=   35006:1:0

dvTPMT_IPTV			=   10001:8:0
dvTPMd_IPTV			=   10002:8:0
dvIPAD_IPTV			=   10003:8:0
vTPIPTV				=   35007:1:0

dvTP1_RMS          		 =  10001:7:0  // RMS Touch Panels (Device Port for RMS TP pages)
dvTP2_RMS           		 =  10002:7:0  //  (RMS uses port 7 by default)


//vdvDisplayTP			= 34005:1:0
//vdvSwitcher			= 33003:1:0
//vdvDSP				= 33004:1:0
//vdvCodecTP			= 33005:1:0
//vdvMonitorsMotors		= 33006:1:0

//vdvTp				= 34006:1:0

vdvRMS  			= 41001:1:0  // RMS Client Engine VDV      (Duet Module)
vdvRMSGui           		= 41002:1:0  // RMS User Interface VDV     (Duet Module)

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

INTEGER SystemProgress1 = 1;

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

LONG second[] =
{
    1000
}

VOLATILE DEV dvRMSTP[] =
{
   dvTP1_RMS,
   dvTP2_RMS
}

VOLATILE DEV dvRMSTP_Base[] =
{
   dvTPMT_Main,
   dvTPIPad_Main
}

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

DEFINE_COMBINE

(vTPMain,dvTPMT_Main,dvTPMD_Main,dvTPIPad_Main)
(vTPSwitching,dvTPMT_Switching,dvTPMD_Switching,dvTPIPad_Switching)
(vTPAudio,dvTPMT_Audio,dvTPMD_Audio,dvIPad_Audio)
(vTPCiscoVC,dvTPMT_CiscoVC,dvTPMD_CiscoVC,dvIPad_CiscoVC)
(vTPCiscoControls,dvTPMT_CiscoControls,dvTPMD_CiscoControls,dvIPAD_CiscoControls)
(vTPDisplay,dvTPMT_Display,dvTPMD_Display,dvIPAD_Display)
(vTPIPTV,dvTPMT_IPTV,dvTPMd_IPTV,dvIPAD_IPTV)

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

#include 'incBiampTesira.axi'
#include 'incCiscoVC.axi'
#include 'incDisplayControl.axi'
#include 'incSwitchingControl.axi'
#include 'incMAGIPTV.axi'
//#include 'incTexting.axi'
//#include 'incRMSMonitoring.axi'


(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

TIMELINE_EVENT[SystemProgress1]
{
    if(TIMELINE.REPETITION<10)
    {
	SEND_COMMAND vTPMain, "'TEXT1-',ITOA(10-TIMELINE.REPETITION),'s'"
	SEND_LEVEL vTPMain,11,TIMELINE.REPETITION
	send_string 0,"'Timeline is Started'"
    }
    else if(TIMELINE.REPETITION==10)
    {
	SEND_COMMAND vTPMain, "'TEXT1-Done'"
	send_command vTPMain,"'PPOF-Busy'"
    }
     else if(TIMELINE.REPETITION==12)
    {
	TIMELINE_KILL(SystemProgress1);
	send_string 0,"'Timeline is Stopped'"
    }
}

button_event[vTPMain,1]
{
    push:
    {
	TIMELINE_CREATE(SystemProgress1,second,1,TIMELINE_RELATIVE,TIMELINE_REPEAT);
	send_string dvDisplay,"'set powerstate=on',$0D"	//TV ON
	send_command vTPMain,"'PPON-Busy'"
    }
}
button_event[vTPMain,2]
{
    push:
    {
	pulse[vdvCiscoSX80,28]	//Cisco Sleep
	send_string dvDisplay,"'set powerstate=standby',$0D"	//TV Off
	send_command vTPMain,"'PPON-Busy'"
    }
}
button_event[vTPMain,3]
{
    push:
    {
	//send_string dvDisplay,"'set input=ops1',$0D"
	//send_level vTPSwitching,51,3
	//do_push(vTPSwitching,2)
    }
}
button_event[vTPMain,4]
{
    push:
    {
	pulse[vdvCiscoSX80,27]	//Wakup VC
	send_string dvDisplay,"'set input=hdmi1',$0D"	//Source HDMI1 on the display
    }
}



(*****************************************************************)
(*                                                               *)
(*                      !!!! WARNING !!!!                        *)
(*                                                               *)
(* Due to differences in the underlying architecture of the      *)
(* X-Series masters, changing variables in the DEFINE_PROGRAM    *)
(* section of code can negatively impact program performance.    *)
(*                                                               *)
(* See “Differences in DEFINE_PROGRAM Program Execution” section *)
(* of the NX-Series Controllers WebConsole & Programming Guide   *)
(* for additional and alternate coding methodologies.            *)
(*****************************************************************)
