'//////// ���ݽ����ű� For Aibang /////////
'//////// Ver 2.1            /////////
'===== Scirpt Start ======
Dim AibangURL As String
Dim Name As String
Dim Phone As String
Dim Address As String
Dim WWW As String
Dim NewURL As String
Dim Count As Integer
Dim IsNextPage As Boolean
Dim Data As New NameValueCollection
Dim Datalist As New List(Of NameValueCollection)
Dim AibangIdParser As NameValueCollection
Dim AibangId As String

Web.Silent = True
Web.DownloadImages = False
Web.RunActiveX = False
Web.DownloadScripts = False
'Web.SetCacheCookie("www.aibang.com", "", "fid=--1230663263--116701419550; city=%E5%8C%97%E4%BA%AC; uls=%E5%8C%97%E4%BA%AC%3A%3A%3A%E8%A5%BF%E5%8D%95%3A%3A%3A%E9%85%92%E5%90%A7%7C%7C%7C%E5%8C%97%E4%BA%AC%3A%3A%3A%3A%3A%3A%E9%85%92%E5%90%A7%7C%7C%7C%E5%8C%97%E4%BA%AC%3A%3A%3A%E8%A5%BF%E5%8D%95%3A%3A%3A%E6%B1%BD%E8%BD%A6%E6%A3%80%E6%B5%8B%E5%9C%BA%7C%7C%7C; recentCR=%E5%8C%97%E4%BA%AC%3A%3A%3A%E8%A5%BF%E5%8D%95%7C%7C%7C%E5%8C%97%E4%BA%AC%3A%3A%3A%E4%B8%9C%E9%95%BF%E5%AE%89%E8%A1%97%7C%7C%7C%E5%8C%97%E4%BA%AC%3A%3A%3ADQ%E5%86%B0%E6%B7%87%E6%B7%8B(%E4%B8%AD%E5%8F%8B%E5%BA%97)%7C%7C%7C; __utma=101383057.338618809904134140.1230663274.1230744270.1230744394.11; __utmz=101383057.1230717664.5.3.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=aibang; __utmb=101383057.21.10.1230744394; hs=6%7E%601956904662-406140670%40%E7%BA%A6%E7%AD%89%E9%B1%BC%7E%601406928202-448141799%40%E6%B0%91%E7%94%9F%E9%93%B6%E8%A1%8C%E5%8C%97%E4%BA%AC%E8%A5%BF%E9%95%BF%E5%AE%89%E8%A1%97%E6%94%AF%E8%A1%8C%7E%60285996242-420541343%40Sixty+Eight%28%E9%95%BF%E5%AE%89%E8%A1%97%E5%BA%97%29%7E%601674528796-1205086818%40%E6%99%A8%E6%9B%A6%E7%99%BE%E8%B4%A7%28%E4%B8%9C%E6%96%B9%E5%B9%BF%E5%9C%BA%E5%BA%97%29%7E%60152892969-419129259%40%E4%B8%89%E6%9F%92%E9%A3%9F%E5%9D%8A%7E%60559311860-431996012%40%E7%BA%A2%E8%8D%B7%E8%BD%A9%E9%85%92%E6%A5%BC%7E%601220313369-421830619%40%E4%B8%AD%E5%8D%8E%E7%A4%BC%E4%BB%AA%E5%8E%85; what=%E9%85%92%E5%90%A7; mid=9; PHPSESSID=a923b583716e2131edbc2c7a9078c63a; __utmc=101383057; addr=%E8%A5%BF%E5%8D%95")
Web.Navigate("http://www.aibang.com")	
Web.NavigateDelay(Task.URL, 15000)	

'ѭ�����п���ҳ��
Do
	'�趨��ǰ��ΧΪ����td����
	Web.ElementPointPushRangeByTagName("td")
	
		'��class = td_topͬʱ����"select_biz"��td����
		While Web.ElementPointMoveNextCondition(Web.ElementSeekClassName("td_top")+Web.ElementSeekInnerHTML("select_biz", false))				
			'�趨�ڲ��α�
			Web.ElementPointPushRangeChildren()
				'�ƶ���<Span>
				Web.ElementPointMoveNext()
				'�趨�ڲ��α�
				Web.ElementPointPushRangeChildren()				
					'�ƶ���<A>(����)
					Web.ElementPointMoveNext()					
					'ȡ�õ���
					Name = Web.ElementPointInnerText
					'ȡ�õ�URL
					AibangURL = Task.ConvertHrefToAbsoluteURL(Web.GetCurrentURL(), Web.ElementPointHref)
					'��AibangURL����ȡAibangId
					AibangIdParser = Task.ConvertURLToQueryString(AibangURL)
					AibangId = AibangIdParser("id")
				'����
				Web.ElementPointPopRange()
			'����
			Web.ElementPointPopRange()
			
			'�ƶ�����һ��td_top
			Web.ElementPointMoveNextCondition(Web.ElementSeekClassName("td_top"))
			'�趨�ڲ��α�
			Web.ElementPointPushRangeChildren()
				'�������
				Phone = ""
				WWW = ""
				Address = ""
				While Web.ElementPointMoveNext()
					'�����Span,��Ϊ�绰����
					If Web.ElementPointTagName = "span" Then
						'�Ƴ����صĵ绰������
						If Not Web.ElementPointRemoveHidden() Then
							Phone = Phone + Web.ElementPointInnerText
						End If
					'����ַ(����)
					ElseIf Web.ElementPointTagName = "a" And Web.ElementPointClassName = "s_www" Then
						WWW = Web.ElementPointInnerText
					End If
					'ɾ����Ϣ���ڲ�Ԫ��
					Web.ElementPointOuterHTML = ""
				End While
			'����
			Web.ElementPointPopRange()
			'ʣ�µ��ǵ�ַ
			Address = Web.ElementPointInnerText
			'������
			Log.Debug("[Name]:"+ Name)
			Data.Add("Name", Name)
			Log.Debug("[PhoneNumber]:"+ Phone)
			Data.Add("Phone", Phone)
			Log.Debug("[Address]:"+ Address)
			Data.Add("Address", Address)
			Log.Debug("[Web]:"+ WWW)
			Data.Add("Web", WWW)
			Log.Debug("[AibangId]:" + AibangId)
			Data.Add("AibangId", AibangId)
			'����������
			Count = Count + 1
			'����ǰPoi���ݴ���datalist����
			Datalist.Add(Data)
			'�趨�µ�Data
			Data = New NameValueCollection()
		End While
	'����
	Web.ElementPointPopRange()
	
	'������һҳ����
	Web.ElementPointPushRangeLinks()
		Web.ElementPointMoveNextCondition(Web.ElementSeekInnerText("��һҳ", true))
		'�����URLת��������URL
		NewURL = Task.ConvertHrefToAbsoluteURL(Web.GetCurrentURL(), Web.ElementPointHref)
		Log.Debug("[New URL!!!]:"+NewURL)
		'���������һҳ����,��ת����ҳ
		If Not Web.ElementPointIsNull() Then
			Web.NavigateDelay(NewURL, 15000)
			IsNextPage = True
		Else
			IsNextPage = False
		End If
	Web.ElementPointPopRange()
'ѭ����û��"��һҳ"�������(˵����ͷ��)
Loop While IsNextPage
Log.Debug("[Count];"+Str(Count))
'��ץȡ�õ����������ݴ���Task
Task.SetHashValue("Count",Count)
Task.SetHashValue("Datalist", Datalist)
'===== Scirpt End ======
