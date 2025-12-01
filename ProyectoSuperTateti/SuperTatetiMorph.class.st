Class {
	#name : 'SuperTatetiMorph',
	#superclass : 'Object',
	#instVars : [
		'window',
		'mainPanel',
		'app',
		'juegoSistema',
		'relojSistema',
		'botonesSistema',
		'partidaSistema'
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

{ #category : 'initialization' }
SuperTatetiMorph >> configurarConJuegoSistema: unJuegoSistema
        relojSistema: unRelojSistema
        botonesSistema: unBotonesSistema [

    "Guardamos referencias (por ahora el Morph las sigue usando)."
    juegoSistema := unJuegoSistema.
    relojSistema := unRelojSistema.
    botonesSistema := unBotonesSistema.

    "Creamos el orquestador de partida y le pasamos todo."
    partidaSistema := SuperTatetiPartidaSistema new.
    partidaSistema
        configurarConJuegoSistema: juegoSistema
        relojSistema: relojSistema
        botonesSistema: botonesSistema
        uiController: self.

    "Conectamos los sistemas para que hablen con PartidaSistema (ya no directo al Morph)."
    juegoSistema configurarController: partidaSistema.
    botonesSistema controller: partidaSistema

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

{ #category : 'events' }
SuperTatetiMorph >> despuesDeJugadaHumano [
    "Hook para subclases. En el modo 1 vs 1 no hace nada."

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

    "Orquestador de la partida."
    partidaSistema := nil

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

{ #category : 'accessing' }
SuperTatetiMorph >> returnHabilitado [
    ^ botonesSistema returnHabilitado

]

{ #category : 'accessing' }
SuperTatetiMorph >> returnHabilitado: unBooleano [
    botonesSistema ifNotNil: [
        botonesSistema returnHabilitado: unBooleano ]

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

    app volverAlMenu

]
