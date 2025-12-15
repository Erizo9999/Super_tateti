Class {
	#name : 'SuperTatetiPcStrategy',
	#superclass : 'Object',
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'game_logic' }
SuperTatetiPcStrategy >> elegirJugadaEn: unJuego [
	| jugadasValidas |
	jugadasValidas := unJuego movimientosValidos.
	jugadasValidas isEmpty ifTrue: [ ^ nil ].
	^ jugadasValidas atRandom

]
