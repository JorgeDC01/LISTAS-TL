%{

// Fichero necesario para el análisis sintáctico del programa.
// Autores: Jorge del Castillo Gómez y Raúl Hormigo Cerón.

#include <string.h>

#include "symbols.h"
#include "instrucciones.h"

using namespace std;

// Elementos externos al analizador sintáctico del léxico

extern bool tipo_identificador;	        // Si el identificador aparece en el bloque de listas, entonces es un elemento de una lista (true). 
                                        // Si aparece en el bloque de codigo (false).

extern bool dentroRango;                // Indica con valor a 'true' cuándo está dentro de una lista formada por un rango. En cualquier otro caso, valdrá 'false'.

extern int yylex ();

extern FILE* yyin;                      // Indica el fichero de entrada desde el que se lee el programa.
extern FILE* yyout;                     // Indica el fichero de salida hacia el que se escribe el programa de salida.



symbolsGroup sg;                        // Tabla de símbolos

cjtoListas conjunto_Listas;             // Conjunto de listas del programa
vectorLista listaAuxiliar;              // Lista auxiliar que almacena de forma temporal los elementos de una lista.

union elem_lista elementoSalida;        // Elemento de lista que guarda los resultados de las instrucciones especiales.
union var_value guardadoTemporal;       // Guarda temporalmente el tipo del valor con el que se trabaja. Se utiliza para interpretar correctamente cada tipo de dato.

bool errorSemantico = false;            // Utilizada para indicar cuándo se produce un error semántico en el lenguaje.
bool errorLocal = false;                // Utilizada para indicar cuándo se produce un error semántico durante la creación de una lista.
bool dentroEscribir = false;            // Indica cuándo un identificador está dentro de una instrucción 'Escribir'.
bool flagIf = true;                     // Es una bandera que indica qué cuerpo del if se ejecuta. Vale 'true' cuando se refiere a la parte del 'if', y 'false' cuando se refiere a la parte del 'else'.

enum type_code tipo_elem_lista;         // Variable auxiliar que almacena temporalmente el tipo de dato que se lee: entero,real,identificador,booleano.
enum type_code tipoTemporal;            // Variable auxiliar que almacenará el tipo de las variables declaradas en la sección VARIABLES de forma temporal,

characters nombreTemporal;              // Almacena temporalmente el nombre de una lista para su posterior búsqueda en declaración de variables de la sección VARIABLES.
cadena_escribir cadenaAuxiliar;         // Cadena que almacena temporalmente aquello que se escribirá con la función 'Escribir ()'.

int enteroAux;                          // Permite indicar qué instrucción sobre listas se debe ejecutar.
int n_lineas;                           // Permite indicar en qué linea de código .list nos encontramos.
int numeroSaltos = 0;                   // Permite saber el número de saltos que se realizan después de un error semántico en las producciones de asignación. 
                                        // Con esta variable, conseguimos que el numero de linea no parezca que se incremente por los saltos antes de realizar las comprobaciones semánticas. 

characters nombreVariable;              // Se encarga de almacenar temporalmente el nombre de una variable para asegurarse que no se producen errores sintácticos tras su declaración.

void yyerror (const char* s) {cout << "ERROR SINTÁCTICO EN LA LINEA " << n_lineas << endl;}

%}

%union {
      int c_entero;
      float c_real;
      char c_cadena[25];
      char comillas[200];
      bool c_boolean;
      struct {
        float valor;
        bool esReal;
      } c_expr;

}

%start inicio
%token TK_LISTAS TK_VARIABLES TK_CODIGO TK_FIN VL_BOOLEAN VL_REAL VL_ENTERO ID NOM_LISTA
%token OP_ASIGNACION OP_MENOR_IGUAL OP_MAYOR_IGUAL OP_IGUAL_IGUAL OP_DISTINTO OP_AND OP_OR OP_NOT OP_SUMA OP_DIFERENCIA
%token OP_MULT OP_DIV OP_MOD OP_RANGO TP_ENTERO TP_REAL TP_LOGICO CADENA INS_ESCRIBIR INS_NUEVALINEA INS_PRIMERO INS_ULTIMO
%token INS_ENESIMO INS_IF INS_ELSE

