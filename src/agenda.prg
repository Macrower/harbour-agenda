PROCEDURE Main()

   LOCAL opcao

   SET COLOR TO W+/B

   IF !File("contatos.dbf")
      criaBanco()
   ENDIF

   USE contatos NEW

   DO WHILE .T.

      opcao := menuPrincipal()

      DO CASE
         CASE opcao == 1
            adicionar()

         CASE opcao == 2
            listar()

         CASE opcao == 3
            excluir()

         CASE opcao == 4
            EXIT
      ENDCASE

   ENDDO

RETURN

FUNCTION menuPrincipal()

   LOCAL op := 1
   LOCAL tecla

   DO WHILE .T.

      CLS

      @ 1,20 SAY "AGENDA DE CONTATOS"
      @ 3,10 TO 12,60 DOUBLE

      menuItem(5,20,"Adicionar contato",op==1)
      menuItem(6,20,"Listar contatos",op==2)
      menuItem(7,20,"Excluir contato",op==3)
      menuItem(8,20,"Sair",op==4)

      tecla := INKEY(0)

      DO CASE
         CASE tecla == 5
            op--
         CASE tecla == 24
            op++
         CASE tecla == 13
            RETURN op
      ENDCASE

      IF op < 1
         op := 4
      ENDIF

      IF op > 4
         op := 1
      ENDIF

   ENDDO

RETURN op

PROCEDURE menuItem(l,c,texto,ativo)

   IF ativo
      SET COLOR TO N/W
   ELSE
      SET COLOR TO W+/B
   ENDIF

   @ l,c SAY texto

   SET COLOR TO W+/B

RETURN

PROCEDURE criaBanco()

   LOCAL aStruct := {}

   AADD(aStruct, {"NOME","C",40,0})
   AADD(aStruct, {"TELEFONE","C",20,0})

   DBCREATE("contatos.dbf", aStruct)

RETURN

PROCEDURE adicionar()

   LOCAL nome := SPACE(40)
   LOCAL telefone := SPACE(20)

   CLS

   @ 2,20 SAY "NOVO CONTATO"
   @ 4,10 TO 10,70 DOUBLE

   @ 6,15 SAY "Nome:"
   @ 6,25 GET nome

   @ 7,15 SAY "Telefone:"
   @ 7,25 GET telefone

   READ

   APPEND BLANK
   REPLACE nome WITH nome
   REPLACE telefone WITH telefone

RETURN

PROCEDURE listar()

   CLS

   ? "LISTA DE CONTATOS"
   ?
   ? "ID  NOME                                   TELEFONE"
   ? "---------------------------------------------------------"

   GO TOP

   DO WHILE !EOF()

      ?? STR(RECNO(),4), " "
      ?? PADR(nome,40), " "
      ?? telefone

      ?
      SKIP

   ENDDO

   ?
   WAIT "Pressione uma tecla..."

RETURN


PROCEDURE excluir()

   LOCAL n := 0

   listar()

   @ 20,0 SAY "Numero do registro para excluir: " GET n
   READ

   IF n > 0 .AND. n <= LASTREC()

      GO n

      IF !DELETED()

         IF confirma("Deseja realmente excluir este contato?")
            DELETE
            PACK
            ? "Contato excluido."
         ELSE
            ? "Operacao cancelada."
         ENDIF

      ELSE
         ? "Registro ja estava excluido."
      ENDIF

   ELSE
      ? "Registro invalido."
   ENDIF

   INKEY(2)

RETURN

FUNCTION confirma(texto)

   LOCAL resp := "N"

   @ 10,20 TO 14,60 DOUBLE
   @ 11,25 SAY texto
   @ 12,25 SAY "Confirmar (S/N): " GET resp
   READ

RETURN UPPER(resp) == "S"