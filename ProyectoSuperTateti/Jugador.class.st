"
clase jugador(humano)
"
Class {
	#name : 'Jugador',
	#superclass : 'Object',
	#instVars : [
		'nombre',
		'marca'
	],
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'testing' }
Jugador >> crearJugador:unNombre  marca:unaMarca [
nombre := unNombre. 
marca:= unaMarca 
]

{ #category : 'accessing' }
Jugador >> marca [
^marca 
]

{ #category : 'accessing' }
Jugador >> nombre [
^nombre 
]