%type <c_cadena> ID NOM_LISTA instrucciones_especiales
%type <comillas> CADENA
%type <c_entero> VL_ENTERO
%type <c_real> VL_REAL
%type <c_boolean> VL_BOOLEAN
%type <c_expr> expr_a
%type <c_boolean> expr_b
%type <tipoElemento> elem_Lista

%left OP_RANGO
%left OP_OR
%left OP_AND
%left OP_IGUAL_IGUAL OP_DISTINTO
%left '<' '>' OP_MENOR_IGUAL OP_MAYOR_IGUAL
%left OP_SUMA OP_DIFERENCIA
%left OP_MULT OP_DIV OP_MOD 
%left menos si_simple saltos_prio
%left OP_NOT

%%

inicio: saltos_opc bl_Listas bl_Variables bl_Codigo saltos_opc          {errorSemantico = false;}
        ;

bl_Listas: TK_LISTAS saltos_obl sec_Listas                              {errorSemantico = false;}
        ;

bl_Variables: TK_VARIABLES saltos_obl sec_Variables                     {errorSemantico = false;}
        ;

bl_Codigo: TK_CODIGO saltos_obl sec_Instrucciones TK_FIN                {errorSemantico = false;}
        ;

sec_Listas:
        | sec_Listas def_Lista saltos_obl                               {errorSemantico = false;}
        ;

sec_Variables:                                                          {errorSemantico = false;}
        | sec_Variables def_Variable                                    {errorSemantico = false;}
        ;

sec_Instrucciones: def_Instruccion                                      {errorSemantico = false;}
        | sec_Instrucciones def_Instruccion                             {errorSemantico = false;}
        ;

def_Lista: NOM_LISTA '=' '{' sec_elem_Lista '}'                         {errorSemantico = errorLocal;
                                                                        errorLocal = false;
                                                                        if (!errorSemantico) {
                                                                                cambiarNombreLista (listaAuxiliar, $1);
                                                                                errorSemantico = insertarLista (conjunto_Listas, listaAuxiliar);
                                                                                if (errorSemantico) {
                                                                                        cout << "Error semántico en la línea " << n_lineas << ". No pueden declararse dos listas con el mismo nombre." << endl;
                                                                                        errorSemantico = false;
                                                                                }
                                                                                iniciarVectorLista(listaAuxiliar);
                                                                        }
                                                                        else {
                                                                                iniciarVectorLista (listaAuxiliar);
                                                                                errorSemantico = false;
                                                                        }
                                                                        }

        | NOM_LISTA '=' '{' expr_a OP_RANGO expr_a '}'                  {if (!errorSemantico) {
                                                                                if (dentroRango && !$4.esReal && !$6.esReal) {
                                                                                        iniciarVectorLista (listaAuxiliar);
                                                                                        errorSemantico = crearListaRangos (listaAuxiliar, $4.valor, $6.valor);
                                                                                        if (!errorSemantico) {
                                                                                                cambiarNombreLista (listaAuxiliar, $1);
                                                                                                errorSemantico = insertarLista (conjunto_Listas, listaAuxiliar);
                                                                                                if (errorSemantico) {
                                                                                                        cout << "Error semántico en la línea " << n_lineas << ". No pueden declararse dos listas con el mismo nombre." << endl;
                                                                                                        errorSemantico = false;
                                                                                                }
                                                                                                iniciarVectorLista(listaAuxiliar);
                                                                                        }
                                                                                        else {
                                                                                                cout << "Error semántico en la línea " << n_lineas << ": el primer delimitador del rango debe ser menor que el segundo." << endl;
                                                                                                errorSemantico = false;
                                                                                        }
                                                                                }
                                                                                else {
                                                                                        cout << "Error semántico en la línea " << n_lineas << ". Los delimitadores del rango deben ser número de tipo entero." << endl;
                                                                                }
                                                                        }
                                                                        else {
                                                                                errorSemantico = false;
                                                                        }
                                                                        dentroRango = false;
                                                                        }
        | error                                                         {iniciarVectorLista (listaAuxiliar);}
        ;

