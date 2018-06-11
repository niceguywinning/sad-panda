on erorr goto ErrorHandler
library env$('pandaPath')&'\BambooForest.br': fnOpenInAndOut,fnCloseInAndOut,fnStatus,fnHas
library env$('pandaPath')&'\BambooForest.br': fnGetHandle
library env$('pandaPath')&'\BambooForest.br': fnStatusPause
tab$=chr$(9)

if fnHas(tab$) t
	if ~settingsSet t
		settingsSet=1
		ope #hSettings:=fnGetHandle: 'name='&program$(1:pos(program$,'\',-1))&'Settings.proc',d,i ioerr SettingsFinis
		dim settingsLine$*800
		do
			lin #hSettings: settingsLine$ eof SettingsEoF
			exe settingsLine$
		loop
		SettingsEoF: !
		cl #hSettings:
		SettingsFinis: !
	en if
	if ~tabSize t 
		pr 'tabSize setting not found'
		pau
		tabSize=2
	en if
	fnStatus('converting tabs to '&str$(tabSize)&' spaces')
	! fnStatusPause
	fn_applyTab(env$('pandaSourceFile'),tabSize) ! process any include: [filename] lines (returns same file passed)
en if
en

def fn_applyTab(fileName$*256,tabSize; ___,hIn,hOut,line$*800) !  currently a good example
	fnOpenInAndOut(fileName$,hIn,hOut, 'applyTab')
	do
		lin #hIn: line$ eof AtEoF
		line$=srep$(line$,tab$,rpt$(' ',tabSize))
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
