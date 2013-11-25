; English forum: http://purebasic.myforums.net/viewtopic.php?t=6122&highlight=
; Author: Danilo
; Date: 11. May 2003
; 
; by Danilo, 31.01.2003 
; 
Procedure.s ExePath() 
  ExePath$ = Space(1000) 
  GetModuleFileName_(0,@ExePath$,1000) 
  ProcedureReturn GetPathPart(ExePath$) 
EndProcedure 

MessageRequester("",ExePath(),0) 
; ExecutableFormat=Windows
; EOF

; ExecutableFormat=Windows
; EOF