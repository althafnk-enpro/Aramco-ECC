PROGRAM_NAME='incCiscoVC'
(***********************************************************)
(*  FILE CREATED ON: 10/12/2023  AT: 13:19:26              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 03/19/2024  AT: 20:11:35        *)
(***********************************************************)
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

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

DEV vdvCamera = vdvCiscoSX80
DEV vdvDev[] = {vdvCiscoSX80}
DEV vdvDev2[] = {vdvCiscoSX80,vdvCiscoSX802}
DEV vdvDev4[] = {vdvCiscoSX80,vdvCiscoSX802,vdvCiscoSX803,vdvCiscoSX804}

// ----------------------------------------------------------
// CURRENT DEVICE NUMBER ON TP NAVIGATION BAR
INTEGER nCiscoSX80 = 1

// ----------------------------------------------------------
// DEFINE THE PAGES THAT YOUR COMPONENTS ARE USING IN THE 
// SUB NAVIGATION BAR HERE
INTEGER nVideoConferencerPages[] = { 1 }
INTEGER nDialerPages[] = { 2 }
INTEGER nCameraPages[] = { 3,4,5 }
INTEGER nPhonebookPages[] = { 6 }
INTEGER nPowerPages[] = { 1 }
INTEGER nSourceSelectPages[] = { 8 }
INTEGER nVolumePages[] = { 9 }
INTEGER nMenuPages[] = { 10,11,12 }
INTEGER nModulePages[] = { 13 }


INTEGER selectedCamera,cameraPresetsave

INTEGER cameraChannels[] = {0,0,132,133,134,135,159,158,161,160}

Display_Select_FB

Camera_1_Selected_FB
Camera_2_Selected_FB

Camera_Lift_FB

CHAR sLastNameDialed[100] = ''
CHAR sLastNumberDialed[100] = ''

integer					VCCallerId // For DTMF CALL

char CNewDialAddress[50]

char TPReceivedString[200]

DEVCHAN dc_VTC_Camera[]=
{
    {vTPCiscoControls, 50}, //Camera 1
    {vTPCiscoControls, 51}, //Camera 2
    {vTPCiscoControls, 52}, //UP
    {vTPCiscoControls, 53}, //DOWN
    {vTPCiscoControls, 54}, //LEFT
    {vTPCiscoControls, 55}, //RIGHT
    {vTPCiscoControls, 56}, //Zoom +
    {vTPCiscoControls, 57}, //Zoom -
    {vTPCiscoControls, 58}, //Focus +
    {vTPCiscoControls, 59} //Focus -
}

DEVCHAN dc_VTC_Camera_Presets[]=
{
    {vTPCiscoControls, 61}, //Preset 1
    {vTPCiscoControls, 62}, //Preset 2
    {vTPCiscoControls, 63}, //Preset 3
    {vTPCiscoControls, 64}, //Preset 4
    {vTPCiscoControls, 65}, //Preset 5
    {vTPCiscoControls, 66}, //Preset 6
    {vTPCiscoControls, 67}, //Preset 7
    {vTPCiscoControls, 68}, //Preset 8
    {vTPCiscoControls, 69}, //Preset 9
    {vTPCiscoControls, 70}, //Preset 10
    {vTPCiscoControls, 71}, //Preset 11
    {vTPCiscoControls, 72}, //Preset 12
    {vTPCiscoControls, 73}, //Preset 13
    {vTPCiscoControls, 74}, //Preset 14
    {vTPCiscoControls, 75}, //Preset 15
    {vTPCiscoControls, 76}, //Preset 16
    {vTPCiscoControls, 77}, //Preset 17
    {vTPCiscoControls, 78}, //Preset 18
    {vTPCiscoControls, 79}, //Preset 19
    {vTPCiscoControls, 80} //Preset 20
}


DEVCHAN dc_Presentation[]=
{
    {vTPCiscoControls, 200}, //HDMI 1
    {vTPCiscoControls, 201}, //HDMI 2
    {vTPCiscoControls, 202}, //HDMI 3
    {vTPCiscoControls, 203}, //HDMI 4
    {vTPCiscoControls, 204},  //Start Presentation
    {vTPCiscoControls, 205}  //stop Presentation
}

DEVCHAN dc_DialButtons[]=
{
    {vTPCiscoControls, 301}, //HDMI 1
    {vTPCiscoControls, 302}, //HDMI 2
    {vTPCiscoControls, 303}, //HDMI 3
    {vTPCiscoControls, 304}, //HDMI 4
    {vTPCiscoControls, 305}
}

