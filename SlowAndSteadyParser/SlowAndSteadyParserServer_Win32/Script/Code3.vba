'//////// Ԥ����ű� For Aibang /////////
'//////// Ver 5.0             /////////
Dim s1 As String
Dim s2 As String

s1 = "��ó"
s2 = "����"


Task.URl = "http://www.aibang.com/?area=bizsearch&cmd=bigmap&city=%E5%8C%97%E4%BA%AC&a="
Task.URL = Task.URL + Task.URLUTF8Encoding(s1)
Task.URL = Task.URL + "&q="
Task.URL = Task.URL + Task.URLUTF8Encoding(s2)
Task.URL = Task.URL + "&as=5000&rc=2&apr=0%7C0&frm=in_sc_rank_rst&fd=4"


'//////// ���ݽ����ű� For Aibang /////////
'//////// Ver 7.0             /////////
'//===Script Start===//
Dim Total As String
Dim AibangURL As String
Dim Name As String
Dim Phone As String
Dim Address As String
Dim WWW As String
Dim NewURL As String
Dim Count As Integer

Dim IsNext As Boolean

Web.Silent = True
Web.DownloadImages = False
Web.RunActiveX = False
Web.DownloadScripts = False
Web.Navigate(Task.URL)	

'��һ����ȡ�øùؼ���������POI����

'�趨��ǰ���ҷ�Χ�趨Ϊ����DIV
Web.ElementPointRangeByTagName("div")
	'�ҵ�����������
	Web.ElementPointPushMoveNextCondition(Web.ElementSeekClassName("sort_result"))
	'�趨�ڲ��α�
	Web.ElementPointPushRangeChildren()
		'�����ƶ�3��
		Web.ElementPointMoveNext(3)
		'�õ�ȫ�������������
		Total = Web.ElementPointInnerText
		Log.Debug("[Total]:"+ Total)
	'�����ڲ��α�
	Web.ElementPointPopRange()
'����Body
Web.ElementPointPopRange()

'ѭ��ҳ��
Do
	'�趨��ǰ��ΧΪ����td����
	Web.ElementPointPushRangeByTagName("td")
	'��class = td_top, ͬʱ����"<A class=select_biz"��td����
	While Web.ElementPointMoveNextCondition(Web.ElementSeekClassName("td_top")+Web.ElementSeekInnerHTML("<A class=select_biz", false))			
		'�趨�ڲ��α�
		Web.ElementChildrenPush()
			'�ƶ�������
			Web.ElementPointMoveNextCondition(Web.ElementSeekTagName("a")+Web.ElementSeekClassName("select_biz"))
			'ȡ�õ���
			Name = Web.ElementPointInnerText
			'ȡ�õ�URL
			AibangURL = Task.ConvertToAbsoluteURL(Web.CurrentURL(), Web.ElementPointHref)
		'����
		Web.ElementPointPopRange()
		
		'�ƶ�����һ��td
		Web.ElementPointMoveNextCondition(Web.ElementSeekClassName("td_top"))
		'�趨�ڲ��α�
		Web.ElementChildrenPush()
			'�������
			Phone = ""
			WWW = ""
			Address = ""
			Do
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
			Loop While Web.ElementPointMoveNext()
			'�����ڲ��α�
			Web.ElementChildrenPop()
			'ʣ�µ��ǵ�ַ
			Address = Web.ElementPointInnerText
		'����
		Web.ElementPointPopRange()
		
		'��������Log
		Log.Debug("[Name]:"+ Name)
		Log.Debug("[PhoneNumber]:"+ Phone)
		Log.Debug("[Address]:"+ Address)
		Log.Debug("[Web]:"+ WWW)
		Log.Debug("[AibangURL]:" + AibangURL)
		
		'����������
		Count = Count + 1

	End While
	
	'������һҳ����
	Web.ElementPointPushRangeLinks()
		Web.ElementPointMoveNextCondition(Web.ElementSeekInnerText("��һҳ", true))
		'�����URLת��������URL
		NewURL = Task.ConvertToAbsoluteURL(Web.CurrentURL(), Web.ElementPointHref)
		Log.Debug("[New URL!!!]:"+NewURL)
		'���������һҳ����,��ת����ҳ
		If Not Web.ElementPointIsNull() Then
			Web.Navigate(NewURL)
			IsNext = True
		Else
			IsNext = False
		End If
	Web.ElementPointPopRange()
	
'ѭ����û��"��һҳ"�������(˵����ͷ��)
Loop While IsNext
Log.Debug("[Count];"+Str(Count))
'//===Script End===//






'//////// ���ű� For Aibang /////////
'//////// Ver 5.0             /////////
'<Script>

Dim objConn As New OleDbConnection("Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source=C:\ex\FrmSampl.mdb")

objConn.Open()

Dim objCmd As New OleDbCommand("SELECT * FROM tblOrders", objConn)
Dim objDataReader As OleDbDataReader = objCmd.ExecuteReader

objDataReader.Read()
Console.Write(objDataReader.Item("Customer") & ", " & objDataReader.Item("Employee"))

'</Script>


'<Script>
'5.0 AIbang ��ץȡ����
	
	'ѭ��ץȡ����
	While 
			'ȡ�õ���
			Name = Web.ElementPointInnerText
			'�ƶ�����Ϣ���ⲿ
			Web.ElementPointMoveNextCondition(Web.ElementSeekTagName("td")+Web.ElementSeekClassName("td_top"))
			'�趨�ڲ��α�
			Web.ElementChildrenPush()
			'�������
			Phone = ""
			WWW = ""
			Address = ""
			Do
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
			Loop While Web.ElementPointMoveNext()
			'�����ڲ��α�
			Web.ElementChildrenPop()
			'ʣ�µ��ǵ�ַ
			Address = Web.ElementPointInnerText
			'�����������Դ���
			Log.Debug("[Name]:"+ Name)
			Log.Debug("[PhoneNumber]:"+ Phone)
			Log.Debug("[Address]:"+ Address)
			Log.Debug("[URL]:"+ WWW)
			'����������
			Count = Count + 1
	End While
	'������һҳ����
	Web.ElementPointReset()
	Web.ElementPointMoveNextCondition(Web.ElementSeekTagName("a")+Web.ElementSeekInnerText("��һҳ", true))
	'�����URLת��������URL
	NewURL = Task.ConvertToAbsoluteURL(Web.CurrentURL(), Web.ElementPointHref)
	Log.Debug("[New URL!!!]:"+NewURL)
	'���������һҳ����,��ת����ҳ
	If Not Web.ElementPointIsNull() Then
		Web.Navigate(NewURL)
	End If
'ѭ����û��"��һҳ"�������(˵����ͷ��)
Loop While Not Web.ElementPointIsNull()
Log.Debug("[Count];"+Str(Count))
</Script>