def_Variable: TP_ENTERO {tipoTemporal = e_integer;} sec_IDs ';' saltos_opc                                           {strcpy (nombreVariable, "");}
        | TP_REAL {tipoTemporal = e_real;} sec_IDs ';' saltos_opc                                                    {strcpy (nombreVariable, "");}
        | TP_LOGICO {tipoTemporal = e_boolean;} sec_IDs ';' saltos_opc                                               {strcpy (nombreVariable, "");}
        | NOM_LISTA {tipoTemporal = e_list; strcpy (nombreTemporal, $1);} sec_IDs ';' saltos_opc                     {strcpy (nombreVariable, "");}
        | error saltos_obl                                                                                           {yyerrok; errorSemantico = false;
                                                                                                                      errorSemantico = eliminaSimbolo (sg, nombreVariable);
                                                                                                                      if (errorSemantico) {
                                                                                                                        cout << "Error semántico en la línea " << n_lineas << ": la variable no ha sido declarada correctamente." << endl;
                                                                                                                        errorSemantico = false;
                                                                                                                      }
                                                                                                                      strcpy (nombreVariable, "");
                                                                                                                      }
        ;

def_Instruccion: INS_ESCRIBIR {if (flagIf) {dentroEscribir = true;}} '(' sec_elem_Escribir ')' ';' saltos_opc        {dentroEscribir = false;}
        | INS_NUEVALINEA ';' saltos_opc                                                                              {if (flagIf) {funcionNuevaLinea (yyout);}}

        | ID OP_ASIGNACION instrucciones_especiales ';' saltos_opc      {if (flagIf) {
                                                                                if (!errorSemantico) {
                                                                                symbol aux;
                                                                                        if (searchVariable (sg, $1, aux)) {
                                                                                                if (aux.type == e_list) {
                                                                                                        if (strcmp (aux.valor.lista.nombre_lista, $3) == 0) {
                                                                                                                errorSemantico = funcionesEspeciales (listaAuxiliar, elementoSalida, enteroAux);
                                                                                                                if (!errorSemantico) {
                                                                                                                        vectorLista listaLocal;
                                                                                                                        union var_value valor;
                                                                                                                        iniciarVectorLista (listaLocal);
                                                                                                                        insertarENLista (listaLocal, elementoSalida, listaAuxiliar.tipo_elemento);
                                                                                                                        strcpy (listaLocal.nombre_lista, listaAuxiliar.nombre_lista);
                                                                                                                        valor.lista = listaLocal;
                                                                                                                        insert (sg, $1, e_list, valor);
                                                                                                                }
                                                                                                                else {
                                                                                                                        cout << "Error semántico en la línea " << (n_lineas-numeroSaltos) << ". El segundo parámetro de la instruccion 'enesimo (Lista, n)' debe ser un número entero que cumpla '0 < n <= número de elementos de la lista'." << endl;
                                                                                                                }
                                                                                                        }
                                                                                                        else {
                                                                                                                cout << "Error semántico en la línea " << (n_lineas - numeroSaltos) << ": la variable no es del tipo de lista correcto." << endl;
                                                                                                        }
                                                                                                }
                                                                                                else {
                                                                                                        cout << "Error semántico en la línea " << (n_lineas - numeroSaltos) << ": la variable no es de tipo lista." << endl;
                                                                                                }
                                                                                        }
                                                                                        else {
                                                                                                cout << "Error semántico en la línea " << (n_lineas-numeroSaltos) << ". La variable " << $1 << " no ha sido previamente declarada." << endl;
                                                                                        }
                                                                                }
                                                                        }
                                                                        numeroSaltos = 0;
                                                                        }
        | ID OP_ASIGNACION expr_a ';' saltos_opc                        {if (flagIf) {
                                                                                
                                                                                if (!errorSemantico) {
                                                                                        symbol aux;
                                                                                        if (searchVariable (sg, $1, aux)) {
                                                                                                union var_value valor;
                                                                                                if ($3.esReal) {
                                                                                                        valor.real = $3.valor;
                                                                                                        errorSemantico = insert (sg, $1, e_real, valor);
                                                                                                }
                                                                                                else { 
                                                                                                        valor.integer = $3.valor;
                                                                                                        errorSemantico = insert (sg, $1, e_integer, valor);
                                                                                                }
                                                                                                if (errorSemantico) {
                                                                                                        searchVariable (sg, $1, aux);
                                                                                                        cout << "Error semántico en la instrucción " << (n_lineas-numeroSaltos)  << ". " << "La variable '" << aux.idName << "' es de tipo " << selectEnum (aux.type)
                                                                                                        << " y no se le puede asignar un valor de tipo ";
                                                                                                        if ($3.esReal) {
                                                                                                                cout << "real." << endl;
                                                                                                        }
                                                                                                        else {
                                                                                                                cout << "entero." << endl;
                                                                                                        }
                                                                                                }
                                                                                        }
                                                                                        else {
                                                                                                cout << "Error semántico en la línea " << (n_lineas-numeroSaltos) << ". La variable " << $1 << " no ha sido previamente declarada." << endl;
                                                                                        }
                                                                                }
                                                                                errorSemantico = false;
                                                                        }
                                                                        numeroSaltos = 0;
                                                                        }

        | ID OP_ASIGNACION expr_b ';' saltos_opc                        {if (flagIf) {
                                                                                if (!errorSemantico) {
                                                                                        symbol aux;
                                                                                        if (searchVariable (sg, $1, aux)) {
                                                                                                union var_value valor;
                                                                                                valor.boolean = $3;
                                                                                                errorSemantico = insert (sg, $1, e_boolean, valor);
                                                                                                if (errorSemantico) {
                                                                                                        searchVariable(sg, $1, aux);
                                                                                                        cout << "Error semántico en la instrucción " << (n_lineas-numeroSaltos)  << ": " << "La variable " << aux.idName << " es de tipo " << selectEnum(aux.type)
                                                                                                        << " y no se le puede asignar un valor de tipo lógico" << endl;
                                                                                                }
                                                                                        }
                                                                                        else {
                                                                                                cout << "Error semántico en la línea " << (n_lineas-numeroSaltos)  << ". La variable " << $1 << " no ha sido previamente declarada." << endl;
                                                                                        }
                                                                                }
                                                                                errorSemantico = false;
                                                                        }
                                                                        numeroSaltos = 0;
                                                                        }

        | instruccion_condicional                                       {;}
        | error saltos_obl                                              {yyerrok; errorSemantico = false; strcpy (cadenaAuxiliar, "");}
        ;

