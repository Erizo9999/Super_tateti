"
recibir eventos de boton y delegar al modelo, luego refrescar el panel
"
Class {
	#name : 'SuperTatetiController',
	#superclass : 'Object',
	#instVars : [
		'juego',
		'boardPanel',
		'topBar'
	],
	#category : 'Super',
	#package : 'Super'
}

{ #category : 'accessing' }
SuperTatetiController >> boardPanel: p [  
boardPanel := p 

]

{ #category : 'updating' }
SuperTatetiController >> clicEnTablerito: t casilla: c [ 
   [ juego jugarEnTablerito: t casilla: c ]
      on: Error do: [:e | Transcript show: e messageText; cr ].

   boardPanel actualizarVistaConAyuda: true.
   topBar refrescar.




]

{ #category : 'accessing' }
SuperTatetiController >> juego: j [ 
 juego := j
]

{ #category : 'accessing' }
SuperTatetiController >> topBar: aTopBar [ 
   topBar := aTopBar

]
