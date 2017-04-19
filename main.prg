/*
* modelo baseado em Contactos
* (C) 2003 Roberto Lopez <mail.box.hmg@gmail.com>
*/

/*
	El archivo 'hmg.ch' debe ser incluido en todos los programas HMG
*/

#include "hmg.ch"
#Include "F_sistema.ch"
#include "ads.ch"
#include "ord.ch"

Function Main

///////////////////////////////////////////////////////////////////////////////

**MsgInfo(System.Clipboard)

**                  MsgInfo(str(System.DesktopWidth))

**                  MsgInfo(System.TempFolder)

**                  MsgInfo(System.DefaultPrinter) 

request ADS
rddRegister( "ADS", 1 )
RDDSETDEFAULT("ADS")
SET SERVER LOCAL
set(39,159)

///////////////////////////////////////////////////////////////////////////////
// Inicializacion RDD DBFCDX Nativo
///////////////////////////////////////////////////////////////////////////////

	REQUEST DBFCDX , DBFFPT
	RDDSETDEFAULT( "DBFCDX" )

 **HB_LANGSELECT("PT")
 **HB_SETCODEPAGE("PT850")

 SET CODEPAGE TO PORTUGUESE  
 SET LANGUAGE TO PORTUGUESE
 HB_SETCODEPAGE("PT850")
 
 SET FONT TO 'currier new',12

 **SET FONT TO 'arial',12

 SET DATE BRITISH
 SET EPOCH TO 1945
 SET CENTURY ON
 SET DELETED ON
 SET MULTIPLE OFF WARNING
 SET NAVIGATION EXTENDED
 set decimals to 3
 set wrap on

 SET( _SET_DATEFORMAT, "dd-mm-yyyy" )
 SET( _SET_PATH, GetCurrentFolder() )
 SET( _SET_DEFAULT, GetCurrentFolder() )
 
