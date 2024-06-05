#!/bin/bash

DEF=""
DIALOGUE_TEXT="Enter Snooze time. Options are:\n- <N>d: <N>days\n- <N>w: <N>weeks\n- <N>m: <N>months\n- yyyy-mm-dd \n- mon, tue, ..., sun\n- ff: no date (1900)\n- xx: unsnooze email"
osascript <<END
set theDate to the text returned of (display dialog "${DIALOGUE_TEXT}"  default answer "${DEF}")
return theDate
END
