using System;
using System.Diagnostics;
using System.Threading;

namespace SlowAndSteadyParser
{
	/// <summary>
	/// ������VBA�ű��������
	/// </summary>
	/// <remarks>������ʵ����һ��VBA�ű�����Ļ������,
	/// ʹ�����ⲿ���� DelegateHelper �� VBAWindowBase
	/// ʹ�������� Microsoft.VisualBasic.Vsa.dll �� Microsoft.Vsa.dll
	/// </remarks>
	public class VBAEngineBase : Microsoft.VisualBasic.Vsa.VsaEngine , Microsoft.Vsa.IVsaSite, IDisposable
	{
        //Log4net
        private static readonly log4net.ILog log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

		/// <summary>
		/// ��ʼ���ű�����
		/// </summary>
		public VBAEngineBase()
		{
            //��������ĳ�������,�Ա�õ���ͬ�����ռ�
            this.AppName = this.AppName + SlowAndSteadyParser.RandomStr.GetRndStrOnlyFor(8, false, false);
            log.Debug("Engine Start:" + this.AppName);
			this.RootMoniker = this.AppName + "://vba";
			this.Site = this;
			this.RootNamespace = this.AppName + "runtimescript";
			this.GenerateDebugInfo = true;
			this.InitNew();
		}

		#region �����������ô���Ⱥ ****************************************************************

		protected string strMainScriptText = null;
		/// <summary>
		/// ��ģ��Դ�����ַ���
		/// </summary>
		public string MainScriptText
		{
			get{ return strMainScriptText ;}
			set{ strMainScriptText = value;}
		}

		protected bool bolEnable = true;
		/// <summary>
		/// �����Ƿ����
		/// </summary>
		public bool Enable
		{
			get{ return bolEnable;}
			set{ bolEnable = value;}
		}
		protected string strAppName = "vbaenginebase";
		/// <summary>
		/// Ӧ������
		/// </summary>
		public virtual string AppName 
		{
			get{ return strAppName ;}
			set{ strAppName = value;}
		}
		
		/// <summary>
		/// �������õ��ⲿ����DLL�����б�
		/// </summary>
		protected virtual string[] RefrenceDllNames
		{
			get
			{
				return new string[]{
									   "system.dll",
									   "mscorlib.dll",
									   "system.xml.dll",
									   "system.data.dll",
									   "Microsoft.VisualBasic.dll"
								   };
			}
		}

		#endregion

		/// <summary>
		/// ���һ�е�����Ϣ
		/// </summary>
		/// <param name="txt">�ı�����</param>
        //public virtual void DebugPrintLine( string txt )
        //{
        //    System.Console.WriteLine( txt );
        //}
		/// <summary>
		/// ��ʾ������Ϣ��
		/// </summary>
		/// <param name="msg">������Ϣ</param>
        //public virtual void AlertError( string msg )
        //{
        //    System.Windows.Forms.MessageBox.Show( null , msg , "�ű����д���" , System.Windows.Forms.MessageBoxButtons.OK , System.Windows.Forms.MessageBoxIcon.Exclamation );

        //}

        /// <summary>
		/// �����ʱ�Ľű�����ת��Ϊ����ʱ�ű�����
		/// </summary>
		/// <param name="strModuleName">ģ������</param>
		/// <param name="strText">���ʱ�ű�����</param>
		/// <returns>����ʱ�ű�����</returns>
		protected virtual string ToRuntimeScriptText( string strModuleName , string strText )
		{
			return @"Option Strict Off
Imports System
Imports System.Data
Imports System.Data.Oledb
Imports System.Collections
Imports System.Collections.Generic
Imports System.Collections.Specialized
Imports System.Text.RegularExpressions
Imports System.Xml
Imports Microsoft.VisualBasic
Module " + strModuleName 
				+ @"
Sub Main()
" + strText	+ @"
End Sub
End Module";
            
		}