instruccion_condicional: parte_IF parte_IF_ELSE
        ;

parte_IF: INS_IF '(' expr_b ')' {flagIf = $3;} bloque
        | INS_IF '(' ID ')' {flagIf = true; evaluarCondicional (sg, $3, flagIf, n_lineas);} bloque
        ;

parte_IF_ELSE: %prec si_simple {flagIf = true;}
        | INS_ELSE {flagIf = !flagIf;} bloque {flagIf = true;}
        ;

bloque: saltos_opc '[' saltos_opc sec_Instrucciones ']' saltos_opc
        ;

sec_elem_Lista: elem_Lista                                               {;}
        | sec_elem_Lista ',' elem_Lista                                  {;}
        ;

sec_IDs: ID                             {symbol aux; union var_value valor;
                                        if (!searchVariable (sg, $1, aux)) {
                                                switch (tipoTemporal) {
                                                        case e_integer:
                                                                valor.integer = -1;
                                                                errorSemantico = insert (sg, $1, e_integer, valor);
                                                        break;
                                                        case e_real:
                                                                valor.real = -1.0;
                                                                errorSemantico = insert (sg, $1, e_real, valor);
                                                        break;
                                                        case e_boolean:
                                                                valor.boolean = true;
                                                                errorSemantico = insert (sg, $1, e_boolean, valor);
                                                        break;
                                                        case e_list:
                                                                errorSemantico = buscaLista (conjunto_Listas, nombreTemporal, listaAuxiliar);
                                                                if (!errorSemantico) {
                                                                        valor.lista = listaAuxiliar;
                                                                        errorSemantico = insert (sg, $1, e_list, valor);
                                                                }
                                                                else {
                                                                        cout << "Error semántico en la línea " << n_lineas << ". La lista '" << nombreTemporal << "' no ha sido declarada previamente." << endl;
                                                                        errorSemantico = false;
                                                                }
                                                        break;
                                                        case e_chars:
                                                                cout << "Error de ejecución. El tipo no está definido." << endl;
                                                        break;
                                                        default:
                                                                cout << "Error de ejecución. El tipo no está definido." << endl;
                                                        break;
                                                }
                                                if (errorSemantico) {
                                                        cout << "Error semántico en la línea " << n_lineas << ". La variable '" << $1 << "' ya ha sido declarada anteriormente." << endl;
                                                        errorSemantico = false;
                                                }
                                        }
                                        else {
                                                cout << "Error semántico en la línea " << n_lineas << ". La variable '" << $1 << "' ya ha sido declarada anteriormente." << endl;
                                                errorSemantico = false;
                                        }
                                        strcpy (nombreVariable, $1);
                                        }
        | sec_IDs ',' ID                {symbol aux; union var_value valor;
                                        if (!searchVariable(sg, $3, aux)) {
                                                switch (tipoTemporal) {
                                                        case e_integer:
                                                                valor.integer = -1;
                                                                errorSemantico = insert (sg, $3, e_integer, valor);
                                                        break;
                                                        case e_real:
                                                                valor.real = -1.0;
                                                                errorSemantico = insert (sg, $3, e_real, valor);
                                                        break;
                                                        case e_boolean:
                                                                valor.boolean = true;
                                                                errorSemantico = insert (sg, $3, e_boolean, valor);
                                                        break;
                                                        case e_list:
                                                                errorSemantico = buscaLista (conjunto_Listas, nombreTemporal, listaAuxiliar);
                                                                if (!errorSemantico) {
                                                                        valor.lista = listaAuxiliar;
                                                                        errorSemantico = insert (sg, $3, e_list, valor);
                                                                }
                                                                else {
                                                                        cout << "Error semántico en la línea " << n_lineas << ". La lista '" << nombreTemporal << "' no ha sido declarada previamente." << endl;
                                                                }
                                                        break;
                                                        case e_chars:
                                                                cout << "Error de ejecución. El tipo no está definido." << endl;
                                                        break;
                                                        default:
                                                                cout << "Error de ejecución. El tipo no está definido." << endl;
                                                        break;
                                                }
                                                if (errorSemantico) {
                                                        cout << "Error semántico en la línea " << n_lineas << ". La variable '" << $3 << "' ya ha sido declarada anteriormente." << endl;
                                                        errorSemantico = false;
                                                }
                                        }
                                        else {
                                                cout << "Error semántico en la línea " << n_lineas << ". La variable '" << $3 << "' ya ha sido declarada anteriormente." << endl;
                                                errorSemantico = false;
                                        }
                                        strcpy (nombreVariable, $3);
                                        }
        ;

