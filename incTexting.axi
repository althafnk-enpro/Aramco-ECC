PROGRAM_NAME='incTexting'
(***********************************************************)
(*  FILE CREATED ON: 08/21/2017  AT: 09:33:53              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 05/18/2023  AT: 12:15:15        *)
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

dvTP = 10001:11:0

dvIpad_1	= 10002:11:0

dvIT_IPad	= 10003:11:0

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

 char CNewMessage[50][100]

 char CReplyMessage[50][100]
 
 char cSupportRequest[20][100]
 
 char CSupportMessage[10][50] = {  
						    'VC Support Requested',
						    'Audio Support Requested',
						    'Stadionary Support Requested'
						}


 char CSaveMessage[50][100]

char receivedString[300]

char EmergencyString[300]

volatile char CEmergencyMessage[100]

 integer RoomMessage_index = 1

 integer SupportMessage_index = 1


char ChatFilename[] = 'ChatFile.csv'

SLONG slFileHandle 

SLONG slResult 

CHAR cLogString[200][500]

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

define_function Message_initialize()
{
    integer loopIndex
    
    for(loopIndex = 1; loopIndex <=50; loopIndex++)
    {
	send_command dvTP, "'^TXT-',itoa(loopIndex+10),',0,', CSaveMessage[loopIndex]"
	send_command dvIT_IPad, "'^TXT-',itoa(loopIndex+10),',0,', CSaveMessage[loopIndex]"
    }
}


DEFINE_FUNCTION SaveToFile ()//(CHAR cFileName[],CHAR cLogString[])
{
   //STACK_VAR SLONG slFileHandle     // stores the tag that represents the file (or and error code)
   //LOCAL_VAR SLONG slResult         // stores the number of bytes written (or an error code)
    integer loopindex
   // STACK_VAR CHAR  cLogString[200]
   
   slFileHandle = FILE_OPEN(ChatFilename,FILE_RW_APPEND) // OPEN OLD FILE (OR CREATE NEW ONE)    
   IF(slFileHandle>0)               // A POSITIVE NUMBER IS RETURNED IF SUCCESSFUL
    {
	for(loopindex = 1; loopindex <= 50;loopindex++)
	{
	    cLogString[loopindex] = CSaveMessage[loopindex]
	    slResult = FILE_WRITE(ChatFilename,cLogString[loopindex],LENGTH_STRING(cLogString[loopindex])) // WRITE THE NEW INFO
	}
	FILE_CLOSE(slFileHandle)   // CLOSE THE LOG FILE
    }           
    ELSE
    {
	SEND_STRING 0,"'FILE OPEN ERROR:',ITOA(slFileHandle)" // IF THE LOG FILE COULD NOT BE CREATED
    }
}



