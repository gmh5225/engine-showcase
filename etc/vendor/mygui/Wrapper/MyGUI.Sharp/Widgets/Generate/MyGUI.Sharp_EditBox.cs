﻿/*!
	@file
	@author		Generate utility by Albert Semenov
	@date		01/2009
	@module
*/

using System;
using System.Runtime.InteropServices;

namespace MyGUI.Sharp
{

    public  class EditBox : StaticText
    {

        #region EditBox

        public EditBox()
            : base()
        {
        }

        internal EditBox(BaseWidget _parent, IntPtr _widget)
            : base(_parent, _widget)
        {
        }

        internal EditBox(IntPtr _parent, WidgetStyle _style, string _skin, IntCoord _coord, Align _align, string _layer, string _name)
            : base(_parent, _style, _skin, _coord, _align, _layer, _name)
        {
        }

        protected override string GetWidgetType() { return "Edit"; }

        internal static BaseWidget RequestWrapEditBox(BaseWidget _parent, IntPtr _widget)
        {
            return new EditBox(_parent, _widget);
        }

        internal static BaseWidget RequestCreateEditBox(IntPtr _parent, WidgetStyle _style, string _skin, IntCoord _coord, Align _align, string _layer, string _name)
        {
            return new EditBox(_parent, _style, _skin, _coord, _align, _layer, _name);
        }
        
		#endregion
	
		
		//InsertPoint

   		#region Event EditTextChange

		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
		private static extern void ExportEditBoxEvent_AdviseEditTextChange( IntPtr _native, bool _advise );

		public delegate void HandleEditTextChange(
			 EditBox _sender );
			
		private HandleEditTextChange mEventEditTextChange;
		public event HandleEditTextChange EventEditTextChange
		{
			add
			{
				if (mEventEditTextChange == null) ExportEditBoxEvent_AdviseEditTextChange( mNative, true );
				mEventEditTextChange += value;
			}
			remove
			{
				mEventEditTextChange -= value;
				if (mEventEditTextChange == null) ExportEditBoxEvent_AdviseEditTextChange( mNative, false );
			}
		}


		private struct ExportEventEditTextChange
		{
			[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
			private static extern void ExportEditBoxEvent_DelegateEditTextChange( ExportHandle _delegate );
			public delegate void ExportHandle(
				[MarshalAs(UnmanagedType.Interface)]  EditBox _sender );
				
			private static ExportHandle mDelegate;
			public ExportEventEditTextChange( ExportHandle _delegate )
			{
				mDelegate = _delegate;
				ExportEditBoxEvent_DelegateEditTextChange( mDelegate );
			}
		}
		static ExportEventEditTextChange mExportEditTextChange =
			new ExportEventEditTextChange(new ExportEventEditTextChange.ExportHandle( OnExportEditTextChange ));

		private static void OnExportEditTextChange(
			 EditBox _sender )
		{
			if (_sender.mEventEditTextChange != null)
				_sender.mEventEditTextChange(
					 _sender );
		}

		#endregion



   		#region Event EditSelectAccept

		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
		private static extern void ExportEditBoxEvent_AdviseEditSelectAccept( IntPtr _native, bool _advise );

		public delegate void HandleEditSelectAccept(
			 EditBox _sender );
			
		private HandleEditSelectAccept mEventEditSelectAccept;
		public event HandleEditSelectAccept EventEditSelectAccept
		{
			add
			{
				if (mEventEditSelectAccept == null) ExportEditBoxEvent_AdviseEditSelectAccept( mNative, true );
				mEventEditSelectAccept += value;
			}
			remove
			{
				mEventEditSelectAccept -= value;
				if (mEventEditSelectAccept == null) ExportEditBoxEvent_AdviseEditSelectAccept( mNative, false );
			}
		}


		private struct ExportEventEditSelectAccept
		{
			[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
			private static extern void ExportEditBoxEvent_DelegateEditSelectAccept( ExportHandle _delegate );
			public delegate void ExportHandle(
				[MarshalAs(UnmanagedType.Interface)]  EditBox _sender );
				
			private static ExportHandle mDelegate;
			public ExportEventEditSelectAccept( ExportHandle _delegate )
			{
				mDelegate = _delegate;
				ExportEditBoxEvent_DelegateEditSelectAccept( mDelegate );
			}
		}
		static ExportEventEditSelectAccept mExportEditSelectAccept =
			new ExportEventEditSelectAccept(new ExportEventEditSelectAccept.ExportHandle( OnExportEditSelectAccept ));

