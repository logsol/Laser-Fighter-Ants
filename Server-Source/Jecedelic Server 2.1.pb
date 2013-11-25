; --------------------------------------------------------------------------------------------------------------|
;- Include Server-Matrix | Author: T.Schmalenberg | (c)rigthed by Jecedelic Software                            |
; --------------------------------------------------------------------------------------------------------------|
IncludeFile "server_var.pb"
IncludeFile "server_array.pb"
IncludeFile "server_procedure.pb"
IncludeFile "server_include.pb"

Win=OpenWindow(0,W_x,W_y,W_width,W_height, #W_Attributs, "Jecedelic Server "+Version)

; --------------------------------------------------------------------------------------------------------------|
;- Include Server-Interface | Author: T.Schmalenberg | (c)rigthed by Jecedelic Software                         |
; --------------------------------------------------------------------------------------------------------------|
IncludeFile "server_interface.pb"

Repeat
 IncludeFile "window_event.pb"
 IncludeFile "server_event.pb"
ForEver
; ExecutableFormat=Windows
; EnableNT4
; EnableXP
; UseIcon=icon16_xp.ico
; Executable=G:\Projekte\Jecedelic Server\Server-Anwendung\Jecedelic Server 2.1 .exe
; DisableDebugger
; EOF