DEVCHAN dc_LayoutButtons[]=
{
    {vTPCiscoControls, 401}, 
    {vTPCiscoControls, 402}, 
    {vTPCiscoControls, 403}, 
    {vTPCiscoControls, 404},
    {vTPCiscoControls, 405},
    {vTPCiscoControls, 406}, 
    {vTPCiscoControls, 407}, 
    {vTPCiscoControls, 408}, 
    {vTPCiscoControls, 409}
}

DEVCHAN dc_DTMFButtons[]=
{
    {vTPCiscoControls, 500}, 
    {vTPCiscoControls, 501}, 
    {vTPCiscoControls, 502}, 
    {vTPCiscoControls, 503}, 
    {vTPCiscoControls, 504},
    {vTPCiscoControls, 505},
    {vTPCiscoControls, 506}, 
    {vTPCiscoControls, 507}, 
    {vTPCiscoControls, 508},
    {vTPCiscoControls, 509},    
    {vTPCiscoControls, 510},
    {vTPCiscoControls, 511}
}

volatile integer nNoiseRemoval

volatile char sDTMFCommands[20][20] = {'0','1','2','3','4','5','6','7','8','9','*','#'}

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

//(Camera_1_Selected_FB,Camera_2_Selected_FB)

([vTPCiscoControls,50]..[vTPCiscoControls,51])

([vTPCiscoControls,200]..[vTPCiscoControls,203])

([vTPCiscoControls,401]..[vTPCiscoControls,409])

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

// ----------------------------------------------------------
// DEVICE MODULE GROUPS SHOULD ALL HAVE THE SAME DEVICE NUMBER
DEFINE_MODULE 'Cisco SX80 VideoConferencerComponent' audioconferencer(vdvDev, vTPCiscoVC, nCiscoSX80, nVideoConferencerPages)
DEFINE_MODULE 'Cisco SX80 DialerComponent' dialer(vdvDev4, vTPCiscoVC, nCiscoSX80, nDialerPages,sLastNameDialed,sLastNumberDialed)
DEFINE_MODULE 'Cisco SX80 MenuComponent' menu(vdvDev, vTPCiscoVC, nCiscoSX80, nMenuPages)
DEFINE_MODULE 'Cisco SX80 ModuleComponent' module(vdvDev, vTPCiscoVC, nCiscoSX80, nModulePages)
DEFINE_MODULE 'Cisco SX80 PhonebookComponent' phonebook(vdvDev2, vTPCiscoVC, nCiscoSX80, nPhonebookPages,sLastNameDialed,sLastNumberDialed)
DEFINE_MODULE 'Cisco SX80 PowerComponent' power(vdvDev, vTPCiscoVC, nCiscoSX80, nPowerPages)
DEFINE_MODULE 'Cisco SX80 VolumeComponent' volume(vdvDev, vTPCiscoVC, nCiscoSX80, nVolumePages)
DEFINE_MODULE 'Cisco SX80 SourceSelectComponent' sourceselect(vdvDev, vTPCiscoVC, nCiscoSX80, nSourceSelectPages)
DEFINE_MODULE 'Cisco SX80 CameraComponent' sourceselect(vdvDev, vTPCiscoVC, nCiscoSX80, nCameraPages)

// Define your communications module here like so:
DEFINE_MODULE 'Cisco_SX80_CE_Comm_dr1_0_0' commCisco(vdvCiscoSX80, dvCiscoVC)


