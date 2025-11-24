"
clase 'main' que manejara la ejecucion del juego
"
Class {
	#name : 'Juego',
	#superclass : 'Object',
	#instVars : [
		'jugadorProximo',
		'jugadorActual',
		'tableroPrincipal'
	],
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'testing' }
Juego >> actualizar [


[tableroPrincipal buscarGanador isNil]whileTrue: [ 
	|fil col|
	fil := UIManager default request: 'Ingrese fila' asInteger .
	col := UIManager default request: 'Ingrese columna' asInteger .	

	jugadorActual enFila: fil columna: col poner: jugadorActual marca.
	self cambioDeTurno
	 ].
UIManager default inform: '¡Ganó ', jugadorActual nombre, '!'.
]

{ #category : 'testing' }
Juego >> cambioDeTurno [
|jug|
jug:= jugadorActual .
jugadorActual :=jugadorProximo.
jugadorProximo:=jugadorActual. 
]

{ #category : 'initialization' }
Juego >> initialize [ 
super initialize

nuevoJuego
actualizar 
]

{ #category : 'testing' }
Juego >> nuevoJuego [

jugadorActual := Jugador new crearJugador:'p1'  marca: 'X'.
jugadorProximo := Jugador new crearJugador:'p2'  marca: 'O'.

tableroPrincipal := Tablero new crear3x3.

]
