/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_SINTACTICO_H_INCLUDED
# define YY_YY_SINTACTICO_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    TK_LISTAS = 258,
    TK_VARIABLES = 259,
    TK_CODIGO = 260,
    TK_FIN = 261,
    VL_BOOLEAN = 262,
    VL_REAL = 263,
    VL_ENTERO = 264,
    ID = 265,
    NOM_LISTA = 266,
    OP_ASIGNACION = 267,
    OP_MENOR_IGUAL = 268,
    OP_MAYOR_IGUAL = 269,
    OP_IGUAL_IGUAL = 270,
    OP_DISTINTO = 271,
    OP_AND = 272,
    OP_OR = 273,
    OP_NOT = 274,
    OP_SUMA = 275,
    OP_DIFERENCIA = 276,
    OP_MULT = 277,
    OP_DIV = 278,
    OP_MOD = 279,
    OP_RANGO = 280,
    TP_ENTERO = 281,
    TP_REAL = 282,
    TP_LOGICO = 283,
    CADENA = 284,
    INS_ESCRIBIR = 285,
    INS_NUEVALINEA = 286,
    INS_PRIMERO = 287,
    INS_ULTIMO = 288,
    INS_ENESIMO = 289,
    INS_IF = 290,
    INS_ELSE = 291,
    menos = 292,
    si_simple = 293,
    saltos_prio = 294
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 57 "sintactico.y"

      int c_entero;
      float c_real;
      char c_cadena[25];
      char comillas[200];
      bool c_boolean;
      struct {
        float valor;
        bool esReal;
      } c_expr;


#line 110 "sintactico.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_SINTACTICO_H_INCLUDED  */
