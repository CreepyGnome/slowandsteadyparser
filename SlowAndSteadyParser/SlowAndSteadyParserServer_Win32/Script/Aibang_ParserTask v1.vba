'//////// ���ݽ����ű� For Aibang /////////
'//////// Ver b1.0            /////////
'===== Scirpt Start ======

Dim Total As String
Dim AibangURL As String
Dim Name As String
Dim Phone As String
Dim Address As String
Dim WWW As String
Dim NewURL As String
Dim Count As Integer
Dim IsNextPage As Boolean

Web.Silent = True
Web.DownloadImages = False
Web.RunActiveX = False
Web.DownloadScripts = False
Web.Navigate(Task.URL)	

'��һ����ȡ�øùؼ���������POI����

'�趨��ǰ���ҷ�Χ�趨Ϊ����DIV
Web.ElementPointPushRangeByTagName("div")
	'�ҵ�����������
	Web.ElementPointMoveNextCondition(Web.ElementSeekClassName("sort_result"))
	'�趨�ڲ��α�
	Web.ElementPointPushRangeChildren()
		'�����ƶ�4��
		Web.ElementPointMoveNext(4)
		'�õ�ȫ�������������
		Total = Web.ElementPointInnerText
		Log.Debug("[Total]:"+ Total)
	'�����ڲ��α�
	Web.ElementPointPopRange()
'����Body
Web.ElementPointPopRange()

'�ڶ���,ѭ�����п���ҳ��
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
					AibangURL = Task.ConvertToAbsoluteURL(Web.GetCurrentURL(), Web.ElementPointHref)
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

			'��������Log
			Log.Debug("[Name]:"+ Name)
			Log.Debug("[PhoneNumber]:"+ Phone)
			Log.Debug("[Address]:"+ Address)
			Log.Debug("[Web]:"+ WWW)
			Log.Debug("[AibangURL]:" + AibangURL)
			'����������
			Count = Count + 1
		End While
	'����
	Web.ElementPointPopRange()
	
	'������һҳ����
	Web.ElementPointPushRangeLinks()
		Web.ElementPointMoveNextCondition(Web.ElementSeekInnerText("��һҳ", true))
		'�����URLת��������URL
		NewURL = Task.ConvertToAbsoluteURL(Web.GetCurrentURL(), Web.ElementPointHref)
		Log.Debug("[New URL!!!]:"+NewURL)
		'���������һҳ����,��ת����ҳ
		If Not Web.ElementPointIsNull() Then
			Web.Navigate(NewURL)
			IsNextPage = True
		Else
			IsNextPage = False
		End If
	Web.ElementPointPopRange()
	
'ѭ����û��"��һҳ"�������(˵����ͷ��)
Loop While IsNextPage
Log.Debug("[Count];"+Str(Count))
'===== Scirpt End ======
