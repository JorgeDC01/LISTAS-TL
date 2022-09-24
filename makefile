#Fichero Makefile necesario para la ejecución del programa.
#Autores: Jorge Del Castillo Gómez y Raúl Hormigo Cerón.

OBJ = sintactico.o lexico.o symbols.o Lists.o instrucciones.o

proyecto: $(OBJ)
	g++ -o proyecto $(OBJ)
	rm -f *.o *.c
	echo

sintactico.o: sintactico.c
	g++ -c -o sintactico.o sintactico.c 
	
lexico.o: lexico.c
	g++ -c -o lexico.o lexico.c 	

sintactico.c: sintactico.y
	bison -d -v -o sintactico.c sintactico.y

lexico.c: lexico.l
	flex -o lexico.c lexico.l

intrucciones.o: instrucciones.h instrucciones.cpp
	g++ -o instrucciones.o instrucciones.cpp

Lists.o: Lists.cpp Lists.h
	g++ -c -o Lists.o Lists.cpp

symbols.o: symbols.cpp symbols.h
	g++ -c -o symbols.o symbols.cpp

clean:
	rm -f *.o *.c
	rm -f proyecto salida.txt sintactico.output
	clear
