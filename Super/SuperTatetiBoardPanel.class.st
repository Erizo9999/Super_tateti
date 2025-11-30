"
contruir la grilla 9x9 con gaps y actualiza visualmente
"
Class {
	#name : 'SuperTatetiBoardPanel',
	#superclass : 'Object',
	#instVars : [
		'juego',
		'controller',
		'botones',
		'panel'
	],
	#category : 'Super',
	#package : 'Super'
}

{ #category : 'updating' }
SuperTatetiBoardPanel >> actualizarBotonDeTablerito: t casilla: c [ 
   | par btn etiqueta valor |
   par := (botones at: t) at: c.
   btn := par first.
   etiqueta := par second.
   valor := juego valorEnTablerito: t casilla: c.

   btn color: Color white.
   etiqueta contents: (valor ifNil: [ '' ] ifNotNil: [ valor asString asUppercase ]).
   etiqueta center: btn center.

]

{ #category : 'updating' }
SuperTatetiBoardPanel >> actualizarVistaConAyuda: mostrarAyuda [ 
   1 to: 9 do: [:t | 1 to: 9 do: [:c | self actualizarBotonDeTablerito: t casilla: c ] ].
   self resaltarEstadoDeSubTableros.
   mostrarAyuda ifTrue: [ self resaltarMovimientosValidos ].
]

{ #category : 'accessing' }
SuperTatetiBoardPanel >> controller [  ^ controller
]

{ #category : 'updating' }
SuperTatetiBoardPanel >> controller: unController [ 
   controller := unController.
   controller boardPanel: self. 
]

{ #category : 'building' }
SuperTatetiBoardPanel >> crearBoardPanel [ 
   | boardPanelLocal |
   boardPanelLocal := Morph new.
   boardPanelLocal layoutPolicy: TableLayout new.
   boardPanelLocal listDirection: #topToBottom.
   boardPanelLocal hResizing: #shrinkWrap; vResizing: #shrinkWrap; cellInset: 0.
   boardPanelLocal color: Color veryLightGray.

   self inicializarBotones.

   1 to: 9 do: [:row |
      boardPanelLocal addMorph: (self crearFila: row).
      (#(3 6) includes: row) ifTrue: [ boardPanelLocal addMorph: self crearGapFila ] ].

   panel := boardPanelLocal.
   ^ boardPanelLocal

]

{ #category : 'building' }
SuperTatetiBoardPanel >> crearBotonEnFila: row columna: col [ 
   | tIndex cIndex btn etiqueta |
   tIndex := self indiceTableritoParaFila: row columna: col.
   cIndex := self indiceCasillaParaFila: row columna: col.

   btn := SimpleButtonMorph new.
   btn extent: self tamanoCelda @ self tamanoCelda.
   btn hResizing: #rigid; vResizing: #rigid.
   btn color: Color white.
   btn borderWidth: 1; borderColor: Color black.

   etiqueta := StringMorph contents: ''.
   etiqueta color: Color black.
   btn addMorph: etiqueta.
   etiqueta center: btn center.

   btn
      target: controller;
      actionSelector: #clicEnTablerito:casilla:;
      arguments: { tIndex. cIndex }.

   (botones at: tIndex) at: cIndex put: { btn. etiqueta }.
   ^ btn

]

{ #category : 'building' }
SuperTatetiBoardPanel >> crearFila: row [ 
   | filaMorph |
   filaMorph := Morph new.
   filaMorph layoutPolicy: TableLayout new.
   filaMorph listDirection: #leftToRight.
   filaMorph hResizing: #shrinkWrap; vResizing: #shrinkWrap; cellInset: 0.

   1 to: 9 do: [:col |
      filaMorph addMorph: (self crearBotonEnFila: row columna: col).
      (#(3 6) includes: col) ifTrue: [ filaMorph addMorph: self crearGapColumna ] ].
   ^ filaMorph

]

{ #category : 'building' }
SuperTatetiBoardPanel >> crearGapColumna [ 
   ^ Morph new
      layoutPolicy: nil;
      hResizing: #rigid; vResizing: #rigid;
      extent: self tamanoGap @ self tamanoCelda;
      color: Color gray;
      borderWidth: 0;
      yourself

]

{ #category : 'building' }
SuperTatetiBoardPanel >> crearGapFila [ 
   | ancho |
   ancho := (9 * self tamanoCelda) + (2 * self tamanoGap).
   ^ Morph new
      layoutPolicy: nil;
      hResizing: #rigid; vResizing: #rigid;
      extent: ancho @ self tamanoGap;
      color: Color gray;
      borderWidth: 0;
      yourself

]

{ #category : 'building' }
SuperTatetiBoardPanel >> indiceCasillaParaFila: row columna: col [ 
   ^ ((row - 1) \\ 3) * 3 + ((col - 1) \\ 3) + 1

]

{ #category : 'building' }
SuperTatetiBoardPanel >> indiceTableritoParaFila: row columna: col [ 
   ^ ((row - 1) // 3) * 3 + ((col - 1) // 3) + 1

]

{ #category : 'building' }
SuperTatetiBoardPanel >> inicializarBotones [ 
botones := (1 to: 9) collect: [:t | Array new: 9]. "Crea e inicializa directamente el Array de Arrays 9x9."

]

{ #category : 'initialization' }
SuperTatetiBoardPanel >> initialize [ 
   super initialize.
   juego := nil.
   controller := nil.
   botones := nil.
   panel := nil.

]

{ #category : 'accessing' }
SuperTatetiBoardPanel >> juego [  ^ juego 

]

{ #category : 'accessing' }
SuperTatetiBoardPanel >> juego: j [ 
 juego := j
]

{ #category : 'accessing' }
SuperTatetiBoardPanel >> panel [  ^ panel
]

{ #category : 'building' }
SuperTatetiBoardPanel >> rearFila: row [ 
   | filaMorph |
   filaMorph := Morph new.
   filaMorph layoutPolicy: TableLayout new.
   filaMorph listDirection: #leftToRight.
   filaMorph hResizing: #shrinkWrap; vResizing: #shrinkWrap; cellInset: 0.

   1 to: 9 do: [:col |
      filaMorph addMorph: (self crearBotonEnFila: row columna: col).
      (#(3 6) includes: col) ifTrue: [ filaMorph addMorph: self crearGapColumna ] ].
   ^ filaMorph

]

{ #category : 'updating' }
SuperTatetiBoardPanel >> resaltarEstadoDeSubTableros [ 
   1 to: 9 do: [:t |
      | estado ganadorSub |
      estado := juego estadoDeTablerito: t.
      ganadorSub := (estado = #x or: [ estado = #o ]) ifTrue: [ estado ] ifFalse: [ nil ].
      1 to: 9 do: [:c |
         | par btn |
         par := (botones at: t) at: c.
         btn := par first.
         ganadorSub ifNotNil: [
            btn color: (ganadorSub = #x ifTrue: [ Color blue ] ifFalse: [ Color red ]).
            btn target: nil; actionSelector: nil; arguments: #() ].
         (estado = #empate) ifTrue: [ btn color: Color veryLightGray ] ] ].


]

{ #category : 'updating' }
SuperTatetiBoardPanel >> resaltarMovimientosValidos [
	| tablerosAInspeccionar |
	
	"Determina qué tablero(s) se deben inspeccionar: todos (1 to: 9) o solo el indicado."
	tablerosAInspeccionar := juego proximoTablerito 
		ifNil: [ 1 to: 9 ]
		ifNotNil: [:destino | Array with: destino ].

	"Itera solo sobre los tableros que están #enJuego"
	tablerosAInspeccionar select: [ :t | (juego estadoDeTablerito: t) = #enJuego ] thenDo: [ :t |

		"Itera sobre las 9 casillas de ese tablero"
		1 to: 9 do: [ :c |
		
			"Si es un movimiento válido, obtiene y resalta el botón."
			(juego esMovimientoValidoEnTablerito: t casilla: c) ifTrue: [
				
				"Accede directamente al primer elemento del par (asumiendo que es el botón)"
				((botones at: t) at: c) first color: Color yellow
			]
		]
	].

]

{ #category : 'building' }
SuperTatetiBoardPanel >> tamanoCelda [  ^ 30
]

{ #category : 'building' }
SuperTatetiBoardPanel >> tamanoGap [  ^ 6 
]
