"
panel
"
Class {
	#name : 'SuperTatetiTopBarPanel',
	#superclass : 'Object',
	#instVars : [
		'juego',
		'panel',
		'labelJugador',
		'labelGanador'
	],
	#category : 'Super',
	#package : 'Super'
}

{ #category : 'building' }
SuperTatetiTopBarPanel >> crearPanel [ 
   panel := Morph new.
   panel layoutPolicy: TableLayout new.
   panel listDirection: #leftToRight.
   panel hResizing: #shrinkWrap; vResizing: #shrinkWrap; cellInset: 10.

   labelJugador := StringMorph contents: 'Jugador: ' , juego jugadorActual asString.
   labelGanador := StringMorph contents: 'Ganador: ' , (juego ganador ifNil: [ '-' ]).

   panel addMorph: labelJugador; addMorph: labelGanador.

   ^ panel
]

{ #category : 'accessing' }
SuperTatetiTopBarPanel >> juego: j [ 
juego := j 


]

{ #category : 'updating' }
SuperTatetiTopBarPanel >> refrescar [ 
   labelJugador contents: 'Jugador: ' , juego jugadorActual asString.
   labelGanador contents: 'Ganador: ' , (juego ganador ifNil: [ '-' ]).




]

{ #category : 'message performing' }
SuperTatetiTopBarPanel >> suscribirAlJuego: unJuego [ 
   unJuego announcer when: TurnoCambiado send: #refrescar to: self.
   unJuego announcer when: GanadorCambiado send: #refrescar to: self.



]
