Class {
	#name : 'SuperTatetiJuegoSistema',
	#superclass : 'Object',
	#instVars : [
		'juego',
		'tableroPanel',
		'partidaSistema'
	],
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'updating' }
SuperTatetiJuegoSistema >> actualizarVistaConAyuda: unBooleano [
    tableroPanel actualizarVista.

    unBooleano ifTrue: [
        tableroPanel resaltarCasillas: self movimientosValidos ]

]

{ #category : 'events' }
SuperTatetiJuegoSistema >> clicEnTablerito: indiceTablerito casilla: indiceCasilla [
    "Puente entre el tablero visual (SuperTatetiBoardPanel) y la Partida.
    El BoardPanel envía el clic a este JuegoSistema y aquí lo reenviamos
    al orquestador de partida (SuperTatetiPartidaSistema)."

    partidaSistema ifNotNil: [
        ^ partidaSistema
            clicEnTablerito: indiceTablerito
            casilla: indiceCasilla
    ].

]

{ #category : 'initialization' }
SuperTatetiJuegoSistema >> configurarController: unController [
    "El controller de alto nivel es unController (SuperTatetiPartidaSistema),
    pero el tablero habla primero con este JuegoSistema."

    partidaSistema := unController.
    tableroPanel controller: self

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
SuperTatetiJuegoSistema >> esMovimientoValidoEnTablerito: indiceTablerito casilla: indiceCasilla [
    ^ juego
        esMovimientoValidoEnTablerito: indiceTablerito
        casilla: indiceCasilla

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
    partidaSistema := nil.

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

{ #category : 'game_logic' }
SuperTatetiJuegoSistema >> movimientosValidos [
    | jugadas |

    jugadas := OrderedCollection new.

    1 to: 9 do: [:t |
        1 to: 9 do: [:c |
            (juego esMovimientoValidoEnTablerito: t casilla: c)
                ifTrue: [ jugadas add: { t. c } ] ] ].

    ^ jugadas

]

{ #category : 'accessing' }
SuperTatetiJuegoSistema >> partidaSistema [
    ^ partidaSistema

]

{ #category : 'accessing' }
SuperTatetiJuegoSistema >> partidaSistema: unPartidaSistema [
    partidaSistema := unPartidaSistema

]

{ #category : 'accessing' }
SuperTatetiJuegoSistema >> reiniciar [
    juego reiniciar

]

{ #category : 'accessing' }
SuperTatetiJuegoSistema >> valorEnTablerito: indiceTablerito casilla: indiceCasilla [
    ^ juego
        valorEnTablerito: indiceTablerito
        casilla: indiceCasilla

]