		private static void OnExportEditSelectAccept(
			 EditBox _sender )
		{
			if (_sender.mEventEditSelectAccept != null)
				_sender.mEventEditSelectAccept(
					 _sender );
		}

		#endregion



   


   


   


   


   		#region Property VisibleHScroll

		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
        [return: MarshalAs(UnmanagedType.U1)]
		private static extern bool ExportEditBox_IsVisibleHScroll( IntPtr _widget );
		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
		private static extern void ExportEditBox_SetVisibleHScroll( IntPtr _widget, [MarshalAs(UnmanagedType.U1)]  bool _value );

		public bool VisibleHScroll
		{
			get { return  ExportEditBox_IsVisibleHScroll( mNative )  ; }
			set { ExportEditBox_SetVisibleHScroll( mNative,  value ); }
		}

		#endregion



   		#region Property VisibleVScroll

		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
        [return: MarshalAs(UnmanagedType.U1)]
		private static extern bool ExportEditBox_IsVisibleVScroll( IntPtr _widget );
		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
		private static extern void ExportEditBox_SetVisibleVScroll( IntPtr _widget, [MarshalAs(UnmanagedType.U1)]  bool _value );

		public bool VisibleVScroll
		{
			get { return  ExportEditBox_IsVisibleVScroll( mNative )  ; }
			set { ExportEditBox_SetVisibleVScroll( mNative,  value ); }
		}

		#endregion



   


   


   


   


   


   


   		#region Property TabPrinting

		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
        [return: MarshalAs(UnmanagedType.U1)]
		private static extern bool ExportEditBox_GetTabPrinting( IntPtr _widget );
		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
		private static extern void ExportEditBox_SetTabPrinting( IntPtr _widget, [MarshalAs(UnmanagedType.U1)]  bool _value );

		public bool TabPrinting
		{
			get { return  ExportEditBox_GetTabPrinting( mNative )  ; }
			set { ExportEditBox_SetTabPrinting( mNative,  value ); }
		}

		#endregion



   		#region Property EditWordWrap

		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
        [return: MarshalAs(UnmanagedType.U1)]
		private static extern bool ExportEditBox_GetEditWordWrap( IntPtr _widget );
		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
		private static extern void ExportEditBox_SetEditWordWrap( IntPtr _widget, [MarshalAs(UnmanagedType.U1)]  bool _value );

		public bool EditWordWrap
		{
			get { return  ExportEditBox_GetEditWordWrap( mNative )  ; }
			set { ExportEditBox_SetEditWordWrap( mNative,  value ); }
		}

		#endregion



   		#region Method SetPasswordChar

		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
		private static extern void ExportEditBox_SetPasswordChar_char( IntPtr _native ,
			[MarshalAs(UnmanagedType.LPWStr)]  string _char );

		public void SetPasswordChar(
			string _char )
		{
			ExportEditBox_SetPasswordChar_char( mNative , 
				 _char );
		}

		#endregion



   		#region Property PasswordChar

		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
        
		private static extern uint ExportEditBox_GetPasswordChar( IntPtr _widget );
		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
		private static extern void ExportEditBox_SetPasswordChar( IntPtr _widget,   uint _value );

		public uint PasswordChar
		{
			get { return  ExportEditBox_GetPasswordChar( mNative )  ; }
			set { ExportEditBox_SetPasswordChar( mNative,  value ); }
		}

		#endregion



   		#region Property EditStatic

		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
        [return: MarshalAs(UnmanagedType.U1)]
		private static extern bool ExportEditBox_GetEditStatic( IntPtr _widget );
		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
		private static extern void ExportEditBox_SetEditStatic( IntPtr _widget, [MarshalAs(UnmanagedType.U1)]  bool _value );

		public bool EditStatic
		{
			get { return  ExportEditBox_GetEditStatic( mNative )  ; }
			set { ExportEditBox_SetEditStatic( mNative,  value ); }
		}

		#endregion