		public static int FixLineNumber( int LineNumber )
		{
			return LineNumber - 12 ;
		}
		/// <summary>
		/// ��������Ӵ���ģ��
		/// </summary>
		/// <param name="ModuleName">ģ������</param>
		/// <param name="SourceCode">Դ����</param>
		/// <returns>�����Ƿ�ɹ�</returns>
		public bool AddSourceCode( string ModuleName , string SourceCode )
		{
			if( HasContent( SourceCode ))
			{
				Microsoft.Vsa.IVsaCodeItem CodeItem = ( Microsoft.Vsa.IVsaCodeItem ) InnerCreateItem( ModuleName , Microsoft.Vsa.VsaItemType.Code , Microsoft.Vsa.VsaItemFlag.None) ;
				CodeItem.SourceText = this.ToRuntimeScriptText( ModuleName , SourceCode );
				return true;
			}
			return false;
		}		
		/// <summary>
		///��ű������������ 
		/// </summary>
		/// <param name="strDllName">����ʹ�õ�DLL�ļ���</param>
		public bool AddRefrence( string strDllName )
		{
			try
			{
                //log.Debug("��ű������������" + strDllName );
				Microsoft.Vsa.IVsaReferenceItem RefItem =  InnerCreateItem( strDllName ,Microsoft.Vsa.VsaItemType.Reference , Microsoft.Vsa.VsaItemFlag.None )  as Microsoft.Vsa.IVsaReferenceItem ;
				RefItem.AssemblyName = strDllName ;
				return true;
			}
			catch(Exception ext)
			{
				log.Debug("��ű������������ " + strDllName + " ����\r\n", ext);
			}
			return false;
		}

		protected Microsoft.Vsa.IVsaItem InnerCreateItem( string vName , Microsoft.Vsa.VsaItemType vType , Microsoft.Vsa.VsaItemFlag vFlag )
		{
			Microsoft.Vsa.IVsaItem item = null ;
			for(int iCount = 0 ; iCount < this.Items.Count ; iCount ++)
			{
				if( this.Items[ iCount ].Name == vName )
				{
					item = this.Items[ iCount ];
					break;
				}
			}
			if( item == null)
				return this.Items.CreateItem( vName , vType , vFlag );
			if( myUnusedItems != null && myUnusedItems.Contains( item ))
				myUnusedItems.Remove( item );
			return item ;
		}
		/// <summary>
		/// �ж�һ���ַ����Ƿ�������
		/// </summary>
		/// <param name="strData">�ַ�������</param>
		/// <returns>���ַ�����Ϊ���Ҵ��ڷǿհ��ַ��򷵻�True ���򷵻�False</returns>
		private bool HasContent( string strData )
		{
			if( strData != null && strData.Length > 0 )
			{
				foreach(char c in strData )
				{
					if( Char.IsWhiteSpace( c ) == false)
						return true;
				}
			}
			return false;
		}// bool HasContent()

		#region ȫ�ֶ��������Ⱥ ****************************************************************

		protected System.Collections.Hashtable myGlobalObjects = new System.Collections.Hashtable();
		/// <summary>
		/// ���ȫ�ֶ���
		/// </summary>
		/// <param name="strName">��������</param>
		/// <param name="obj">��������</param>
		/// <param name="strTypeName">����������������</param>
		public void AddGlobalObject( string strName , object obj , string strTypeName )
		{
			if( strName == null || strName.Trim().Length == 0 )
				throw new System.ArgumentException("�������Ʋ���Ϊ��");

			if( strTypeName == null)
				strTypeName = obj.GetType().FullName;

            if (!myGlobalObjects.ContainsKey(strName))
            {
                AddGlobalItem(strName, strTypeName);
            }

			myGlobalObjects[ strName ] = obj ;
		}

        protected virtual object InnerGetObject(string strName)
        {
            foreach (string strKey in myGlobalObjects.Keys)
            {
                if (string.Compare(strKey, strName, true) == 0)
                {
                    return myGlobalObjects[strKey];
                }
            }
            return null;
        }
		/// <summary>
		/// ��ű����ȫ�ֶ���
		/// </summary>
		/// <param name="strName">ȫ�ֶ��������</param>
		/// <param name="strTypeName">ȫ�ֶ������������</param>
		public void AddGlobalItem( string strName , string strTypeName)
		{
			Microsoft.Vsa.IVsaGlobalItem myGolItem = this.InnerCreateItem( strName,Microsoft.Vsa.VsaItemType.AppGlobal , Microsoft.Vsa.VsaItemFlag.None ) as Microsoft.Vsa.IVsaGlobalItem ;
			myGolItem.TypeString = strTypeName ;
		}

