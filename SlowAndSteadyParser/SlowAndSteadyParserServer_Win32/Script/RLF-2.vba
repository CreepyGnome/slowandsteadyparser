'//////// ���ݽ����ű� For ������ /////////
'//////// Ver 1            /////////
'===== Scirpt Start ======
Dim Person As String
Dim Relationship As String
Dim URL As String
Dim Head As String
Dim HeadDetail As String
Dim Occupation As String
Dim OccupationDetail As String

Dim RelationData As NameValueCollection
Dim HeadData As NameValueCollection
Dim OccupationData As NameValueCollection
Dim Relationlist As New List(Of NameValueCollection)
Dim Headlist As New List(Of NameValueCollection)
Dim Occupationlist As New List(Of NameValueCollection)

Web.Silent = True
Web.DownloadImages = False
Web.RunActiveX = False
Web.DownloadScripts = False
Web.Navigate(Task.URL)

	'�趨��ǰ��ΧΪall
	Web.ElementPointPushRangeAll()		
		'��tagname = div, class = title-barͬʱ����"��ϵ"��td����
		While Web.ElementPointMoveNextCondition(Web.ElementSeekTagName("div")+Web.ElementSeekClassName("title-bar"))
		
			If Web.ElementPointInnerText = "��ϵ" Then
				Web.ElementPointMoveNext()
				'�趨�ڲ��α�
				Web.ElementPointPushRangeChildren()				
					'�ƶ���<div class=item>
					While Web.ElementPointMoveNextCondition(Web.ElementSeekClassName("item"))
						'�趨�µ�����
						RelationData = New NameValueCollection()
						'�趨�ڲ��α�
						Web.ElementPointPushRangeChildren()				
							'�ƶ���<div class=relationship>
							Web.ElementPointMoveNextCondition(Web.ElementSeekClassName("relationship"))
							'ȡ�ù�ϵ��
							Relationship = Web.ElementPointInnerText
							If Relationship = "" Then
								Relationship = "�޹�ϵ"
							End if
							'�ƶ���<div class=title>
							Web.ElementPointMoveNextCondition(Web.ElementSeekClassName("title"))
							'�趨�ڲ��α�
							Web.ElementPointPushRangeChildren()				
								'�ƶ���<a>
								Web.ElementPointMoveNext()
								'ȡ������
								Person = Web.ElementPointInnerText
								'ȡ����ַ
								URL = Utility.ConvertHrefToAbsoluteURL(Web.GetCurrentURL(), Web.ElementPointHref)
							'����
							Web.ElementPointPopRange()
						'����
						Web.ElementPointPopRange()
						'���������ݴ���RelationData
						RelationData.Add("Person", Person)
						Log.Info("[Person]: "+ Person)
						RelationData.Add("Relationship", Relationship)
						Log.Info("[Relation]: "+ Relationship)
						RelationData.Add("URL", URL)
						Log.Info("[URL]: "+ URL)
						'����List��
						Relationlist.Add(RelationData)
					End While
				'����
				Web.ElementPointPopRange()
			End If
			
			If Web.ElementPointInnerText = "ͷ��" Then
				'�ƶ��� <div class=panel>
				Web.ElementPointMoveNext()
				'�趨�ڲ��α�
				Web.ElementPointPushRangeChildren()				
					'�ƶ���<div class=clip>
					While Web.ElementPointMoveNextCondition(Web.ElementSeekClassName("clip"))						
						'�趨�µ�����
						HeadData = New NameValueCollection()
						'�趨�ڲ��α�
						Web.ElementPointPushRangeChildren()				
							'�ƶ���<div class=btitle>
							Web.ElementPointMoveNextCondition(Web.ElementSeekClassName("btitle"))
							'ȡ��ͷ��
							Head = Web.ElementPointInnerText
							'�ƶ�������
							Web.ElementPointMoveNext()
							'ȡ��ͷ�ξ�������
							HeadDetail = Web.ElementPointInnerText
						'����
						Web.ElementPointPopRange()			
						'��ͷ�����ݴ���HeadData
						HeadData.Add("Head", Head)
						Log.Info("[Head]: "+ Head)
						HeadData.Add("HeadDetail", HeadDetail)
						Log.Info("[HeadDetail]: "+ HeadDetail)
						'����List��
						Headlist.Add(HeadData)
					End While
				'����
				Web.ElementPointPopRange()
			End If
			
			If Web.ElementPointInnerText = "����ְ��" Then
				'�ƶ��� <div class=panel>
				Web.ElementPointMoveNext()
				'�趨�ڲ��α�
				Web.ElementPointPushRangeChildren()				
					'�ƶ���<div class=clip>
					While Web.ElementPointMoveNextCondition(Web.ElementSeekClassName("clip"))						
						'�趨�µ�����
						OccupationData = New NameValueCollection()
						'�趨�ڲ��α�
						Web.ElementPointPushRangeChildren()				
							'�ƶ���<div class=btitle>
							Web.ElementPointMoveNextCondition(Web.ElementSeekClassName("btitle"))
							'ȡ��ͷ��
							Occupation = Web.ElementPointInnerText
							'�ƶ�������
							Web.ElementPointMoveNext()
							'ȡ��ͷ�ξ�������
							OccupationDetail = Web.ElementPointInnerText
						'����
						Web.ElementPointPopRange()			
						'��ͷ�����ݴ���HeadData
						OccupationData.Add("Occupation", Occupation)
						Log.Info("[Occupation]: "+ Occupation)
						OccupationData.Add("OccupationDetail", OccupationDetail)
						Log.Info("[OccupationDetail]: "+ OccupationDetail)
						'����List��
						Occupationlist.Add(OccupationData)
					End While
				'����
				Web.ElementPointPopRange()
			End If
			
		End While
	'����
	Web.ElementPointPopRange()

Task.SetHashValue("Relationlist",Relationlist)
Task.SetHashValue("Headlist", Headlist)
Task.SetHashValue("Occupationlist", Occupationlist)
'===== Scirpt End ======
