PROGRAM_NAME='incSwitchingControl'
(***********************************************************)
(*  FILE CREATED ON: 01/17/2023  AT: 13:52:29              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 01/18/2024  AT: 14:11:31        *)
(***********************************************************)

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

//dropTargets
integer btndt1 	= 51
integer btndt2 	= 52
integer btndt3 	= 53
integer btndt4 	= 54
integer btndt5 	= 55
integer btndt6 	= 56
integer btndt7 	= 57
integer btndt8 	= 58
integer btndt9 	= 59
integer btndt10 = 60
integer btndt11 = 61
integer btndt12 = 62
integer btndt13 = 63
integer btndt14 = 64
integer btndt15 = 65


integer btndt21 = 71
integer btndt22 = 72
integer btndt23 = 73
integer btndt24 = 74
integer btndt25 = 75
integer btndt26 = 76
integer btndt27 = 77
integer btndt28 = 78
integer btndt29 = 79
integer btndt30 = 80

//draggables
integer btndg1	= 1
integer btndg2	= 2
integer btndg3	= 3
integer btndg4	= 4
integer btndg5	= 5


(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

//an array to store our draggable buttons
integer dgBTNS[] = {btnDG1 ,btnDG2 ,btnDG3 ,btnDG4,btnDG5}

//an array to store our target buttons
integer TgBTNS[] = {btnDT1 ,btnDT2 ,btnDT3 ,btnDT4,btnDT5,btnDT6,btnDT7,btnDT8,btnDT9,btnDT10}

//to store draggable address from start event
integer nDragAddress = 0

volatile integer nSelectedInput

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

([vTPSwitching,1]..[vTPSwitching,5])
([vTPSwitching,21]..[vTPSwitching,24])

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

data_event[vTPSwitching]
{
    online:
    {
	//Let's make sure we are starting in state 1
	send_command vTPSwitching,"'^ANI-',itoa(btnDT10),',1,1,0'"
    }
} 

data_event[dvAMXPR_Switcher]
{
    online: 
    {
	send_command dvAMXPR_Switcher,"'SET BAUD 9600,N,8,1'"
    }
    string:
    {
	send_string 0,"'SWITCHER SAYS>>> '"
    }	
}

//Select the input here
button_event[vTPSwitching,1]
button_event[vTPSwitching,2]
button_event[vTPSwitching,3]
button_event[vTPSwitching,4]
button_event[vTPSwitching,5]
button_event[vTPSwitching,6]
{
    push:
    {
	nSelectedInput 	= button.input.channel
	on[vTPSwitching,button.input.channel]
    }
} 



//Videowall Presets
button_event[vTPSwitching,21]
button_event[vTPSwitching,22]
button_event[vTPSwitching,23]
{
    push:{
	ON[vTPSwitching,BUTTON.INPUT.CHANNEL]
	    IF(BUTTON.INPUT.CHANNEL == 20){
		SEND_STRING dvAMXPR_Switcher,"'load preset:1',$0A,$0D"
	    }
	    
	    ELSE IF(BUTTON.INPUT.CHANNEL == 21){
		SEND_STRING dvAMXPR_Switcher,"'load preset:2',$0A,$0D"
	    }
	    
	    ELSE IF(BUTTON.INPUT.CHANNEL == 22){
		SEND_STRING dvAMXPR_Switcher,"'load preset:3',$0A,$0D"
	    } 
	    
	    ELSE IF(BUTTON.INPUT.CHANNEL == 23){
		SEND_STRING dvAMXPR_Switcher,"'load preset:4',$0A,$0D"	
	    }
    }
}


//A DROP event occurs when a draggable has been released within the boundaries
//of a valid dropTarget.  A valid dropTarget is a dropTarget that has a group
//which the draggable is assigned to


custom_event[vTPSwitching,btnDT1,1413]
{
    send_command vTPSwitching,"'^ANI-',itoa(btnDT1),',1,1,0'"
    send_string dvAMXPR_Switcher,"'set win select:1,',itoa(nSelectedInput),$0A,$0D"
    send_string 0,"'set switch VI',itoa(nSelectedInput),'OALL',$0A,$0D"
    send_level vTPSwitching,51,nSelectedInput + 1
} 
