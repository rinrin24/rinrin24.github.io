#include "hsp3cl.as"
#include "getGSearch.as"
#include "unixTime.as"

;print getGSearchNumWPeriod("godhub", 2021, 10, 10, 2020, 10, 10)
;print getGSearchNumWPeriod("github", 2020, 10, 24, 2015, 5, 3)

onerror goto *error

word = ""
i = 0

notesel inputData
noteload "input.txt"
wordNum = notemax
sdim inWord, wordNum, 50
repeat wordNum
	noteget inWord(cnt),cnt
loop
noteunsel

beginYear = 2010
beginMonth = 1
beginDay = 1

endYear = gettime(0)
endMonth = gettime(1)
endDay = gettime(3)

searchCycle = 180//[Day]

beginTime = time2ut(beginYear, beginMonth, beginDay, 0, 0, 0)
endTime = time2ut(endYear, endMonth, endDay, 0, 0, 0)
searchCycle *= 24 * 60 * 60

date = ","

notesel output	
repeat (endTime - beginTime) / searchCycle
	ut2time curYear, curMonth, curDay, curHour, curMin, curSec, beginTime + cnt * searchCycle
	date += "" + curYear + "/" + curMonth + "/" + curDay + ","
loop
;noteadd date
noteload "data.csv" 

repeat 4
	word = inWord(cnt)
	i = cnt
	strrep word, " ", "+"
	strrep word, "Å@", "+"
	strrep word, "(", "%28"
	strrep word, "Åi", "%28"
	strrep word, ")", "%29"
	strrep word, "Åj", "%29"
	;logmes word
	mes word

	date = ""
	data = word + ","

	repeat (endTime - beginTime) / searchCycle
		ut2time curYear, curMonth, curDay, curHour, curMin, curSec, beginTime + cnt * searchCycle
		date += "" + curYear + "/" + curMonth + "/" + curDay + ","
		tmp = getGSearchNumWPeriod(word, curYear, curMonth, curDay, 0, 0, 0)
		data += "" + tmp + ","
		;logmes "" + curYear + "/" + curMonth + "/" + curDay + " : " + tmp
		mes "" + curYear + "/" + curMonth + "/" + curDay + " : " + tmp
		await 5000
	loop
	
	noteadd data
	notesave "data.csv"
loop

await 1000
notesel hoge
noteload "input.txt"
repeat (i - 1)
	notedel cnt
loop
run "searchNumTrans1.as"

//dialog "saved"
stop

*error
	if(word != ""){
		notesel hoge
		noteload "input.txt"
		repeat (i - 1)
			notedel cnt
		loop
	}
	run "searchNumTrans1.as"