   		#region Property EditMultiLine

		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
        [return: MarshalAs(UnmanagedType.U1)]
		private static extern bool ExportEditBox_GetEditMultiLine( IntPtr _widget );
		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
		private static extern void ExportEditBox_SetEditMultiLine( IntPtr _widget, [MarshalAs(UnmanagedType.U1)]  bool _value );

		public bool EditMultiLine
		{
			get { return  ExportEditBox_GetEditMultiLine( mNative )  ; }
			set { ExportEditBox_SetEditMultiLine( mNative,  value ); }
		}

		#endregion



   		#region Property EditPassword

		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
        [return: MarshalAs(UnmanagedType.U1)]
		private static extern bool ExportEditBox_GetEditPassword( IntPtr _widget );
		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
		private static extern void ExportEditBox_SetEditPassword( IntPtr _widget, [MarshalAs(UnmanagedType.U1)]  bool _value );

		public bool EditPassword
		{
			get { return  ExportEditBox_GetEditPassword( mNative )  ; }
			set { ExportEditBox_SetEditPassword( mNative,  value ); }
		}

		#endregion



   		#region Property EditReadOnly

		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
        [return: MarshalAs(UnmanagedType.U1)]
		private static extern bool ExportEditBox_GetEditReadOnly( IntPtr _widget );
		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
		private static extern void ExportEditBox_SetEditReadOnly( IntPtr _widget, [MarshalAs(UnmanagedType.U1)]  bool _value );

		public bool EditReadOnly
		{
			get { return  ExportEditBox_GetEditReadOnly( mNative )  ; }
			set { ExportEditBox_SetEditReadOnly( mNative,  value ); }
		}

		#endregion



   		#region Method EraseText

		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
		private static extern void ExportEditBox_EraseText_start_count( IntPtr _native ,
			  uint _start ,
			  uint _count );

		public void EraseText(
			uint _start ,
			uint _count )
		{
			ExportEditBox_EraseText_start_count( mNative , 
				 _start ,
				 _count );
		}

		#endregion



   		#region Method AddText

		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
		private static extern void ExportEditBox_AddText_text( IntPtr _native ,
			[MarshalAs(UnmanagedType.LPWStr)]  string _text );

		public void AddText(
			string _text )
		{
			ExportEditBox_AddText_text( mNative , 
				 _text );
		}

		#endregion



   		#region Method InsertText

		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
		private static extern void ExportEditBox_InsertText_text_index( IntPtr _native ,
			[MarshalAs(UnmanagedType.LPWStr)]  string _text ,
			  uint _index );

		public void InsertText(
			string _text ,
			uint _index )
		{
			ExportEditBox_InsertText_text_index( mNative , 
				 _text ,
				 _index );
		}

		#endregion



   		#region Property MaxTextLength

		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
        
		private static extern uint ExportEditBox_GetMaxTextLength( IntPtr _widget );
		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
		private static extern void ExportEditBox_SetMaxTextLength( IntPtr _widget,   uint _value );

		public uint MaxTextLength
		{
			get { return  ExportEditBox_GetMaxTextLength( mNative )  ; }
			set { ExportEditBox_SetMaxTextLength( mNative,  value ); }
		}

		#endregion



   		#region Property OverflowToTheLeft

		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
        [return: MarshalAs(UnmanagedType.U1)]
		private static extern bool ExportEditBox_GetOverflowToTheLeft( IntPtr _widget );
		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
		private static extern void ExportEditBox_SetOverflowToTheLeft( IntPtr _widget, [MarshalAs(UnmanagedType.U1)]  bool _value );

		public bool OverflowToTheLeft
		{
			get { return  ExportEditBox_GetOverflowToTheLeft( mNative )  ; }
			set { ExportEditBox_SetOverflowToTheLeft( mNative,  value ); }
		}

		#endregion



   		#region Property TextLength

		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
        
		private static extern uint ExportEditBox_GetTextLength( IntPtr _native );

		public uint TextLength
		{
			get { return  ExportEditBox_GetTextLength( mNative )  ; }
		}

		#endregion



   		#region Property OnlyText

		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
        
		private static extern IntPtr ExportEditBox_GetOnlyText( IntPtr _widget );
		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
		private static extern void ExportEditBox_SetOnlyText( IntPtr _widget, [MarshalAs(UnmanagedType.LPWStr)]  string _value );

