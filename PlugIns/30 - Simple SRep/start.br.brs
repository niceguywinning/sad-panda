on erorr goto ErrorHandler
library env$('pandaPath')&'\BambooForest.br': fnOpenInAndOut,fnCloseInAndOut
library env$('pandaPath')&'\BambooForest.br': fnStatus,fnAddOneC,fnGetSetting$,fnHas
library env$('pandaPath')&'\BambooForest.br': fnReadFileIntoArray
if ~srepSetup then
	srepSetup=1
	tab$=chr$(9)
	dim srLine$(0)*1024
	dim srepFrom$(0)*512
	dim srepTo$(0)*512
	srepCount=0
	mat srepFrom$(0)
	mat srepTo$(0)
	fnReadFileIntoArray(program$(1:pos(program$,'\',-1))&'srepList.txt',mat srLine$)
	for srLine=1 to udim(mat srLine$)
		if trim$(srline$(srLine))<>'' and trim$(srline$(srLine))(1:1)<>'!' then
			posTab=pos(srLine$(srLine),tab$)
			fnAddOneC(mat srepFrom$,trim$(trim$(srLine$(srLine)(1:posTab-1)),"'"))
			fnAddOneC(mat srepTo$,trim$(trim$(srLine$(srLine)(posTab+1:inf)),"'"))
		end if
	nex srLine
end if

fnStatus('Applying SRep(s)')

fn_applySrep(env$('pandaSourceFile'),mat srepFrom$,mat srepTo$)
en

def fn_applySrep(fileName$*256,mat srepFrom$,mat srepTo$; ___,hIn,hOut,line$*800) !  currently a good example
	fnOpenInAndOut(fileName$,hIn,hOut, 'applyTab')
	do
		lin #hIn: line$ eof AtEoF
		for srepItem=1 to udim(mat srepFrom$)
			line$=srep$(line$,srepFrom$(srepItem),srepTo$(srepItem))
		nex srepItem
		pr #hOut: line$
	loop
	AtEoF: !
	fnCloseInAndOut(hIn,hOut)
fn
ErrorHandler: ! r:
	! exec 'list -'&str$(line)
	pr bell;'~o~   ~o~   ~o~   ~o~   ~o~   ~o~   ~o~   ~o~   Error   ~o~   ~o~   ~o~   ~o~   ~o~   ~o~   ~o~   ~o~'
	exe 'st st'
	pr '        program: '&program$
	pr '      variable$: '&variable$
	pr '          error: '&str$(err)
	pr '          line: '&str$(line)
	exec 'list '&str$(line)
	pr bell;'~o~   ~o~   ~o~   ~o~   ~o~   ~o~   ~o~   ~o~   o-_-o   ~o~   ~o~   ~o~   ~o~   ~o~   ~o~   ~o~   ~o~'
	pau
retry ! /r
