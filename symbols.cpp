/*
	EL presente fichero se encarga de otorgar funcionalidad a la Tabla de Símbolos del lenguaje LISTAS.
	Autores: Jorge del Castillo Gómez y Raúl Hormigo Cerón.
*/

#include "symbols.h"

void iniciar (symbolsGroup &s) {
	s.occupied = 0;
}

bool insert (symbolsGroup &sg, characters nombre, type_code type, var_value nuevoValor) {
	bool encontrado = false;
	bool error = false;
	symbol aux;
	int pos = -1;
	for (int i = 0; (i < sg.occupied) && !encontrado; i++) {
		if (strcmp (sg.vSymbols[i].idName, nombre) == 0) {
			encontrado = true;
			pos = i;
		}
	}
	if (!encontrado) { // Aquí se inserta el nuevo valor en caso de que no exista
		strcpy (aux.idName, nombre);
		switch (type) {
			case e_integer:
				aux.valor.integer = nuevoValor.integer;
			break;
			case e_boolean:
				aux.valor.real = nuevoValor.real;
			break;
			case e_real:
				aux.valor.real = nuevoValor.real;
			break;
			case e_list:
				aux.valor.lista = nuevoValor.lista;
			break;
			case e_chars:
				aux.valor.integer = -1;
			break;
		}
		aux.type = type;
		sg.vSymbols [sg.occupied] = aux;
		sg.occupied++;
	}
	else { // Aquí se actualiza si existe
		if (sg.vSymbols [pos].type == type) {
			switch (type) {
				case e_integer:
					sg.vSymbols [pos].valor.integer = nuevoValor.integer;
				break;
				case e_real:
					sg.vSymbols [pos].valor.real = nuevoValor.real;
				break;
				case e_list:
					sg.vSymbols [pos].valor.lista = nuevoValor.lista;
				break;
				case e_boolean:
					sg.vSymbols [pos].valor.boolean = nuevoValor.boolean;
				break;
			}
		}
		else {
			error = true;
		}
	}
	return error;
}

bool searchVariable (symbolsGroup &sg, characters searchName, symbol &retId) {
	bool encontrado = false;
	for (int i = 0; (i < sg.occupied) && !encontrado; i++) {
		if (strcmp (sg.vSymbols [i].idName, searchName) == 0) {
			retId = sg.vSymbols [i];
			encontrado = true;
		}
	}
	return encontrado;
}

string selectEnum (type_code code) {
	switch (code) {
		case e_integer:
			return "entero";
		break;
		case e_real:
			return "real";
		break;
		case e_boolean:
			return "booleano";
		break;
		case e_chars:
			return "defecto";
		break;
		case e_list:
			return "lista";
		break;
		default:
			return "ERROR: no se ha podido identificar el tipo.";
		break;
	}
}

void showIDs (symbolsGroup &sg, int fd_out) {
	dup2 (fd_out, 1);
	if (sg.occupied != 0) {
		cout << "Contenido de la Tabla de Símbolos" << endl;
		cout << "\n\tLista de variables creadas <Nombre><Tipo><Valor>:" << endl;
		cout << endl;
		symbol aux;
		for (int i = 0; i < sg.occupied; i++) {
			aux = sg.vSymbols [i];
			switch (aux.type) {
				case e_integer:
					cout << "\t\t" << aux.idName << "\t\t" << selectEnum(aux.type) << "\t\t" << aux.valor.integer << endl;
				break;
				case e_real:
					cout << "\t\t" << aux.idName << "\t\t" << selectEnum(aux.type) << "\t\t" << aux.valor.real << endl;
				break;
				case e_boolean:
					if (aux.valor.boolean) {
						cout << "\t\t" << aux.idName << "\t\t" << selectEnum(aux.type) << "\t\t" << "cierto" << endl;
					}
					else {
						cout << "\t\t" << aux.idName << "\t\t" << selectEnum(aux.type) << "\t\t" << "falso" << endl;
					}
				break;
				case e_list:
					cout << "\t\t" << aux.idName << "\t\t" << selectEnum (aux.type) << "\t\t";
					mostrarLista (aux.valor.lista);
					cout << endl;
				break;
				case e_chars:
					cout << "\t\t" << aux.idName << "\t\t" << selectEnum (aux.type) << "\t\t" << "defecto" << endl;
				break;
			}
		}
		cout << endl;
	}
}

void showID2s (symbolsGroup &sg) {
	if (sg.occupied != 0) {
		cout << "\nContenido de la Tabla de Símbolos" << endl;
		cout << "\n\tLista de variables creadas <Nombre><Tipo><Valor>:" << endl;
		cout << endl;
		symbol aux;
		for (int i = 0; i < sg.occupied; i++) {
			aux = sg.vSymbols [i];
			switch (aux.type) {
				case e_integer:
					cout << "\t\t" << aux.idName << "\t\t" << selectEnum(aux.type) << "\t\t" << aux.valor.integer << endl;
				break;
				case e_real:
					cout << "\t\t" << aux.idName << "\t\t" << selectEnum(aux.type) << "\t\t" << aux.valor.real << endl;
				break;
				case e_boolean:
					if (aux.valor.boolean) {
						cout << "\t\t" << aux.idName << "\t\t" << selectEnum(aux.type) << "\t\t" << "cierto" << endl;
					}
					else {
						cout << "\t\t" << aux.idName << "\t\t" << selectEnum(aux.type) << "\t\t" << "falso" << endl;
					}
				break;
				case e_list:
					cout << "\t\t" << aux.idName << "\t\t" << selectEnum (aux.type) << "\t\t";
					mostrarLista (aux.valor.lista);
					cout << endl;
				break;
				case e_chars:
					cout << "\t\t" << aux.idName << "\t\t" << selectEnum (aux.type) << "\t\t" << "defecto" << endl;
				break;
			}
		}
		cout << endl;
	}
}

bool eliminaSimbolo (symbolsGroup &sg, characters nombre_var_eliminar) {
	bool error = false;
	bool encontrada = false;
	symbol aux;
	int posicion = -1;
	if (strcmp (nombre_var_eliminar, "") != 0) {
		error = !searchVariable (sg, nombre_var_eliminar, aux);
		if (!error) {
			for (int i = 0; (i < sg.occupied && !encontrada); i++) {
				if (strcmp (sg.vSymbols [i].idName, nombre_var_eliminar) == 0) {
					posicion = i;
					encontrada = true;
				}
			}
			if (posicion != -1) {
				for (int i = posicion; i < sg.occupied; i++) {
					sg.vSymbols [i] = sg.vSymbols [i + 1];
				}
				sg.occupied--;
			}
		}
	}
	return error;
}