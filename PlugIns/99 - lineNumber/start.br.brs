on erorr goto ErrorHandler
library env$('pandaPath')&'\BambooForest.br': fnAddOneC,fnAddOneN,fnGetHandle,fnGetPp,fnOpenInAndOut,fnCloseInAndOut,fnStatusClose,fnStatus,fnHasInitialScan,fnStatusPause,fnhas,fnReadFileIntoArray
fnStatus('adding line numbers')
fn_applyLineNumber(env$('pandaSourceFile')) ! process any include: [filename] lines (returns same file passed)
en

def fn_applyLineNumber(fileName$*256; ___,line$*800,hIn,hOut,lineCount)
	fnOpenInAndOut(fileName$,hIn,hOut, 'lineNumber')
	exclamationColon$=chr$(ord('!'))&':' ! chr$(ord('!')) evaluates to an exclamation mark, but prevents a compile issue with the exclamation mark colon not doing what it normally does.
	do
		lin #hIn: line$ eof AanEoF
		line$=rtrm$(line$)
		if line$='' t
			lineCount+=1
		else
			lineNumber=0
			lineNumber=val(line$(1:5)) conv ignore
			if lineNumber>0 t
				line$=cnvrt$("pic(#####)",lineNumber)&' '&line$(7:inf)
				if lineCount<lineNumber then lineCount=lineNumber
			else
				if continuingAfterExcCol t
					line$='      '&line$
					continuingAfterExcCol=0
				else
					line$=cnvrt$("pic(#####)",lineCount+=1)&' '&line$
				en if
			en if
			if line$(len(line$)-1:inf)=exclamationColon$ t
				continuingAfterExcCol=1
			en if
			pr #hOut: line$
		en if
	loop
	AanEoF: !
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
