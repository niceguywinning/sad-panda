00001 ! exe 'lo "'&program$(1:pos(program$,'.')-1)&'.br"'
00002 ! execute 'config editor "c:\program files\notepad++\notepad++.exe"'
00003 ! ed ~                     
00004 ! ** Please do not remove line numbers nor used syntax that requires a pre-compilier in this program. **
00010 dim pandaPath$*256
00020 pandaPath$=program$(1:pos(program$,'\',-1)-1) ! pandaPath$=env$('cmd_home')(without a trailing backslash
00240 execute 'con sub [pandaPath] '&pandaPath$
00242 setenv('pandaPath',pandaPath$)
00250 if env$('returningFromPlugInProc')='' t exe 'loa "'&env$('pandaPath')&'\BambooForest.br",Resident'
00260 library env$('pandaPath')&'\BambooForest.br': fnAddOneC,fnAddOneN,fnGetHandle,fnGetPp,fnOpenInAndOut,fnCloseInAndOut,fnStatusClose,fnStatus,fnHasInitialScan,fnStatusPause,fnhas,fnReadFileIntoArray,fnBackgroundPicture$,fnWriteProc,fnHasKeyAdd
02000 ! r: basic tests on file specified (in env$('name')) to confirm the program will work properly
02020 dim orgSourceFile$*256            ! full name (without quotes) of the program source file we are compiling.
02040 orgSourceFile$=trim$(env$('name'),'"')
03600 if orgSourceFile$='' t
03620   pr 'This program requires env$("name") be set to the source code to compile.'
03640   pr 'Your env$("name") is blank.  Program stopping.'
03660   en
03680 else if orgSourceFile$(1:len(program$))=program$ t
03700   pr 'If you try to use this program to compile itself, you''re probably not gonna have a good time.'
03720   pr 'Program stopping.'
03740   en
03760 else if ~exists(orgSourceFile$) t
03780   pr 'It appears the file you are trying to compile does not exist.'
03800   pr 'Program stopping.'
03820   en
03840 en if
03860 ! /r
03870 on err got ErrorHandler
03880 setenv('icon',env$('pandaPath')&'\asset\sadPanda32.ico')
04000 ! r: Defaults to be overriden by subproc Developer Settings.proc
04020   setenv('background_picture','[pandaPath]\wallpaper\52H.jpg') ! 52H or 39H ! [pandaPath] only works in env$('background_picture') and it just gets replaced with pandaPath$ after pandaPath$ is set.  (smoke and mirrors)  This is done so that this developer prefernce region can be set at the top of the logic flow
04060   setEnv('path-include','C:\ACS\Dev-5\^resource\')
04080   setEnv('ext-include','.brs')
04100   setenv('keyword-include','include:')
04160   setenv('exe-examDiff','C:\Program Files\ExamDiff Pro\ExamDiff.exe')
04200   ! r: CD %temp%
04220   ! by default we're in a vareity of different places depending upon how the Compile.cmd was called.  Temp is, at least, writable.   This isn't necessary, all paths are fully qualified but I leave some procs there that make my life easier. -John
04240   if env$('temp')(2:2)=':' t
04260     exe 'CD '&env$('temp')(1:2)
04280     exe 'CD '&env$('temp')(3:len(env$('temp')))
04300   en if
04320   ! /r
04340 ! /r
09000 ! r: constants
09001 dim tab$*1
09002 tab$=chr$(9)
09004 dim cap$*128
09006 cap$='Sad Panda Compiler'
09009 dim exclamationColon$*2
09010 exclamationColon$=chr$(ord('!'))&':' ! chr$(ord('!')) evaluates to an exclamation mark, but prevents a compile issue with the exclamation mark colon not doing what it normally does.
09090 !/r
10000 ! r: prepare local variables
10030 dim folder$*256              ! path of program source file we are compiling
10040 dim filenameNoPathNoExt$*256 ! base name (no path, no extension) - note that files like 'c:\sample.br.brs ' would be 'sample.br' while 'd:\example.wbs' would be 'example'
10050 dim filenameExt$*64
10060 fnGetPp(orgSourceFile$,folder$,filenameNoPathNoExt$,filenameExt$)
10070 dim tmpSourceFile$*256
10080 tmpSourceFile$=env$('temp')&'\Sad Panda '&filenameNoPathNoExt$&' session'&session$&'.brs'
10082 setenv('pandaSourceFile',tmpSourceFile$)
10090 dim outCompileFile$*256
10092 posLastSlash=pos(orgSourceFile$,'\',-1)
10100 outCompileFile$=orgSourceFile$(1:pos(orgSourceFile$,'.',posLastSlash)-1) ! this looks for the first . in a program name and strips everything after that off to get the name without the extensions .br.brs .brs .wb.wbs and .wbs this method may be overkill if there are program names with any other periods in them
10110 if pos(orgSourceFile$,'.wbs')>0 t
10120   outCompileFile$(inf:inf)='.wb'
10130 else
10140   outCompileFile$(inf:inf)='.br'
10150 en if
10160 ! /r
10170 ! r: read Developer Settings
10180 ! r: initialize arrays built in Developer Settings.proc
10190   dim simpleSrepFrom$(0)*256
10200   dim simpleSrepTo$(0)*256
10230 ! /r
10240   dim developerSettingsFilename$*256
10250   developerSettingsFilename$=pandaPath$&'\Developer Settings.proc'
10260     dim developerSettingsProcLine$(0)*800
10270   if exists(developerSettingsFilename$) t
10280     exe 'subproc '&developerSettingsFilename$
10290     fnReadFileIntoArray(developerSettingsFilename$,mat developerSettingsProcLine$)
10300   en if
10310 ! /r
10320 if env$('returningFromPlugInProc')='True' t
10330   setenv('returningFromPlugInProc','')
10340   ! pr 'doing returningFromPlugInProc magic' : pau
10350   got AfterRunPlugIns
10360 en if
11800 ! r: setup screen and display some initial collected data in fnstatus
11900 exe 'con gui on'
11920 fn_apply_theme
11930 ope #0: 'SRow=1,SCol=2,Rows=35,Cols=115,Picture='&fnBackgroundPicture$&',border=S:[screen],N=[screen],Caption='&cap$,display,outIn
11940 
12000 ope #winData:=fnGetHandle: 'SRow=32,SCol=15,Rows=3,Cols=80,border=S:[screen],N=[screen],Caption=Data,NoClose',display,outIn
12020 lc=0 
12040 pr #winData,f str$(lc+=1)&',1,Cr 15,[label]': 'File In:'   : pr #winData,f str$(lc)&',17,50/C 256,[textBox]': orgSourceFile$
12060 pr #winData,f str$(lc+=1)&',1,Cr 15,[label]': 'File temp:' : pr #winData,f str$(lc)&',17,50/C 256,[textBox]': tmpSourceFile$
12080 pr #winData,f str$(lc+=1)&',1,Cr 15,[label]': 'Compile:'   : pr #winData,f str$(lc)&',17,50/C 256,[textBox]': outCompileFile$
12120 fnStatus('          Origional Source:    '&orgSourceFile$ )
12140 fnStatus('   Post Pre-Compile Source:    '&tmpSourceFile$ )
12160 fnStatus('             Final Compile:    '&outCompileFile$)
12180 fnStatus('developer settings processed')
12200 for dsItem=1 to udim(mat developerSettingsProcLine$)
12220   if trim$(developerSettingsProcLine$(dsItem))(1:1)<>'!' and trim$(developerSettingsProcLine$(dsItem))<>'' t
12230     fnStatus(developerSettingsProcLine$(dsItem))
12232   en if
12240 n dsItem
12260 ! fnStatusPause ! pau ! /r
13000 ! r: *** main process ***
13020 fnStatus('Starting Pre-Compile')
13060 exec 'copy "'&orgSourceFile$&'" "'&tmpSourceFile$&'"'
14000 ! r: whole file processes
14030 fnHasKeyAdd(exclamationColon$        )
14040 !
14082 fnHasKeyAdd(tab$           ) 
14084 for simpleSrepItem=1 to udim(mat simpleSrepFrom$)
14086  fnHasKeyAdd(simpleSrepFrom$(simpleSrepItem)) 
14088 n simpleSrepItem
14092 ! fnHasKeyAdd('[ifWithoutThen]'               ) !  add ' then' to the end of lines that have an 'if' but no 'then'
14099 !
14100 fnHasInitialScan(tmpSourceFile$) ! todo: add collections for varialbes and functions, variables-di/dim/init-ed-or-not, add collection for labels and a count of each label's references
14110 ! pau !
14112 if enablePlugIns t le fn_runPlugins(pandaPath$)
14114 AfterRunPlugIns: !
14320 ! fn_applySimpleSrep(tmpSourceFile$,mat simpleSrepFrom$,mat simpleSrepTo$)
14900 ! ! /r
19180 exe '*free "'&env$('runProc')&'" -n' ioerr ignore
19200 ! /r
20000 ! r: make and execute a subproc to do the actual compile and exit BR!
20010 dim tmpProcFile$*256
20020 tmpProcFile$=env$('temp')&'\SadPandaSession'&session$&'.$$$'
20030 fnWriteProc(tmpProcFile$,'Load "'&tmpSourceFile$&'",Source')
20032 fnWriteProc(''          ,'Pr B: "*'&orgSourceFile$&' - Sad Panda"')
20040 if exists(outCompileFile$) t
20050   fnWriteProc(''        ,'Replace "'&outCompileFile$&'"')
20060 else
20070   fnWriteProc(''        ,'Save "'&outCompileFile$&'"')
20080 en if
20090 fnWriteProc(''          ,'free "'&tmpSourceFile$&'"')
20100 fnWriteProc(''          ,'sy')
20102 ! fnStatusClose
20110 exe 'subproc '&tmpProcFile$&''
20120 ! /r
86000 def fn_apply_theme(; disableConScreenOpenDflt) ! from C:\ACS\Dev-5\Core\Programs\Preferences.br.brs
86060   min_fontsize_height$='14'                                      ! fnureg_read('Min_FontSize_Height',min_fontsize_height$)
86080   min_fontsize_width$='6'                                        ! fnureg_read('Min_FontSize_Width',min_fontsize_width$)
86100   exe 'config Min_FontSize '&min_fontsize_height$&'x'&min_fontsize_width$
86160   fn_set_color('[screen]','#000000','#E7EDF5')
86162 ! fn_set_color('[screen]','#000000','#E7EDF5')
86180   fn_set_color('[screenHeader]','#000000','#FFFFFF')
86200   fn_set_color('[textBox]','#000000','#FFFFFF')
86220   fn_set_color('[gridHeader]','#000000','#FFFFFF')
86240   fn_set_color('[label]','#000000','#B0C4DE')
86260   fn_set_color('[button]','#000000','#74DF00') ! '#F0F8FF')
86280   fn_set_color('[buttonCancel]','#000000','#CD5C5C')
86300   if ~disableConScreenOpenDflt t
86320     exe 'Config Screen OpenDflt "Rows=35, Cols=115, Picture='&fnBackgroundPicture$&',border=S:[screen],N=[screen]"'
86340   en if
86360 fn
88000 def fn_set_color(attribute$,foregroundDefault$,backgroundDefault$)
88020   foreground$=foregroundDefault$ ! fnureg_read('color.'&attribute$&'.foreground',foreground$) : if foreground$='' t foreground$=foregroundDefault$
88040   background$=backgroundDefault$ ! fnureg_read('color.'&attribute$&'.background',background$) : if background$='' t background$=backgroundDefault$
88060   exe 'Con Attr '&attribute$&' /'&foreground$&':'&background$ error ignore ! pr 'config attribute '&attribute$&' /'&foreground$&':'&background$ : pau
88080 fn
96000 def fn_runPlugins(pandaPath$*256; ___,dir$*256,hDir,line$*800,plugInProcName$*256,plugInProcCount,plugInProcNameRepeat$*256)
96010   setenv('filename',tmpSourceFile$)
96040   exe 'sy dir /on /ad /b "'&pandaPath$&'\PlugIns\*." >"'&env$('temp')&'\SadPandaDir'&session$&'.txt"'
96060   ope #hDir:=fnGetHandle: 'name='&env$('temp')&'\SadPandaDir'&session$&'.txt',d,i
96100   plugInProcName$=env$('temp')&'\SadPanda_plugInProc'&session$&'.proc'
96120   plugInProcNameRepeat$=plugInProcName$
96140   do
96160     lin #hDir: line$ eof EoDirFile
96180     if exists(pandaPath$&'\PlugIns\'&line$&'\start.br') t
96200       plugInProcCount+=1
96210       fnStatus('detected PlugIn: '&line$)
96220       fnWriteProc(plugInProcNameRepeat$, 'loa "'&pandaPath$&'\PlugIns\'&line$&'\start.br"')
96240       plugInProcNameRepeat$=''
96260       fnWriteProc(plugInProcNameRepeat$, 'ru')
96280     en if
96300   loop
96320   EoDirFile: !
96340   if plugInProcCount>0 t
96341     fnWriteProc(plugInProcNameRepeat$, 'loa "'&program$&'"')
96342     setenv('returningFromPlugInProc','True')
96343     fnWriteProc(plugInProcNameRepeat$, 'ru')
96360     exe 'subproc '&plugInProcName$&''
96380   en if
96390   cl #hDir,free:
96400 fn
98000 ErrorHandler: ! r:
98020   ! exec 'list -'&str$(line)
98030   pr bell;'***   ***   ***   ***   ***   ***   ***   ***   Error   ***   ***   ***   ***   ***   ***   ***   ***'
98032   exe 'st st'
98040   pr '        program: '&program$
98060   pr '      variable$: '&variable$
98080   pr '          error: '&str$(err)
98082   pr '          line: '&str$(line)
98090   exec 'list '&str$(line)
98092   pr bell;'***   ***   ***   ***   ***   ***   ***   ***   o-_-o   ***   ***   ***   ***   ***   ***   ***   ***'
98100   pau
98120 retry ! /r