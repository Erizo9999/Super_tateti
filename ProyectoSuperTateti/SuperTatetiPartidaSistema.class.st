Class {
	#name : 'SuperTatetiPartidaSistema',
	#superclass : 'Object',
	#instVars : [
		'juegoSistema',
		'relojSistema',
		'botonesSistema',
		'vistaPrincipal'
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

    (jugadaValida and: [ vistaPrincipal notNil ]) ifTrue: [
        vistaPrincipal despuesDeJugadaHumano ]

]

{ #category : 'initialization' }
SuperTatetiPartidaSistema >> configurarConJuegoSistema: unJuegoSistema
        relojSistema: unRelojSistema
        botonesSistema: unBotonesSistema
        uiController: unMorph [

    juegoSistema := unJuegoSistema.
    relojSistema := unRelojSistema.
    botonesSistema := unBotonesSistema.
    vistaPrincipal := unMorph.

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
        vistaPrincipal ifNotNil: [
            vistaPrincipal informarJuegoTerminadoEnAyuda ].
        ^ self
    ].

    "Toggle de la bandera de ayuda en BotonesSistema."
    botonesSistema ayudaActiva: (botonesSistema ayudaActiva not).

    "Redibujamos todo según el nuevo estado de la ayuda."
    vistaPrincipal ifNotNil: [
        vistaPrincipal actualizarVista ]

]

