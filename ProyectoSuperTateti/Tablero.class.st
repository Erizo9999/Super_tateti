"
tablero que puede contener tanto subtableros como casillas
"
Class {
	#name : 'Tablero',
	#superclass : 'Object',
	#instVars : [
		'casillas',
		'ganador',
		'casMarcadas'
	],
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'testing' }
Tablero >> buscarGanador [

"minimo debe haber tres marcas para considerar un ganador"
casMarcadas > 2 

ifTrue: [ 
	1 to: 3 do: [ :i|
		self controlarFila: i.
		self controlarColumna:i
		 ].

self controlarDiagonales.
].
^ganador.

]

{ #category : 'testing' }
Tablero >> controlarColumna: colNum [
|conjunto|
ganador
ifNil: [ 
	conjunto := (self enColumna: colNum) asSet. 
	 self controlarConjunto: colNum
	 ].
^ganador 
]

{ #category : 'testing' }
Tablero >> controlarConjunto: unConjunto [

	unConjunto size == 1 ifFalse: [ ^ self ].
	(unConjunto includes: 'X') ifTrue: [ ganador := 'P1' ].

	(unConjunto includes: 'O') ifTrue: [ ganador := 'P2' ]
]

{ #category : 'testing' }
Tablero >> controlarDiagonales [
|diagonalPrincipal diagonalSecundaria|
ganador 
ifNil: [ 
	diagonalPrincipal := (0 to: 2) collect: [:i | (casillas at: i + 1) at: i + 1] asSet.
	diagonalSecundaria := (0 to: 2) collect: [:i | (casillas at: i + 1) at: 3 - i] asSet.
	 ].
]

{ #category : 'testing' }
Tablero >> controlarFila: unaFila [
|conjunto|
ganador
ifNil: [ 
	conjunto := (self enFila: unaFila ) asSet. 
	 self controlarConjunto: unaFila 
	 ].
^ganador 
]

{ #category : 'testing' }
Tablero >> crear3x3 [
casillas := (1 to: 3) collect: [:i |
        Array new: 3 withAll: nil ].
]

{ #category : 'testing' }
Tablero >> enColumna: unaColumna [
^casillas at:unaColumna 

]

{ #category : 'testing' }
Tablero >> enFila: unaFila [
^casillas at:unaFila 
]

{ #category : 'testing' }
Tablero >> enFila: unaFila columna: unaColumna [
^(casillas at:unaFila) at:unaColumna.
]

{ #category : 'testing' }
Tablero >> enFila: unaFila columna: unaColumna poner: unaMarca [
(casillas at: unaFila) at:unaColumna put:unaMarca .
^casillas.
]

{ #category : 'initialization' }
Tablero >> initialize [ 
super initialize.
casMarcadas:= 0.
]
