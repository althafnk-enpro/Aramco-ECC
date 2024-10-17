PROGRAM_NAME='incTvControl'
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 01/16/2024  AT: 11:23:18        *)
(***********************************************************)

DEFINE_CONSTANT

DEFINE_MUTUALLY_EXCLUSIVE

([vTPDisplay,1],[vTPDisplay,2])

DEFINE_START

DEFINE_EVENT

data_event[dvDisplay]
{
    online: 
    {
	send_command dvDisplay,"'SET BAUD 19200,N,8,1'"
    }
    string:
    {
    }	
}

button_event[vTPDisplay,button.input.channel]
{
    push:
    {
	on[vTPDisplay,button.input.channel]
	switch(button.input.channel)
	{
	    case 1:	//Power On
	    {
		send_string dvDisplay,"'set powerstate=on',$0D"
	    }
	    case 2:	//Power Off
	    {
		send_string dvDisplay,"'set powerstate=standby',$0D"
	    }
	     case 3:	//Hdmi 1
	    {
		send_string dvDisplay,"'set input=hdmi1',$0D"
	    }
	     case 4:	//Hdmi 2
	    {
		send_string dvDisplay,"'set input=hdmi2',$0D"
	    }
	    case 5:		//Hdmi 3
	    {
		send_string dvDisplay,"'set input=hdmi3',$0D"
	    }
	    case 6:		//OPS
	    {
		send_string dvDisplay,"'set input=ops1',$0D"
	    }
	    case 7:		//Android
	    {
		send_string dvDisplay,"'set input=android',$0D"
	    }
	}
    }
}