Class {
	#name : 'Partida',
	#superclass : 'Object',
	#instVars : [
		'tablero',
		'jugadorActual'
	],
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'game-logic' }
Partida >> cambiarTurno [
    jugadorActual = #X
        ifTrue: [ jugadorActual := #O ]
        ifFalse: [ jugadorActual := #X ].

]

{ #category : 'accessing' }
Partida >> estaTerminada [
    ^ self ganador notNil.

]

{ #category : 'accessing' }
Partida >> ganador [
    ^ tablero ganador.

]

{ #category : 'initialization' }
Partida >> initialize [
    super initialize.
    tablero := TableroGrande new.
    jugadorActual := #X.

]

{ #category : 'accessing' }
Partida >> jugadorActual [
    ^ jugadorActual.

]

{ #category : 'game-logic' }
Partida >> jugarEnTableroFila: filaTablero
    columna: colTablero
    filaChica: filaChica
    columnaChica: colChica [

    | ganoSubTablero |
    self estaTerminada ifTrue: [
        self error: 'La partida ya termino.' ].

    ganoSubTablero := tablero
        jugarSimbolo: jugadorActual
        enTableroFila: filaTablero
        columna: colTablero
        filaChica: filaChica
        columnaChica: colChica.

    (ganoSubTablero not and: [ tablero ganador isNil ]) ifTrue: [
        self cambiarTurno ].

]

{ #category : 'accessing' }
Partida >> tablero [
    ^ tablero.

]
