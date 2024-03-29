/*
	google検索ヒット数取得プログラム
	
*/

#include "hspinet.as"
#module
#defcfunc getGSearchNum str word
*start
	netinit@
	;if stat : logmes "ネット接続できません。\n再試行します" : goto *start
	if stat : mes "ネット接続できません。\n再試行します" : goto *start

	//URLを指定	
	neturl@ "https://www.google.com/"

	//検索内容
	/*
	word 	= "github"
	bYear 	= str(2020)
	bMonth 	= str(10)
	bDay 	= str(24)
	aYear	= str(2015)
	aMonth	= str(5)
	aDay	= str(3)
*/
	reqStr = "search?hl=ja&source=hp&q=" + word
	;if(bYear != 0) : reqStr += "+before:" + bYear + "-" + bMonth + "-" + bDay
	;if(aYear != 0) : reqStr += "+after:" + aYear + "-" + aMonth + "-" + aDay

	//ヘッダでユーザーエージェントを設定
	;header = "User-Agent:Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36"
	header = "User-Agent:Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36 Edg/103.0.1264.62"
	netheader@ header

	//GET形式でCGIにパラメーターを渡す
	netrequest_get@ reqStr
	;netrequest@ reqStr

/*	mes "DOWNLOAD 開始"
	mes "URL = https://www.google.com/search?hl=ja&source=hp&q=" + word + "+before:" + bYear + "-" + bMonth + "-" + bDay + "+after:" + aYear + "-" + aMonth + "-" + aDay
	mes "検索内容: " + word + " before:" + bYear + "-" + bMonth + "-" + bDay + " after:" + aYear + "-" + aMonth + "-" + aDay
	mes "検索内容: " + reqStr
*/

*main
	//結果待ちのためのループ
	netexec@ res
	if res > 0 : goto *comp
	if res < 0 : goto *bad
	await 50
	goto *main

*bad
	//エラー
	neterror@ estr
	;logmes "ERROR "+estr + "再試行します"
	mes "ERROR "+estr + "再試行します"
	goto *start
	stop

*comp
	//完了
	//mes "DOWNLOAD 完了"

	//htmlファイルの取得
	netgetv@ buf
	nkfcnv@ buf, buf,,strlen(buf), strlen(buf)

	mes "https://www.google.com/" + reqStr
	mesbox buf,640,400,1
	//件数の部分(id="result-stats")から情報を取得、数値へ変換
	tmp = instr(buf, 0, "id=\"result-stats\">")
	if(tmp == -1) {
		stop
		dialog "googleからbotの疑いが出ました\n" + gettime(4) + ":" + gettime(5) + ":" + gettime(6) + "\n再試行します", 1
		if(stat == 1) : goto *start
	}
	indx = tmp + strlen("id=\"result-stats\">約 ")
	endIndx = instr(buf, 0, "件<nobr>")
	hoge =  strmid(buf, indx, endIndx - indx)	
	strrep hoge, ",", ""
	;dialog hoge + "件"

	return int(hoge)

#defcfunc getGSearchNumWPeriod str word, int bYear, int bMonth, int bDay, int aYear, int aMonth, int aDay
	tmp = word
	if(bYear != 0) : tmp += "+before:" + bYear + "-" + bMonth + "-" + bDay
	if(aYear != 0) : tmp += "+after:" + aYear + "-" + aMonth + "-" + aDay
	return getGSearchNum(tmp)

#global

//print getGSearchNumWPeriod("github", 0,0,0,0,0,0)