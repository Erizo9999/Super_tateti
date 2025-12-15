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

{ #category : 'game_logic' }
SuperTatetiPartidaSistema >> aplicarPenalizacionSiCapturoTablerito: indiceTablerito estadoAntes: estadoAntes [
    | estadoDespues ganadorTablerito oponente |

    estadoDespues := juegoSistema estadoDeTablerito: indiceTablerito.

    ((#(#x #o) includes: estadoDespues) and: [ estadoDespues ~= estadoAntes ]) ifFalse: [
        ^ self ].

    ganadorTablerito := estadoDespues.
    oponente := (ganadorTablerito = #x)
        ifTrue: [ #o ]
        ifFalse: [ #x ].

    relojSistema penalizarA: oponente segundos: 10.

    "Actualizar el panel del reloj sin pasar por la vista"
    self actualizarTextoTiempo

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
SuperTatetiPartidaSistema >> debeRechazarJugada [
	(self rechazarSiTerminoPorTiempo) ifTrue: [ ^ true ].
	(self rechazarSiJuegoTerminado) ifTrue: [ ^ true ].
	(self rechazarSiNoIniciado) ifTrue: [ ^ true ].
	(self rechazarSiRelojPausado) ifTrue: [ ^ true ].
	^ false

]

{ #category : 'game_logic' }
SuperTatetiPartidaSistema >> detenerReloj [
    relojSistema detener

]

{ #category : 'accessing' }
SuperTatetiPartidaSistema >> fijarGanador: unSimbolo [
    juegoSistema ganador: unSimbolo

]

{ #category : 'game_logic' }
SuperTatetiPartidaSistema >> finalizarPartidaPorTablero [
    relojSistema detener.
    botonesSistema juegoIniciado: false.
    botonesSistema ponerBotonStartEnModoStart.

    vistaPrincipal ifNotNil: [
        vistaPrincipal anunciarGanador ]

]

{ #category : 'game_logic' }
SuperTatetiPartidaSistema >> finalizarTurnoTrasJugadaEnTablerito: indiceTablerito estadoAntes: estadoAntes [
	vistaPrincipal ifNotNil: [ vistaPrincipal actualizarVista ].

	juegoSistema juegoTerminado ifTrue: [
		self finalizarPartidaPorTablero.
		^ true ].

	self aplicarPenalizacionSiCapturoTablerito: indiceTablerito estadoAntes: estadoAntes.
	relojSistema alternarJugador.
	^ true

]

{ #category : 'accessing' }
SuperTatetiPartidaSistema >> ganadorActual [
    ^ juegoSistema ganador

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
        conCallback: [ self procesarTickRelojes ]

]

{ #category : 'initialization' }
SuperTatetiPartidaSistema >> initialize [
    super initialize.
]

{ #category : 'game_logic' }
SuperTatetiPartidaSistema >> intentarJugarEnTablerito: indiceTablerito casilla: indiceCasilla [
	[ juegoSistema jugarEnTablerito: indiceTablerito casilla: indiceCasilla ]
		on: Error
		do: [ :ex |
			vistaPrincipal ifNotNil: [
				vistaPrincipal informarError: ex messageText ].
			^ false ].
	^ true

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

{ #category : 'accessing' }
SuperTatetiPartidaSistema >> juegoTerminado [
    ^ juegoSistema juegoTerminado

]

{ #category : 'accessing' }
SuperTatetiPartidaSistema >> jugadorActual [
    ^ juegoSistema jugadorActual

]

{ #category : 'events' }
SuperTatetiPartidaSistema >> jugarMovimientoPcEnTablerito: indiceTablerito casilla: indiceCasilla [
    self
        procesarJugadaEnTablerito: indiceTablerito
        casilla: indiceCasilla

]

{ #category : 'accessing' }
SuperTatetiPartidaSistema >> modeloDeJuego [
    ^ juegoSistema juego

]

{ #category : 'events' }
SuperTatetiPartidaSistema >> ponerBotonStartEnModoStart [
    botonesSistema ponerBotonStartEnModoStart

]

{ #category : 'events' }
SuperTatetiPartidaSistema >> ponerBotonStartEnModoStop [
    botonesSistema ponerBotonStartEnModoStop

]

{ #category : 'game_logic' }
SuperTatetiPartidaSistema >> procesarJugadaEnTablerito: indiceTablerito casilla: indiceCasilla [
	| estadoAntes |

	(self debeRechazarJugada) ifTrue: [ ^ false ].

	estadoAntes := juegoSistema estadoDeTablerito: indiceTablerito.

	(self intentarJugarEnTablerito: indiceTablerito casilla: indiceCasilla)
		ifFalse: [ ^ false ].

	^ self finalizarTurnoTrasJugadaEnTablerito: indiceTablerito estadoAntes: estadoAntes

]

{ #category : 'updating' }
SuperTatetiPartidaSistema >> procesarTickRelojes [
    | quienPerdio |

    quienPerdio := relojSistema tic.

    relojSistema actualizarTextoTiempo.

    quienPerdio ifNotNil: [
        vistaPrincipal ifNotNil: [
            vistaPrincipal finPorTiempoDe: quienPerdio ] ]

]

{ #category : 'game_logic' }
SuperTatetiPartidaSistema >> rechazarSiJuegoTerminado [
    juegoSistema juegoTerminado ifFalse: [ ^ false ].

    vistaPrincipal ifNotNil: [
        vistaPrincipal anunciarGanador ].

    ^ true

]

{ #category : 'game_logic' }
SuperTatetiPartidaSistema >> rechazarSiNoIniciado [
    (botonesSistema juegoIniciado) ifTrue: [ ^ false ].

    vistaPrincipal ifNotNil: [
        vistaPrincipal informarQueDebeIniciar ].

    ^ true

]

{ #category : 'game_logic' }
SuperTatetiPartidaSistema >> rechazarSiRelojPausado [
    (relojSistema corriendo) ifTrue: [ ^ false ].

    vistaPrincipal ifNotNil: [
        vistaPrincipal informarRelojPausado ].

    ^ true

]

{ #category : 'game_logic' }
SuperTatetiPartidaSistema >> rechazarSiTerminoPorTiempo [
    | perdedor |

    (relojSistema relojX termino or: [ relojSistema relojO termino ]) ifFalse: [
        ^ false ].

    perdedor := (relojSistema relojX termino)
        ifTrue: [ #x ]
        ifFalse: [ #o ].

    vistaPrincipal ifNotNil: [
        vistaPrincipal finPorTiempoDe: perdedor ].

    ^ true

]

{ #category : 'accessing' }
SuperTatetiPartidaSistema >> relojCorriendo [
    ^ relojSistema corriendo

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
    self actualizarTextoTiempo.
    vistaPrincipal ifNotNil: [
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
        self actualizarTextoTiempo.
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
