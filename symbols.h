/*
	EL presente fichero se encarga de definir la Tabla de Símbolos del lenguaje LISTAS.
	Autores: Jorge del Castillo Gómez y Raúl Hormigo Cerón.
*/

#ifndef SYMBOLS_H_
#define SYMBOLS_H_

#include <iostream>
#include <string>
#include <fcntl.h>
#include <sys/types.h>
#include <unistd.h>

#include "Lists.h"

using namespace std;

const int NUM_MAX_VARS = 99;          // Número máximo de variables en el programa.

union var_value {
	int integer;
	float real;
	bool boolean;
	vectorLista lista;
};

struct symbol {
	characters idName;          // Nombre de la variable
	type_code type;             // Tipo del dato
	var_value valor;            // Valor del dato
};

typedef symbol Tvector [NUM_MAX_VARS];

struct symbolsGroup {
	Tvector vSymbols;
	int occupied;
};


/*
	PRE = {s != nullptr}
	POST = {s.occupied = 0}
	Descripción: Inicializa la Tabla de Símbolos con cero variables.
	Complejidad: O(1).
	Parámetros:
		s: symbolsGroup& -> La Tabla de Símbolos a inicializar.
*/

void iniciar (symbolsGroup &s);


/*
	PRE = {sg != nullptr && nombre != nullptr && type != nullptr && nuevoValor != nullptr}
	POST = {(sg.occupied++ && insert = false) || insert = true}
	Descripción: Inserta un nuevo símbolo en la Tabla de Símbolos. En caso de que ya exista, su valor se ve actualizado.
	Complejidad: O(1).
	Parámetros:
		sg: symbolsGroup -> La Tabla de Símbolos sobre la que se insertará una nueva variable o un nuevo valor.
		nombre: characters -> Nombre de la variable a insertar en la Tabla de Símbolos.
		type: type_code -> Tipo del símbolo a insertar.
		nuevoValor: var_value -> Valor del símbolo a insertar.
*/

bool insert (symbolsGroup &sg, characters nombre, type_code type, var_value nuevoValor);


/*
	PRE = {sg != nullptr && searchName != nullptr && retId != nullptr}
	POST = {(retId.idName != nullptr && searchVariable == false) || searchVariable == true}
	Descripción: Busca en la Tabla de Símbolos la variable dado su nombre y lo devuelve por el parámetro de salida
	             en caso de encontrarlo; devolviendo 'false'. Si no lo encuentra, devuelve 'true'.
	Complejidad: O(n) -> n = sg.occupied.
	Parámetros:
		sg: symbolsGroup& -> La Tabla de Símbolos sobre la que buscar.
		searchName: characters -> Nombre del símbolo a buscar.
		retId: symbol& -> Símbolo de salida una vez encontrado en la Tabla.
*/

bool searchVariable (symbolsGroup &sg, characters searchName, symbol &retId);


/*
	PRE = {code != nullptr}
	POST = {selectEnum != ""}
	Descripción: Devuelve la interpretación en std::string del tipo indicado por parámetro.
	Complejidad: O(1).
	Parámetros:
		code: type_code -> El tipo a imprimir por pantalla.
*/

string selectEnum (type_code code);

/*
	PRE = {sg != nullptr && fd_out != nullptr}
	POST = {}
	Descripción: Muestra la Tabla de Símbolos por el flujo de salida indicado.
	Complejidad: O(1).
	Parámetros:
		sg: symbolsGroup& -> La Tabla de Símbolos a mostrar por pantalla.
		fd_out: int -> El flujo de salida por el que imprimir los mensajes.
*/

void showIDs (symbolsGroup &sg, int fd_out);


/*
	PRE = {sg != nullptr}
	POST = {}
	Descripción: Muestra la Tabla de Símbolos por pantalla
	Complejidad: O(1).
	Parámetros:
		sg: symbolsGroup& -> La Tabla de Símbolos a mostrar por pantalla.
*/

void showID2s (symbolsGroup &sg);


/*
	PRE = {sg != nullptr && nombre_var_eliminar != nullptr}
	POST = {(sg.occupied-- && eliminaSimbolo = false) || eliminaSimbolo = true}
	Descripción: Elimina la variable de la Tabla de Símbolos dado su nombre, en caso de que exista.
	             Si la elimina, devolverá 'false'. Si no la encuentra, devolverá 'true'.
	Complejidad: O(n) -> n = sg.occupied.
	Parámetros:
		sg: symbolsGroup -> La Tabla de Símbolos de la que una variable podría ser eliminada.
		nombre_var_eliminar: characters -> El nombre de la variable que será eliminada de la Tabla de Símbolos.
*/

bool eliminaSimbolo (symbolsGroup &sg, characters nombre_var_eliminar);

#endif