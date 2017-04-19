/*
* Controle Financeiro - Pequeno Exemplo
* Humberto Fornazier - Maio/2003
* hfornazier@brfree.com.br
* www.geocities.com/harbourminas
*
* Harbour Compiler (MiniGUI Distribution) 2003.05.03 (Flex)
* Copyright 1999-2003, http://www.harbour-project.org/
*
* Harbour MiniGUI R.62a Copyright 2002-2003 Roberto Lopez,
* MINIGUI - Harbour Win32 GUI library - Release 62a - 23/05/2003
* Copyright 2002 Roberto Lopez <roblez@ciudad.com.ar>
* http://www.geocities.com/harbourminigui/
*
* Algumas das telas do sistema foram contru�das com auxilio do
* GUIDES - Release 0.12 for MiniGUI
* Carlos Andres - carlos.andres@navegalia.com
* http://www.geocities.com/harbour_links
*
* Este exemplo � uma contribui��o ao Projeto Harbour/MiniGUI  e pode ser modificado e distribu�do livremente.
*
* Importante	: Este sistema foi desenvolvido com intens�o de auxiliar usu�rios
*	 	  que utilizem o Harbour e o MiniGUI.   � um projeto apenas para			
*		  estudo dos comandos.   N�o deve ser utilizado comercialmente 
*		  por estar sujeito a apresentar possiveis erros n�o detectados em
*		  testes feitos pelo autor. 
*/
#include "minigui.ch"
*#Include "winprint.ch"

