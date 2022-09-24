/*
	EL presente fichero se encarga de otorgar funcionalidad a la traducción del lenguaje LISTAS a C++.
	Autores: Jorge del Castillo Gómez y Raúl Hormigo Cerón.
*/

#include "instrucciones.h"

void removeChar (char *str) {
    int i, j;
    int len = strlen (str);
    for (i = 0; i < len; i++) {
        if (str [i] == '"') {
            for (j = i; j < len; j++) {
                str [j] = str [j + 1];
            }
            len--;
            i--;
        }
    }
}

string traducirBooleano (bool traduccion) {
    string resultado;
    if (traduccion) {
        resultado = "cierto";
    }
    else {
        resultado = "falso";
    }
    return resultado;
}

bool funcionesEspeciales (vectorLista lista, elem_lista &valorResultante, int posicion) {
    bool error = false;
    if (posicion <= lista.n_elems_lista && posicion > 0) {
        if (lista.tipo_elemento == e_chars) {
            strcpy (valorResultante.identifiers, lista.nodos [posicion - 1].identifiers);
        }
        else {
            valorResultante = lista.nodos [posicion - 1];
        }
    }
    else {
        error = true;
    }
    return error;
}

void evaluarCondicional (symbolsGroup &sg, cadena_escribir cadena, bool &bandera, int n_lineas) {
        symbol aux;
        if (searchVariable (sg, cadena, aux)) {
            if (aux.type == e_boolean) {
                    bandera = aux.valor.boolean;
            }
            else { 
                cout << "Error semántico en la línea " << n_lineas << ". La variable " << cadena << " no es de tipo booleano." << endl;
            }
        }
        else {
            cout << "Error semántico en la línea " << n_lineas << ". La variable " << cadena << " no ha sido previamente declarada." << endl;
        }
}

void codigo_c_antes (FILE *yyout) {
    fprintf (yyout, "#include <iostream>");
    fprintf (yyout, "\n\n");
    fprintf (yyout, "using namespace std;");
    fprintf (yyout, "\n\n");
    fprintf (yyout, "int main () {");
    fprintf (yyout, "\n\n");
    fprintf (yyout, "\t// Inicio del bloque de código");
    fprintf (yyout, "\n");
}


void codigo_c_despues (FILE *yyout) {
    fprintf (yyout, "\n");
    fprintf (yyout, "\t// Final del bloque de código");
    fprintf (yyout, "\n");
    fprintf (yyout, "\n");
    fprintf (yyout, "\treturn 0;");
    fprintf (yyout, "\n");
    fprintf (yyout, "}");
}

void funcionEscribir (cadena_escribir cadena, FILE *yyout) {
    if (cadena [0] == '"') {
        removeChar (cadena); //Quita las comillas de la cadena en caso de que empiece con ellas.
    }
    fprintf (yyout, "\tcout << \"%s\";\n", cadena);
}

void funcionNuevaLinea (FILE *yyout) {
    fprintf (yyout, "\tcout << endl;\n");
}

void copiarLista (cadena_escribir cadena, vectorLista lista) {
    elem_lista aux;
    strcpy (cadena, "");
    int length = 0;
    if (lista.n_elems_lista > 0) {
        for (int i = 0; i < lista.n_elems_lista; i++) {
            aux = lista.nodos [i];
            switch (lista.tipo_elemento) {
                case e_boolean:
                    strcat (cadena, traducirBooleano (aux.boolean).c_str ());
                break;
                case e_chars:
                    strcat (cadena, aux.identifiers);
                break;
                case e_integer:
                    strcat (cadena, to_string (aux.integer).c_str ());
                break;
                case e_real:
                    strcat (cadena, to_string (aux.real).c_str ());
                break;
            }
            strcat (cadena, " ");
        }
        length = strlen (cadena);
        cadena [length - 1] = '\0';
    }
}