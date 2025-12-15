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
	tableroPanel actualizarVistaConAyuda: unBooleano

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
	^ juego movimientosValidos

]

{ #category : 'accessing' }
SuperTatetiJuegoSistema >> partidaSistema [
    ^ partidaSistema

]

{ #category : 'accessing' }
SuperTatetiJuegoSistema >> partidaSistema: unPartidaSistema [
    partidaSistema := unPartidaSistema

]

{ #category : 'game_logic' }
SuperTatetiJuegoSistema >> procesarJugadaEnTablerito: indiceTablerito casilla: indiceCasilla [
	"El controller real del tablero es JuegoSistema.
	Este método encapsula TODO lo del modelo para una jugada en 1 sola llamada.
	Devuelve un Dictionary con:
	  #jugadaValida -> Boolean
	  #error -> String (si falla)
	  #estadoAntes -> (#enJuego/#empate/#x/#o)
	  #estadoDespues -> idem
	  #juegoTerminado -> Boolean
	  #jugadorActual -> (#x/#o) (después de jugar)
	  #ganador -> (#x/#o/nil)"

	| resultado estadoAntes estadoDespues |

	resultado := Dictionary new.

	estadoAntes := self estadoDeTablerito: indiceTablerito.
	resultado at: #estadoAntes put: estadoAntes.

	[ juego jugarEnTablerito: indiceTablerito casilla: indiceCasilla ]
		on: Error
		do: [ :ex |
			resultado at: #jugadaValida put: false.
			resultado at: #error put: ex messageText.
			resultado at: #estadoDespues put: estadoAntes.
			resultado at: #juegoTerminado put: juego juegoTerminado.
			resultado at: #jugadorActual put: juego jugadorActual.
			resultado at: #ganador put: juego ganador.
			^ resultado ].

	estadoDespues := self estadoDeTablerito: indiceTablerito.

	resultado at: #jugadaValida put: true.
	resultado at: #estadoDespues put: estadoDespues.
	resultado at: #juegoTerminado put: juego juegoTerminado.
	resultado at: #jugadorActual put: juego jugadorActual.
	resultado at: #ganador put: juego ganador.

	^ resultado

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