		#endregion

		#region ����,������ֹͣ����Ĵ���Ⱥ *******************************************************
		/// <summary>
		/// δʹ�õ�ģ���б�
		/// </summary>
		protected System.Collections.ArrayList myUnusedItems = null;

		protected virtual void ResetItems()
		{
			// ��ӱ�׼���ÿ�
			string[] dlls = this.RefrenceDllNames;
			foreach( string name in dlls )
				AddRefrence( name );
			if( HasContent( this.strMainScriptText ) )
				this.AddSourceCode("MainModule" , this.strMainScriptText );
		}

		/// <summary>
		/// ɾ������δʹ�õ���Ŀ
		/// </summary>
		protected void RemoveUnusedItem()
		{
			if( myUnusedItems != null && myUnusedItems.Count > 0 )
			{
				foreach( object obj in myUnusedItems )
				{
					for(int iCount = this.Items.Count -1 ; iCount >= 0 ; iCount --)
					{
						if( this.Items[ iCount ] == obj )
						{
							this.Items.Remove( iCount );
							break;
						}
					}
				}
			}
		}
		/// <summary>
		/// ׼��������¼�
		/// </summary>
		public event System.EventHandler BeforeCompile = null;
		/// <summary>
		/// ׼������,�����ظ÷��������ýű������ȫ�ֶ���
		/// </summary>
		/// <returns>�����Ƿ�ɹ�</returns>
		protected virtual bool OnBeforeCompile()
		{
			if( BeforeCompile != null )
				BeforeCompile( this , null );
			return true;
		}
		/// <summary>
		/// ��ʼ���нű�
		/// </summary>
		protected virtual void StartRun()
		{
			RefreshMethodList();
		}
		/// <summary>
		/// ���벢�����ű�
		/// </summary>
		/// <returns>�����Ƿ�ɹ�</returns>
		public bool CompileAndRun()
		{
			if( this.bolEnable == false)
			{
				return false;
			}
			this.StopScript(); //�ж����еĽű�!
			myCompilerError = null;
			this.myGlobalObjects.Clear();
			this.ResetItems();
			if( this.OnBeforeCompile())
			{
				if( this.Compile())
				{
					this.Run();
					this.StartRun();
					return true;
				}
			}
			return false;
		}

		/// <summary>
		/// ֹͣ���нű�
		/// </summary>
		public virtual void StopScript()
		{
			if( this.IsRunning )
			{
				this.Reset();
				this.RevokeCache();
			}
		}

        public virtual void RefreshGlobeItem()
        {          
            this.StopScript();
            Thread.Sleep(200);
            this.myGlobalObjects.Clear();
            this.OnBeforeCompile();
            this.Run();
            this.StartRun();
        }

        public override void Close()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

		#endregion

		#region VBA�����б������Ⱥ *************************************************************

		protected System.Collections.ArrayList myVBAMethods = new System.Collections.ArrayList();

		private class VBAScriptMethodItem
		{
			/// <summary>
			/// ģ������
			/// </summary>
			public string ModuleName = null;
			/// <summary>
			/// ��������
			/// </summary>
			public string MethodName = null;
			/// <summary>
			/// ��������
			/// </summary>
			public System.Reflection.MethodInfo MethodObject = null;
			/// <summary>
			/// ��������ֵ
			/// </summary>
			public System.Type ReturnType = null;
			/// <summary>
			/// ָ��÷�����ί��
			/// </summary>
			public System.Delegate MethodDelegate = null;
		}
		/// <summary>
		/// ˢ��VBA�����б�
		/// </summary>
		protected void RefreshMethodList()
		{
			myVBAMethods.Clear();
			System.Reflection.Assembly myAssembly = this.Assembly ;
			foreach( object obj in this.Items )
			{
				if( obj is Microsoft.Vsa.IVsaCodeItem )
				{
					Microsoft.Vsa.IVsaCodeItem CodeItem = ( Microsoft.Vsa.IVsaCodeItem ) obj ;
					System.Type t = myAssembly.GetType( this.RootNamespace + "." + CodeItem.Name );
					System.Reflection.MethodInfo[] ms = t.GetMethods( System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Static );
					foreach( System.Reflection.MethodInfo m in ms )
					{
						VBAScriptMethodItem MethodItem = new VBAScriptMethodItem();
						myVBAMethods.Add( MethodItem );
						MethodItem.ModuleName = CodeItem.Name ;
						MethodItem.MethodName = m.Name ;
						MethodItem.MethodObject = m ;
						MethodItem.ReturnType = m.ReturnType ;
						if( m.GetParameters().Length == 0 )
						{
							System.Type dt = SlowAndSteadyParser.DelegateHelper.GetDelegateType( m.ReturnType );
							if( dt != null)
								MethodItem.MethodDelegate = System.Delegate.CreateDelegate( dt , m );
						}
					}//foreach
				}
			}
		}

