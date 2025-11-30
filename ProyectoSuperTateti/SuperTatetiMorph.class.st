Class {
	#name : 'SuperTatetiMorph',
	#superclass : 'Object',
	#instVars : [
		'window',
		'mainPanel',
		'app',
		'juegoSistema',
		'relojSistema',
		'botonesSistema'
	],
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'instance creation' }
SuperTatetiMorph class >> open [
    ^ self new openInWorld

]

{ #category : 'helpers' }
SuperTatetiMorph >> actualizarTextoTiempo [
    relojSistema actualizarTextoTiempo.

]

{ #category : 'updating' }
SuperTatetiMorph >> actualizarVista [
    "Delegamos el redibujado del tablero al panel especializado."
    juegoSistema ifNotNil: [
        juegoSistema actualizarVistaConAyuda: self ayudaActiva ].

]

{ #category : 'helpers' }
SuperTatetiMorph >> anunciarGanador [
    juegoSistema ganador
        ifNil: [
            UIManager default inform:
                'Fin del juego: empate o todos los tableritos cerrados.' ]
        ifNotNil: [
            UIManager default inform:
                'Ganador: ', juegoSistema ganador asString asUppercase ].

]

{ #category : 'accessing' }
SuperTatetiMorph >> app [
    ^ app

]

{ #category : 'accessing' }
SuperTatetiMorph >> app: unaApp [
    app := unaApp

]

{ #category : 'accessing' }
SuperTatetiMorph >> ayudaActiva [
    ^ botonesSistema ayudaActiva

]

{ #category : 'accessing' }
SuperTatetiMorph >> ayudaActiva: unBooleano [
    botonesSistema ayudaActiva: unBooleano

]

{ #category : 'accessing' }
SuperTatetiMorph >> botonStart [
    ^ botonesSistema botonStart

]

{ #category : 'accessing' }
SuperTatetiMorph >> botonStart: unBoton [
    botonesSistema botonStart: unBoton

]

{ #category : 'events' }
SuperTatetiMorph >> clicEnTablerito: indiceTablerito casilla: indiceCasilla [
    | estadoAntes estadoDespues ganadorTablerito oponente perdedor boton |

    "Si ya se acabó el tiempo de X u O, cerramos por tiempo."
    ((relojSistema relojX termino) or: [ relojSistema relojO termino ]) ifTrue: [
        perdedor := (relojSistema relojX termino)
            ifTrue: [ #x ]
            ifFalse: [ #o ].
        ^ self finPorTiempoDe: perdedor
    ].

    "Si el juego ya terminó (por tablero o por tiempo), ignoramos el click."
    juegoSistema juegoTerminado ifTrue: [
        self anunciarGanador.
        ^ self
    ].

    "Si el juego todavía no fue iniciado con Start, no permitimos jugar."
    self juegoIniciado ifFalse: [
        self informarQueDebeIniciar.
        ^ self
    ].

    "Si el reloj está pausado (Stop), no permitimos jugar."
    relojSistema corriendo ifFalse: [
        UIManager default inform: 'El reloj está pausado. Presiona Start para seguir jugando.'.
        ^ self
    ].

    "Recordamos el estado del tablerito antes de la jugada."
    estadoAntes := juegoSistema estadoDeTablerito: indiceTablerito.

    "Intentamos jugar la jugada en el modelo, capturando posibles errores."
    [ juegoSistema jugarEnTablerito: indiceTablerito casilla: indiceCasilla ]
        on: Error
        do: [:ex | ^ UIManager default inform: ex messageText ].

    "Actualizamos la vista del tablero."
    self actualizarVista.

    "Si el juego terminó (por tablero), detenemos relojes y anunciamos ganador."
    juegoSistema juegoTerminado ifTrue: [
        self detenerReloj.
        self juegoIniciado: false.
        boton := self botonStart.
        boton ifNotNil: [
            boton label: 'Start'.
            boton extent: 100@40
        ].
        ^ self anunciarGanador
    ].

    "Revisamos si con esta jugada se capturó el tablerito del tablero grande."
    estadoDespues := juegoSistema estadoDeTablerito: indiceTablerito.
    ((#(#x #o) includes: estadoDespues) and: [ estadoDespues ~= estadoAntes ]) ifTrue: [
        "El ganador del tablerito es estadoDespues; penalizamos al oponente."
        ganadorTablerito := estadoDespues.
        oponente := (ganadorTablerito = #x)
            ifTrue: [ #o ]
            ifFalse: [ #x ].
        relojSistema penalizarA: oponente segundos: 10.
        self actualizarTextoTiempo
    ].

    "Si el juego sigue, alternamos el jugador activo del reloj."
    relojSistema alternarJugador.

]

{ #category : 'initialization' }
SuperTatetiMorph >> configurarConJuegoSistema: unJuegoSistema
        relojSistema: unRelojSistema
        botonesSistema: unBotonesSistema [ 

    juegoSistema := unJuegoSistema.
    relojSistema := unRelojSistema.
    botonesSistema := unBotonesSistema.

    "Conectar relaciones internas."
    juegoSistema configurarController: self.
    botonesSistema controller: self.

]

{ #category : 'building' }
SuperTatetiMorph >> crearBoardPanel [
    ^ juegoSistema crearBoardPanel

]

{ #category : 'building' }
SuperTatetiMorph >> crearMainPanel [
    ^ Morph new
        layoutPolicy: TableLayout new;
        listDirection: #topToBottom;
        hResizing: #spaceFill;
        vResizing: #spaceFill;
        cellInset: 10;
        color: Color veryLightGray;
        "alinear hijos (barra y tablero) a la izquierda"
        listCentering: #left;
        wrapCentering: #left;
        yourself

]

{ #category : 'building' }
SuperTatetiMorph >> crearPanelTiemposJugadores [
    ^ relojSistema crearPanelTiemposJugadores

]

{ #category : 'building' }
SuperTatetiMorph >> crearTablero [
    "Arma el layout principal del juego: barra arriba, tablero al centro y tiempos abajo."
    | topBar boardPanel panelTiemposLocal |

    mainPanel := self crearMainPanel.
    topBar := self crearTopBarPanel.
    boardPanel := self crearBoardPanel.
    panelTiemposLocal := self crearPanelTiemposJugadores.

    mainPanel addMorph: topBar.
    mainPanel addMorph: boardPanel.
    mainPanel addMorph: panelTiemposLocal.

    window addMorph: mainPanel frame: (0@0 corner: 1@1).

]

{ #category : 'building' }
SuperTatetiMorph >> crearTopBarPanel [ 
    ^ botonesSistema crearTopBarPanel
]

{ #category : 'building' }
SuperTatetiMorph >> crearVentana [
    window := SystemWindow labelled: 'Tic Tac Toe'.
    window extent: 425@450.

]

{ #category : 'helpers' }
SuperTatetiMorph >> detenerReloj [
    relojSistema detener.

]

{ #category : 'helpers' }
SuperTatetiMorph >> finPorTiempoDe: unSimbolo [
    | ganadorPorTiempo mensaje boton |

    juegoSistema juegoTerminado ifTrue: [ ^ self ].

    self detenerReloj.
    self juegoIniciado: false.

    ganadorPorTiempo := (unSimbolo = #x)
        ifTrue: [ #o ]
        ifFalse: [ #x ].

    juegoSistema ganador: ganadorPorTiempo.

    boton := self botonStart.
    boton ifNotNil: [
        boton label: 'Start'.
        boton extent: 100@40
    ].

    mensaje := 'Se terminó el tiempo de ', unSimbolo asString asUppercase,
               '. Gana ', ganadorPorTiempo asString asUppercase, ' por tiempo.'.
    UIManager default inform: mensaje.

]

{ #category : 'events' }
SuperTatetiMorph >> helpPresionado [
    juegoSistema juegoTerminado ifTrue: [
        UIManager default inform: 'El juego ya terminó.'.
        ^ self
    ].

    "Toggle de la bandera en BotonesSistema."
    self ayudaActiva: (self ayudaActiva not).

    "Redibujamos todo según el nuevo estado de la ayuda."
    self actualizarVista.

]

{ #category : 'helpers' }
SuperTatetiMorph >> informarQueDebeIniciar [
    "Muestra un mensaje indicando que hay que presionar Start antes de jugar."
    UIManager default inform: 'Debes presionar Start para comenzar el juego.'.

]

{ #category : 'helpers' }
SuperTatetiMorph >> iniciarReloj [
    relojSistema iniciarRelojParaJuego: juegoSistema conCallback: [ self ticRelojes ].

]

{ #category : 'initialization' }
SuperTatetiMorph >> initialize [
    super initialize.

    window := nil.
    mainPanel := nil.
    app := nil.

    "Los sistemas se inyectan desde afuera (App)."
    juegoSistema := nil.
    relojSistema := nil.
    botonesSistema := nil.

]

{ #category : 'initialization' }
SuperTatetiMorph >> instalarEnVentana: unaVentana [
    window := unaVentana.
    self crearTablero.
    self actualizarVista.

]

{ #category : 'accessing' }
SuperTatetiMorph >> juegoIniciado [
    ^ botonesSistema juegoIniciado

]

{ #category : 'accessing' }
SuperTatetiMorph >> juegoIniciado: unBooleano [
    botonesSistema juegoIniciado: unBooleano

]

{ #category : 'accessing' }
SuperTatetiMorph >> mainPanel [ 
	^ mainPanel 
]

{ #category : 'initialization' }
SuperTatetiMorph >> openInWorld [
    self crearVentana.
    self crearTablero.
    self actualizarVista.
    window openInWorld.

]

{ #category : 'events' }
SuperTatetiMorph >> resetPresionado [
    | boton |

    "Detenemos cualquier reloj que esté andando."
    self detenerReloj.

    "Marcamos que el juego ya no está en curso."
    self juegoIniciado: false.

    "Reiniciamos el modelo de juego."
    juegoSistema reiniciar.

    "Reiniciamos ambos relojes y dejamos a X como jugador activo."
    relojSistema resetearAmbos.

    "La ayuda de casillas válidas queda siempre activada."
    self ayudaActiva: true.

    "Volvemos el botón a 'Start' con tamaño fijo."
    boton := self botonStart.
    boton ifNotNil: [
        boton label: 'Start'.
        boton extent: 100@40
    ].

    "Actualizamos tiempos y tablero en pantalla."
    self actualizarTextoTiempo.
    self actualizarVista.

]

{ #category : 'events' }
SuperTatetiMorph >> returnDeshabilitado [
    UIManager default inform: 'La función Return está deshabilitada para esta partida.'

]

{ #category : 'accessing' }
SuperTatetiMorph >> returnHabilitado [
    ^ botonesSistema returnHabilitado

]

{ #category : 'accessing' }
SuperTatetiMorph >> returnHabilitado: unBooleano [
    botonesSistema ifNotNil: [
        botonesSistema returnHabilitado: unBooleano ]

]

{ #category : 'events' }
SuperTatetiMorph >> returnPresionado [ 
    "Deshace la última jugada, solo si el juego sigue en curso."

    juegoSistema juegoTerminado ifTrue: [
        UIManager default inform: 'El juego ya terminó. No puedes deshacer jugadas.'.
        ^ self
    ].

    [ juegoSistema deshacerUltimaJugada ]
        on: Error
        do: [:ex | ^ UIManager default inform: ex messageText ].

    "Sincronizamos el jugador activo del reloj con el del juego."
    relojSistema jugadorActivo: juegoSistema jugadorActual.

    self actualizarVista.
]

{ #category : 'events' }
SuperTatetiMorph >> startPresionado [
    | boton |

    "Si el juego ya terminó, mensaje y salir."
    juegoSistema juegoTerminado ifTrue: [
        UIManager default inform:
            'El juego ya terminó. Debes volver al menú para iniciar una nueva partida.'.
        ^ self
    ].

    boton := self botonStart.

    "Si el reloj ya está corriendo → lo pausamos."
    relojSistema corriendo ifTrue: [
        self detenerReloj.
        boton ifNotNil: [
            boton label: 'Start'.
            boton extent: 100@40
        ].
        ^ self
    ].

    "Si aún no se inició el juego, reseteamos los relojes y marcamos que está iniciado."
    self juegoIniciado ifFalse: [
        self juegoIniciado: true.
        relojSistema resetearAmbos.
        self actualizarTextoTiempo
    ].

    "Aseguramos que el jugador activo del reloj coincida con el jugador del juego."
    relojSistema jugadorActivo: juegoSistema jugadorActual.

    "Arrancamos el proceso de tiempo y ponemos el botón en Stop."
    boton ifNotNil: [
        boton label: 'Stop'.
        boton extent: 100@40
    ].
    self iniciarReloj.

]

{ #category : 'helpers' }
SuperTatetiMorph >> ticRelojes [
    "Pide al RelojTurnos que reste un segundo al jugador activo y
    actualiza la interfaz. Si alguien se queda sin tiempo, termina el juego."

    | quienPerdio |

    quienPerdio := relojSistema tic.
    self actualizarTextoTiempo.

    "Si nadie se quedó sin tiempo, no hacemos nada más."
    quienPerdio ifNil: [ ^ self ].

    "Si alguien quedó sin tiempo, delegamos al helper."
    self finPorTiempoDe: quienPerdio.

]

{ #category : 'events' }
SuperTatetiMorph >> volverAlInicio [
    | boton |

    self detenerReloj.
    self juegoIniciado: false.

    boton := self botonStart.
    boton ifNotNil: [
        boton label: 'Start'.
        boton extent: 100@40
    ].

    app volverAlMenu.

]
