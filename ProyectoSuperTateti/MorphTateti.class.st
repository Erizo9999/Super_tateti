"
los graficos
"
Class {
	#name : 'MorphTateti',
	#superclass : 'Object',
	#instVars : [
		'contenedor',
		'modelo'
	],
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'testing' }
MorphTateti >> addControls [
| rowMorph newGameButton exitGameButton |
rowMorph := Morph new 
             layoutPolicy: RowLayout new; 
             color: Color transparent.
newGameButton := self createCtrlLabelled: 'New'      onClickExecutes: [self restart].
exitGameButton := self createCtrlLabelled: 'Exit'  onClickExecutes: [contenedor delete].
rowMorph addMorph: exitGameButton.
rowMorph addMorph: newGameButton.
contenedor addMorph: rowMorph.
]

{ #category : 'testing' }
MorphTateti >> agregarFilas [
|filaMorph unaCelda |

1 to:3 do:[ :fil |

filaMorph := Morph new layoutPolicy: RowLayout new.

1 to: 3 do: [ :col |

unaCelda := Celda new.

unaCelda setModel: (modelo) fila: fil col: col.

filaMorph addMorph: unaCelda .

].
contenedor addMorph: filaMorph 
]
]

{ #category : 'testing' }
MorphTateti >> createCtrlLabelled: aString onClickExecutes: aBlock [
| aCtrlButton |
aCtrlButton := SimpleButtonMorph new label: aString.
aCtrlButton color: (Color black alpha: 0.2).
aCtrlButton extent: 120@50.
aCtrlButton on: #click send: #value to: aBlock.
^aCtrlButton.
]

{ #category : 'initialization' }
MorphTateti >> inizialize [ 
contenedor:= Morph new
layoutPolicy: TableLayout new;
color: Color transparent. 

modelo:= Tablero new crear3x3 
"self agregarFilas
self agregarControles
^self."
]

{ #category : 'start' }
MorphTateti >> restart [
contenedor delete.
Smalltalk garbageCollect.
Juego new open
]
