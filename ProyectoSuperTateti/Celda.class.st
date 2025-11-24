Class {
	#name : 'Celda',
	#superclass : 'Object',
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
self extend: 80@80.
self color: Color yellow.
"self on: #click send: #value to: (self onCli)"
^self. 
]