		private VBAScriptMethodItem GetMethodItem( string ModuleName , string MethodName )
		{
			if( this.bolEnable == false )
				return null;
			foreach( VBAScriptMethodItem MethodItem in myVBAMethods)
			{
				if( string.Compare( MethodItem.MethodName , MethodName ,true ) == 0 )
				{
					if( ModuleName == null || string.Compare( MethodItem.ModuleName , ModuleName , true ) == 0 )
					{
						return MethodItem ;
					}
				}
			}
			return null;
		}

		/// <summary>
		/// ������ж���ķ���
		/// </summary>
		/// <returns>��������</returns>
		public System.Reflection.MethodInfo[]  GetScriptMethods()
		{
			System.Collections.ArrayList myList = new System.Collections.ArrayList();
			foreach( VBAScriptMethodItem MethodItem in myVBAMethods)
				myList.Add( MethodItem.MethodObject );
			return ( System.Reflection.MethodInfo[]) myList.ToArray( typeof( System.Reflection.MethodInfo ));
		}
		/// <summary>
		/// ���ָ��ģ�������ж���ķ���
		/// </summary>
		/// <param name="ModuleName">ģ������</param>
		/// <returns>��������</returns>
		public System.Reflection.MethodInfo[]  GetScriptMethods( string ModuleName )
		{
			System.Collections.ArrayList myList = new System.Collections.ArrayList();
			foreach( VBAScriptMethodItem MethodItem in myVBAMethods)
			{
				if( string.Compare( MethodItem.ModuleName , ModuleName ) == 0 )
					myList.Add( MethodItem.MethodObject );
			}
			return ( System.Reflection.MethodInfo[]) myList.ToArray( typeof( System.Reflection.MethodInfo ));
		}

		#endregion