{ #category : 'game_logic' }
SuperTatetiPartidaSistema >> iniciarReloj [
    relojSistema
        iniciarRelojParaJuego: juegoSistema
        conCallback: [ vistaPrincipal ticRelojes ]

]

{ #category : 'initialization' }
SuperTatetiPartidaSistema >> initialize [
    super initialize.
    juegoSistema := nil.
    relojSistema := nil.
    botonesSistema := nil.
    vistaPrincipal := nil

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
    | estadoAntes estadoDespues ganadorTablerito oponente perdedor |

    "1) Si ya se acabó el tiempo de X u O, cerramos por tiempo."
    (relojSistema relojX termino or: [ relojSistema relojO termino ]) ifTrue: [
        perdedor := (relojSistema relojX termino)
            ifTrue: [ #x ]
            ifFalse: [ #o ].
        vistaPrincipal ifNotNil: [
            vistaPrincipal finPorTiempoDe: perdedor ].
        ^ false
    ].

    "2) Si el juego ya terminó (por tablero), no se acepta la jugada."
    juegoSistema juegoTerminado ifTrue: [
        vistaPrincipal ifNotNil: [ vistaPrincipal anunciarGanador ].
        ^ false
    ].

    "3) Si el juego todavía no fue iniciado con Start, no permitimos jugar."
    (botonesSistema juegoIniciado) ifFalse: [
        vistaPrincipal ifNotNil: [ vistaPrincipal informarQueDebeIniciar ].
        ^ false
    ].

    "4) Si el reloj está pausado (Stop), no permitimos jugar."
    (relojSistema corriendo) ifFalse: [
        vistaPrincipal ifNotNil: [
            vistaPrincipal informarRelojPausado ].
        ^ false
    ].

    "5) Recordamos el estado del tablerito antes de la jugada."
    estadoAntes := juegoSistema estadoDeTablerito: indiceTablerito.

    "6) Intentamos jugar la jugada en el modelo, capturando posibles errores."
    [ juegoSistema jugarEnTablerito: indiceTablerito casilla: indiceCasilla ]
        on: Error
        do: [ :ex |
            vistaPrincipal ifNotNil: [
                vistaPrincipal informarError: ex messageText ].
            ^ false
        ].

    "7) Actualizamos la vista del tablero."
    vistaPrincipal ifNotNil: [
        vistaPrincipal actualizarVista ].

    "8) Si el juego terminó (por tablero), detenemos relojes y anunciamos ganador."
    juegoSistema juegoTerminado ifTrue: [
        relojSistema detener.
        botonesSistema juegoIniciado: false.
        botonesSistema ponerBotonStartEnModoStart.
        vistaPrincipal ifNotNil: [
            vistaPrincipal anunciarGanador ].
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
        vistaPrincipal ifNotNil: [
            vistaPrincipal actualizarTextoTiempo ].
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
    "Detenemos cualquier reloj que esté andando."
    vistaPrincipal ifNotNil: [
        vistaPrincipal detenerReloj ].

    "Marcamos que el juego ya no está en curso."
    botonesSistema juegoIniciado: false.

    "Reiniciamos el modelo de juego."
    juegoSistema reiniciar.

    "Reiniciamos ambos relojes y dejamos a X como jugador activo."
    relojSistema resetearAmbos.

    "La ayuda de casillas válidas queda siempre activada."
    botonesSistema ayudaActiva: true.

    "Volvemos el botón a 'Start' con tamaño fijo."
    botonesSistema ponerBotonStartEnModoStart.

    "Actualizamos tiempos y tablero en pantalla."
    vistaPrincipal ifNotNil: [
        vistaPrincipal actualizarTextoTiempo.
        vistaPrincipal actualizarVista ]

]

{ #category : 'events' }
SuperTatetiPartidaSistema >> returnDeshabilitado [
    vistaPrincipal ifNotNil: [
        vistaPrincipal informarReturnDeshabilitado ]

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
        vistaPrincipal ifNotNil: [
            vistaPrincipal informarNoSePuedeDeshacerJuegoTerminado ].
        ^ self
    ].

    [ juegoSistema deshacerUltimaJugada ]
        on: Error
        do: [ :ex |
            vistaPrincipal ifNotNil: [
                vistaPrincipal informarError: ex messageText ].
            ^ self
        ].

    "Sincronizamos el jugador activo del reloj con el del juego."
    relojSistema jugadorActivo: juegoSistema jugadorActual.

    vistaPrincipal ifNotNil: [
        vistaPrincipal actualizarVista ]

]

{ #category : 'events' }
SuperTatetiPartidaSistema >> startPresionado [

    "Si el juego ya terminó, mensaje y salir."
    juegoSistema juegoTerminado ifTrue: [
        vistaPrincipal ifNotNil: [
            vistaPrincipal informarJuegoTerminadoDebeVolverAlMenu ].
        ^ self
    ].

    "Si el reloj ya está corriendo → lo pausamos."
    (relojSistema corriendo) ifTrue: [
        vistaPrincipal ifNotNil: [
            vistaPrincipal detenerReloj ].
        botonesSistema ponerBotonStartEnModoStart.
        ^ self
    ].

    "Si aún no se inició el juego, reseteamos los relojes y marcamos que está iniciado."
    (botonesSistema juegoIniciado) ifFalse: [
        botonesSistema juegoIniciado: true.
        relojSistema resetearAmbos.
        vistaPrincipal ifNotNil: [
            vistaPrincipal actualizarTextoTiempo ].
    ].

    "Aseguramos que el jugador activo del reloj coincida con el jugador del juego."
    relojSistema jugadorActivo: juegoSistema jugadorActual.

    "Arrancamos el proceso de tiempo y ponemos el botón en Stop."
    botonesSistema ponerBotonStartEnModoStop.

    vistaPrincipal ifNotNil: [
        vistaPrincipal iniciarReloj ]

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

{ #category : 'accessing' }
SuperTatetiPartidaSistema >> vistaPrincipal [
    ^ vistaPrincipal

]

{ #category : 'accessing' }
SuperTatetiPartidaSistema >> vistaPrincipal: unMorph [
    vistaPrincipal := unMorph

]

{ #category : 'events' }
SuperTatetiPartidaSistema >> volverAlInicio [
    vistaPrincipal ifNotNil: [
        vistaPrincipal volverAlInicio ]

]