/*
	Todas los programas HMG, deben tener una ventana principal.
	Esta debe ser definida antes que cualquier otra.
*/

	DEFINE WINDOW Principal ;
		AT 0,0 ;
		WIDTH 640 ;
		HEIGHT 480 ;
		TITLE SISTEMA ;
		MAIN ;
		ICON 'ICONE01' ; 
		BACKCOLOR {252,230,192} ;
		ON INIT Ambiente_Inicial() ;
		ON RELEASE Abandona_Sistema();
		ON PAINT AJUSTAR() ;

	
		DEFINE MAIN MENU 
			DEFINE POPUP '&Cadastros'
				MENUITEM '&Cd s  ou  Dvd s'		ACTION AdministradorDeContactos()
				MENUITEM '&Tipos de Mídias'	ACTION AdministradorDeTipos()
				SEPARATOR
				MENUITEM '&Sair'		ACTION EXIT PROGRAM
			END POPUP

			DEFINE POPUP '&Relatorios'
				MENUITEM '&Cd´s  ou  Dvd´s'		ACTION AdministradorDeContactos()
				MENUITEM '&Tipos de Mídias'	ACTION AdministradorDeTipos()
				SEPARATOR
			END POPUP

			DEFINE POPUP 'A&juda'
				MENUITEM 'S&obre...' ACTION MsgInfo ('CORP.AM SISTEMAS' + QUEBRA + ;
              hb_compiler() + QUEBRA + ;
              SubStr(MiniGuiVersion(), 1, 38) + QUEBRA )
			END POPUP

		END MENU

		// Fin de la definicion del menu principal 

		// El control TOOLBAR puede contener multiples botones de 
		// comando.
		// El tama¤o de estos botones es definido por medio de la
		// clausula BUTTONSIZE <Ancho>,<Alto>
		// FLAT crea botones 'planos'
		// RIGHTTEXT indica que el texto de los botones se ubicara
		// a la derecha de su imagen.

		DEFINE TOOLBAR ToolBar_1 FLAT BUTTONSIZE 110,35 RIGHTTEXT BORDER

			BUTTON Button_1 ;
				CAPTION '&Cd s  ou  Dvd s' ;
				PICTURE 'CLIENTES' ;
				ACTION AdministradorDeContactos()

			// CAPTION Indica el titulo del boton.
			// PICTURE El archivo de imagen asociado (BMP)
			// ACTION Un procedimiento de evento asociado al boton
			// (lo que va a ejecutarse cuando se haga click)

			BUTTON Button_2 ;
				CAPTION '&Tipos de Midias' ;
				PICTURE 'TIPOS' ;
				ACTION AdministradorDeTipos()

			BUTTON Button_3 ;
				CAPTION 'Ajuda' ;
				PICTURE 'ajuda' ;
				ACTION MsgInfo ('CORP.AM SISTEMAS' + QUEBRA + ;
              hb_compiler() + QUEBRA + ;
              SubStr(MiniGuiVersion(), 1, 38) + QUEBRA )

		END TOOLBAR

		// La barra de estado aparece en la parte inferior de la ventana.
		// Puede tener multiples secciones definidas por medio de STATUSITEM
		// Existen dos secciones (opcionales) predefinidas, llamadas 
		// CLOCK y DATE (muestran un reloj y la fecha respectivamente)

    DEFINE STATUSBAR FONT 'Verdana' SIZE 7	
			STATUSITEM "Base de Dados: "+BaseDeDados() WIDTH 150
			STATUSITEM "Status: "+Iif( ServidorDeDados() == "SIM" , "SERVIDOR", "TERMINAL" ) WIDTH 115
			STATUSITEM "Usuário: " WIDTH 100	
			STATUSITEM "Rede: "+AllTrim( NetName() ) WIDTH 150	
			CLOCK
		END STATUSBAR


    DEFINE IMAGE Image_1
        ROW    50
        COL    10
        WIDTH  840
        HEIGHT 530
        PICTURE "FUNDO01"
        HELPID Nil
        VISIBLE .T.
        STRETCH .T.
        ACTION Nil
    END IMAGE

	// Fin de la definicion de la ventana

	END WINDOW

	// maximizar la ventana 

	MAXIMIZE WINDOW Principal 

	// Activar la ventana

	ACTIVATE WINDOW Principal

	// El comando ACTIVATE WINDOW genera un estado de espera. 
	// El programa estara detenido en este punto hasta que la ventana
	// sea cerrada interactiva o programaticamente. Solo se ejecutaran
	// los procedimientos de evento asociados a sus controles (o a la 
	// ventana misma)

Return
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Função		: Ambiente_Inicial()
* Finalidade	: Quando o Aplicativo é iniciado, automaticamente é desviado para esta função através da Cláusula
*		: ON INIT definida no Form_0 .
*		: Nesta função o sistema verifica se o aplicativo foi desligado corretamente.
*		: Esta verificação só ocorre se a Cópia estiver configurada como Servidor=SIM no arquivo FINANC.INI
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function Ambiente_Inicial()		

	If ServidorDeDados() == "SIM"  .And.  Saida_Irregular() != "SIM" 

		LinhaDeStatus('Saída Irregular do Sistema!!')

		If  MsgYesNo(PadC("*** Corp.AM Controle v.1.0 ***",60)+QUEBRA+;
			PadC(" ",30)+QUEBRA+;
			PadC(" *** Saida Irregular do Sistema ***",60)+QUEBRA+;
			PadC(" ",30)+QUEBRA+;
			PadC(" O Sistema nao foi Desligado Corretamente!!",60)+QUEBRA+;
			PadC(" É aconselhável efetuar a Indexação do Sistema!!",60)+QUEBRA+;
			PadC("",60) , SISTEMA )		

			AcessoOpen()			

			Indexa()	

			LinhaDeStatus()

		EndIf		

	EndIf

	Status_Entrada_Saida("NAO")

/*
	AcessoAoSistema()
*/
	
Return Nil

/*
*/
Function Abandona_Sistema()
             Status_Entrada_Saida("SIM")
             Close All	
Return Nil
/*
*/
static procedure ajustar
	Principal.image_1.row	:= 70
	Principal.image_1.col	:= 0
	Principal.image_1.width	:= Principal.Width
	Principal.image_1.height	:= Principal.Height-175
return

