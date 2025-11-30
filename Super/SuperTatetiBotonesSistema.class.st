"
botonera
"
Class {
	#name : 'SuperTatetiBotonesSistema',
	#superclass : 'Object',
	#instVars : [
		'juego',
		'boardPanel'
	],
	#category : 'Super',
	#package : 'Super'
}

{ #category : 'accessing' }
SuperTatetiBotonesSistema >> boardPanel: p [ 
boardPanel := p 
]

{ #category : 'building' }
SuperTatetiBotonesSistema >> crearPanel [ 
   | panel reiniciar ayuda |
   panel := Morph new.
   panel layoutPolicy: TableLayout new.
   panel listDirection: #leftToRight.
   panel hResizing: #shrinkWrap; vResizing: #shrinkWrap; cellInset: 4.

   reiniciar := SimpleButtonMorph new label: 'Reiniciar'.
   reiniciar target: self; actionSelector: #reiniciarJuego.

   ayuda := SimpleButtonMorph new label: 'Ayuda'.
   ayuda target: self; actionSelector: #toggleAyuda.

   panel addMorph: reiniciar; addMorph: ayuda.
   ^ panel

]

{ #category : 'accessing' }
SuperTatetiBotonesSistema >> juego: j [ 
 juego := j 

]

{ #category : 'functions' }
SuperTatetiBotonesSistema >> reiniciarJuego [ 
   juego reiniciar.
   boardPanel actualizarVistaConAyuda: false.
]

{ #category : 'functions' }
SuperTatetiBotonesSistema >> toggleAyuda [ 
   boardPanel actualizarVistaConAyuda: true.

]
