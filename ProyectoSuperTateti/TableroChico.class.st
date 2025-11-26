Class {
	#name : 'TableroChico',
	#superclass : 'TableroTatetiAbstracto',
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'game-logic' }
TableroChico >> colocar: unSimbolo fila: fila columna: columna [
    | casilla |
    casilla := self celdaEnFila: fila columna: columna.
    casilla estaOcupada ifTrue: [
        self error: 'La casilla ya esta ocupada.' ].
    casilla colocar: unSimbolo.
    self actualizarGanador.

]

{ #category : 'game-logic' }
TableroChico >> estaOcupada [
    "Para el tablero grande: consideramos ocupado si el tablerito ya terminó."
    ^ self estaTerminado.

]

{ #category : 'game-logic' }
TableroChico >> estaTerminado [
    "Un tablerito está terminado si tiene ganador o si está lleno."
    ^ self hayGanador or: [ self estaLleno ].

]

{ #category : 'game-logic' }
TableroChico >> hayGanador [
    ^ ganador notNil.

]

{ #category : 'initialization' }
TableroChico >> inicializarCeldas [
    | lado matriz |
    lado := self tamano.
    matriz := (1 to: lado) collect: [:f |
        (1 to: lado) collect: [:c | Casilla new ] ].
    self celdas: matriz.


]

{ #category : 'initialization' }
TableroChico >> initialize [
    super initialize.

]

{ #category : 'game-logic' }
TableroChico >> marcaParaGanador [
    "Para el tablero grande: devuelve #X, #O o nil si no hay ganador."
    ^ ganador.

]
