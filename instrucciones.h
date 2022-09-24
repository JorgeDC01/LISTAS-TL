/*
	EL presente fichero se encarga de traducir los programas del lenguaje LISTAS a C++.
	Autores: Jorge del Castillo Gómez y Raúl Hormigo Cerón.
*/

#ifndef INSTRUCCIONES_H_
#define INSTRUCCIONES_H_

#include <iostream>
#include <cstring>
#include "symbols.h"

using std::cout;
using std::endl;
using std::string;

const int MAX_CUSTOM_LENGTH = 200;                         // Tamaño máximo de las cadenas escritas entre comillas.

typedef char cadena_escribir [MAX_CUSTOM_LENGTH];          // Mantiene las cadenas escritas entre comillas.

/*
	PRE = {str != nullptr}
  POST = {strlen (str) < strlen (str_original)}
  Descripción: Elimina los caracteres " de la cadena dada por parámetro.
  Complejidad: O(n) -> n = strlen (str)
  Parámetros:
    str: char* -> Cadena de caracteres a la que se le eliminarán las comillas dobles.
*/

void removeChar (char *str);


/*
  PRE = {traduccion != nullptr}
  POST = {traducirBooleano == "cierto" || traducirBooleano == "falso"}
  Descripción: Devuelve una traducción del valor booleano del parámetro a std::string.
  Complejidad: O(1).
  Parámetros:
    traduccion: bool -> Parámetro que será traducido a std::string.
*/

string traducirBooleano (bool traduccion);


/*
  PRE = {lista != nullptr && valorResultante != nullptr && 0 < posicion >= lista.n_elems_lista}
  POST = {(valorResultante != nullptr && funcionesEspeciales == false) || valorResultante == true}
  Descripción: Ejecuta las funciones "primero (Lista)", "ultimo (Lista)" y "enesimo (Lista)" dependiendo
               del parámetro "posicion".
  Complejidad: O(1).
  Parámetros:
    lista: vectorLista -> La lista sobre la que se ejecutará la función.
    valorResultante: elem_lista& -> Elemento de la lista que contendrá el resultado de la función.
    posicion: int -> Indica la función que se ejecutará sobre la lista.
*/

bool funcionesEspeciales (vectorLista lista, elem_lista &valorResultante, int posicion);


/*
  PRE = {sg != nullptr && cadena != nullptr && bandera != nullptr && n_lineas != nullptr}
  POST = {bandera = expresión dentro de if con variable}
  Descripción: Permite evaluar qué parte del condicional se ejecutará
  Complejidad: O(1).
  Parámetros:
    sg: symbolsGroup& -> Tabla de Símbolos donde se encontrará la variable a evaluar.
    cadena: cadena_escribir -> Cadena que contiene el nombre de la variable.
    bandera: bool& -> Bandera que indica el resultado de la expresión booleana.
    n_lineas: int -> Indica el número de linea donde se encuentra la instrucción.
*/

void evaluarCondicional (symbolsGroup &sg, cadena_escribir cadena, bool &bandera, int n_lineas);


/*
  PRE = {yyout != nullptr}
  POST = {}
  Descripción: Muestra el código en C++ que debe escribirse antes de ejecutar el módulo "parse ()".
  Complejidad: O(1).
  Parámetros:
    yyout: FILE* -> Flujo del fichero de salida.
*/

void codigo_c_antes (FILE *yyout);


/*
  PRE = {yyout != nullptr}
  POST = {}
  Descripción: Muestra el código en C++ que debe escribirse después de ejecutar el módulo "parse ()".
  Complejidad: O(1).
  Parámetros:
    yyout: FILE* -> Flujo del fichero de salida.
*/

void codigo_c_despues (FILE *yyout);


/*
  PRE = {yyout != nullptr}
  POST = {}
  Descripción: Permite ejecutar la función "NuevaLinea" en el fichero de salida.
  Complejidad: O(1).
  Parámetros:
    yyout: FILE* -> Flujo del fichero de salida.
*/

void funcionNuevaLinea (FILE *yyout);


/*
  PRE = {cadena != nullptr && yyout != nullptr}
  POST = {}
  Descripción: Permite ejecutar la función "Escribir" en el fichero de salida.
  Complejidad: O(1).
  Parámetros:
    cadena: cadena_escribir -> Cadena a mostrar por pantalla.
    yyout: FILE* -> Flujo del fichero de salida.
*/

void funcionEscribir (cadena_escribir cadena, FILE *yyout);


/*
  PRE = {lista != nullptr}
  POST = {cadena = lista.nodos}
  Descripción: Copia el contenido de la lista en la cadena.
  Complejidad: O(n) -> n = lista.n_elems_lista.
  Parámetros:
    lista: vectorLista -> Lista cuyo contenido será formateado a la cadena.
    cadena: escribir_cadena -> Cadena que mantendrá el contenido de la cadena.
*/

void copiarLista (cadena_escribir cadena, vectorLista lista);

#endif