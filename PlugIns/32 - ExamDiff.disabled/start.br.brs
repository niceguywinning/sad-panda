library env$('pandaPath')&'\BambooForest.br': fnStatus
fnStatus('calling ExamDiff Pro to show diff')
exe 'sy ""'&env$('exe-examDiff')&'" '&env$('name')&' "'&env$('pandaSourceFile')&'"'