		public string OnlyText
		{
			get { return  Marshal.PtrToStringUni(  ExportEditBox_GetOnlyText( mNative )  )  ; }
			set { ExportEditBox_SetOnlyText( mNative,  value ); }
		}

		#endregion



   


   		#region Property TextCursor

		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
        
		private static extern uint ExportEditBox_GetTextCursor( IntPtr _widget );
		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
		private static extern void ExportEditBox_SetTextCursor( IntPtr _widget,   uint _value );

		public uint TextCursor
		{
			get { return  ExportEditBox_GetTextCursor( mNative )  ; }
			set { ExportEditBox_SetTextCursor( mNative,  value ); }
		}

		#endregion



   		#region Method SetTextSelectionColour

		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
		private static extern void ExportEditBox_SetTextSelectionColour_colour( IntPtr _native ,
			[In] ref Colour _colour );

		public void SetTextSelectionColour(
			Colour _colour )
		{
			ExportEditBox_SetTextSelectionColour_colour( mNative , 
				ref _colour );
		}

		#endregion



   		#region Method IsTextSelection

		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
        [return: MarshalAs(UnmanagedType.U1)]
		private static extern bool ExportEditBox_IsTextSelection( IntPtr _native );

		public bool IsTextSelection( )
		{
			return  ExportEditBox_IsTextSelection( mNative )  ;
		}

		#endregion



   		#region Method GetTextSelection

		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
        
		private static extern IntPtr ExportEditBox_GetTextSelection( IntPtr _native );

		public string GetTextSelection( )
		{
			return  Marshal.PtrToStringUni(  ExportEditBox_GetTextSelection( mNative )  )  ;
		}

		#endregion



   		#region Method DeleteTextSelection

		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
		private static extern void ExportEditBox_DeleteTextSelection( IntPtr _native );

		public void DeleteTextSelection( )
		{
			ExportEditBox_DeleteTextSelection(  mNative );
		}

		#endregion



   		#region Method SetTextSelection

		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
		private static extern void ExportEditBox_SetTextSelection_start_end( IntPtr _native ,
			  uint _start ,
			  uint _end );

		public void SetTextSelection(
			uint _start ,
			uint _end )
		{
			ExportEditBox_SetTextSelection_start_end( mNative , 
				 _start ,
				 _end );
		}

		#endregion



   		#region Method GetTextInterval

		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
        
		private static extern IntPtr ExportEditBox_GetTextInterval_start_count( IntPtr _native ,
			  uint _start ,
			  uint _count );

		public string GetTextInterval(
			uint _start ,
			uint _count )
		{
			return  Marshal.PtrToStringUni(  ExportEditBox_GetTextInterval_start_count( mNative , 
				 _start ,
				 _count )  )  ;
		}

		#endregion



   		#region Method GetTextSelectionLength

		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
        
		private static extern uint ExportEditBox_GetTextSelectionLength( IntPtr _native );

		public uint GetTextSelectionLength( )
		{
			return  ExportEditBox_GetTextSelectionLength( mNative )  ;
		}

		#endregion



   		#region Method GetTextSelectionEnd

		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
        
		private static extern uint ExportEditBox_GetTextSelectionEnd( IntPtr _native );

		public uint GetTextSelectionEnd( )
		{
			return  ExportEditBox_GetTextSelectionEnd( mNative )  ;
		}

		#endregion



   		#region Method GetTextSelectionStart

		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
        
		private static extern uint ExportEditBox_GetTextSelectionStart( IntPtr _native );

		public uint GetTextSelectionStart( )
		{
			return  ExportEditBox_GetTextSelectionStart( mNative )  ;
		}

		#endregion



   		#region Method SetTextIntervalColour

		[DllImport("MyGUI.Export.dll", CallingConvention = CallingConvention.Cdecl)]
		private static extern void ExportEditBox_SetTextIntervalColour_start_count_colour( IntPtr _native ,
			  uint _start ,
			  uint _count ,
			[In] ref Colour _colour );

		public void SetTextIntervalColour(
			uint _start ,
			uint _count ,
			Colour _colour )
		{
			ExportEditBox_SetTextIntervalColour_start_count_colour( mNative , 
				 _start ,
				 _count ,
				ref _colour );
		}

		#endregion



   


   

		
    }

}
