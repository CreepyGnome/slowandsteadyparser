'//////// �������ű� For RLF /////////
'//////// Ver 1            /////////
'===== Scirpt Start ======
Dim Name As String
Dim Person As String
Dim Relationship As String
Dim URL As String
Dim Head As String
Dim HeadDetail As String
Dim Occupation As String
Dim OccupationDetail As String

Dim Relationlist As List(Of NameValueCollection)
Dim Headlist As List(Of NameValueCollection)
Dim Occupationlist As List(Of NameValueCollection)

Dim strsqlcmd As String
Dim cn As OleDbConnection
Dim cmd As OleDbCommand

'��Task��ȡ������
Name = Task.GetHashString("Name")
Relationlist = Task.GetHashValue("Relationlist")
Headlist = Task.GetHashValue("Headlist")
Occupationlist = Task.GetHashValue("Occupationlist")

Try
	'�����ݿ�����
	cn = New OleDbConnection("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=RLF.MDB;")
	cn.Open()
	'��Relationlist��ȡ��ÿһ��Relation
	For Each Relation As NameValueCollection In Relationlist
		'�����ݴ������
		Person = Relation("Person")
		Relationship = Relation("Relationship")
		URL = Relation("URL")
			
		'����person��
		strsqlcmd = "INSERT INTO Person(Name,URL, isused, isfinished, lasttime) VALUES('"+Person+"','"+URL+"',0,0,Now())"
		Try	
			cmd = New OleDbCommand(strsqlcmd, cn)
			cmd.ExecuteNonQuery()
		Catch ex As System.Data.OleDb.OleDbException
			Log.Info("����person�����ظ�ֵ:"+Person)
		Catch ex As Exception
			Log.Error("����person���쳣����:", ex)
		End Try
		
		'����relationship��
		strsqlcmd = "INSERT INTO Relationship(Person1,Person2,Relation) VALUES('"+Name+"','"+Person+"','"+Relationship+"')"
		Try	
			cmd = New OleDbCommand(strsqlcmd, cn)
			cmd.ExecuteNonQuery()
		Catch ex As System.Data.OleDb.OleDbException
			Log.Info("����relationship�����ظ�ֵ:"+Name+"|"+Person)
		Catch ex As Exception
			Log.Error("����relationship���쳣����:", ex)
		End Try
	Next
	
	'��Occupationlist��ȡ��ÿһ��Head
	For Each OccupationData As NameValueCollection In Occupationlist
		'�����ݴ������
		Occupation = OccupationData("Occupation")
		OccupationDetail = OccupationData("OccupationDetail")			
		
		'����head��
		strsqlcmd = "INSERT INTO Occupation(Name,Occupation,Detail) VALUES('"+Name+"','"+Occupation+"','"+OccupationDetail+"')"
		Try	
			cmd = New OleDbCommand(strsqlcmd, cn)
			cmd.ExecuteNonQuery()
		Catch ex As System.Data.OleDb.OleDbException
			Log.Info("����Occupation�����ظ�ֵ:"+Name+"|"+Occupation)
		Catch ex As Exception
			Log.Error("����Occupation���쳣����:", ex)
		End Try
	Next
	
	'��Headlist��ȡ��ÿһ��Head
	For Each HeadData As NameValueCollection In Headlist
		'�����ݴ������
		Head = HeadData("Head")
		HeadDetail = HeadData("HeadDetail")			
		
		'����head��
		strsqlcmd = "INSERT INTO Head(Name,Head,Detail) VALUES('"+Name+"','"+Head+"','"+HeadDetail+"')"
		Try	
			cmd = New OleDbCommand(strsqlcmd, cn)
			cmd.ExecuteNonQuery()
		Catch ex As System.Data.OleDb.OleDbException
			Log.Info("����Head�����ظ�ֵ:"+Name+"|"+Head)
		Catch ex As Exception
			Log.Error("����Head���쳣����:", ex)
		End Try
	Next
		
		
	'����seed����
	Try
		cmd = New OleDbCommand("UPDATE [person] SET [isused]=1,[isfinished]=1, [lasttime]=Now() WHERE [Name] = '"+Name+"'", cn)
		cmd.ExecuteNonQuery()
	Catch ex As Exception
		Log.Error("����seed���쳣:", ex)
	End Try
Catch ex As Exception
	Log.Error("��db����:", ex)
Finally	
	cn.Close()
End Try
'===== Scirpt End ======