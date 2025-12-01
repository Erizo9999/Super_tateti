Class {
	#name : 'SuperTatetiJuegoSistema',
	#superclass : 'Object',
	#instVars : [
		'juego',
		'tableroPanel',
		'uiController'
	],
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'building' }
SuperTatetiJuegoSistema >> actualizarVistaConAyuda: unBooleano [
    tableroPanel actualizarVistaConAyuda: unBooleano.

]

{ #category : 'events' }
SuperTatetiJuegoSistema >> clicEnTablerito: indiceTablerito casilla: indiceCasilla [
    "Puente entre el tablero visual (SuperTatetiBoardPanel) y el Morph de UI.
    El BoardPanel envía el clic a este JuegoSistema y aquí lo reenviamos
    al uiController (por ejemplo, un SuperTatetiMorph)."

    uiController ifNotNil: [
        ^ uiController clicEnTablerito: indiceTablerito casilla: indiceCasilla
    ].

]

{ #category : 'initialization' }
SuperTatetiJuegoSistema >> configurarController: unController [
    "El controller de alto nivel es unController (SuperTatetiPartidaSistema),
    pero el tablero habla primero con este JuegoSistema."

    uiController := unController.
    tableroPanel controller: self.
    tableroPanel juego: juego

]

{ #category : 'building' }
SuperTatetiJuegoSistema >> crearBoardPanel [
    ^ tableroPanel crearBoardPanel

]

{ #category : 'events' }
SuperTatetiJuegoSistema >> deshacerUltimaJugada [ 
    "Pide al modelo que deshaga la última jugada."
    ^ juego deshacerUltimaJugada
]

{ #category : 'accessing' }
SuperTatetiJuegoSistema >> estadoDeTablerito: indiceTablerito [
    ^ juego estadoDeTablerito: indiceTablerito

]

{ #category : 'accessing' }
SuperTatetiJuegoSistema >> ganador [
    ^ juego ganador

]

{ #category : 'accessing' }
SuperTatetiJuegoSistema >> ganador: unSimbolo [
    juego ganador: unSimbolo

]

{ #category : 'initialization' }
SuperTatetiJuegoSistema >> initialize [
    super initialize.
    juego := SuperTateti new.
    tableroPanel := SuperTatetiBoardPanel new.
    uiController := nil.

]

{ #category : 'accessing' }
SuperTatetiJuegoSistema >> juego [
	^juego
]

{ #category : 'accessing' }
SuperTatetiJuegoSistema >> juegoTerminado [
    ^ juego juegoTerminado

]

{ #category : 'accessing' }
SuperTatetiJuegoSistema >> jugadorActual [
    ^ juego jugadorActual

]

{ #category : 'accessing' }
SuperTatetiJuegoSistema >> jugarEnTablerito: indiceTablerito casilla: indiceCasilla [
    ^ juego jugarEnTablerito: indiceTablerito casilla: indiceCasilla

]

{ #category : 'accessing' }
SuperTatetiJuegoSistema >> reiniciar [
    juego reiniciar

]

{ #category : 'accessing' }
SuperTatetiJuegoSistema >> uiController [
    ^ uiController
]

{ #category : 'accessing' }
SuperTatetiJuegoSistema >> uiController: unMorph [
    uiController := unMorph
]
