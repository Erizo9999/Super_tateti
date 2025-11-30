"
Ventana principal que contiene el SuperTatetiBoardPanel
la barra superior (SuperTatetiTopBarPanel) y los botones de sistema (SuperTatetiBotonesSistema).

"
Class {
	#name : 'SuperTatetiMorph',
	#superclass : 'Morph',
	#instVars : [
		'juego',
		'controller',
		'boardPanel',
		'topBar',
		'botonesSistema'
	],
	#category : 'Super',
	#package : 'Super'
}

{ #category : 'building' }
SuperTatetiMorph >> crearBoardPanel [ 
   boardPanel := SuperTatetiBoardPanel new.
   boardPanel juego: juego.
   boardPanel controller: controller.
   controller boardPanel: boardPanel.
   self addMorph: boardPanel crearBoardPanel.
   boardPanel actualizarVistaConAyuda: true.

]

{ #category : 'building' }
SuperTatetiMorph >> crearBotonesSistema [ 
   botonesSistema := SuperTatetiBotonesSistema new.
   botonesSistema juego: juego.
   botonesSistema boardPanel: boardPanel.
   self addMorph: botonesSistema crearPanel.

]

{ #category : 'building' }
SuperTatetiMorph >> crearJuego [ 
   juego := SuperTateti new.
   controller := SuperTatetiController new.
   controller juego: juego.

]

{ #category : 'building' }
SuperTatetiMorph >> crearTopBar [ 
   topBar := SuperTatetiTopBarPanel new.
   topBar juego: juego.
   self addMorph: topBar crearPanel.
   controller topBar: topBar.
]

{ #category : 'initialization' }
SuperTatetiMorph >> initialize [ 
   super initialize.
   self color: Color veryLightGray.
   self layoutPolicy: TableLayout new.
   self listDirection: #topToBottom.
   self hResizing: #shrinkWrap; vResizing: #shrinkWrap; cellInset: 4.

   self crearJuego.
   self crearTopBar.
   self crearBoardPanel.
   self crearBotonesSistema.
]
