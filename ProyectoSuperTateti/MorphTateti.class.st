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
MorphTateti >> agregarFilas [
|filaMorph unaCelda filaCol |

1 to:3 do:[ :fil |

filaMorph := Morph new layoutPolicy: RowLayout new.

1 to: 3 do: [ :col |
"
unaCelda := Celda new.

unaCelda setModel: (modelo) fila: fil col: col.

filaMorph addMorph: unaCelda ."

].
contenedor addMorph: filaMorph 
]
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
