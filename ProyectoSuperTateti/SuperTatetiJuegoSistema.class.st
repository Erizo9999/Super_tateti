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

{ #category : 'accessing' }
SuperTatetiJuegoSistema >> botonStart [
    uiController ifNotNil: [ ^ uiController botonStart ].
    ^ nil

]

{ #category : 'accessing' }
SuperTatetiJuegoSistema >> botonStart: unBoton [
    uiController ifNotNil: [
        uiController botonStart: unBoton
    ].

]

{ #category : 'events' }
SuperTatetiJuegoSistema >> clicEnTablerito: indiceTablerito casilla: indiceCasilla [
    uiController ifNotNil: [
        ^ uiController clicEnTablerito: indiceTablerito casilla: indiceCasilla
    ].

]

{ #category : 'initialization' }
SuperTatetiJuegoSistema >> configurarController: unMorph [
    uiController := unMorph.
    tableroPanel controller: self.
    tableroPanel juego: juego.
]

{ #category : 'building' }
SuperTatetiJuegoSistema >> crearBoardPanel [
    ^ tableroPanel crearBoardPanel

]

{ #category : 'accessing' }
SuperTatetiJuegoSistema >> deshacerUltimaJugada [
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

{ #category : 'events' }
SuperTatetiJuegoSistema >> resetPresionado [
    uiController ifNotNil: [
        ^ uiController resetPresionado
    ].

]

{ #category : 'events' }
SuperTatetiJuegoSistema >> returnDeshabilitado [
    uiController ifNotNil: [
        ^ uiController returnDeshabilitado
    ].
]

{ #category : 'accessing' }
SuperTatetiJuegoSistema >> returnHabilitado [
    uiController ifNotNil: [ ^ uiController returnHabilitado ].
    ^ true  "valor por defecto si por algún motivo no hay uiController"

]

{ #category : 'accessing' }
SuperTatetiJuegoSistema >> returnHabilitado: unBooleano [
    uiController ifNotNil: [
        uiController returnHabilitado: unBooleano
    ].

]

{ #category : 'events' }
SuperTatetiJuegoSistema >> returnPresionado [
    uiController ifNotNil: [
        ^ uiController returnPresionado
    ].
]

{ #category : 'events' }
SuperTatetiJuegoSistema >> startPresionado [
    uiController ifNotNil: [
        ^ uiController startPresionado
    ].

]

{ #category : 'accessing' }
SuperTatetiJuegoSistema >> uiController [
    ^ uiController
]

{ #category : 'accessing' }
SuperTatetiJuegoSistema >> uiController: unMorph [
    uiController := unMorph
]

{ #category : 'events' }
SuperTatetiJuegoSistema >> volverAlInicio [
    uiController ifNotNil: [
        ^ uiController volverAlInicio
    ].
]