		#region ���Һ͵���ָ���ű������ĺ���Ⱥ ****************************************************
		/// <summary>
		/// �ж��Ƿ�����ָ��ģ���ָ�����Ƶķ���,ģ�����ƺͷ������Ʋ����ִ�Сд
		/// </summary>
		/// <param name="ModuleName">ģ������</param>
		/// <param name="MethodName">��������</param>
		/// <returns>�Ƿ�����ָ������</returns>
		public bool HasScriptMethod( string ModuleName , string MethodName )
		{
			return  GetMethodItem( ModuleName , MethodName ) != null;
		}
		/// <summary>
		/// �ж��Ƿ�����ָ�����Ƶķ���,�������Ʋ����ִ�Сд
		/// </summary>
		/// <param name="MethodName">��������</param>
		/// <returns>�Ƿ�����ָ���ķ���</returns>
		public bool HasScriptMethod( string MethodName )
		{
			return GetMethodItem( null , MethodName ) != null;
		}
		/// <summary>
		/// ���ָ��ģ���ָ�����ƵĽű���������,ģ�����ƺͷ������Ʋ����ִ�Сд
		/// </summary>
		/// <param name="ModuleName">ģ������</param>
		/// <param name="MethodName">��������</param>
		/// <returns>�ű���������</returns>
		public System.Reflection.MethodInfo GetScriptMethod( string ModuleName , string MethodName )
		{
			VBAScriptMethodItem MethodItem = GetMethodItem( ModuleName , MethodName );
			if( MethodItem == null)
				return null;
			else
				return MethodItem.MethodObject ;
		}
		/// <summary>
		/// ���ָ�����ƵĽű���������,�������Ʋ����ִ�Сд
		/// </summary>
		/// <param name="MethodName">��������</param>
		/// <returns>�ű���������</returns>
		public System.Reflection.MethodInfo GetScriptMethod( string MethodName )
		{
			VBAScriptMethodItem MethodItem = GetMethodItem( null , MethodName );
			if( MethodItem == null)
				return null;
			else
				return MethodItem.MethodObject ;
		}
		/// <summary>
		/// �޲�����ִ��ָ�����ƵĽű����������ط�������ֵ,�������Ʋ����ִ�Сд
		/// </summary>
		/// <param name="MethodName">��������</param>
		/// <returns>��ִ�гɹ��򷵻ط�������ֵ,���򷵻ؿ�����</returns>
		public object RunScriptMethod( string MethodName )
		{
                VBAScriptMethodItem MethodItem = GetMethodItem(null, MethodName);
                if (MethodItem == null || MethodItem.MethodDelegate == null)
                    return null;
                else                    
                    return MethodItem.MethodDelegate.DynamicInvoke(null);
		}
		/// <summary>
		/// �޲�����ִ��ָ�����ƵĽű����������ط�������ֵ,ģ�����ƺͷ������Ʋ����ִ�Сд
		/// </summary>
		/// <param name="ModuleName">ģ������</param>
		/// <param name="MethodName">����</param>
		/// <returns>��ִ�гɹ��򷵻ط�������ֵ,���򷵻ؿ�����</returns>
		public object RunScriptMethod( string ModuleName , string MethodName )
		{
			VBAScriptMethodItem MethodItem = GetMethodItem( ModuleName , MethodName );
			if( MethodItem == null || MethodItem.MethodDelegate == null )
				return null;
			else
				return MethodItem.MethodDelegate.DynamicInvoke( null );		}
		/// <summary>
		/// �޲�����ִ��ָ��ģ��ָ�����ƵĽű����������ط�������ֵ,ģ�����ƺͷ������Ʋ����ִ�Сд
		/// </summary>
		/// <param name="ModuleName">ģ������</param>
		/// <param name="MethodName">��������</param>
		/// <param name="obj">���õĶ���</param>
		/// <param name="Parameters">��������</param>
		/// <returns>��ִ�гɹ��򷵻ط�������ֵ�����򷵻ؿ�����</returns>
		public object RunScriptMethod( string ModuleName , string MethodName , object obj , object[] Parameters )
		{
			VBAScriptMethodItem MethodItem = GetMethodItem( ModuleName , MethodName );
			if( MethodItem == null)
				return null;
			else
			{
				if( MethodItem.MethodDelegate != null)
					return MethodItem.MethodDelegate.DynamicInvoke( null );
				else
					return MethodItem.MethodObject.Invoke(obj , Parameters);
			}
		}
		/// <summary>
		/// �޲�����ִ��ָ�����ƵĽű����������ط�������ֵ,ģ�����ƺͷ������Ʋ����ִ�Сд
		/// </summary>
		/// <param name="MethodName">��������</param>
		/// <param name="obj">���õĶ���</param>
		/// <param name="Parameters">��������</param>
		/// <returns>��ִ�гɹ��򷵻ط�������ֵ�����򷵻ؿ�����</returns>
		public object RunScriptMethod( string MethodName , object obj , object[] Parameters )
		{
			return RunScriptMethod( null , MethodName , obj , Parameters );
		}
		/// <summary>
		/// �޲�����ִ��ָ��ģ��ָ�����ƴ��뷽���������ַ���ֵ,ģ�����ƺͷ������Ʋ����ִ�Сд
		/// �����������ڻ�ִ�д����򷵻�Ĭ��ֵ
		/// </summary>
		/// <param name="ModuleName">ģ������</param>
		/// <param name="MethodName">��������</param>
		/// <param name="DefaultValue">Ĭ��ֵ</param>
		/// <returns>ִ�н��</returns>
		public string GetScriptStringValue( string ModuleName , string MethodName , string DefaultValue )
		{
			if( this.bolEnable )
			{
				VBAScriptMethodItem MethodItem = GetMethodItem( ModuleName , MethodName );
				if( MethodItem != null && MethodItem.MethodDelegate != null)
				{
					try
					{
						return Convert.ToString( MethodItem.MethodDelegate.DynamicInvoke( null ));
					}
					catch{}
				}
			}
			return DefaultValue ;
		}
		/// <summary>
		/// �޲�����ִ��ָ��ģ��ָ�����ƴ��뷽������������ֵ,ģ�����ƺͷ������Ʋ����ִ�Сд
		/// �����������ڻ�ִ�д����򷵻�Ĭ��ֵ
		/// </summary>
		/// <param name="ModuleName">ģ������</param>
		/// <param name="MethodName">��������</param>
		/// <param name="DefaultValue">Ĭ��ֵ</param>
		/// <returns>ִ�н��</returns>
		public int GetScriptInt32Value( string ModuleName , string MethodName , int DefaultValue )
		{
			if( this.bolEnable )
			{
				VBAScriptMethodItem MethodItem = GetMethodItem( ModuleName , MethodName );
				if( MethodItem != null && MethodItem.MethodDelegate != null)
				{
					try
					{
						return Convert.ToInt32( MethodItem.MethodDelegate.DynamicInvoke( null ));
					}
					catch{}
				}
			}
			return DefaultValue ;
		}
		/// <summary>
		/// �޲�����ִ��ָ��ģ��ָ�����ƴ��뷽��������˫���ȸ�����ֵ,ģ�����ƺͷ������Ʋ����ִ�Сд
		/// �����������ڻ�ִ�д����򷵻�Ĭ��ֵ
		/// </summary>
		/// <param name="ModuleName">ģ������</param>
		/// <param name="MethodName">��������</param>
		/// <param name="DefaultValue">Ĭ��ֵ</param>
		/// <returns>ִ�н��</returns>
		public double GetScriptDoubleValue( string ModuleName , string MethodName , double DefaultValue )
		{
			if( this.bolEnable )
			{
				VBAScriptMethodItem MethodItem = GetMethodItem( ModuleName , MethodName );
				if( MethodItem != null && MethodItem.MethodDelegate != null)
				{
					try
					{
						return Convert.ToDouble( MethodItem.MethodDelegate.DynamicInvoke( null ));
					}
					catch{}
				}
			}
			return DefaultValue ;
		}
		/// <summary>
		/// �޲�����ִ��ָ��ģ��ָ�����ƴ��뷽�������ص����ȸ�����ֵ,ģ�����ƺͷ������Ʋ����ִ�Сд
		/// �����������ڻ�ִ�д����򷵻�Ĭ��ֵ
		/// </summary>
		/// <param name="ModuleName">ģ������</param>
		/// <param name="MethodName">��������</param>
		/// <param name="DefaultValue">Ĭ��ֵ</param>
		/// <returns>ִ�н��</returns>
        public float GetScriptSingleValue(string ModuleName, string MethodName, float DefaultValue)
		{
			if( this.bolEnable )
			{
				VBAScriptMethodItem MethodItem = GetMethodItem( ModuleName , MethodName );
				if( MethodItem != null && MethodItem.MethodDelegate != null)
				{
					try
					{
						return Convert.ToSingle( MethodItem.MethodDelegate.DynamicInvoke( null ));
					}
					catch{}
				}
			}
			return DefaultValue ;
		}
		/// <summary>
		/// �޲�����ִ��ָ��ģ��ָ�����ƴ��뷽�������ز���ֵ,ģ�����ƺͷ������Ʋ����ִ�Сд
		/// �����������ڻ�ִ�д����򷵻�Ĭ��ֵ
		/// </summary>
		/// <param name="ModuleName">ģ������</param>
		/// <param name="MethodName">��������</param>
		/// <param name="DefaultValue">Ĭ��ֵ</param>
		/// <returns>ִ�н��</returns>
		public bool GetScriptBooleanValue( string ModuleName , string MethodName , bool DefaultValue )
		{
			if( this.bolEnable )
			{
				VBAScriptMethodItem MethodItem = GetMethodItem( ModuleName , MethodName );
				if( MethodItem != null && MethodItem.MethodDelegate != null)
				{
					try
					{
						return Convert.ToBoolean( MethodItem.MethodDelegate.DynamicInvoke( null ));
					}
					catch{}
				}
			}
			return DefaultValue ;
		}

