on erorr goto ErrorHandler
library env$('pandaPath')&'\BambooForest.br': fnAddOneC,fnAddOneN,fnGetHandle,fnGetPp,fnOpenInAndOut,fnCloseInAndOut,fnStatusClose,fnStatus,fnHasInitialScan,fnStatusPause,fnhas,fnReadFileIntoArray
pr ' in plugin: Include '
pr "  fnHas('[lineStartsWith]'&env$('keyword-include'))  returns  "&str$(fnHas('[lineStartsWith]'&env$('keyword-include')))
! if fnHas('[lineStartsWith]'&env$('keyword-include')) t
  fn_applyInclude(env$('pandaSourceFile')) ! process any include: [filename] lines (returns same file passed)
! en if
en
 
en
def fn_applyInclude(fileName$*256)
	! env$('path-include') - if the (include:) file included can't be found the include routine will attempt to prepend( append this to the beginning of) the parsed filename and try again.
	! skipNextOne - means the prior one ended with an (exclamation mark)(colon)
	includedFileCount=0
	do
		imbededincludeCount=0
		fnOpenInAndOut(fileName$,hIn,hOut, 'applyInclude')
		! pau
		dim line$*4000
		do
			lin #hIn: line$ eof EoAiIn
			if trim$(lwrc$(line$(1:len(env$('keyword-include')))))=trim$(lwrc$(env$('keyword-include'))) t
				includedFileCount+=1
				if pos(line$,'!')>0 t line$(pos(line$,'!'):len(line$))='' ! strip any comment off the end
				line$=trim$(line$)
				line$(1:len(env$('keyword-include')))='' ! remove the env$('keyword-include')( i.e. include:) from the beginning
				line$=trim$(line$)  ! remove any spaces between the include: and the filename
				dim includeFile$*256
				includeFile$=line$
				pr #hOut: '! r: programatically included region : '&includeFile$
				if ~exists(includeFile$) and exists(env$('path-include')&includeFile$&env$('ext-include')) t
					includeFile$=env$('path-include')&includeFile$&env$('ext-include')
				else if ~exists(includeFile$) and exists(env$('path-include')&includeFile$) t
					includeFile$=env$('path-include')&includeFile$
				else
					fnStatus('EXCEPTION: could not find to include for: '&line$)
					fnStatus('  try 1: '&env$('path-include')&includeFile$&env$('ext-include'))
					fnStatus('  try 2: '&env$('path-include')&includeFile$)
					fnStatus('  try 3: '&env$('path-include'))
					fnStatusPause
				en if
				! r: include a file
				fnStatus('  including '&includeFile$)
				ope #hInclude:=fnGetHandle: "name="&includeFile$,d,i
				aiDoIncludeThisLine=1
				do
					lin #hInclude: line$ eof EoAiInclude
					if srep$(srep$(lwrc$(line$),' ',''),tab$,'')(1:15)='!r:donotinclude' t
						aiDoIncludeThisLine=0
						do
							lin #hInclude: line$ eof EoAiInclude
						loop until srep$(srep$(lwrc$(line$),' ',''),tab$,'')(1:15)='!/rdonotinclude'
						lin #hInclude: line$ eof EoAiInclude
					en if
					if trim$(lwrc$(line$))(1:len(env$('keyword-include')))=lwrc$(env$('keyword-include')) t
						imbededIncludeCount+=1
					en if
					pr #hOut: line$
				loop
				EoAiInclude: !
				cl #hInclude:
				pr #hOut: '! /r programatically included region : '&includeFile$
				! /r
			else
				pr #hOut: line$
			en if
		loop
		EoAiIn: !
		cl #hOut:
		cl #hIn,free:
	loop while imbededIncludeCount
	fnStatus('Included '&str$(includedFileCount)&' code snippet(s).')
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