(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

DATA_EVENT[vdvCiscoSX80]
{
    ONLINE:
    {
	SEND_COMMAND vdvCiscoSX80,"'PROPERTY-Baud_Rate,115200'"
	SEND_COMMAND vdvCiscoSX80,"'REINIT'"
    }
}




BUTTON_EVENT[dc_VTC_Camera]
{
    PUSH:
    {
	Integer index
	index = GET_LAST(dc_VTC_Camera)
	
	SWITCH(index)
	{
	    CASE 1://camera 1
	    {
		selectedCamera = 1
		ON[vTPCiscoControls,50]
		vdvCamera = vdvCiscoSX80
		SEND_COMMAND vTPCiscoControls,"'^SHO-58.59,1'"
		SEND_STRING dvCiscoVC,"'xConfiguration Video MainVideoSource: 1',$0A,$0D"
		SEND_STRING dvCiscoVC,"'xCommand Video Input SetMainVideoSource ConnectorId: 1',$0D,$0A"
	    }
	    CASE 2://camera 2
	    {
		selectedCamera = 2
		ON[vTPCiscoControls,51]
		vdvCamera = vdvCiscoSX802
		SEND_COMMAND vTPCiscoControls,"'^SHO-58.59,0'"
		SEND_STRING dvCiscoVC,"'xConfiguration Video MainVideoSource: 2',$0A,$0D"
		SEND_STRING dvCiscoVC,"'xCommand Video Input SetMainVideoSource ConnectorId: 2',$0D,$0A"
	    }
	    default:
	    {
		ON[vdvCamera,cameraChannels[index]]
	    }
	}
    }
    RELEASE:
    {
	Integer index
	index = GET_LAST(dc_VTC_Camera)
	
	SWITCH(index)
	{
	    default:
	    {
		
		OFF[vdvCamera,cameraChannels[index]]
	    }
	}
    }
}


/*
BUTTON_EVENT[TPCISCO,1101]
{
    PUSH:
    {
	send_string dvCiscoSSH,"'xCommand Video Input SetMainVideoSource ConnectorId: 1',$0D,$0A"
	
	on[TPCISCO,1101]
	off[TPCISCO,1102]
    }
}

BUTTON_EVENT[TPCISCO,1102]
{
    PUSH:
    {
	send_string dvCiscoSSH,"'xCommand Video Input SetMainVideoSource ConnectorId: 2',$0D,$0A"
	
	off[TPCISCO,1101]
	on[TPCISCO,1102]
    }
}
*/


BUTTON_EVENT[dc_VTC_Camera_Presets]
{
    PUSH:
    {
	Integer index
	index = GET_LAST(dc_VTC_Camera_Presets)
	
	if(index == 7)
	{
	    cameraPresetsave = 1
	}
	else
	{
	    if(cameraPresetsave = 1)
	    {
		if(selectedCamera == 1)
		{
		    SEND_COMMAND vdvCamera,"'CAMERAPRESETSAVE-',itoa(index)"
		}
		else
		{
		    SEND_COMMAND vdvCiscoSX802, "'CAMERAPRESETSAVE-',ITOA(index)"
		}
		cameraPresetsave = 0
	    }
	    else
	    {
		if(selectedCamera == 1)
		{
		    //SEND_COMMAND vdvCamera,"'CAMERAPRESET-',itoa(index)"
		     send_string dvCiscoVC,"'xCommand Camera Preset Activate PresetId:',itoa(index),$0A,$0D"
		}
		else
		{
		 //   SEND_COMMAND vdvCiscoSX802, "'CAMERAPRESET-',ITOA(index)"
		   send_string dvCiscoVC,"'xCommand Camera Preset Activate PresetId:',itoa(index),$0A,$0D"
		}
		cameraPresetsave = 0
	    }
	}
    }
}

BUTTON_EVENT[vTPCiscoControls,146]	//VC Mute
{
    PUSH:
    {
	PULSE[vdvCiscoSX80,145]
	//pulse[vdvBiamp1TesiraArray[5], 26] 
    }
}

BUTTON_EVENT[vTPCiscoControls,68]	//Self View
{
    PUSH:
    {
	PULSE[vdvCiscoSX80, 194]
    }
}

BUTTON_EVENT[vTPCiscoControls,67]
{
    PUSH:
    {
	if(Camera_Lift_FB)
	{
	    OFF[Camera_Lift_FB]
	   
	}else
	{
	    ON[Camera_Lift_FB]
	    
	}
    }
}

BUTTON_EVENT[vTPCiscoControls,90]
{
    PUSH:
    {
	OFF[vdvCiscoSX80, 238]
    }
}


BUTTON_EVENT[vTPCiscoControls,99]
{
    PUSH:
    {
	pulse[vdvCiscoSX80, 99]
    }
}

channel_event[vdvCiscoSX80,99]
{
    on:
    {
	on[vTPCiscoControls,99]
    }
    off:
    {
	off[vTPCiscoControls,99]
    }
}


channel_event[vdvCiscoSX80,146]	//Cisco VC MicMute
{
    on:
    {
	on[vdvBiampTesira_5, 199] 	//Mic Mute ON
    }
    off:
    {
	off[vdvBiampTesira_5, 199] 	//Mic Mute OFF
    }
}


//Noise Removal

BUTTON_EVENT[vTPCiscoControls,91]
{
    PUSH:
    {
	If(nNoiseRemoval == 0)
	{
	    send_command vdvCiscoSX80,"'PASSTHRU-xCommand Audio Microphones NoiseRemoval Activate'"
	    nNoiseRemoval = 1
	    [vTPCiscoControls,91] = nNoiseRemoval
	}
	else if(nNoiseRemoval == 1)
	{
	    send_command vdvCiscoSX80,"'PASSTHRU-xCommand Audio Microphones NoiseRemoval Deactivate'"
	   nNoiseRemoval = 0
	   [vTPCiscoControls,91] = nNoiseRemoval
	}
    }
}

/*
data_event[dvCiscoVC]
{
    string:	//$0D$0AOK$0D$0A*r NoiseRemovalActivateResult (status=OK): $0D$0A** end$0D$0A*s Au
    {
	if ((find_string(data.text,'Audio Input KeyClick Enabled: True',1) > 0) || (find_string(data.text,'NoiseRemovalActivateResult (status=OK)',1) > 0))
	{
	    nNoiseRemoval = 1
	    [vTPCiscoControls,91] = nNoiseRemoval
	}
	else if ((find_string(data.text,'Audio Input KeyClick Enabled: False',1) > 0) || (find_string(data.text,'NoiseRemovalDeactivateResult (status=OK)',1) > 0))
	{
	    nNoiseRemoval = 0
	    [vTPCiscoControls,91] = nNoiseRemoval
	}
    }
}
*/

BUTTON_EVENT[dc_Presentation]
{
    PUSH:
    {
	Integer index,source
	index = GET_LAST(dc_Presentation)
	
	//on[vTPCiscoControls,button.input.channel]
	
	SWITCH(index)
	{
	    CASE 1:
	    {
		ON[vdvCiscoSX80,301]
		ON[vTPCiscoControls,200]
		OFF[vTPCiscoControls,205]
		//SEND_COMMAND vdvCiscoC902,"'INPUTSELECT-1'"
		SEND_STRING dvCiscoVC,"'xCommand Presentation Start PresentationSource: 3',$0A,$0D"

	    }
	    CASE 2:
	    {
		ON[vdvCiscoSX80,301]
		//SEND_COMMAND vdvCiscoC902,"'INPUTSELECT-2'"
		SEND_STRING dvCiscoVC,"'xCommand Presentation Start PresentationSource: 3',$0A,$0D"
	    }
	    
	    CASE 3:
	    {
		ON[vdvCiscoSX80,301]
		//SEND_COMMAND vdvCiscoC902,"'INPUTSELECT-2'"
		SEND_STRING dvCiscoVC,"'xCommand Presentation Start PresentationSource: 3',$0A,$0D"
	    }
	    CASE 4:
	    {
		ON[vdvCiscoSX80,301]
		//SEND_COMMAND vdvCiscoC902,"'INPUTSELECT-2'"
		SEND_STRING dvCiscoVC,"'xCommand Presentation Start PresentationSource: 3',$0A,$0D"
	    }
	    
	    CASE 5:
	    {

	    }
	    CASE 6:
	    {
		OFF[vdvCiscoSX80,301]
		OFF[vTPCiscoControls,200]
		ON[vTPCiscoControls,205]
		SEND_STRING dvCiscoVC,"'xCommand Presentation Stop PresentationSource: 3',$0A,$0D"
		
	    }
	    
	}
    }
}


button_event[dc_DialButtons]
{
    push:
    {
	switch(button.input.channel)
	{
	    case 301:
	    {
		//send_command vTPCiscoControls,"'@AKB-;ENTER THE ADDRESS'"
		send_command button.input.device,"'@AKB-;ENTER THE ADDRESS'"
	    }
	    case 302:
	    {
		send_command vdvCiscoSX80,"'DIALNUMBER-',CNewDialAddress"
		send_command vTPCiscoControls,"'^TXT-301,0,',CNewDialAddress"
	    }
	}
    }
}

data_event[vTPCiscoControls]
{
    string:
    {
	TPReceivedString = data.text
	
	if (find_string(TPReceivedString,'KEYB',1) > 0)
	{
	    if (find_string (TPReceivedString,'ABORT',1) == 0)
	    {
		char newChannelName[100]
		integer nMessageIndex
		
		newChannelName = right_string (TPReceivedString, length_string(TPReceivedString) -5)
		CNewDialAddress = newChannelName
		send_command vTPCiscoControls,"'^TXT-301,0,',CNewDialAddress"
		send_command  vTPCiscoControls,"'AKEYR'"
	    }
	}
    }
}


button_event[dc_LayoutButtons]
{
    push:
    {
	Integer index
	index = GET_LAST(dc_LayoutButtons)
	on[vTPCiscoControls,button.input.channel]
	
	switch(index)	//CenterLeft/CenterRight/LowerLeft/LowerRight/UpperCenter/UpperLeft/UpperRight
	{
	    case 1:
	    {
		SEND_STRING dvCiscoVC,"'xCommand Video Selfview Set Mode: On FullscreenMode: Off PIPPosition: UpperLeft OnMonitorRole: First',$0D,$0A"
	    }
	    case 2:
	    {
		SEND_STRING dvCiscoVC,"'xCommand Video Selfview Set Mode: On FullscreenMode: Off PIPPosition: UpperCenter OnMonitorRole: First',$0D,$0A"
	    }
	    case 3:
	    {
		SEND_STRING dvCiscoVC,"'xCommand Video Selfview Set Mode: On FullscreenMode: Off PIPPosition: UpperRight OnMonitorRole: First',$0D,$0A"
	    }
	    case 4:
	    {
		SEND_STRING dvCiscoVC,"'xCommand Video Selfview Set Mode: On FullscreenMode: Off PIPPosition: CenterLeft OnMonitorRole: First',$0D,$0A"
	    }
	    case 5:
	    {
		SEND_STRING dvCiscoVC,"'xCommand Video Selfview Set Mode: On FullscreenMode: Off PIPPosition: CenterRight OnMonitorRole: First',$0D,$0A"
	    }
	    case 6:
	    {
		SEND_STRING dvCiscoVC,"'xCommand Video Selfview Set Mode: On FullscreenMode: Off PIPPosition: LowerLeft OnMonitorRole: First',$0D,$0A"
	    }
	     case 7:
	    {
		SEND_STRING dvCiscoVC,"'xCommand Video Selfview Set Mode: On FullscreenMode: Off PIPPosition: LowerRight OnMonitorRole: First',$0D,$0A"	
	    }
	}
    }
}

button_event[dc_DTMFButtons]
{
    push:
    {
	//SEND_STRING dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: ',itoa(sDTMFCommands[button.input.channel -499]),$0D,$0A"
	SWITCH(BUTTON.INPUT.CHANNEL)
	{
	CASE 500:		{ SEND_STRING dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: 0',$0D,$0A" }
	CASE 501:		{ SEND_STRING dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: 1',$0D,$0A" }
	CASE 502:		{ SEND_STRING dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: 2',$0D,$0A" }
	CASE 503:		{ SEND_STRING dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: 3',$0D,$0A" }
	CASE 504:		{ SEND_STRING dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: 4',$0D,$0A" }
	CASE 505:		{ SEND_STRING dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: 5',$0D,$0A" }
	CASE 506:		{ SEND_STRING dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: 6',$0D,$0A" }
	CASE 507:		{ SEND_STRING dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: 7',$0D,$0A" }
	CASE 508:		{ SEND_STRING dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: 8',$0D,$0A" }
	CASE 509:		{ SEND_STRING dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: 9',$0D,$0A" }
	CASE 510:		{ SEND_STRING dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: *',$0D,$0A" }
	CASE 511:		{ SEND_STRING dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: #',$0D,$0A" }
	}
    }
}






button_event[vTPCiscoControls,551]
button_event[vTPCiscoControls,552]
{
    push:
    {
	//SEND_STRING dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: ',itoa(sDTMFCommands[button.input.channel -499]),$0D,$0A"
	switch(BUTTON.INPUT.CHANNEL)
	{
	    case 551:	//Emergency	
	    {
		send_command vdvCiscoSX80,"'DIALNUMBER-8804111'"
		wait 50
		{
		    send_string dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: 6',$0D,$0A"
		    wait 5
		    send_string dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: 7',$0D,$0A"
		    wait 10
		    send_string dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: 0',$0D,$0A"
		    wait 15
		    send_string dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: 1',$0D,$0A"
		    wait 30
		    send_string dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: #',$0D,$0A"
		}
		wait 90
		{
		    send_string dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: 1',$0D,$0A"
		    wait 5
		    send_string dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: 3',$0D,$0A"
		    wait 10
		    send_string dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: 5',$0D,$0A"
		    wait 15
		    send_string dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: 9',$0D,$0A"
		    wait 20
		    send_string dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: 8',$0D,$0A"
		    wait 25
		    send_string dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: 7',$0D,$0A"
		    wait 30
		    send_string dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: #',$0D,$0A"
		}
	    }
	    case 552:	//Weekly Test		
	    {
		send_command vdvCiscoSX80,"'DIALNUMBER-34002900'"
		wait 50
		{
		    send_string dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: 6',$0D,$0A"
		    wait 5
		    send_string dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: 6',$0D,$0A"
		    wait 10
		    send_string dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: 7',$0D,$0A"
		    wait 15
		    send_string dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: 7',$0D,$0A"
		    wait 20
		    send_string dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: 8',$0D,$0A"
		    wait 25
		    send_string dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: 8',$0D,$0A"
		    wait 30
		    send_string dvCiscoVC,"'xCommand Call DTMFSend CallId: 0 DTMFString: #',$0D,$0A"
		}
	    }
	}
    }
}