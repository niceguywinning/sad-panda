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
			line$=fn_srepExcludeStringLiterals$(line$,srepFrom$(srepItem),srepTo$(srepItem))
			! line$=srep$(line$,srepFrom$(srepItem),srepTo$(srepItem))
		nex srepItem
		pr #hOut: line$
	loop
	AtEoF: !
	fnCloseInAndOut(hIn,hOut)
fn
def fn_srepExcludeStringLiterals$*1024(in$*1024,srepFrom$,srepTo$; ___,return$*1024,x,map$*1024,posI,inLen)
	inLen=len(in$)
	map$=rpt$(' ',inLen)
	return$=in$
	for x=1 to inLen
		if in$(x:X)='"' and ~inQuoteS then
			! map$(x:x)='x' ! '"'
			if inQuoteD=0 then
				inQuoteD=1
			else if ~inQuoteS then
				inQuoteD=0
				closeingQuoteD=1
			end if
		else if in$(x:x)="'" and ~inQuoteD then
			! map$(x:x)='x' ! '"'
			if inQuoteS=0 then
				inQuoteS=1
			else if ~inQuoteD then
				inQuoteS=0
				closeingQuoteS=1
			end if
		end if
		if inQuoteD or closeingQuoteD then
			map$(x:x)='x' ! '"'
			closeingQuoteD=0
		else if inQuoteS or closeingQuoteS then
			map$(x:x)='x' ! "'"
			closeingQuoteS=0
		else 
			map$(x:x)='_'
		end if
	nex x
	posI=0
	posI=srch(map$,'_',posI)
	do while posI<=inLen and posI>0
		posI=pos(map$,'_',posI+1) ! find next replaceable character
		posX=pos(map$,'x',posI+1) ! find next end of replaceable characters
		if posX>0 then posX-=1 else posX=inLen
		return$(posI:posX)=srep$(in$(posI:posX),srepFrom$,srepTo$)
	loop
	fn_srepExcludeStringLiterals$=return$
fnend
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
