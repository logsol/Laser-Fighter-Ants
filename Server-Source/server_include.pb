LoadImage(0,"..\Design\neuf\oben.bmp")
;- Img oben
GrabImage(0, 1, 0, 0, 568, 11)
;- Img unten
GrabImage(0, 2, 0, 27, 568, 3)
;- Img Mitte-links
GrabImage(0, 3, 0, 11, 528, 16)
;- Img Mitte-rechts
GrabImage(0, 4, 559, 11, 9, 16)
;- Img Button-Task
GrabImage(0, 5, 528, 11, 17, 16)
;- Img Button-Close
GrabImage(0, 6, 545, 11, 19, 16)

p.s = "G:\Projekte\Jecedelic Server\Server-Anwendung\"
;p.s = Path()
f_pfad.s = p + "server_interface.swf?codex=35169219TKKGSPHK"
url$ = "about:<html><body "+e_event+" leftmargin='0' topmargin='0' scroll='no'><object><embed src='"+f_pfad+"' menu='false' quality='high' bgcolor='#ffffff' width='568' height='319' name='server_interface' align='middle' allowScriptAccess='sameDomain' type='application/x-shockwave-flash' pluginspage='http://www.macromedia.com/go/getflashplayer'/></object></body></html>"
; ExecutableFormat=Windows
; EOF