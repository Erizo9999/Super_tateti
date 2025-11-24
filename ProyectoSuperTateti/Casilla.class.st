Class {
	#name : 'Casilla',
	#superclass : 'Object',
	#instVars : [
		'valor'
	],
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'accessing' }
Casilla >> colocar: unSimbolo [
	"Marca la casilla con #X, #O"
    valor := unSimbolo.

]

{ #category : 'game-logic' }
Casilla >> estaOcupada [
    "True si la casilla ya tiene valor."
    ^ valor notNil.

]

{ #category : 'initialization' }
Casilla >> initialize [
    super initialize.
    valor := nil.

]

{ #category : 'game-logic' }
Casilla >> marcaParaGanador [
    "Devuelve la marca usada para chequear ganadores (#X, #O o nil)."
    ^ valor.

]

{ #category : 'accessing' }
Casilla >> valor [
    ^ valor.


]
