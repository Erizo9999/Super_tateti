"
celda
"
Class {
	#name : 'Celda',
	#superclass : 'SimpleButtonMorph',
	#instVars : [
		'modeloPadre',
		'filNum',
		'colNum'
	],
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'initialization' }
Celda >> initialize [ 
super initialize. 

self label: ' '.
self extent: 80@80.
self color: Color yellow.
self on: #click send: #value to: (self onClickExecutionBlock).
^self. 
]

{ #category : 'initialization' }
Celda >> setModel: ticTacToeModel fila: aRow col: aCol [
modeloPadre := ticTacToeModel.
filNum := aRow.
colNum := aCol.
]
