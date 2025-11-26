Class {
	#name : 'TableroTatetiAbstracto',
	#superclass : 'Object',
	#instVars : [
		'celdas',
		'tamano',
		'ganador'
	],
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'game-logic' }
TableroTatetiAbstracto >> actualizarGanador [
    ganador := self calcularGanador.

]

{ #category : 'game-logic' }
TableroTatetiAbstracto >> calcularGanador [
    "Devuelve #X, #O o nil si no hay ganador."
    | marcasLinea |
    self lineas do: [:linea |
        marcasLinea := (linea collect: [:celda | celda marcaParaGanador]) asSet.
        (marcasLinea size = 1 and: [ marcasLinea anyOne notNil ]) ifTrue: [
            ^ marcasLinea anyOne ] ].
    ^ nil.


]

{ #category : 'accessing' }
TableroTatetiAbstracto >> celdaEnFila: fila columna: columna [
    ^ (celdas at: fila) at: columna.

]

{ #category : 'accessing' }
TableroTatetiAbstracto >> celdas [
    ^ celdas.

]

{ #category : 'accessing' }
TableroTatetiAbstracto >> celdas: unaMatriz [
    celdas := unaMatriz.

]

{ #category : 'game-logic' }
TableroTatetiAbstracto >> estaLleno [
    "True si todas las celdas están ocupadas."
    ^ celdas allSatisfy: [:fila |
        fila allSatisfy: [:celda | celda estaOcupada ] ].

]

{ #category : 'accessing' }
TableroTatetiAbstracto >> ganador [
    ^ ganador.

]

{ #category : 'initialization' }
TableroTatetiAbstracto >> inicializarCeldas [
    | lado matriz |
    lado := self tamano.
    matriz := (1 to: lado) collect: [:f |
        (1 to: lado) collect: [:c | Casilla new ] ].
    self celdas: matriz.


]

{ #category : 'initialization' }
TableroTatetiAbstracto >> initialize [
    super initialize.
    tamano := 3.
    self inicializarCeldas.
    ganador := nil.

]

{ #category : 'game-logic' }
TableroTatetiAbstracto >> lineas [
    "Devuelve todas las filas, columnas y diagonales como colecciones de celdas."
    | filas columnas diagonales |
    
    filas := (1 to: tamano) collect: [:f |
        (1 to: tamano) collect: [:c | self celdaEnFila: f columna: c ] ].

    columnas := (1 to: tamano) collect: [:c |
        (1 to: tamano) collect: [:f | self celdaEnFila: f columna: c ] ].

    diagonales := {
        (1 to: tamano) collect: [:i | self celdaEnFila: i columna: i ].
        (1 to: tamano) collect: [:i | self celdaEnFila: i columna: (tamano - i + 1) ] }.

    ^ filas , columnas , diagonales.


]

{ #category : 'accessing' }
TableroTatetiAbstracto >> tamano [
    ^ tamano.

]

{ #category : 'accessing' }
TableroTatetiAbstracto >> tamano: unNumero [
    tamano := unNumero.
]
