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
Web.Navigate("http://www.aibang.com")
Web.NavigateDelay(Task.URL, 16000)

'ѭ�����п���ҳ��
Do
	'����Ƿ񵯳���֤��/Ban IP
	If Web.Title = "������������-��ʾ" Then
		Task.TaskRestartADSL()
		Return
	End If
	
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
			Web.NavigateDelay(NewURL, 16000)
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