(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

button_event[dvTP,101]
{
    push:
    {
	send_command dvTP,"'@AKB-;ENTER THE MESSAGE'"
    }
}

button_event[dvTP,102]	//Send
{
    push:
    {
	send_command dvIpad_1, "'@SOU-Notification Sound.wav'"
	//send_command dvIpad_1, "'^TXT-100,0,', CNewMessage"
	send_command dvIpad_1,"'PPON-Support Request'"
	//send_command dvTP, "'^TXT-',itoa(RoomMessage_index+10),',0,', CNewMessage[RoomMessage_index]"
	
	send_command dvTP, "'^TXT-',itoa(RoomMessage_index+10),',0,LIP 3161-CR: ', CNewMessage[RoomMessage_index]"
	send_command dvIpad_1, "'^TXT-',itoa(RoomMessage_index+10),',0,LIP 3161-CR: ', CNewMessage[RoomMessage_index]"
	
	//Message_initialize()
	RoomMessage_index++
	
	
	if((RoomMessage_index >= 1) && (RoomMessage_index <= 10))
	{
	    send_command dvTP,"'PPON-Chat Message - 1'"
	    send_command dvIpad_1,"'PPON-Chat Message - 1'"
	}
	else if((RoomMessage_index >= 11) && (RoomMessage_index <= 20))
	{
	    send_command dvTP,"'PPON-Chat Message - 2'"
	    send_command dvIpad_1,"'PPON-Chat Message - 2'"
	}
	else if((RoomMessage_index >= 21) && (RoomMessage_index <= 30))
	{
	    send_command dvTP,"'PPON-Chat Message - 3'"
	    send_command dvIpad_1,"'PPON-Chat Message - 3'"
	}
    }
}


button_event[dvTP,111]	//Vc Support
button_event[dvTP,112]	//Audio Support
button_event[dvTP,113]	//Stationary Support
{
    push:
    {
	send_command dvIT_IPad, "'@SOU-Notification Sound.wav'"
	send_command dvIT_IPad,"'PPON-Support Request'"
	send_level dvIT_IPad,511,button.input.channel-109
	
	cSupportRequest[SupportMessage_index] = CSupportMessage[button.input.channel - 110]
	
	send_command dvIT_IPad, "'^TXT-',itoa(SupportMessage_index + 10),',0,', cSupportRequest[SupportMessage_index]"
	
	
	SupportMessage_index++
    }
}


button_event[dvIT_IPad,121]	//Support Accept
{
    push:
    {
	send_command dvTP, "'@SOU-Notification Sound.wav'"
	send_command dvTP,"'PPON-Support acknowledgement'"
	
	send_command dvTP, "'^TXT-120,0, Your Support is Accepted'"
	
	send_command dvIT_IPad, "'^TXT-',itoa(SupportMessage_index + 110),',0, Accepted'"
	
	//send_command dvIT_IPad, "'^TXT-',itoa(SupportMessage_index + 110),',0,Accepted'"
    }
}

button_event[dvIT_IPad,122]	//Support Reject
{
    push:
    {
	send_command dvTP, "'@SOU-Notification Sound.wav'"
	send_command dvTP,"'PPON-Support acknowledgement'"
	
	send_command dvTP, "'^TXT-120,0, Your Support is Rejected'"
	
	send_command dvIT_IPad, "'^TXT-',itoa(SupportMessage_index + 110),',0, Rejected'"
    }
}



data_event[dvTP]
{
    online:
    {
	Message_initialize()
	on[dvTP,110]
    }
    offline:
    {
	off[dvTP,110]
    }
    string:
    {
	receivedString = data.text
	if (find_string(receivedString,'KEYB',1) > 0)
	{
	    if (find_string (receivedString,'ABORT',1) == 0)
	    {
		char newChannelName[100]
		integer nMessageIndex
		
		newChannelName = right_string (receivedString, length_string(receivedString) -5)
		CNewMessage[RoomMessage_index] = newChannelName
		
		CSaveMessage[RoomMessage_index] = "'LIP 3161-CR: ',newChannelName"
		//send_command dvTP, "'^TXT-1,0,', CNewMessage[RoomMessage_index]"
		
		SaveToFile()
	    }
	}
    }
}

button_event[dvIpad_1,201]
{
    push:
    {
	send_command dvIpad_1,"'@AKB-;ENTER THE MESSAGE'"
    }
}

button_event[dvIpad_1,202]	//Send
{
    push:
    {
	send_command dvTP, "'@SOU-Notification Sound.wav'"
	send_command dvIpad_1, "'^TXT-100,0,', CNewMessage"
	send_command dvIpad_1,"'PPON-Support Request'"
	//send_command dvTP, "'^TXT-',itoa(RoomMessage_index+10),',0,', CNewMessage"
	
	send_command dvIpad_1, "'^TXT-',itoa(RoomMessage_index+10),',0,ROOM 2: ', CNewMessage[RoomMessage_index]"
	send_command dvTP, "'^TXT-',itoa(RoomMessage_index+10),',0,ROOM 2: ', CNewMessage[RoomMessage_index]"
	
	RoomMessage_index++
	//Message_initialize()
	
	if((RoomMessage_index >= 1) && (RoomMessage_index <= 10))
	{
	    send_command dvTP,"'PPON-Chat Message - 1'"
	    send_command dvIpad_1,"'PPON-Chat Message - 1'"
	}
	else if((RoomMessage_index >= 11) && (RoomMessage_index <= 20))
	{
	    send_command dvTP,"'PPON-Chat Message - 2'"
	    send_command dvIpad_1,"'PPON-Chat Message - 2'"
	}
	else if((RoomMessage_index >= 21) && (RoomMessage_index <= 30))
	{
	    send_command dvTP,"'PPON-Chat Message - 3'"
	    send_command dvIpad_1,"'PPON-Chat Message - 3'"
	}
    }
}


data_event[dvIpad_1]
{
    online:
    {
	Message_initialize()
	on[dvIpad_1,110]
    }
    offline:
    {
	off[dvIpad_1,110]
    }
    string:
    {
	receivedString = data.text

	
	if (find_string(receivedString,'KEYB',1) > 0)
	{
	    if (find_string (receivedString,'ABORT',1) == 0)
	    {
		char newChannelName[100]
		integer nMessageIndex
		
		newChannelName = right_string (receivedString, length_string(receivedString) -5)
		CNewMessage[RoomMessage_index] = newChannelName
		
		CSaveMessage[RoomMessage_index] = "'ROOM 2: ',newChannelName"
		//send_command dvTP, "'^TXT-1,0,', CNewMessage[RoomMessage_index]"
		
		SaveToFile()
	    }
	}
    }
}


button_event[dvTP,1001]
button_event[dvIpad_1,1001]
{
    push:
    {
	Message_initialize()
    }
}


button_event[dvIT_IPad,501]
{
    push:
    {
	send_command dvIT_IPad,"'@AKB-;ENTER THE MESSAGE'"
    }
}

button_event[dvIT_IPad,502]
{
    push:
    {
	send_command dvTP,"'PPON-Emergency Message'"
	send_command dvIpad_1,"'PPON-Emergency Message'"
	
	send_command dvTP, "'@SOU-Notification Sound.wav'"
	send_command dvIpad_1,"'@SOU-Notification Sound.wav'"
	
	send_command dvTP, "'^TXT-501,0,', CEmergencyMessage"
	send_command dvIpad_1, "'^TXT-501,0,', CEmergencyMessage"
    }
}


button_event[dvIT_IPad,503]
{
    push:
    {
	send_string dvAMXPR_Switcher,"'set switch CI0O1',$0A,$0D"
	wait 5
	send_string dvAMXPR_Switcher,"'set vidout blank:logo1',$0A,$0D"
    }
}


data_event[dvIT_IPad]
{
    online:
    {
	
    }
    string:
    {
	EmergencyString = data.text
	
	if (find_string(EmergencyString,'KEYB',1) > 0)
	{
	    if (find_string (EmergencyString,'ABORT',1) == 0)
	    {
		char newEmergencyMessage[100]
		integer nEMessageIndex
		
		newEmergencyMessage = right_string (EmergencyString, length_string(EmergencyString) -5)
		CEmergencyMessage = newEmergencyMessage
		
		send_command dvIT_IPad, "'^TXT-501,0,', CEmergencyMessage"
	    }
	}
    }
}
	
