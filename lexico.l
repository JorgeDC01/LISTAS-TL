%{

// Fichero necesario para el análisis léxico del programa.
// Autores: Jorge Del Castillo Gómez y Raúl Hormigo Cerón.

#include <cstring>
#include "sintactico.h"

bool tipo_identificador;
bool dentroRango = false;
%}

%option noyywrap


digito	[0-9]

entero	{digito}+

realNotClasEnt {entero}[.]{digito}*
realNotClasDec {digito}*[.]{digito}+
realNotCienEnt {realNotClasEnt}[eE]{entero}
realNotCienDec {realNotClasDec}[eE]{entero}

identificador [a-z][a-zA-Z0-9_]*

nombre_lista [A-Z][A-Za-z0-9_]*

cadena ["][^"]*["]

%x COMENTARIOS
%x DENTRO_LISTA
%%

"#"							        BEGIN(COMENTARIOS);
<COMENTARIOS>\n 			        {BEGIN(0); return yytext [0];}
<COMENTARIOS>.                      ;

{cadena}                            {strcpy (yylval.comillas, yytext); return CADENA;}

LISTAS                              {tipo_identificador = true; return TK_LISTAS;}
VARIABLES                           {tipo_identificador = false; return TK_VARIABLES;}
INICIO                              {return TK_CODIGO;}
FIN                                 {return TK_FIN;}

Entero                              {return TP_ENTERO;}
Real                                {return TP_REAL;}
Logico                              {return TP_LOGICO;}

Escribir                            {return INS_ESCRIBIR;}
NuevaLinea                          {return INS_NUEVALINEA;}
primero                             {return INS_PRIMERO;}
ultimo                              {return INS_ULTIMO;}
enesimo                             {return INS_ENESIMO;}

Si                                  {return INS_IF;}
Si_no                               {return INS_ELSE;}

[<][-]                              {return OP_ASIGNACION;}
[<][=]                              {return OP_MENOR_IGUAL;}
[>][=]                              {return OP_MAYOR_IGUAL;}
[=][=]                              {return OP_IGUAL_IGUAL;}
[<][>]                              {return OP_DISTINTO;}
y                                   {return OP_AND;}
o                                   {return OP_OR;}
no                                  {return OP_NOT;}
[ ][.][.][ ]                        {dentroRango = true; return OP_RANGO;}
[+]                                 {return OP_SUMA;}
[-]                                 {return OP_DIFERENCIA;}
[*]                                 {return OP_MULT;}
[/]                                 {return OP_DIV;}
[%]                                 {return OP_MOD;}

cierto                              {yylval.c_boolean = true; return VL_BOOLEAN;}
falso                               {yylval.c_boolean = false; return VL_BOOLEAN;}

{realNotCienDec}                    {yylval.c_real = atof (yytext); return VL_REAL;}
{realNotCienEnt}                    {yylval.c_real = atof (yytext); return VL_REAL;}
{realNotClasDec}                    {yylval.c_real = atof (yytext); return VL_REAL;}
{realNotClasEnt}                    {yylval.c_real = atof (yytext); return VL_REAL;}

{entero}                            {yylval.c_entero = atoi (yytext); return VL_ENTERO;}

{identificador}                     {strcpy (yylval.c_cadena, yytext); return ID;}

{nombre_lista}                      {strcpy (yylval.c_cadena, yytext); return NOM_LISTA;}

[\t ]                               ;

\n                                  return '\n';

.                                   return (yytext[0]);
%%