 		#endregion

		#region IVsaSite ��Ա *********************************************************************

		/// <summary>
		/// �ڲ�����,��Ҫ����
		/// </summary>
		public object GetEventSourceInstance(string itemName, string eventSourceName)
		{
			return InnerGetObject( itemName );
		}

		/// <summary>
		/// �ڲ�����,��Ҫ����
		/// </summary>
		public object GetGlobalInstance(string name)
		{
			return InnerGetObject( name );
		}

		/// <summary>
		/// �ڲ�����,��Ҫ����
		/// </summary>
		public void Notify(string notify, object info)
		{
			// TODO:  ��� XDesignerVBAScriptEngine.Notify ʵ��
		}

		/// <summary>
		/// �ڲ�����,��Ҫ����
		/// </summary>
		public bool OnCompilerError(Microsoft.Vsa.IVsaError error)
		{
			myCompilerError = new CompilerErrorInfo();
			myCompilerError.SourceItem = error.SourceItem ;
			if( error.SourceItem is Microsoft.Vsa.IVsaCodeItem )
				myCompilerError.ModuleName = error.SourceItem.Name ;
			myCompilerError.Line = FixLineNumber( error.Line );
			myCompilerError.ErrorDescription = error.Description ;
			myCompilerError.StartColumn = error.StartColumn ;
			myCompilerError.EndColumn = error.EndColumn ;
			myCompilerError.LineText = error.LineText ;
			myCompilerError.Severity = error.Severity ;			
            log.Fatal("�������:" + myCompilerError.ToString());
			return false;
		}

