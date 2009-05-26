'//////// �������ɽű� For Aibang /////////
'//////// Ver 2.0             /////////
'===== Scirpt Start ======
Dim City As String
Dim Poi As String
Dim Category As String

Dim cn As OleDbConnection
Dim cmd As OleDbCommand
Dim dr As OleDbDataReader

Try
	cn = New OleDbConnection("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=AibangPOI.MDB;")
	cn.Open()
	cmd = New OleDbCommand("SELECT TOP 1 * FROM [seed] WHERE [isused] = 0", cn)
	dr = cmd.ExecuteReader
	If dr.Read() Then
		City = dr.Item("city")
		Poi = dr.Item("poi")
		Category = dr.Item("category")
		'���¸�������		
		cmd = New OleDbCommand("UPDATE [seed] SET [IsUsed]=1,[lasttime]=Now() WHERE [city] = '"+City+"' AND [Poi] = '"+Poi+"' AND [Category] = '"+Category+"'", cn)
		cmd.ExecuteNonQuery()
	Else
		'û��nonused��seed,����used,ûfinished��seed
		dr.Close()
		cmd = New OleDbCommand("SELECT * FROM [seed] WHERE [isused] = 1 AND [isfinished] = 0 AND DateDiff('d', [lasttime], NOW()) >= 1 ORDER BY [lasttime]", cn)
		dr = cmd.ExecuteReader
		If dr.Read() Then
			City = dr.Item("city")
			Poi = dr.Item("poi")
			Category = dr.Item("category")
			'���¸�������		
			cmd = New OleDbCommand("UPDATE [seed] SET [IsUsed]=1,[lasttime]=Now() WHERE [city] = '"+City+"' AND [Poi] = '"+Poi+"' AND [Category] = '"+Category+"'", cn)
			cmd.ExecuteNonQuery()
		Else
			'û�п��õ�seed,��Ǹ�����ʧ��,����ִ�к�������
			Task.TaskFail()
		End If
	End If
Catch ex As Exception
	'Log.Error("DatabaseError in Aibang Beforetask",ex)
	Throw ex
Finally
	dr.Close()
	cn.Close()
End Try

If Not City Is Nothing Then
	'��������Ϣ����Task��
	Task.SetHashValue("City", City)
	Task.SetHashValue("Poi", Poi)
	Task.SetHashValue("Category", Category)
	'��������URL
	Task.URl = "http://www.aibang.com/?area=bizsearch&cmd=bigmap&city=" + Utility.UnicodeToUTF8(City)
	Task.URL = Task.URL + "&a=" + Utility.UnicodeToUTF8(Poi) + "&q=" + Utility.UnicodeToUTF8(Category)
	Task.URL = Task.URL + "&as=5000&rc=2&frm=in_sc_rank_rst"
End If
'===== Scirpt End ======