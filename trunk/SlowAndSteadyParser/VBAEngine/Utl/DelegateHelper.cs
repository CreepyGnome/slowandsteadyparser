using System;

namespace SlowAndSteadyParser
{
	/// <summary>
	/// ����ί�в���������ģ��,�����󲻿�ʵ����
	/// </summary>
	/// <remarks>���� yyf 2006</remarks>
	public sealed class DelegateHelper
	{
		/// <summary>
		/// �޷���ֵ��ί������
		/// </summary>
		public delegate void	VoidDelegate();
		/// <summary>
		/// ���س��������ݵ�ί������
		/// </summary>
		public delegate long	Int64Delegate();
		/// <summary>
		/// �����������ݵ�ί������
		/// </summary>
		public delegate int		Int32Delegate();
		/// <summary>
		/// ���ض����ε�ί������
		/// </summary>
		public delegate short   Int16Delegate();
		/// <summary>
		/// �����޷��ų����͵�ί������
		/// </summary>
		public delegate ulong   UInt64Delegate();
		/// <summary>
		/// �����޷���������ί������
		/// </summary>
		public delegate uint	UInt32Delegate();
		/// <summary>
		/// �����޷��Ŷ�������ί������
		/// </summary>
		public delegate ushort	UInt16Delegate();
		/// <summary>
		/// ���ص����ֽڵ�ί������
		/// </summary>
		public delegate byte	ByteDelegate();
		/// <summary>
		/// ���ص����з����ֽڵ�ί������
		/// </summary>
		public delegate sbyte	SByteDelegate();
		/// <summary>
		/// �����ֽ������ί������
		/// </summary>
		public delegate byte[]  BytesDelegate();
		/// <summary>
		/// ����˫���ȸ�������ί������
		/// </summary>
		public delegate double	DoubleDelegate();
		/// <summary>
		/// ���ص����ȸ�������ί������
		/// </summary>
		public delegate float	SingleDelegate();

		/// <summary>
		/// ���ز������͵�ί������
		/// </summary>
		public delegate bool	BooleanDelegate();
		/// <summary>
		/// ����ʮ������ֵ��ί������
		/// </summary>
		public delegate decimal DecimalDelegate();
		/// <summary>
		/// ���ص����ַ���ί������
		/// </summary>
		public delegate char	CharDelegate();
		/// <summary>
		/// ����ʱ�����͵�ί������
		/// </summary>
		public delegate System.DateTime DateTimeDelegate();
		/// <summary>
		/// �����ַ�����ί������
		/// </summary>
		public delegate string	StringDelegate();
		/// <summary>
		/// ���ض����ί������
		/// </summary>
		public delegate object	ObjectDelegate();
		/// <summary>
		/// �������͵�ί������
		/// </summary>
		public delegate System.Type TypeDelegate();
		/// <summary>
		/// ��������ί������
		/// </summary>
		public delegate System.IO.Stream StreamDelegate();
		/// <summary>
		/// �����б��ί������
		/// </summary>
		public delegate System.Collections.ArrayList ArrayListDelegate();
		/// <summary>
		/// ���ؼ��ϵ�ί������
		/// </summary>
		public delegate System.Collections.ICollection CollectionDelegate();
		/// <summary>
		/// ���� IDisposable ��ί������
		/// </summary>
		public delegate System.IDisposable DisposableDelegate();

//		public delegate System.Drawing.Point PointDelegate();
//		public delegate System.Drawing.Rectangle RectangleDelegate();
//		public delegate System.Drawing.Size SizeDelegate();

		/// <summary>
		/// ���ݷ������ͻ��ί������,��δ֧�ָ÷��������򷵻ؿ�����
		/// </summary>
		/// <param name="ReturnType">��������</param>
		/// <returns>ί������</returns>
		public static System.Type GetDelegateType( System.Type ReturnType )
		{
			if( ReturnType == null)
				return null;

			System.Type DelegateType = null;
			
			if( ReturnType.Equals( typeof( void )))
				DelegateType = typeof( VoidDelegate );

			else if( ReturnType.Equals( typeof( long )))
				DelegateType = typeof( Int64Delegate );
			else if( ReturnType.Equals( typeof( int )))
				DelegateType = typeof( Int32Delegate ) ;
			else if( ReturnType.Equals( typeof( short)))
				DelegateType = typeof( Int16Delegate );
			else if( ReturnType.Equals( typeof( ulong )))
				DelegateType = typeof( UInt64Delegate );
			else if( ReturnType.Equals( typeof( uint )))
				DelegateType = typeof( UInt32Delegate ) ;
			else if( ReturnType.Equals( typeof( ushort)))
				DelegateType = typeof( UInt16Delegate );
			
			else if( ReturnType.Equals( typeof( string )))
				DelegateType = typeof( StringDelegate ) ;
			else if( ReturnType.Equals( typeof( double )))
				DelegateType = typeof( DoubleDelegate );
			else if( ReturnType.Equals( typeof( float )))
				DelegateType = typeof( SingleDelegate );
			else if( ReturnType.Equals( typeof( bool )))
				DelegateType = typeof( BooleanDelegate );
			else if( ReturnType.Equals( typeof( decimal )))
				DelegateType = typeof( DecimalDelegate );
			else if( ReturnType.Equals( typeof( byte[])))
				DelegateType = typeof( BytesDelegate );
			else if( ReturnType.Equals( typeof( byte)))
				DelegateType = typeof( ByteDelegate );
			else if( ReturnType.Equals( typeof( sbyte)))
				DelegateType = typeof( SByteDelegate );

			else if( ReturnType.Equals( typeof( char )))
				DelegateType = typeof( CharDelegate );
			else if( ReturnType.Equals( typeof( System.DateTime )))
				DelegateType = typeof( DateTimeDelegate );
			else if( ReturnType.Equals( typeof( object )))
				DelegateType = typeof( ObjectDelegate );

			else if( ReturnType.Equals( typeof( System.Type )))
				DelegateType = typeof( TypeDelegate);
			else if( ReturnType.Equals( typeof( System.IO.Stream )))
				DelegateType = typeof( StreamDelegate );
			else if( ReturnType.Equals( typeof( System.Collections.ArrayList )))
				DelegateType = typeof( ArrayListDelegate );
			else if( ReturnType.Equals( typeof( System.Collections.ICollection )))
				DelegateType = typeof( CollectionDelegate );
			else if( ReturnType.Equals( typeof( System.IDisposable )))
				DelegateType = typeof( DisposableDelegate );

			return DelegateType ;

		}//public static System.Type GetDelegateType( System.Type ReturnType )

		public static System.Delegate CreateDelegate( System.Reflection.MethodInfo method , object obj )
		{
			if( method == null)
				return null;
			if( method.GetParameters().Length == 0 )
				return null;
			System.Delegate Result = null;
			System.Type DelegateType = GetDelegateType( method.ReturnType );
			
			if( DelegateType == null)
				return null;

			if( method.IsStatic )
			{
				Result = System.Delegate.CreateDelegate( DelegateType , method );
			}
			else
			{
				Result = System.Delegate.CreateDelegate( DelegateType , obj , method.Name );
			}
			return Result ;
		}

		private DelegateHelper(){}

	}//public sealed class DelegateHelper
}