#Include "F_sistema.ch"
/*
*/
Function Main()      		
             
	REQUEST DBFCDX , DBFFPT
	RDDSETDEFAULT( "DBFCDX" )

	SET DATE BRITISH
	SET BROWSESYNC ON
	SET CENTURY ON             
	SET DELETE ON   
	
	Public xWidth, yHeight

	Cria_File_ini()		

	DEFINE WINDOW Form_0 ;
   AT 0,0;
   WIDTH 640 ;
   HEIGHT 480	;
		TITLE SISTEMA ;
		ICON 'Tutor.Ico';
		MAIN ;
		FONT 'Arial' ;
    SIZE 10 ;
		BACKCOLOR {252,230,192} ;
		ON INIT Ambiente_Inicial() ;
		ON RELEASE Abandona_Sistema();
		ON PAINT AJUSTAR() ;
		ON KEY ALT+C ACTION Clientes() ; 
		ON KEY ALT+F ACTION Fornecedores(); 
		ON KEY ALT+T ACTION AcessoAoSistema()

		DEFINE MAIN MENU 
			POPUP '&Sistema'               
				ITEM 'Contas � &Pagar'  ACTION ContasPagar() NAME Mn_Pagar				
				ITEM 'Contas � Receber' ACTION ContasReceber() NAME Mn_Receber
				SEPARATOR
				ITEM '&Clientes        '     ACTION Clientes() NAME Mn_Clientes
				ITEM '&Fornecedores'      ACTION Fornecedores() NAME Mn_Fornecedores
				SEPARATOR
				ITEM '&Sair'  ACTION  Confirmar_Saida()
			END POPUP
      POPUP '&Tabelas de Apoio'
					ITEM 'Contas &Financeiras' ACTION CadastroGenerico( "Contas"    ,  "Cadastro de Contas Financeiras"   )  NAME Mn_Contas
					ITEM '&Grupos de Contas  ' ACTION CadastroGenerico( "Grupos" ,  "Cadastro de Grupos de Contas")  NAME Mn_Grupos
					ITEM '&Centros de Custos ' ACTION CadastroGenerico( "Custos"  ,  "Cadastro de Centros de Custo" )  NAME Mn_Custos
      END POPUP	
      POPUP '&Usu�rios'   
					ITEM 'Cadastros dos &Usu�rios' ACTION Usuarios() NAME Mn_Usuarios					
					SEPARATOR
					ITEM '&Altera Senha Usu�rio Atual' ACTION  AlteraSenha() NAME Mn_Altera_Senha   
			END POPUP
			POPUP '&Utilit�rios e Configura��es'   
         SEPARATOR				
				 ITEM '&Troca Usu�rio' ACTION AcessoAoSistema()
				 SEPARATOR 
				 ITEM 'Inde&xa��o do Sistema' ACTION Indexa() NAME Mn_Indexar
				 SEPARATOR
				 ITEM '&Altera Senha Usu�rio Atual' ACTION  AlteraSenha() NAME Mn_Altera_Senha   
			END POPUP
			POPUP '&Help'
				ITEM '&About' ACTION Sobre_o_Sistema()
			END POPUP
		END MENU

		DEFINE CONTEXT MENU
		 	ITEM 'Contas � &Pagar' ACTION ContasPagar()
		 	ITEM 'Contas � &Receber' ACTION ContasReceber()
			SEPARATOR
			ITEM '&Clientes'		ACTION Clientes() 
			ITEM '&Fornecedores'	ACTION Fornecedores()
			SEPARATOR
			ITEM 'Contas &Financeiras' ACTION CadastroGenerico( "Contas"    ,  "Cadastro de Contas Financeiras"   )
			ITEM '&Grupos de Contas ' ACTION CadastroGenerico( "Grupos" ,  "Cadastro de Grupos de Contas")
			ITEM '&Centros de Custos' ACTION CadastroGenerico( "Custos"  ,  "Cadastro de Centros de Custo" )  
			SEPARATOR
			ITEM 'Alterar &Usu�rio Ativo'	ACTION AcessoAoSistema()		
			ITEM 'Alterar &Senha'	ACTION AlteraSenha()
			SEPARATOR
			ITEM 'Sair'   ACTION Confirmar_Saida()
		END MENU

		DEFINE STATUSBAR FONT 'Verdana' SIZE 7	
			STATUSITEM "Base de Dados: "+BaseDeDados() WIDTH 150
			STATUSITEM "Status: "+Iif( ServidorDeDados() == "SIM" , "SERVIDOR", "TERMINAL" ) WIDTH 115
			STATUSITEM "Usu�rio: " WIDTH 100	
			STATUSITEM "Rede: "+AllTrim( NetName() ) WIDTH 150	
			CLOCK
		END STATUSBAR


    DEFINE IMAGE Image_1
        ROW    50
        COL    10
        WIDTH  840
        HEIGHT 530
        PICTURE "fondo.JPG"
        HELPID Nil
        VISIBLE .T.
        STRETCH .T.
        ACTION Nil
    END IMAGE

	 	 @380,010 LABEL Label_Mensagens	;
			   VALUE "Linha Livre para Mensagens do Sistema";
			   WIDTH 550		;
			   HEIGHT 25		;
			   FONT "Arial" SIZE 08	;
         BACKCOLOR GRAY 	;
         FONTCOLOR WHITE BOLD	

		@ 004,005 BUTTON Bt_Clientes		;
				 PICTURE 'IMAGES\CLIENTES.BMP'	;
				 ACTION  Clientes()	;
				 WIDTH 40 HEIGHT 27	;
				 TOOLTIP 'Cadastro dos Cientes'

		@ 004,045 BUTTON Bt_Fornecedores		;
				 PICTURE 'IMAGES\Forneced.BMP'	;
				 ACTION  Fornecedores()	;
				 WIDTH 40 HEIGHT 27	;
				 TOOLTIP 'Cadastro dos Fornecedores'

		@ 004,085 BUTTON Bt_Pagar		;
				 PICTURE 'IMAGES\Pagar.BMP'		;
				 ACTION ContasPagar()	;
				 WIDTH 40 HEIGHT 27	;
				 TOOLTIP 'Arquivo de Contas � Pagar'

		@ 004,125 BUTTON Bt_Receber		;
				 PICTURE 'IMAGES\Receber.BMP'	;
				 ACTION  ContasReceber()	;
				 WIDTH 40 HEIGHT 27	;
				 TOOLTIP 'Arquivo de Contas � Receber'

		@ 004,165 BUTTON Bt_Tabelas_Grupos  ;
				 PICTURE 'IMAGES\Grupos.BMP';
				 ACTION  CadastroGenerico( "Grupos" ,  "Grupos de Contas") ;
				 WIDTH 40 HEIGHT 27 ;
				 TOOLTIP 'Cadastro dos Grupos de Contas'        
  
		@ 004,205 BUTTON Bt_Tabelas_Contas  ;
				 PICTURE 'IMAGES\Tipos.BMP';
				 ACTION  CadastroGenerico( "Contas" ,  "Contas Financeiras") ;
				 WIDTH 40 HEIGHT 27 ;
				 TOOLTIP 'Cadastro das Contas Financeiras'

		@ 004,245 BUTTON Bt_Tabelas_Custos  ;
				 PICTURE 'IMAGES\Custos.BMP';
				 ACTION  CadastroGenerico( "Custos" ,  "Centros de Custo") ;
				 WIDTH 40 HEIGHT 27 ;
				 TOOLTIP 'Cadastro dos Centros de Custo'          

		@ 004,510 BUTTON Bt_Acesso			;
				 PICTURE 'IMAGES\Acesso.BMP'		;
				 ACTION  AcessoAoSistema()	;
				 WIDTH 40 HEIGHT 27	;
				 TOOLTIP 'Trocar Usu�rio Ativo'         

		@ 004,550 BUTTON Bt_Sair;
				 PICTURE 'IMAGES\SAIR.BMP';
				 ACTION  Confirmar_Saida();
				 WIDTH 40 HEIGHT 27	;
				 TOOLTIP 'Sair do Sistema'   
  
		@ 004,590 BUTTON Bt_Help;
				 PICTURE 'IMAGES\HELP.BMP';
				 ACTION  Sobre_o_Sistema();
				 WIDTH 40 HEIGHT 27	;
				 TOOLTIP 'Sobre o Sistema'	               

		*** Links ***
		    
	END WINDOW	

	Form_0.Label_Mensagens.Visible := .F.

	CENTER WINDOW Form_0

	MAXIMIZE WINDOW Form_0

	ACTIVATE WINDOW Form_0