sec_elem_Escribir: elem_Escribir                                {if (flagIf) {funcionEscribir (cadenaAuxiliar, yyout);}}
        | sec_elem_Escribir ',' elem_Escribir                   {if (flagIf) {funcionEscribir (cadenaAuxiliar, yyout);}}
        ;

instrucciones_especiales: INS_PRIMERO '(' NOM_LISTA ')'         {errorSemantico = buscaLista (conjunto_Listas, $3, listaAuxiliar); numeroSaltos = 0;
                                                                if (!errorSemantico) {
                                                                        enteroAux = 1;
                                                                }
                                                                else {
                                                                        cout << "Error semántico en la línea " << n_lineas << ". La lista '" << $3 << "' no ha sido declarada previamente." << endl;
                                                                }
                                                                strcpy ($$, $3);}
        | INS_ULTIMO '(' NOM_LISTA ')'                          {errorSemantico = buscaLista (conjunto_Listas, $3, listaAuxiliar); numeroSaltos = 0;
                                                                if (!errorSemantico) {
                                                                        enteroAux = listaAuxiliar.n_elems_lista;
                                                                }
                                                                else {
                                                                        cout << "Error semántico en la línea " << n_lineas << ". La lista '" << $3 << "' no ha sido declarada previamente." << endl;
                                                                }
                                                                strcpy ($$, $3);}
        | INS_ENESIMO '(' NOM_LISTA ',' expr_a ')'              {errorSemantico = buscaLista (conjunto_Listas, $3, listaAuxiliar); numeroSaltos = 0;
                                                                if (!errorSemantico) {
                                                                        if (!$5.esReal) {
                                                                                enteroAux = $5.valor;
                                                                        }
                                                                        else {
                                                                                errorSemantico = true;
                                                                                cout << "Error semántico en la línea " << n_lineas << ". El segundo parámetro de la función 'enesimo (Lista, n)' debe ser un número entero." << endl;
                                                                        }
                                                                }
                                                                else {
                                                                        cout << "Error semántico en la línea " << n_lineas << ". La lista '" << $3 << "' no ha sido declarada previamente." << endl;
                                                                }
                                                                strcpy ($$, $3);}
        ;

