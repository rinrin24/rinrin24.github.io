/*
	google�����q�b�g���擾�v���O����
	
*/

#include "hspinet.as"
#module
#defcfunc getGSearchNum str word
*start
	netinit@
	;if stat : logmes "�l�b�g�ڑ��ł��܂���B\n�Ď��s���܂�" : goto *start
	if stat : mes "�l�b�g�ڑ��ł��܂���B\n�Ď��s���܂�" : goto *start

	//URL���w��	
	neturl@ "https://www.google.com/"

	//�������e
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

	//�w�b�_�Ń��[�U�[�G�[�W�F���g��ݒ�
	;header = "User-Agent:Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36"
	header = "User-Agent:Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36 Edg/103.0.1264.62"
	netheader@ header

	//GET�`����CGI�Ƀp�����[�^�[��n��
	netrequest_get@ reqStr
	;netrequest@ reqStr

/*	mes "DOWNLOAD �J�n"
	mes "URL = https://www.google.com/search?hl=ja&source=hp&q=" + word + "+before:" + bYear + "-" + bMonth + "-" + bDay + "+after:" + aYear + "-" + aMonth + "-" + aDay
	mes "�������e: " + word + " before:" + bYear + "-" + bMonth + "-" + bDay + " after:" + aYear + "-" + aMonth + "-" + aDay
	mes "�������e: " + reqStr
*/

*main
	//���ʑ҂��̂��߂̃��[�v
	netexec@ res
	if res > 0 : goto *comp
	if res < 0 : goto *bad
	await 50
	goto *main

*bad
	//�G���[
	neterror@ estr
	;logmes "ERROR "+estr + "�Ď��s���܂�"
	mes "ERROR "+estr + "�Ď��s���܂�"
	goto *start
	stop

*comp
	//����
	//mes "DOWNLOAD ����"

	//html�t�@�C���̎擾
	netgetv@ buf
	nkfcnv@ buf, buf,,strlen(buf), strlen(buf)

	mes "https://www.google.com/" + reqStr
	mesbox buf,640,400,1
	//�����̕���(id="result-stats")��������擾�A���l�֕ϊ�
	tmp = instr(buf, 0, "id=\"result-stats\">")
	if(tmp == -1) {
		stop
		dialog "google����bot�̋^�����o�܂���\n" + gettime(4) + ":" + gettime(5) + ":" + gettime(6) + "\n�Ď��s���܂�", 1
		if(stat == 1) : goto *start
	}
	indx = tmp + strlen("id=\"result-stats\">�� ")
	endIndx = instr(buf, 0, "��<nobr>")
	hoge =  strmid(buf, indx, endIndx - indx)	
	strrep hoge, ",", ""
	;dialog hoge + "��"

	return int(hoge)

#defcfunc getGSearchNumWPeriod str word, int bYear, int bMonth, int bDay, int aYear, int aMonth, int aDay
	tmp = word
	if(bYear != 0) : tmp += "+before:" + bYear + "-" + bMonth + "-" + bDay
	if(aYear != 0) : tmp += "+after:" + aYear + "-" + aMonth + "-" + aDay
	return getGSearchNum(tmp)

#global

//print getGSearchNumWPeriod("github", 0,0,0,0,0,0)