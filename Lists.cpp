/*
    El presente fichero se encarga de otorgar funcionalidad a las listas y al conjunto de listas del
    lenguaje LISTAS.
    Autores: Jorge del Castillo Gómez y Raúl Hormigo Ceron.
*/

#include "Lists.h"

using std :: cout;
using std :: endl;

void iniciarCjtoListas (cjtoListas &listas) {
    listas.n_listas = 0;
}

bool insertarLista (cjtoListas &listas, vectorLista nuevaLista) {
    bool error = false;
    for (int i = 0; i < listas.n_listas && !error; i++) {
        if (strcmp (nuevaLista.nombre_lista, listas.secListas [i].nombre_lista) == 0) {
            error = true;
        }
    }
    if (!error) {
        listas.secListas [listas.n_listas] = nuevaLista;
        listas.n_listas++;
    }
    return error;
}

bool buscaLista (cjtoListas &listas, characters nombre, vectorLista &listaSalida) {
    bool error = false;
    bool encontrada = false;
    for (int i = 0; (i < listas.n_listas) && (!encontrada); i++) {
        if (strcmp (nombre, listas.secListas [i].nombre_lista) == 0) {
            listaSalida = listas.secListas [i];
            encontrada = true;
        }
    }
    if (!encontrada) {
        error = true; //La lista no ha sido encontrada, por lo que no está declarada y es un error semántico.
    }
    return error;
}

void mostrarCjtoLista (cjtoListas conjunto) {
    if (conjunto.n_listas > 0) {
        cout << "\nCONJUNTO DE LISTAS" << endl;
        for (int i = 0; i < conjunto.n_listas; i++) {
            mostrarLista (conjunto.secListas [i]);
            cout << endl;
        }
    }
}


/* -----------------------------------FUNCIONES PARA UNA ÚNICA LISTA -----------------------------------*/


void iniciarVectorLista (vectorLista &lista) {
    lista.n_elems_lista = 0;
}

bool insertarENLista (vectorLista &lista, elem_lista dato, type_code tipo) {
    bool error = false;
    if (!estaVacia (lista)) {
        if (lista.tipo_elemento == tipo) {
            switch (tipo) {
                case e_chars:
                    strcpy (lista.nodos [lista.n_elems_lista].identifiers, dato.identifiers);
                break;
                case e_integer:
                    lista.nodos [lista.n_elems_lista].integer = dato.integer;
                break;
                case e_real:
                    lista.nodos [lista.n_elems_lista].real = dato.real;
                break;
                case e_boolean:
                    lista.nodos [lista.n_elems_lista].boolean = dato.boolean;
                break;
            }
            lista.n_elems_lista++;
        }
        else {
            error = true;           // Error semantico porque los tipos no coinciden
        }
    }
    else {
        switch (tipo) {
            case e_chars:
                strcpy (lista.nodos [lista.n_elems_lista].identifiers, dato.identifiers);
                lista.tipo_elemento = e_chars;
            break;
            case e_integer:
                lista.nodos [lista.n_elems_lista].integer = dato.integer;
                lista.tipo_elemento = e_integer;
            break;
            case e_real:
                lista.nodos [lista.n_elems_lista].real = dato.real;
                lista.tipo_elemento = e_real;
            break;
            case e_boolean:
                lista.nodos [lista.n_elems_lista].boolean = dato.boolean;
                lista.tipo_elemento = e_boolean;
            break;
        }
        lista.n_elems_lista++;
    }
    return error;
}

bool estaVacia (vectorLista lista) {
    return lista.n_elems_lista == 0;
}

void mostrarLista (vectorLista lista) { 
    cout << "Lista " << lista.nombre_lista << ": ";
    switch (lista.tipo_elemento) {
        case e_chars:
            for (int i = 0; i < lista.n_elems_lista; i++) {
                printf ("%s ", lista.nodos [i].identifiers);
            }
        break;
        case e_integer:
            for (int i = 0; i < lista.n_elems_lista; i++) {
                cout << lista.nodos [i].integer << " ";
            }
        break;
        case e_real:
            for (int i = 0; i < lista.n_elems_lista; i++) {
                cout << lista.nodos [i].real << " ";
            }
        break;
        case e_boolean:
            for (int i = 0; i < lista.n_elems_lista; i++) {
            if (lista.nodos[i].boolean) {
                cout << "cierto" << " ";
            }
            else {
                cout << "falso" << " ";
            }
        }
        break;
    }
}

void cambiarNombreLista (vectorLista &lista, characters nombre) {
    strcpy (lista.nombre_lista, nombre);
}

bool crearListaRangos (vectorLista &lista, int inicio, int final) {
    bool error = false;
    union elem_lista aux;
    if (inicio < final) {
        for (int i = inicio; i <= final; i++) {
            aux.integer = i;
            insertarENLista (lista, aux, e_integer);
        }
    }
    else {
        error = true;
    }
    return error;
}