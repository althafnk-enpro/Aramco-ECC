PROGRAM_NAME='incMAGIPTV'
(***********************************************************)
(*  FILE CREATED ON: 01/17/2024  AT: 08:45:45              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 01/17/2024  AT: 08:48:58        *)
(***********************************************************)
DEFINE_CONSTANT

DEFINE_MUTUALLY_EXCLUSIVE

DEFINE_START

DEFINE_EVENT

button_event[vTPIPTV,button.input.channel]
{
    push:
    {
	SET_PULSE_TIME(2) pulse[dvMAG_IPTV,button.input.channel]
    }
}