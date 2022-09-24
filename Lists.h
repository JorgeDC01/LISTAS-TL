/*
    El presente fichero ser encarga de definir el concepto de "lista" y de "conjunto de listas" dentro del contexto
    del lenguaje LISTAS.
    Autores: Jorge del Castillo Gómez y Raúl Hormigo Cerón.
*/

#ifndef LISTS_H
#define LISTS_H

#include <fcntl.h>
#include <sys/types.h>
#include <unistd.h>
#include <iostream>
#include <cstring>

const int MAX_NOMB_LISTA = 25;          // Número máximo de caracteres del nombre de una lista.
const int MAX_ELEMS_LISTA = 50;         // Numero máximo de elementos que puede haber en una lista.
const int MAX_NUM_LISTAS = 20;          // Número máximo de listas de un programa.

typedef char characters [MAX_NOMB_LISTA];

union elem_lista {
	int integer;
	float real;
	bool boolean;
    characters identifiers;
};

typedef union elem_lista IVector [MAX_ELEMS_LISTA];

enum type_code {
	e_integer =  0,
	e_real    =  1,
	e_boolean =  2,
	e_chars   =  3,
    e_list    =  4
};

struct vectorLista {
    int n_elems_lista;                  // Número de elementos de una lista.
    characters nombre_lista;            // Nombre que recibe la lista.
    type_code tipo_elemento;            // Tipo de los elementos que forman la lista.
    IVector nodos;                      // Elementos que constituyen la lista
};

struct cjtoListas {                     //Conjunto de listas del traductor.
    int n_listas;
    vectorLista secListas [MAX_NUM_LISTAS];
};


/*
    PRE = {}
    POST = {listas.n_listas == 0}
    Descripción: Inicializa el conjunto de listas a cero.
    Complejidad: O(1).
    Parámetros:
        listas: cjtoListas& -> Conjunto de Listas a ser inicializado.
*/

void iniciarCjtoListas (cjtoListas &listas);


/*
    PRE = {listas != nullptr && nuevaLista != nullptr}
    POST = {(listas.n_listas++ && insertarLista == false) || (insertarLista == true)}
    Descripción: Inserta una nueva lista en el conjunto de listas en caso de que no exista.
                 Si la lista ya existe, indicará un error semántico.
    Complejidad: O(n) -> n = listas.n_listas
    Parámetros:
        listas: cjtoListas& -> Conjunto de Listas al que se le podría insertar una nueva lista.
        nuevaLista: vectorLista -> Nueva lista a insertar en el Conjunto de Listas.
*/

bool insertarLista (cjtoListas &listas, vectorLista nuevaLista);


/*
    PRE = {listas != nullptr && nombre != nullptr && listaSalida == nullptr}
    POST = {(listaSalida != nullptr && buscaLista = false) || buscaLista == true}
    Descripción: Devuelve por el parámetro de entrada-salida la lista identificada por el nombre,
                 siempre que exista; y devuelve 'false'.
                 En caso de que no exista, el módulo devuelve 'true'.
    Complejidad: O(n) -> n = listas.n_listas.
    Parámetros:
        listas: cjtoListas& -> Conjunto de Listas sobre el que buscar la lista.
        nombre: characters -> Nombre de la lista a buscar.
        listaSalida: vectorLista& -> Lista sobre la que se asignará la lista encontrada, en caso de que exista.
*/

bool buscaLista (cjtoListas &listas, characters nombre, vectorLista &listaSalida);


/*
    PRE = {conjunto != nullptr}
    POST = {}
    Descripción: Muestra por pantalla todas las listas almacenadas en el conjunto.
    Complejidad: O(n) -> n = conjunto.n_listas.
    Parámetros:
        conjunto: cjtoListas -> Conjunto de Listas a mostrar por pantalla.
*/

void mostrarCjtoLista (cjtoListas conjunto);


/* -----------------------------------FUNCIONES PARA UNA ÚNICA LISTA -----------------------------------*/


/*
    PRE = {lista != nullptr}
    POST = {lista.n_elems_lista == 0}
    Descripción: Inicializa la lista sin ningún elemento.
    Complejidad: O(1).
    Parámetros:
        lista: vectorLista& -> Lista a ser inicializada.
*/
void iniciarVectorLista (vectorLista &lista);


/*
    PRE = {lista != nullptr && dato != nullptr && tipo != nullptr}
    POST = {(lista.n_elems_lista++ && insertarENLista == false) || insertarENLista == true}
    Descripción: Inserta un nuevo elemento en la lista. En caso de que el tipo del nuevo elemento
                 no coincida con el tipo de los elementos de la lista, indica un error semántico.
    Complejidad: O(1).
    Parámetros:
        lista: vectorLista& -> Lista sobre la que se podría insertar un nuevo elemento.
        dato: elem_lista -> Nuevo dato a insertar en la lista.
        tipo: type_code -> Indica el tipo del dato a insertar.
*/

bool insertarENLista (vectorLista &lista, elem_lista dato, type_code tipo);


/*
    PRE = {lista != nullptr}
    POST = {estaVacia = true || estaVacia = false}
    Descripción: Indica si la lista dada por parámetro está vacía.
    Complejidad: O(1).
    Parámetros:
        lista: vectorLista -> Lista a indicar si está o no vacía.
*/

bool estaVacia (vectorLista lista);


/*
    PRE = {lista != nullptr}
    POST = {}
    Descripción: Muestra por pantalla los elementos de la lista dada.
    Complejidad: O(n) -> n = lista.n_elems_lista.
    Parámetros:
        lista: vectorLista -> Lista a mostrar por pantalla.
*/

void mostrarLista (vectorLista lista);


/*
    PRE = {lista != nullptr && nombre != nullptr}
    POST = {lista.nombre_lista = nombre}
    Descripción: Actualiza el nombre de la lista con el nuevo nombre dado.
    Complejidad: O(1).
    Parámetros:
        lista: vectorLista& -> Lista a la que se cambiará el nombre.
        nombre: characters -> Nuevo nombre a asignar a la lista.
*/

void cambiarNombreLista (vectorLista &lista, characters nombre);


/*
    PRE = {lista != nullptr && inicio < final}
    POST = {(lista.n_elems_lista += final - inicio && crearListaRangos = false) || crearListaRangos = true}
    Descripción: Crea una lista nueva dados los límites del rango.
    Complejidad: O(n) -> n = final - inicio
    Parámetros:
        lista: vectorLista& -> Nueva lista a crear por rangos.
        inicio: int -> Indica el inicio del rango.
        final: int -> Indica el final del rango.
*/

bool crearListaRangos (vectorLista &lista, int inicio, int final);

#endif