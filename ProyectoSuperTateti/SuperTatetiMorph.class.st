Class {
	#name : 'SuperTatetiMorph',
	#superclass : 'Object',
	#instVars : [
		'mainPanel',
		'app',
		'partidaSistema'
	],
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'instance creation' }
SuperTatetiMorph class >> open [
    ^ self new openInWorld

]

{ #category : 'updating' }
SuperTatetiMorph >> actualizarVista [
    partidaSistema actualizarVista

]

{ #category : 'helpers' }
SuperTatetiMorph >> anunciarGanador [
    | ganadorLocal |

    ganadorLocal := partidaSistema ganadorActual.

    ganadorLocal
        ifNil: [
            UIManager default inform:
                'Fin del juego: empate o todos los tableritos cerrados.' ]
        ifNotNil: [
            UIManager default inform:
                'Ganador: ', ganadorLocal asString asUppercase ]

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
    ^ partidaSistema ayudaActiva

]

{ #category : 'accessing' }
SuperTatetiMorph >> ayudaActiva: unBooleano [
    partidaSistema ayudaActiva: unBooleano

]

{ #category : 'initialization' }
SuperTatetiMorph >> configurarConJuegoSistema: unJuegoSistema
        relojSistema: unRelojSistema
        botonesSistema: unBotonesSistema [

    "Creamos el orquestador de partida y le pasamos todo."
    partidaSistema := SuperTatetiPartidaSistema new.
    partidaSistema
        configurarConJuegoSistema: unJuegoSistema
        relojSistema: unRelojSistema
        botonesSistema: unBotonesSistema
        uiController: self

]

{ #category : 'building' }
SuperTatetiMorph >> crearBoardPanel [
    ^ partidaSistema crearBoardPanel

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
    ^ partidaSistema crearPanelTiemposJugadores

]

{ #category : 'building' }
SuperTatetiMorph >> crearTableroEn: unaVentana [
	| topBar boardPanel panelTiemposLocal |

	mainPanel := self crearMainPanel.
	topBar := self crearTopBarPanel.
	boardPanel := self crearBoardPanel.
	panelTiemposLocal := self crearPanelTiemposJugadores.

	mainPanel addMorph: panelTiemposLocal.
	mainPanel addMorph: boardPanel.
	mainPanel addMorph: topBar.

	unaVentana addMorph: mainPanel frame: (0@0 corner: 1@1)

]

{ #category : 'building' }
SuperTatetiMorph >> crearTopBarPanel [
    ^ partidaSistema crearTopBarPanel

]

{ #category : 'events' }
SuperTatetiMorph >> despuesDeJugadaHumano [
    "Hook para subclases. En el modo 1 vs 1 no hace nada."

]

{ #category : 'helpers' }
SuperTatetiMorph >> detenerReloj [
    partidaSistema detenerReloj

]

{ #category : 'helpers' }
SuperTatetiMorph >> finPorTiempoDe: unSimbolo [
    | ganadorPorTiempo mensaje |

    (partidaSistema juegoTerminado) ifTrue: [ ^ self ].

    self detenerReloj.
    self juegoIniciado: false.

    ganadorPorTiempo := (unSimbolo = #x)
        ifTrue: [ #o ]
        ifFalse: [ #x ].

    partidaSistema fijarGanador: ganadorPorTiempo.
    partidaSistema ponerBotonStartEnModoStart.

    mensaje := 'Se terminó el tiempo de ', unSimbolo asString asUppercase,
               '. Gana ', ganadorPorTiempo asString asUppercase, ' por tiempo.'.
    UIManager default inform: mensaje

]

{ #category : 'helpers' }
SuperTatetiMorph >> informarError: unMensaje [
    UIManager default inform: unMensaje

]

{ #category : 'helpers' }
SuperTatetiMorph >> informarJuegoTerminadoDebeVolverAlMenu [
    UIManager default inform:
        'El juego ya terminó.'

]

{ #category : 'helpers' }
SuperTatetiMorph >> informarJuegoTerminadoEnAyuda [
    UIManager default inform: 'El juego ya terminó.'

]

{ #category : 'helpers' }
SuperTatetiMorph >> informarNoSePuedeDeshacerJuegoTerminado [
    UIManager default inform:
        'El juego ya terminó. No puedes deshacer jugadas.'

]

{ #category : 'helpers' }
SuperTatetiMorph >> informarQueDebeIniciar [
    "Muestra un mensaje indicando que hay que presionar Start antes de jugar."
    UIManager default inform: 'Debes presionar Start para comenzar el juego.'.

]

{ #category : 'helpers' }
SuperTatetiMorph >> informarRelojPausado [
    UIManager default inform:
        'El reloj está pausado. Presiona Start para seguir jugando.'

]

{ #category : 'helpers' }
SuperTatetiMorph >> informarReturnDeshabilitado [
    UIManager default inform:
        'La función Return está deshabilitada para esta partida.'

]

{ #category : 'helpers' }
SuperTatetiMorph >> iniciarReloj [
    partidaSistema iniciarReloj

]

{ #category : 'initialization' }
SuperTatetiMorph >> initialize [
	super initialize.

]

{ #category : 'initialization' }
SuperTatetiMorph >> instalarEnVentana: unaVentana [
	self crearTableroEn: unaVentana.
	self actualizarVista

]

{ #category : 'accessing' }
SuperTatetiMorph >> juegoIniciado [
    ^ partidaSistema juegoIniciado

]

{ #category : 'accessing' }
SuperTatetiMorph >> juegoIniciado: unBooleano [
    partidaSistema juegoIniciado: unBooleano

]

{ #category : 'accessing' }
SuperTatetiMorph >> mainPanel [ 
	^ mainPanel 
]

{ #category : 'initialization' }
SuperTatetiMorph >> prepararPartidaConReturnHabilitado: unBooleano [
	| juegoSistema relojSistema botonesSistema |

	juegoSistema := SuperTatetiJuegoSistema new.
	relojSistema := SuperTatetiRelojSistema new.
	botonesSistema := SuperTatetiBotonesSistema new.

	self
		configurarConJuegoSistema: juegoSistema
		relojSistema: relojSistema
		botonesSistema: botonesSistema.

	self returnHabilitado: unBooleano

]

{ #category : 'accessing' }
SuperTatetiMorph >> returnHabilitado [
    ^ partidaSistema returnHabilitado

]

{ #category : 'accessing' }
SuperTatetiMorph >> returnHabilitado: unBooleano [
    partidaSistema ifNotNil: [
        partidaSistema returnHabilitado: unBooleano ]

]

{ #category : 'helpers' }
SuperTatetiMorph >> ticRelojes [
    partidaSistema procesarTickRelojes

]

{ #category : 'events' }
SuperTatetiMorph >> volverAlInicio [
    self detenerReloj.
    self juegoIniciado: false.

    partidaSistema ponerBotonStartEnModoStart.

    app volverAlMenu

]
