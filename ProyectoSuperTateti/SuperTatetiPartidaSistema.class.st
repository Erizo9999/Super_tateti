Class {
	#name : 'SuperTatetiPartidaSistema',
	#superclass : 'Object',
	#instVars : [
		'juegoSistema',
		'relojSistema',
		'botonesSistema',
		'uiController'
	],
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'updating' }
SuperTatetiPartidaSistema >> actualizarTextoTiempo [
    relojSistema actualizarTextoTiempo

]

{ #category : 'updating' }
SuperTatetiPartidaSistema >> actualizarVista [
    juegoSistema actualizarVistaConAyuda: self ayudaActiva

]

{ #category : 'accessing' }
SuperTatetiPartidaSistema >> ayudaActiva [
    ^ botonesSistema ayudaActiva

]

{ #category : 'accessing' }
SuperTatetiPartidaSistema >> ayudaActiva: unBooleano [
    botonesSistema ayudaActiva: unBooleano

]

{ #category : 'accessing' }
SuperTatetiPartidaSistema >> botonStart [
    ^ botonesSistema botonStart

]

{ #category : 'accessing' }
SuperTatetiPartidaSistema >> botonStart: unBoton [
    botonesSistema botonStart: unBoton

]

{ #category : 'accessing' }
SuperTatetiPartidaSistema >> botonesSistema [
    ^ botonesSistema

]

{ #category : 'accessing' }
SuperTatetiPartidaSistema >> botonesSistema: unBotonesSistema [
    botonesSistema := unBotonesSistema

]

{ #category : 'events' }
SuperTatetiPartidaSistema >> clicEnTablerito: indiceTablerito casilla: indiceCasilla [
    | jugadaValida |

    jugadaValida := self
        procesarJugadaEnTablerito: indiceTablerito
        casilla: indiceCasilla.

    (jugadaValida and: [ uiController notNil ]) ifTrue: [
        uiController despuesDeJugadaHumano ]

]

{ #category : 'initialization' }
SuperTatetiPartidaSistema >> configurarConJuegoSistema: unJuegoSistema
        relojSistema: unRelojSistema
        botonesSistema: unBotonesSistema
        uiController: unMorph [

    juegoSistema := unJuegoSistema.
    relojSistema := unRelojSistema.
    botonesSistema := unBotonesSistema.
    uiController := unMorph.

    "Conectar los sistemas con este orquestador de partida."
    juegoSistema configurarController: self.
    botonesSistema controller: self

]

{ #category : 'building' }
SuperTatetiPartidaSistema >> crearBoardPanel [
    ^ juegoSistema crearBoardPanel

]

{ #category : 'building' }
SuperTatetiPartidaSistema >> crearPanelTiemposJugadores [
    ^ relojSistema crearPanelTiemposJugadores

]

{ #category : 'building' }
SuperTatetiPartidaSistema >> crearTopBarPanel [
    ^ botonesSistema crearTopBarPanel

]

{ #category : 'game_logic' }
SuperTatetiPartidaSistema >> detenerReloj [
    relojSistema detener

]

{ #category : 'events' }
SuperTatetiPartidaSistema >> helpPresionado [
    juegoSistema juegoTerminado ifTrue: [
        UIManager default inform: 'El juego ya terminó.'.
        ^ self
    ].

    "Toggle de la bandera de ayuda en BotonesSistema."
    botonesSistema ayudaActiva: (botonesSistema ayudaActiva not).

    "Redibujamos todo según el nuevo estado de la ayuda."
    uiController ifNotNil: [
        uiController actualizarVista ]

]

{ #category : 'game_logic' }
SuperTatetiPartidaSistema >> iniciarReloj [
    relojSistema
        iniciarRelojParaJuego: juegoSistema
        conCallback: [ uiController ticRelojes ]

]

{ #category : 'initialization' }
SuperTatetiPartidaSistema >> initialize [
    super initialize.
    juegoSistema := nil.
    relojSistema := nil.
    botonesSistema := nil.
    uiController := nil

]

{ #category : 'accessing' }
SuperTatetiPartidaSistema >> juegoIniciado [
    ^ botonesSistema juegoIniciado

]

{ #category : 'accessing' }
SuperTatetiPartidaSistema >> juegoIniciado: unBooleano [
    botonesSistema juegoIniciado: unBooleano

]

{ #category : 'accessing' }
SuperTatetiPartidaSistema >> juegoSistema [
    ^ juegoSistema

]

{ #category : 'accessing' }
SuperTatetiPartidaSistema >> juegoSistema: unJuegoSistema [
    juegoSistema := unJuegoSistema

]

{ #category : 'events' }
SuperTatetiPartidaSistema >> jugarMovimientoPcEnTablerito: indiceTablerito casilla: indiceCasilla [
    self
        procesarJugadaEnTablerito: indiceTablerito
        casilla: indiceCasilla

]

{ #category : 'game_logic' }
SuperTatetiPartidaSistema >> procesarJugadaEnTablerito: indiceTablerito casilla: indiceCasilla [
    | estadoAntes estadoDespues ganadorTablerito oponente perdedor boton |

    "1) Si ya se acabó el tiempo de X u O, cerramos por tiempo."
    (relojSistema relojX termino or: [ relojSistema relojO termino ]) ifTrue: [
        perdedor := (relojSistema relojX termino)
            ifTrue: [ #x ]
            ifFalse: [ #o ].
        uiController ifNotNil: [
            uiController finPorTiempoDe: perdedor ].
        ^ false
    ].

    "2) Si el juego ya terminó (por tablero), no se acepta la jugada."
    juegoSistema juegoTerminado ifTrue: [
        uiController ifNotNil: [ uiController anunciarGanador ].
        ^ false
    ].

    "3) Si el juego todavía no fue iniciado con Start, no permitimos jugar."
    (botonesSistema juegoIniciado) ifFalse: [
        uiController ifNotNil: [ uiController informarQueDebeIniciar ].
        ^ false
    ].

    "4) Si el reloj está pausado (Stop), no permitimos jugar."
    (relojSistema corriendo) ifFalse: [
        UIManager default inform: 'El reloj está pausado. Presiona Start para seguir jugando.'.
        ^ false
    ].

    "5) Recordamos el estado del tablerito antes de la jugada."
    estadoAntes := juegoSistema estadoDeTablerito: indiceTablerito.

    "6) Intentamos jugar la jugada en el modelo, capturando posibles errores."
    [ juegoSistema jugarEnTablerito: indiceTablerito casilla: indiceCasilla ]
        on: Error
        do: [ :ex |
            UIManager default inform: ex messageText.
            ^ false ].

    "7) Actualizamos la vista del tablero."
    uiController ifNotNil: [
        uiController actualizarVista ].

    "8) Si el juego terminó (por tablero), detenemos relojes y anunciamos ganador."
    juegoSistema juegoTerminado ifTrue: [
        relojSistema detener.
        botonesSistema juegoIniciado: false.
        boton := botonesSistema botonStart.
        boton ifNotNil: [
            boton label: 'Start'.
            boton extent: 100@40 ].
        uiController ifNotNil: [
            uiController anunciarGanador ].
        ^ true
    ].

    "9) Revisamos si con esta jugada se capturó el tablerito del tablero grande."
    estadoDespues := juegoSistema estadoDeTablerito: indiceTablerito.
    ((#(#x #o) includes: estadoDespues) and: [ estadoDespues ~= estadoAntes ]) ifTrue: [
        ganadorTablerito := estadoDespues.
        oponente := (ganadorTablerito = #x)
            ifTrue: [ #o ]
            ifFalse: [ #x ].
        relojSistema penalizarA: oponente segundos: 10.
        uiController ifNotNil: [
            uiController actualizarTextoTiempo ].
    ].

    "10) Si el juego sigue, alternamos el jugador activo del reloj."
    relojSistema alternarJugador.

    ^ true

]

{ #category : 'accessing' }
SuperTatetiPartidaSistema >> relojSistema [
    ^ relojSistema

]

{ #category : 'accessing' }
SuperTatetiPartidaSistema >> relojSistema: unRelojSistema [
    relojSistema := unRelojSistema

]

{ #category : 'events' }
SuperTatetiPartidaSistema >> resetPresionado [
    | boton |

    "Detenemos cualquier reloj que esté andando."
    uiController ifNotNil: [
        uiController detenerReloj ].

    "Marcamos que el juego ya no está en curso."
    botonesSistema juegoIniciado: false.

    "Reiniciamos el modelo de juego."
    juegoSistema reiniciar.

    "Reiniciamos ambos relojes y dejamos a X como jugador activo."
    relojSistema resetearAmbos.

    "La ayuda de casillas válidas queda siempre activada."
    botonesSistema ayudaActiva: true.

    "Volvemos el botón a 'Start' con tamaño fijo."
    boton := botonesSistema botonStart.
    boton ifNotNil: [
        boton label: 'Start'.
        boton extent: 100@40 ].

    "Actualizamos tiempos y tablero en pantalla."
    uiController ifNotNil: [
        uiController actualizarTextoTiempo.
        uiController actualizarVista ]

]

{ #category : 'events' }
SuperTatetiPartidaSistema >> returnDeshabilitado [
    UIManager default inform:
        'La función Return está deshabilitada para esta partida.'

]

{ #category : 'accessing' }
SuperTatetiPartidaSistema >> returnHabilitado [
    ^ botonesSistema returnHabilitado

]

{ #category : 'accessing' }
SuperTatetiPartidaSistema >> returnHabilitado: unBooleano [
    botonesSistema returnHabilitado: unBooleano

]

{ #category : 'events' }
SuperTatetiPartidaSistema >> returnPresionado [
    "Deshace la última jugada, solo si el juego sigue en curso."

    juegoSistema juegoTerminado ifTrue: [
        UIManager default inform:
            'El juego ya terminó. No puedes deshacer jugadas.'.
        ^ self
    ].

    [ juegoSistema deshacerUltimaJugada ]
        on: Error
        do: [ :ex | ^ UIManager default inform: ex messageText ].

    "Sincronizamos el jugador activo del reloj con el del juego."
    relojSistema jugadorActivo: juegoSistema jugadorActual.

    uiController ifNotNil: [
        uiController actualizarVista ]

]

{ #category : 'events' }
SuperTatetiPartidaSistema >> startPresionado [
    | boton |

    "Si el juego ya terminó, mensaje y salir."
    juegoSistema juegoTerminado ifTrue: [
        UIManager default inform:
            'El juego ya terminó. Debes volver al menú para iniciar una nueva partida.'.
        ^ self
    ].

    boton := botonesSistema botonStart.

    "Si el reloj ya está corriendo → lo pausamos."
    (relojSistema corriendo) ifTrue: [
        uiController ifNotNil: [
            uiController detenerReloj ].
        boton ifNotNil: [
            boton label: 'Start'.
            boton extent: 100@40 ].
        ^ self
    ].

    "Si aún no se inició el juego, reseteamos los relojes y marcamos que está iniciado."
    (botonesSistema juegoIniciado) ifFalse: [
        botonesSistema juegoIniciado: true.
        relojSistema resetearAmbos.
        uiController ifNotNil: [
            uiController actualizarTextoTiempo ].
    ].

    "Aseguramos que el jugador activo del reloj coincida con el jugador del juego."
    relojSistema jugadorActivo: juegoSistema jugadorActual.

    "Arrancamos el proceso de tiempo y ponemos el botón en Stop."
    boton ifNotNil: [
        boton label: 'Stop'.
        boton extent: 100@40 ].

    uiController ifNotNil: [
        uiController iniciarReloj ]

]

{ #category : 'game_logic' }
SuperTatetiPartidaSistema >> ticRelojes [
    ^ relojSistema tic

]

{ #category : 'accessing' }
SuperTatetiPartidaSistema >> uiController [
    ^ uiController

]

{ #category : 'accessing' }
SuperTatetiPartidaSistema >> uiController: unMorph [
    uiController := unMorph

]

{ #category : 'events' }
SuperTatetiPartidaSistema >> volverAlInicio [
    uiController ifNotNil: [
        uiController volverAlInicio ]

]