elem_Lista: expr_a                              {union elem_lista aux;
                                                if(tipo_elem_lista == e_integer){
                                                        aux.integer = $1.valor;
                                                        errorSemantico = insertarENLista (listaAuxiliar, aux, e_integer);
                                                }
                                                else if(tipo_elem_lista == e_real){
                                                        aux.real = $1.valor;
                                                        errorSemantico = insertarENLista (listaAuxiliar, aux, e_real);
                                                }
                                                if (errorSemantico) {
                                                        errorLocal = true;
                                                        iniciarVectorLista(listaAuxiliar);
                                                        cout << "Error semántico en la línea " << n_lineas << ": el tipo de dato no coincide con el tipo de la lista" << endl;
                                                }
                                                }

        | expr_b                                {union elem_lista aux;
                                                if(tipo_elem_lista == e_boolean) {
                                                        aux.boolean = $1;
                                                        errorSemantico = insertarENLista(listaAuxiliar, aux, e_boolean);
                                                }
                                                if (errorSemantico) {
                                                        errorLocal = true;
                                                        cout << "Error semántico en la línea " << n_lineas << ": el tipo de dato no coincide con el tipo de la lista" << endl;
                                                        iniciarVectorLista (listaAuxiliar);
                                                }
                                                }
        ;

elem_Escribir: CADENA                           {strcpy (cadenaAuxiliar, $1);}
        | expr_a                                {if ($1.esReal && !dentroEscribir) {
                                                        guardadoTemporal.real = $1.valor;
                                                        strcpy (cadenaAuxiliar, to_string (guardadoTemporal.real).c_str ());
                                                }
                                                else if (!dentroEscribir) {
                                                        guardadoTemporal.integer = $1.valor;
                                                        strcpy (cadenaAuxiliar, to_string (guardadoTemporal.integer).c_str ());
                                                }
                                                }
        | expr_b                                {strcpy (cadenaAuxiliar, traducirBooleano ($1).c_str ());}

        | instrucciones_especiales              {if (!errorSemantico) {
                                                        errorSemantico = funcionesEspeciales (listaAuxiliar, elementoSalida, enteroAux);
                                                        if (!errorSemantico) {
                                                                if (listaAuxiliar.tipo_elemento == e_chars) {
                                                                        strcpy (cadenaAuxiliar, elementoSalida.identifiers);
                                                                }
                                                                if (listaAuxiliar.tipo_elemento == e_boolean) {
                                                                        strcpy (cadenaAuxiliar, traducirBooleano (elementoSalida.boolean).c_str ());
                                                                }
                                                                else {
                                                                        strcpy (cadenaAuxiliar, to_string (elementoSalida.integer).c_str ());
                                                                }
                                                                switch (listaAuxiliar.tipo_elemento) {
                                                                        case e_chars:
                                                                                strcpy (cadenaAuxiliar, elementoSalida.identifiers);
                                                                        break;
                                                                        case e_boolean:
                                                                                strcpy (cadenaAuxiliar, traducirBooleano (elementoSalida.boolean).c_str ());
                                                                        break;
                                                                        case e_integer:
                                                                                strcpy (cadenaAuxiliar, to_string (elementoSalida.integer).c_str ());
                                                                        break;
                                                                        case e_real:
                                                                                strcpy (cadenaAuxiliar, to_string (elementoSalida.real).c_str ());
                                                                        break;
                                                                        case e_list:
                                                                        default:
                                                                                cout << "Error de ejecución. No se puede identificar correctamente el tipo de la lista." << endl;
                                                                                errorSemantico = true;
                                                                        break;
                                                                }
                                                        }
                                                        else {
                                                                cout << "Error semántico en la línea " << n_lineas << ". El segundo parámetro de la instruccion 'enesimo (Lista, n)' debe ser un número entero que cumpla '0 < n <= número de elementos de la lista'." << endl;
                                                                errorSemantico = false;
                                                        }
                                                }
                                                }
        ;

