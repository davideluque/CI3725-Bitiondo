README
Traductores e Interpretadores
Etapa 1 - Analizador lexicografico

Autores:
David Ernesto Cabeza Luque 1310191 <13-10191@usb.ve>
Fabiola Mercedes Martinez Perez 1310838 <13-10838@usb.ve>

EJECUCION
----------------------------------------------------------------------------------------------------

```
$ ./bitiondo fileName.bto
```

Nota: Para ejecutar el archivo, el dueño (quien lo descarga) debe tener permisos de ejecución. Esto se logra fácilmente ejecutando el siguiente comando en el terminal (estando en la ruta del proyecto):

```
chmod u+x bitiondo
```

Añadir sudo al inicio del comando si hay problemas de permisos.

DECISIONES DE IMPLEMENTACION 
----------------------------------------------------------------------------------------------------

En el archivo lexer.rb, se crearon dos clases:

La primera clase token que tiene como metodos:

- initialize: se creo para inicializar todos los atributos que posee un token. Type que se refiere 
a la clave del diccionario, es decir el nombre del token, value los valores que toman ciertos ele-
mentos (string, integer, identifier, bitsexpression) del lenguaje bitiondo, que deben ser mostrados 
en la salida. Tambien contiene la información sobre la columna y fila a la que pertence el token.

- to_s: se usa para que cada token genere su string de salida.

La segunda clase lexer, que tiene como metodos:

- intialize: inicializa las estructuras de datos y elementos que se usaran a lo largo del programa. 
Contiene un diccionario donde la clave es el nombre del token del lenguaje bitiondo y valor es la 
expresion regular que le corresponde, este es usado para hacer las comparaciones correspondientes 
con el archivo y tambien para imprimir la salida. Por otro lado, se tienen dos arreglos uno que almacena
los tokens correctos y otro que almacena los tokens incorrectos del lenguaje bitiondo. 
Finalmente, dos contadores para las columnas y filas, y una expresion regular ignore para hacer las 
comparaciones con los tokens que se deben ignorar.

- readFile: este método se creo para hacer la lectura de archivo .bto, se encarga de abrir archivo,
 leerlo y luego cerrarlo.

- tokenizer: es la funcion principal del analizador lexicografico, esta se encarga de recorrer el ar-
chivo y hacer las comparaciones correspondientes de los tokens del archivo con las expresiones con-
tenidas en el diccionario, luego los tokens correctos se anaden a una lista y los incorrectos a otra 
lista. Al mismo tiempo, se van contando las lineas y columnas correspondientes.

- printk: se encarga de recorrer las listas de tokens correctos e incorrectos y mostrarlos en la 
salida.

Para finalizar, el main del programa se encuentra en el archivo bitiondo.

ESTADO ACTUAL DEL PROYECTO
----------------------------------------------------------------------------------------------------
El programa que se comporta como un analizador lexicografico para el lenguaje Bitiondo, cumple con 
todas las funcionalidades requeridas para la etapa 1. 


PROBLEMAS PRESENTES
----------------------------------------------------------------------------------------------------
No posee problemas.
