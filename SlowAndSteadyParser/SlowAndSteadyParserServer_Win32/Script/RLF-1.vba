'//////// �������ɽű� For RLF /////////
'//////// Ver 2.0             /////////
'===== Scirpt Start ======
Dim Name As String

Dim cn As OleDbConnection
Dim cmd As OleDbCommand
Dim dr As OleDbDataReader

Try
	cn = New OleDbConnection("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=RLF.MDB;")
	cn.Open()
	cmd = New OleDbCommand("SELECT TOP 1 * FROM [Person] WHERE [isused] = 0", cn)
	dr = cmd.ExecuteReader
	If dr.Read() Then
		Name = dr.Item("name")
		Task.URL = dr.Item("url")
		'���¸�������		
		cmd = New OleDbCommand("UPDATE [person] SET [IsUsed]=1,[lasttime]=Now() WHERE [name] = '"+Name+"'", cn)
		cmd.ExecuteNonQuery()
	Else
		'û�п��õ�seed,��Ǹ�����ʧ��,����ִ�к�������
		Task.TaskFail()
	End If
Catch ex As Exception
	Throw ex
Finally
	If Not(dr Is Nothing) Then
		dr.Close()
	End If
	cn.Close()
End Try

If Not Name Is Nothing Then
	'��������Ϣ����Task��
	Task.SetHashValue("Name", Name)
End If
'===== Scirpt End ======