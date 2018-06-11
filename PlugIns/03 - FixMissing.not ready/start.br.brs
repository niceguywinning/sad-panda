on erorr goto ErrorHandler
fn_applyFixMissing(env$('filename'))
en
def fn_applyFixMissing(fileName$*256; ___,hIn,hOut,line$*800,lineCount)
	! add missing let(s), #s, etc, ((t)hen from lines that have 'if' (but not 'end if') but no '(t)hen'), 
	library env$('pandaPath')&'\LexiLibrary.br': fnOpenInAndOut,fnCloseInAndOut
	! library env$('pandaPath')&'\LexiLibrary.br': fnMaskStringLiterals$
	library env$('pandaPath')&'\LexiLibrary.br': fnStatus,fnStatusPause
	library env$('pandaPath')&'\LexiLibrary.br': fnGetHandle,fnAddOneC,fnAddOneN,fnHas
	fnOpenInAndOut(fileName$,hIn,hOut, 'applyFixMissing')
	fnStatus('fn_applyFixMissing not written yet')
	fnStatusPause
	do
		lin #hIn: line$ eof AfmEof
		lineCount+=1
		! r: line transformation logic
			line$=srep$(line$,'asdfjkl;','~didit~')
		! /r
		pr #hOut: line$
	loop
	AfmEof: !
	fnCloseInAndOut(hIn,hOut)
	pr 'i ran my first plugin !!! ' : pause
fnend
ErrorHandler: ! r:
  ! exec 'list -'&str$(line)
  pr bell;'***   ***   ***   ***   ***   ***   ***   ***   Error   ***   ***   ***   ***   ***   ***   ***   ***'
  exe 'st st'
  pr '        program: '&program$
  pr '      variable$: '&variable$
  pr '          error: '&str$(err)
  pr '          line: '&str$(line)
  exec 'list '&str$(line)
  pr bell;'***   ***   ***   ***   ***   ***   ***   ***   o-_-o   ***   ***   ***   ***   ***   ***   ***   ***'
  pau
retry ! /r