expr_a: VL_ENTERO                               {$$.esReal = false; $$.valor = $1; tipo_elem_lista = e_integer; numeroSaltos = 0;}
        | VL_REAL                               {$$.esReal = true; $$.valor = $1; tipo_elem_lista = e_real; numeroSaltos = 0;}
        | ID                                    {symbol aux;
                                                if (dentroEscribir) {                   
                                                        if (searchVariable (sg, $1, aux)) {
                                                                switch (aux.type) {
                                                                        case e_integer:
                                                                                strcpy (cadenaAuxiliar, to_string (aux.valor.integer).c_str ());
                                                                                $$.esReal = false;
                                                                                $$.valor = aux.valor.integer;
                                                                        break;
                                                                        case e_real:
                                                                                strcpy (cadenaAuxiliar, to_string (aux.valor.real).c_str ());
                                                                                $$.esReal = true;
                                                                                $$.valor = aux.valor.real;
                                                                        break;
                                                                        case e_boolean:
                                                                                strcpy (cadenaAuxiliar, to_string (aux.valor.boolean).c_str ());
                                                                        break;
                                                                        case e_list:
                                                                                copiarLista (cadenaAuxiliar, aux.valor.lista);
                                                                        break;
                                                                        case e_chars:
                                                                        default:
                                                                                cout << "Error al identificar el tipo de la variable." << endl;
                                                                                errorSemantico = true;
                                                                        break;
                                                                }
                                                        }
                                                        else {
                                                                cout << "Error semántico en la línea " << n_lineas << ". La variable " << $1 << " no ha sido definida." << endl;
                                                                errorSemantico = true;
                                                        }
                                                }
                                                else {
                                                        if (!tipo_identificador) {
                                                                symbol aux; tipo_elem_lista = e_chars;
                                                                if (searchVariable(sg, $1, aux)) {
                                                                        if(aux.type == e_integer) $$.esReal = false;
                                                                        else if(aux.type == e_real) $$.esReal = true;
                                                                        else if(aux.type == e_boolean){
                                                                                errorSemantico = true;
                                                                                cout << "Error semántico en la instrucción " << n_lineas << ": Variables de tipo booleano no pueden aparecer en la parte derecha de la asignación." << endl; 
                                                                        }

                                                                        if(aux.type == e_integer){
                                                                                $$.valor = aux.valor.integer;
                                                                        }
                                                                        else if(aux.type == e_real){
                                                                                $$.valor = aux.valor.real;
                                                                        }
                                                                }
                                                                else {
                                                                        errorSemantico = true;
                                                                        cout << "Error semántico en la instrucción " << n_lineas << ": " << "La variable " <<  $1 << " no está definida" << endl;
                                                                }
                                                        }
                                                        else if (!dentroRango) {
                                                                union elem_lista aux;
                                                                tipo_elem_lista = e_chars;
                                                                strcpy (aux.identifiers, $1);
                                                                errorSemantico = insertarENLista (listaAuxiliar, aux, e_chars);
                                                                if(errorSemantico){
                                                                        cout << "Error semántico en la línea " << n_lineas << ": el tipo de dato no coincide con el tipo de la lista" << endl;
                                                                }
                                                        }
                                                        else {
                                                                errorSemantico = true;
                                                                cout << "Error semántico en la línea " << n_lineas << ". Un rango no puede estar compuesto por identificadores." << endl;
                                                        }
                                                }
                                                numeroSaltos = 0;
                                                }


        | expr_a OP_SUMA expr_a                 {$$.esReal = $1.esReal || $3.esReal; $$.valor = $1.valor + $3.valor;}
        | expr_a OP_DIFERENCIA expr_a           {$$.esReal = $1.esReal || $3.esReal; $$.valor = $1.valor - $3.valor;}
        | expr_a OP_MULT expr_a                 {$$.esReal = $1.esReal || $3.esReal; $$.valor = $1.valor * $3.valor;}
        | expr_a OP_DIV expr_a                  {$$.esReal = $1.esReal || $3.esReal;
                                                if ($3.valor == 0) {
                                                        errorSemantico = true;
                                                        cout << "Error semántico en la instrucción " << n_lineas << ": " << "División entre 0" << endl;
                                                }
                                                else if ($$.esReal) {
                                                        $$.valor = $1.valor / $3.valor;
                                                }
                                                else {
                                                        $$.valor = int ($1.valor) / int ($3.valor);}
                                                }

        | expr_a OP_MOD  expr_a                 {$$.esReal = false;
                                                if ($3.valor == 0) {
                                                        errorSemantico = true;
                                                        cout << "Error semántico en la instrucción " << n_lineas << ": " << "Módulo entre 0" << endl;
                                                }
                                                else if ($1.esReal || $3.esReal) {
                                                        errorSemantico = true;
                                                        cout << "Error semántico en la instrucción " << n_lineas << ": " << "Los operandos en % son de tipo real" << endl;
                                                }
                                                else{
                                                        $$.valor = int($1.valor) % int($3.valor);}
                                                }

        | OP_DIFERENCIA expr_a %prec menos      {$$.valor = -$2.valor; $$.esReal = $2.esReal;}
        | '(' expr_a ')'                        {$$.valor = $2.valor; $$.esReal = $2.esReal;}
        ;

