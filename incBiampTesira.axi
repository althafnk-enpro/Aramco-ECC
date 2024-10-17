PROGRAM_NAME='incBiampTesira'
(***********************************************************)
(*  FILE CREATED ON: 08/05/2018  AT: 09:58:16              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 01/24/2024  AT: 15:19:25        *)
(***********************************************************)
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

vdvBiampTesira_1	=	41003:1:0
vdvBiampTesira_2	=	41003:2:0
vdvBiampTesira_3	=	41003:3:0
vdvBiampTesira_4	=	41003:4:0
vdvBiampTesira_5	=	41003:5:0

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

integer nVolumeLevel[10]

integer nVolumeMute[10]

integer nBargraphStatus[10]

integer TP_Status

volatile dev vdvBiamp1TesiraArray[10] = {vdvBiampTesira_1,vdvBiampTesira_2,vdvBiampTesira_3,vdvBiampTesira_4,vdvBiampTesira_5}

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

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

wait 20
send_level vdvBiampTesira_1, 1, 240
wait 25
send_level vdvBiampTesira_2, 1, 240
wait 30
send_level vdvBiampTesira_3, 1, 240
wait 35
send_level vdvBiampTesira_4, 1, 240

// Communication Module
define_module 'Biamp_Tesira_dr1_0_0' modTesira(vdvBiampTesira, dvBiampTesira)

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

data_event[dvBiampTesira]
{
    online:
    {
	ON[vdvBiampTesira_RMS,252]
	ON[vdvBiampTesira_RMS,251]
    }
    offline:
    {
	OFF[vdvBiampTesira_RMS,252]
	OFF[vdvBiampTesira_RMS,251]
    }
}

data_event[vdvBiampTesira]
{
	online:
	{
		send_command vdvBiampTesira,'PROPERTY-Baud_Rate,38400'
		
		//These two commands log the AMX controller into the Biamp device when it receives the login prompt from the Biamp device.
		send_command vdvBiampTesira,'PROPERTY-User_Name,admin'
		//send_command vdvBiampTesira,'PROPERTY-Password,P@ssw0rd'
		
		send_command vdvBiampTesira,'DEBUG-4'
		
		// Turn Polling Off, Just Delete Line if you need polling...
		send_command vdvBiampTesira,'PROPERTY-Poll_Time,0'		

		////////////////////////////////////////////////////////
		// Configure Biamp Virtual Devices
		////////////////////////////////////////////////////////
		
		// Faders //
		// AUDIOPROCADD-<PORT>,LEVELSTATE[<TagName>|<level attribute>|<state attribute>|<index1>|<index2>|<level step>]		
		send_command vdvBiampTesira,"'AUDIOPROCADD-',itoa(vdvBiampTesira_1.PORT),',LEVELSTATE[Level5|level|mute|1|0|3]'"
		send_command vdvBiampTesira,"'AUDIOPROCADD-',itoa(vdvBiampTesira_2.PORT),',LEVELSTATE[Level1|level|mute|4|0|3]'"
		send_command vdvBiampTesira,"'AUDIOPROCADD-',itoa(vdvBiampTesira_3.PORT),',LEVELSTATE[Level1|level|mute|2|0|3]'"
		send_command vdvBiampTesira,"'AUDIOPROCADD-',itoa(vdvBiampTesira_4.PORT),',LEVELSTATE[Level7|level|mute|1|0|3]'"
		send_command vdvBiampTesira,"'AUDIOPROCADD-',itoa(vdvBiampTesira_5.PORT),',LEVELSTATE[ParleMic1|level|mute|1|0|3]'"
		
		
		////////////////////////////////////////////////////////
		// Get it going!
		////////////////////////////////////////////////////////
		send_command vdvBiampTesira,'REINIT'
	}
}
//Main Volume Control Start from here

data_event[dvTPMT_Audio]
data_event[dvIPad_Audio]
{
    online:
    {
	TP_Status = 1
	
	send_level dvTPMT_Audio, 11, nVolumeLevel[1]
	send_level dvTPMT_Audio, 11, nVolumeLevel[2]
	send_level dvIPad_Audio, 11, nVolumeLevel[1]
	send_level dvIPad_Audio, 11, nVolumeLevel[2]
    }
    offline:
    {
	TP_Status = 0
    }
}

//Bargraph status button
button_event[vTPAudio,21]
button_event[vTPAudio,22]
button_event[vTPAudio,23]
button_event[vTPAudio,24]
button_event[vTPAudio,25]
button_event[vTPAudio,26]
button_event[vTPAudio,27]
button_event[vTPAudio,28]
button_event[vTPAudio,29]
button_event[vTPAudio,30]
{
    push:
    {
	nBargraphStatus[button.input.channel - 20] = 1
    }
    release:
    {
	nBargraphStatus[button.input.channel - 20] = 0
    }
}



level_event[vTPAudio, 11]
level_event[vTPAudio, 12]
level_event[vTPAudio, 13]
level_event[vTPAudio, 14]
level_event[vTPAudio, 15]
level_event[vTPAudio, 16]
level_event[vTPAudio, 17]
level_event[vTPAudio, 18]
level_event[vTPAudio, 19]
level_event[vTPAudio, 20]
{
    //Main_volumeLevel = level.value
    
    if(TP_Status == 1)
    {
	if(nBargraphStatus[level.input.level - 10]== 1)
	{
	    send_string 0,"'Inside Level event to the virtual device'"
	   send_level vdvBiamp1TesiraArray[level.input.level-10], 1, level.value
	   // send_level vdvBiamp1TesiraArray[1], 1, level.value
	  //  send_level vdvBiamp1TesiraArray[2], 1, level.value
	}
    }
}

level_event[vdvBiamp1TesiraArray, 1]
{
    nVolumeLevel[level.input.device.port ] = level.value
	
    if(TP_Status==1)
    {
	if(nBargraphStatus [level.input.device.port] == 0)
	{	
	    send_level vTPAudio, level.input.level, nVolumeLevel [level.input.device.port]
	}
    }
}


button_event[vTPAudio,31]
button_event[vTPAudio,32]
button_event[vTPAudio,33]
button_event[vTPAudio,34]
button_event[vTPAudio,35]
button_event[vTPAudio,36]
button_event[vTPAudio,37]
button_event[vTPAudio,38]
button_event[vTPAudio,39]
button_event[vTPAudio,40]
{
    push:
    {
	pulse[vdvBiamp1TesiraArray[button.input.channel - 30], 26] // Toggle mute the Level
	if(button.input.channel == 32)
	{
	    pulse[vdvBiamp1TesiraArray[5], 26] 
	}
	//pulse[vdvBiamp1TesiraArray[1], 26] // Toggle mute the Level
	//pulse[vdvBiamp1TesiraArray[2], 26] // Toggle mute the Level
    }
}

button_event[vTPAudio,33]
{
    push:
    {
	pulse[vdvBiamp1TesiraArray[3], 26]
    }
}


CHANNEL_EVENT[vdvBiamp1TesiraArray, 199]
{
    ON:
    {
	integer tpindex
	tpindex = channel.device.port
	
	nVolumeMute[tpindex] = 1
	
	[vTPAudio, tpindex+30] = nVolumeMute[tpindex]
    }
    OFF:
    {
	integer tpindex
	tpindex = channel.device.port
	
	nVolumeMute[tpindex] = 0
	
	[vTPAudio, tpindex+30] = nVolumeMute[tpindex]
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
