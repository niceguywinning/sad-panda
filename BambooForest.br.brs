00100 def fn_setup
00120   if ~setup t
00140     setup=1
00160     option retain
00200     dim tab$*1,exclamationColon$*2
00220     tab$=chr$(9)
00260     exclamationColon$=chr$(ord('!'))&':' ! chr$(ord('!')) evaluates to an exclamation mark, but prevents a compile issue with the exclamation mark colon not doing what it normally does.
00300     dim hasKey$(0)*128,hasKeyN(0)
00320     m hasKey$(0) : m hasKeyN(0)
00640   en if
00660 fn
00680 def library fnOpenInAndOut(fileName$*256,&hIn,&hOut; tempFileSuffix$*64)
00700   if ~setup t le fn_setup
00720   fnOpenInAndOut=fn_openInAndOut(fileName$,hIn,hOut, tempFileSuffix$)
00740 fn
00760 def fn_openInAndOut(fileName$*256,&hIn,&hOut; tempFileSuffix$*64)
00780   dim aiInFile$*256
00800   if  exists(fileName$) t
00820     if tempFileSuffix$<>'' t tempFileSuffix$(0:0)=' '
00840     aiInFile$=env$('temp')&'\Sad Panda '&filenameNoPathNoExt$&' Session'&session$&tempFileSuffix$&'.brs'
00860     exe 'copy "'&fileName$&'" "'&aiInFile$&'"'
00880     ope #hIn:=fn_gethandle: "name="&aiInFile$,d,i
00900     ope #hOut:=fn_gethandle: "name="&fileName$&", recl=800, replace", display, output
00920   else
00940     pr ' non-existant file passed to fn_openInAndOut.'
00960     pau
00980   en if
01000 fn
01020 def library fnCloseInAndOut(&hIn,&hOut)
01040   if ~setup t le fn_setup
01060   fnCloseInAndOut=fn_closeInAndOut(hIn,hOut)
01080 fn
01100 def fn_closeInAndOut(&hIn,&hOut)
01120   cl #hIn,free:
01140   cl #hOut:
01160 fn
01180 def library fnHas(something$*128)
01200   if ~setup t le fn_setup
01220   fnHas=fn_has(something$)
01240 fn
01260 def fn_has(something$*128)
01280   ! should be setup before first use by fn_hasInitialScan
01300   ! uses local variables: mat hasKey$, mat hasKeyN
01320   hasWhich=srch(mat hasKey$,something$)
01340   if hasWhich>0 t
01360     hasReturn=hasKeyN(hasWhich)
01380   else
01400     hasReturn=0
01420   en if
01440   fn_has=hasReturn
01460 fn
01480 def library fnHasInitialScan(hisFilename$*256)
01500   if ~setup t le fn_setup
01520   fnHasInitialScan=fn_hasInitialScan(hisFilename$)
01540 fn
01560 def fn_hasInitialScan(hisFilename$*256; ___,line$*800,linePrior$*800)
01580   ! find all mat hasKey$ in [hisFilename$] and be prepared to return how many of each their are
01600   ! setup funciton for fn_has
01620   ! default to case insensitive  - implement [caseSensitive] to force case sensitivity.
01640   ! RETURNS LOCAL VARIABLES:   mat lineNumber
01660   m hasKeyN(udim(mat hasKey$))
01680   m lineNumber(0)
01700   ope #hHis:=fn_gethandle: "name="&hisFilename$,d,i
01720   do
01740     lin #hHis: line$ eof HisEoF
01760     ! r: line number checking
01780     tmpLineNumber=val(line$(1:5)) conv ignore
01800     fn_addOneN(mat lineNumber,tmpLineNumber)
01820     if line$<>'' and udim(mat lineNumber)>1 and tmpLineNumber<lineNumber(udim(mat lineNumber)-1) then
01840       linePrior$=trim$(linePrior$)
01860       if linePrior$(len(linePrior$)-1:len(linePrior$))<>exclamationColon$ then
01880         fn_status('line numbers go out of sequence on (counted) line number '&str$(udim(mat lineNumber))&' after (read line number) '&str$(lineNumber(udim(mat lineNumber)-1)))
01890         pr 'line numbers go out of sequence on (counted) line number '&str$(udim(mat lineNumber))&' after (read line number) '&str$(lineNumber(udim(mat lineNumber)-1))
01900         pause ! fn_statusPause
01920       end if
01940     end if
01960     ! /r
01980     for hisKeyItem=1 to udim(mat hasKey$)
02000       ! line$=fn_stripComments$(line$)
02020       dim hisSearchKey$*128
02040       hisSearchKey$=hasKey$(hisKeyItem)
02060       if pos(lwrc$(line$),lwrc$(hisSearchKey$))>0 t
02080         hasKeyN(hisKeyItem)+=1
02100       else if pos(hisSearchKey$,'[')>0 t
02120         if pos(hisSearchKey$,'[lineStartsWith]')>0 t
02140           hisSearchKey$=srep$(hisSearchKey$,'[lineStartsWith]','')
02160           if lwrc$(line$)(1:len(hisSearchKey$))=lwrc$(hisSearchKey$) t
02180             hasKeyN(hisKeyItem)+=1
02200           en if
02220         en if
02240       en if
02260     n hisKeyItem
02280     linePrior$=line$
02300   loop
02320   HisEoF: !
02340   cl #hHis:
02360 fn
02362 def library fnHasKeyAdd(newHasKey$*256)
02364   if ~setup t le fn_setup
02366   fn_addOneC(mat hasKey$,newHasKey$, 1,1)
02368 fn
02380 def library fnStripComments$*800(scLine$*800) ! todo: fn_stripComments$ could be better, probably good enough for what it is currently used for
02382   if ~setup t le fn_setup
02384   fnStripComments$=fn_stripComments$(scLine$)
02386 fn
02390 def fn_stripComments$*800(scLine$*800) ! todo: fn_stripComments$ could be better, probably good enough for what it is currently used for
02400   ! this function is rough at best
02420   !    needs enhancment to handle ! inside quotes
02440   !    needs enhancment to handle exclamationColon$
02460   ! who cares it doesn't matter !  scLine$=srep$(scLine$,exclamationColon$,'') ! justbecause it'd cause a false negative
02480   posExc=pos(scLine$,'!')
02500   if posExc>0 t
02520     scLine$=scLine$(1:posExc-1)
02540   en if
02560   fn_stripComments$=scLine$
02580 fn
02582 def library fnReadFileIntoArray(rfaFile$*256,mat rfaLine$)
02584   if ~setup t le fn_setup
02586   fnReadFileIntoArray=fn_readFileIntoArray(rfaFile$,mat rfaLine$)
02588 fn
02600 def fn_readFileIntoArray(rfaFile$*256,mat rfaLine$)
02640   mat rfaLine$(0)
02660   dim rfaLine$*800
02680   if exists(rfaFile$) t
02700     ope #hRfaFile:=fn_gethandle: 'name='&rfaFile$,d,i
02720     do
02740       lin #hRfaFile: rfaLine$ eof RfaEoF
02760       fn_addOneC(mat rfaLine$,rfaLine$)
02780     loop
02800     RfaEoF: !
02820     cl #hRfaFile:
02840   en if
02860   fn_readFileIntoArray=udim(mat rfaLine$)
02880 fn