		/// <summary>
		/// �ڲ�����,��Ҫ����
		/// </summary>
		public void GetCompiledState(out byte[] pe, out byte[] debugInfo)
		{
			pe = null;
			debugInfo = null;
		}

		#endregion

		#region ���������Ϣ�������Ⱥ ************************************************************

		protected CompilerErrorInfo myCompilerError = null;
		/// <summary>
		/// ���������Ϣ����
		/// </summary>
		public CompilerErrorInfo CompilerError
		{
			get{ return myCompilerError ;}
		}
		/// <summary>
		/// ���������Ϣ����
		/// </summary>
		public class CompilerErrorInfo
		{
			public Microsoft.Vsa.IVsaItem SourceItem = null;
			/// <summary>
			/// ������������ģ������
			/// </summary>
			public string ModuleName = null;
			/// <summary>
			/// ������ʾ�ı�
			/// </summary>
			public string ErrorDescription = null;
			/// <summary>
			/// ����������к�
			/// </summary>
			public int Line = 0 ;
			/// <summary>
			/// ����������к�
			/// </summary>
			public int StartColumn = 0 ;
			/// <summary>
			/// ��������Ľ����к�
			/// </summary>
			public int EndColumn = 0 ;
			/// <summary>
			/// ������������еĴ����ı�
			/// </summary>
			public string LineText = null;
			/// <summary>
			/// �������س̶�
			/// </summary>
			public int Severity = 0 ;

            public override string ToString()
            {
                return "�� " + this.Line + " �нű������������:" + this.ErrorDescription + "\r\n���д���Ϊ:" + this.LineText.Trim();
            }
		}//public class CompilerErrorInfo

		#endregion

        #region IDisposable ��Ա

        private bool IsDisposed=false;

        public void Dispose()  
        {  
            Dispose(true);
            GC.SuppressFinalize(this);  
        }

        protected override void Dispose(bool Disposing)  
        {  
            if(!IsDisposed)  
            {  
                if(Disposing)  
                {
                    try
                    {
                        //�����й���Դ
                        //base.Close();
                        log.Debug("Engine Close:" + this.AppName);
                    }
                    catch (System.StackOverflowException e)
                    {
                    }
                }  
                //������й���Դ
            }  
            IsDisposed=true;  
        }

        ~VBAEngineBase()
        {  
            Dispose(false);  
        } 

        #endregion
    }
}