expr_b: VL_BOOLEAN                              {$$ = $1; tipo_elem_lista = e_boolean; numeroSaltos = 0; iniciarVectorLista (listaAuxiliar);}
        | expr_b OP_OR expr_b                   {$$ = ($1 || $3);}
        | expr_b OP_AND expr_b                  {$$ = ($1 && $3);}
        | expr_a OP_IGUAL_IGUAL expr_a          {$$ = ($1.valor == $3.valor);}
        | expr_a OP_DISTINTO expr_a             {$$ = ($1.valor != $3.valor);}
        | expr_b OP_IGUAL_IGUAL expr_b          {$$ = ($1 == $3);}
        | expr_b OP_DISTINTO expr_b             {$$ = ($1 != $3);}
        | expr_a '<' expr_a                     {$$ = ($1.valor < $3.valor);}
        | expr_a '>' expr_a                     {$$ = ($1.valor > $3.valor);}
        | expr_a OP_MENOR_IGUAL expr_a          {$$ = ($1.valor <= $3.valor);}
        | expr_a OP_MAYOR_IGUAL expr_a          {$$ = ($1.valor >= $3.valor);}
        | OP_NOT expr_b                         {$$ = !$2;}
        | '(' expr_b ')'                        {$$ = $2;}
        ;

saltos_opc: %prec saltos_prio
        | saltos_opc '\n'                       {n_lineas++; numeroSaltos++;}
        ;

saltos_obl: '\n'                                {n_lineas++; numeroSaltos++;}
        | saltos_obl '\n'                       {n_lineas++; numeroSaltos++;}
        ;

%%
int main (int argc, char *argv[]) {

        if (argc == 2) {
                n_lineas = 1;
                yyin = fopen (argv[1], "r");

                argv [1][strlen (argv [1]) - 4] = '\0';
                string aux (argv [1]);
                string extension = "cpp";
                aux = aux + extension;
                char filename [aux.length () + 1];

                strcpy (filename, aux.c_str ());

                yyout = fopen (filename, "w+");

                codigo_c_antes (yyout);
                
                iniciarCjtoListas (conjunto_Listas);
                iniciarVectorLista (listaAuxiliar);
                iniciar (sg);
                yyparse ();

                codigo_c_despues (yyout);
                
                // mostrarCjtoLista (conjunto_Listas);
                // showID2s (sg);

                fclose (yyin);
                fclose (yyout);
      } 
      else {
            cout << "El archivo de entrada tiene que ser sólo uno con formato 'cpp'" << endl;
      }
      return 0;
}