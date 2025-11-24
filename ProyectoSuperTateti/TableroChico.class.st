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
TableroChico >> estaTerminado [
    ^ self hayGanador or: [ self estaLleno ].

]

{ #category : 'game-logic' }
TableroChico >> hayGanador [
    ^ self ganador notNil.

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