02900 def library fnBackgroundPicture$*256
02920   if ~setup t le fn_setup
02940   fnBackgroundPicture$=fn_BackgroundPicture$
02960 fn
02980 def fn_BackgroundPicture$*256
03000   fn_BackgroundPicture$=srep$(env$('background_picture'),'[pandaPath]',env$('pandaPath'))
03020 fn
03040 def library fnWriteProc(procName$*64,procLine$*256) ! from C:\ACS\Dev-5\Core\Start.br.brs
03060   if ~setup t le fn_setup
03080   dim procNameHold$*64
03100   if procName$='' t ! append last one
03120     ope #hEd:=fn_gethandle: 'name='&procNameHold$&',use',d,o
03140   else
03160     procNameHold$=procName$
03180     ope #hEd:=fn_gethandle: 'name='&procName$&',replace',d,o
03200   en if
03220   pr #hEd: procLine$
03240   cl #hEd:
03260 fn
03280 def library fnAddOneC(mat add_to$,one$*2048; skip_blanks, skip_dupes) ! from C:\ACS\Dev-5\Core\Array.br.brs
03300   if ~setup t le fn_setup
03320   fnAddOneC=fn_addOneC(mat add_to$,one$, skip_blanks,skip_dupes) ! from C:\ACS\Dev-5\Core\Array.br.brs
03340 fn
03360 def fn_addOneC(mat add_to$,one$*2048; skip_blanks,skip_dupes) ! from C:\ACS\Dev-5\Core\Array.br.brs
03380   ! must dim an array to 0 before you can add a first item
03400   !    Mat Add_To$ - the array to add One$ item to
03420   !    One$ - the One$ item to add to Mat Add_To$
03440   !    skip_Blanks - if =1 than only add One$ if Trim$(One$)<>""
03460   !    skip_dupes - if =1 than only add One$ if One$ is not yet in Mat Add_To$
03480   !    This function returns the number of items in the array after any add
03500   if skip_blanks=0 or (skip_blanks and trim$(one$)<>"") t
03520     if skip_dupes=0 or (skip_dupes and srch(mat add_to$,one$)<=0) t
03540       add_to_udim=udim(mat add_to$) : m add_to$(add_to_udim+1) : add_to$(add_to_udim+1)=one$
03560     en if
03580   en if
03600   fn_addOneC=udim(mat add_to$)
03620 fn
03640 def library fnAddOneN(mat add_to,one; skip_zeros,skip_dupes)
03660   if ~setup t le fn_setup
03680   fnAddOneN=fn_addOneN(mat add_to,one, skip_zeros,skip_dupes)
03700 fn
03720 def fn_addOneN(mat add_to,one; skip_zeros,skip_dupes)
03740   ! must dim an array to 0 before you can add a first item
03760   !    Mat Add_To - the array to add One item to
03780   !    One - the One item to add to Mat Add_To
03800   !    skip_Zeros - if =1 than only add One if One<>0
03820   !    skip_dupes - if =1 than only add One if One is not yet in Mat Add_To
03840   !    This function returns the number of items in the array after any add
03860   if skip_zeros=0 or (skip_zeros and one<>0) t
03880     if skip_dupes=0 or (skip_dupes and srch(mat add_to,one)=-1) t
03900       add_to_udim=udim(mat add_to) : m add_to(add_to_udim+1) : add_to(add_to_udim+1)=one
03920     en if
03940   en if
03960   fn_addOneN=udim(mat add_to)
03980 fn
04000 def library fnGetHandle
04020   if ~setup t le fn_setup
04040   fnGetHandle=fn_gethandle
04060 fn
04080 def fn_gethandle ! from C:\ACS\Dev-5\Core\Start.br.brs
04100   hMaybe=189
04120   ghReturn=0
04140   do
04160     if file(hMaybe)<0 and file$(hMaybe)='' t
04180       ghReturn=hMaybe
04200       goto gethandleFINIS
04220     en if
04240     hMaybe-=1
04260   loop until hMaybe=-1
04280   pr 'fn_gethandle found no available file handles, so it is returning -1' : pau
04300   gethandleFINIS: !
04320   fn_gethandle=ghReturn
04340 fn
04360 def library fnApplyTheme(; disableConScreenOpenDflt) ! from C:\ACS\Dev-5\Core\Programs\Preferences.br.brs
04380   min_fontsize_height$='14'                                      ! fnureg_read('Min_FontSize_Height',min_fontsize_height$)
04400   min_fontsize_width$='6'                                        ! fnureg_read('Min_FontSize_Width',min_fontsize_width$)
04420   exe 'config Min_FontSize '&min_fontsize_height$&'x'&min_fontsize_width$
04440   fn_setColor('[screen]','#000000','#E7EDF5')
04460 ! fn_setColor('[screen]','#000000','#E7EDF5')
04480   fn_setColor('[screenHeader]','#000000','#FFFFFF')
04500   fn_setColor('[textBox]','#000000','#FFFFFF')
04520   fn_setColor('[gridHeader]','#000000','#FFFFFF')
04540   fn_setColor('[label]','#000000','#B0C4DE')
04560   fn_setColor('[button]','#000000','#74DF00') ! '#F0F8FF')
04580   fn_setColor('[buttonCancel]','#000000','#CD5C5C')
04600   if ~disableConScreenOpenDflt t
04620     exe 'Config Screen OpenDflt "Rows=35, Cols=115, Picture='&fn_backgroundpicture$&',border=S:[screen],N=[screen]"'
04640   en if
04660 fn
04680 def fn_setColor(attribute$,foregroundDefault$,backgroundDefault$)
04700   foreground$=foregroundDefault$ ! fnureg_read('color.'&attribute$&'.foreground',foreground$) : if foreground$='' t foreground$=foregroundDefault$
04720   background$=backgroundDefault$ ! fnureg_read('color.'&attribute$&'.background',background$) : if background$='' t background$=backgroundDefault$
04740   exe 'Con Attr '&attribute$&' /'&foreground$&':'&background$ error ignore ! pr 'config attribute '&attribute$&' /'&foreground$&':'&background$ : pau
04760 fn
04780 def library fnStatus(text$*512)
04800   if ~setup t le fn_setup
04820   fnStatus=fn_status(text$)
04840 fn
04860 def fn_status(text$*512) ! from C:\ACS\Dev-5\Core\Programs\Update.br.brs
04880   if ~status_initialized or file$(h_status_win)='' t
04900     status_initialized=1
04920     dim headings$(1)*40,widths(1),forms$(1)*40,status_gridspec$*80
04940     ope #h_status_win:=fn_gethandle: 'SRow=20,SCol=15,Rows=10,Cols=80,Border=S,Caption=Status,NoClose',display,output
04960     status_gridspec$='#'&str$(h_status_win)&',1,1,List 10/80'
04980     headings$(1)='Status'
05000     widths(1)=80
05020     forms$(1)='C 512'
05040     pr f status_gridspec$&",headers,[gridHeader]": (mat headings$,mat widths, mat forms$)
05060   en if
05080   if env$('ACSDeveloper')<>'' t
05100     pr f status_gridspec$&",+": text$(1:512)
05120   else
05140     pr f status_gridspec$&",+": text$(1:512) error ignore
05160   en if
05180   !
05200   input fields status_gridspec$&",rowcnt,all,nowait": grid_rows
05220   curfld(1,grid_rows+1)
05240   !
05260 fn
05280 def library fnStatusPause
05300   if ~setup t le fn_setup
05320   fnStatusPause=fn_statusPause
05340 fn
05360 def fn_statusPause
05380   fn_status('Press any key to continue.')
05400   kstat$(1)
05420 fn
05440 def library fnStatusClose
05460   if ~setup t le fn_setup
05480   fnStatusClose=fn_status_close
05500 fn
05520 def fn_status_close
05540   cl #h_status_win: ioerr ignore
05560   h_status_win=0
05580   status_initialized=0
05600 fn
05620 def library fnGetPp(input$*256,&path$,&prog$,&ext$) ! from C:\ACS\Dev-5\Core\Parse\GetPP.br.brs
05640   if ~setup t le fn_setup
05660   fnGetPp=fn_getPp(input$,path$,prog$,ext$)
05680 fn
05700 def fn_getPp(input$*256,&path$,&prog$,&ext$) ! from C:\ACS\Dev-5\Core\Parse\GetPP.br.brs
05720   ! Dim Note: Please Dim you Path$ and Prog$ as long as your Input$
05740   ! Input$: this is what you want parsed...
05760   !         supported formats:  progam/dir
05780   !                             program.ext/dir
05800   !                             dir\program
05820   !                             dir\program.ext
05840   !                             dir\dir\program.ext
05860   ! path$:  the path to the input program (i.e. "S:\acsUB\")
05880   ! prog$:  the file name (without it's extension) (i.e. "ubmenu")
05900   ! ext$:   the input progams extension (period included) (i.e. ".wb")
05920   input$=trim$(input$) : path$=prog$=ext$=""
05940   fslash_pos=pos(input$,"/",1) : bslash_pos=pos(input$,"\",-1)
05960   if fslash_pos>0 t ! front slash parse
05980     prog$=input$(1:fslash_pos-1)
06000     path$=input$(fslash_pos+1:len(input$))
06020   en if
06040   if bslash_pos>0 t
06060     prog$=input$(bslash_pos+1:len(input$))
06080     path$=input$(1:bslash_pos)
06100   en if
06120   if fslash_pos<=0 and bslash_pos<=0 t
06140     prog$=input$(1:len(input$))
06160     path$=""
06180   en if
06200   dot_pos=pos(prog$,".",-1)
06220   if dot_pos>0 t
06240     ext$=prog$(dot_pos:len(prog$))
06260     prog$=prog$(1:dot_pos-1)
06280   en if
06300   path$=trim$(path$)
06320   if path$(len(path$):len(path$))<>"\" t path$=trim$(path$)&"\"
06340 fn
06360 ErrorHandler: ! r:
06380   ! exec 'list -'&str$(line)
06400   pr '***   ***   ***   ***   ***   ***   ***   ***   Error   ***   ***   ***   ***   ***   ***   ***   ***'
06420   exe 'st st'
06440   pr '        program: '&program$
06460   pr '      variable$: '&variable$
06480   pr '          error: '&str$(err)
06500   pr '          line: '&str$(line)
06520   exec 'list '&str$(line)
06540   pr '***   ***   ***   ***   ***   ***   ***   ***   _____   ***   ***   ***   ***   ***   ***   ***   ***'
06560   pau
06580 retry ! /r
07000 def library fnGetSetting$*256(key$*256)
07010   if ~setup t le fn_setup
07020   fnGetSetting$=fn_getSetting$(key$)
07030 fn
07040 def fn_getSetting$*256(key$*256; ___,return$*256)
07050   dim developerSettingsProcLine$(0)*800
07060   fn_readFileIntoArray(env$('pandaPath')&'\Developer Settings.proc',mat developerSettingsProcLine$)
07070   for dsItem=1 to udim(mat developerSettingsProcLine$)
07080     if trim$(developerSettingsProcLine$(dsItem))(1:1)<>'!' and trim$(developerSettingsProcLine$(dsItem))<>'' t
07090       developerSettingsProcLine$(dsItem)=fn_stripComments$(developerSettingsProcLine$(dsItem))
07100       developerSettingsProcLine$(dsItem)=srep$(developerSettingsProcLine$(dsItem),tab$,'')
07110       developerSettingsProcLine$(dsItem)=srep$(developerSettingsProcLine$(dsItem),' ','')
07120       developerSettingsProcLine$(dsItem)=lwrc$(developerSettingsProcLine$(dsItem))
07130       if developerSettingsProcLine$(dsItem)(1:len(key$)+1)=lwrc$(key$)&'=' t
07140         return$=developerSettingsProcLine$(dsItem)(9:inf)
07150       en if
07160     en if
07170   n dsItem
07180   fn_getSetting$=return$
07190 fn