Return Nil					

*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Fun��o		: Ambiente_Inicial()
* Finalidade	: Quando o Aplicativo � iniciado, automaticamente � desviado para esta fun��o atrav�s da Cl�usula
*		: ON INIT definida no Form_0 .
*		: Nesta fun��o o sistema verifica se o aplicativo foi desligado corretamente.
*		: Esta verifica��o s� ocorre se a C�pia estiver configurada como Servidor=SIM no arquivo FINANC.INI
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function Ambiente_Inicial()		

	If ServidorDeDados() == "SIM"  .And.  Saida_Irregular() != "SIM" 

		LinhaDeStatus('Sa�da Irregular do Sistema!!')

		If  MsgYesNo(PadC("*** Core Controle v.1.0 ***",60)+QUEBRA+;
			PadC(" ",30)+QUEBRA+;
			PadC(" *** Sa�da Irregular do Sistema ***",60)+QUEBRA+;
			PadC(" ",30)+QUEBRA+;
			PadC(" O Sistema n�o foi Desligado Corretamente!!",60)+QUEBRA+;
			PadC(" � aconselh�vel efetuar a Indexa��o do Sistema!!",60)+QUEBRA+;
			PadC("",60) , SISTEMA )		
			
			AcessoOpen()			

			Indexa()	

			LinhaDeStatus()

		EndIf		

	EndIf

	Status_Entrada_Saida("NAO")

	AcessoAoSistema()
	
Return Nil
/*
*/
Function Confirmar_Saida()
	If MSGYesNo( "Confirma Sa�da do Sistema??" , SISTEMA )
	   Form_0.Release
	EndIf
	Return Nil

/*
*/
Function Abandona_Sistema()
             Status_Entrada_Saida("SIM")
             Close All	
             Return Nil
/*
*/
Function Sobre_o_Sistema()
         PlayExclamation()
         MsgINFO (PadC("*** Baseado no Sistema Controle Financeiro V.1.0 ***",60)+QUEBRA+;
                  PadC(" Sistema Freeware - Contribui��o ao Projeto Harbour/MiniGUI",60)+QUEBRA+;
                  PadC(" ",30)+QUEBRA+;
                  PadC(" Humberto Fornazier  hfornazier@brfree.com.br",60), SISTEMA)
Return NIL
/*
*/
static procedure ajustar
	Main.image_1.row	:= 70
	Main.image_1.col	:= 0
	Main.image_1.width	:= Main.Width
	Main.image_1.height	:= Main.Height-175
	Main.Label_1.Row	:= Main.Image_1.row + Main.Image_1.Height
	Main.Label_1.Col	:= 0
	Main.Label_1.Width	:= Main.Image_1.Width
	Main.Label_1.Value	:= "Usuario : "+oUser:cName
return

*---------------------------------------------------------------------------------------- Prgs --------------------------------------------------------------------------------*
