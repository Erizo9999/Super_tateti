Class {
	#name : 'SuperTatetiMorph',
	#superclass : 'Object',
	#instVars : [
		'juego',
		'window',
		'mainPanel',
		'app',
		'returnHabilitado',
		'ayudaActiva',
		'juegoIniciado',
		'relojTurnos',
		'procesoReloj',
		'botonStart',
		'relojPanel',
		'tableroPanel',
		'topBarPanel'
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
    "Delegamos la actualización de los textos del tiempo al panel de relojes."
    relojPanel ifNotNil: [ relojPanel actualizarTextoTiempo ].

]

{ #category : 'updating' }
SuperTatetiMorph >> actualizarVista [
    "Delegamos el redibujado del tablero al panel especializado."
    tableroPanel ifNotNil: [
        tableroPanel actualizarVistaConAyuda: ayudaActiva ].

]

{ #category : 'helpers' }
SuperTatetiMorph >> anunciarGanador [
    juego ganador
        ifNil: [
            UIManager default inform:
                'Fin del juego: empate o todos los tableritos cerrados.' ]
        ifNotNil: [
            UIManager default inform:
                'Ganador: ', juego ganador asString asUppercase ].

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
SuperTatetiMorph >> botonStart [
    ^ botonStart

]

{ #category : 'accessing' }
SuperTatetiMorph >> botonStart: unBoton [
    botonStart := unBoton

]

{ #category : 'events' }
SuperTatetiMorph >> clicEnTablerito: indiceTablerito casilla: indiceCasilla [
    "Maneja el clic en una casilla del tablero y alterna los relojes de turno.
    Además, si se captura un tablerito (casilla del tablero grande), se
    penaliza con 10 segundos menos al reloj del oponente."

    | estadoAntes estadoDespues ganadorTablerito oponente perdedor |

    "Si ya se acabó el tiempo de X u O, cerramos por tiempo."
    ((relojTurnos relojX termino) or: [ relojTurnos relojO termino ]) ifTrue: [
        perdedor := (relojTurnos relojX termino)
            ifTrue: [ #x ]
            ifFalse: [ #o ].
        ^ self finPorTiempoDe: perdedor
    ].

    "Si el juego ya terminó (por tablero o por tiempo), ignoramos el click."
    juego juegoTerminado ifTrue: [
        self anunciarGanador.
        ^ self
    ].

    "Si el juego todavía no fue iniciado con Start, no permitimos jugar."
    juegoIniciado ifFalse: [
        self informarQueDebeIniciar.
        ^ self
    ].

    "Si el reloj está pausado (Stop), no permitimos jugar."
    relojTurnos corriendo ifFalse: [
        UIManager default inform: 'El reloj está pausado. Presiona Start para seguir jugando.'.
        ^ self
    ].

    "Recordamos el estado del tablerito antes de la jugada."
    estadoAntes := juego estadoDeTablerito: indiceTablerito.

    "Intentamos jugar la jugada en el modelo, capturando posibles errores."
    [ juego jugarEnTablerito: indiceTablerito casilla: indiceCasilla ]
        on: Error
        do: [:ex | ^ UIManager default inform: ex messageText ].

    "Actualizamos la vista del tablero."
    self actualizarVista.

    "Si el juego terminó (por tablero), detenemos relojes y anunciamos ganador."
    juego juegoTerminado ifTrue: [
        self detenerReloj.
        juegoIniciado := false.
        botonStart ifNotNil: [
            botonStart label: 'Start'.
            botonStart extent: 100@40
        ].
        ^ self anunciarGanador
    ].

    "Revisamos si con esta jugada se capturó el tablerito del tablero grande."
    estadoDespues := juego estadoDeTablerito: indiceTablerito.
    ((#(#x #o) includes: estadoDespues) and: [ estadoDespues ~= estadoAntes ]) ifTrue: [
        "El ganador del tablerito es estadoDespues; penalizamos al oponente."
        ganadorTablerito := estadoDespues.
        oponente := (ganadorTablerito = #x)
            ifTrue: [ #o ]
            ifFalse: [ #x ].
        relojTurnos penalizarA: oponente segundos: 10.
        self actualizarTextoTiempo
    ].

    "Si el juego sigue, alternamos el jugador activo del reloj."
    relojTurnos alternarJugador.

]

{ #category : 'building' }
SuperTatetiMorph >> crearBoardPanel [
    ^ tableroPanel crearBoardPanel

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
    "Pide al panel de relojes que cree el panel de tiempos y lo devuelve."
    ^ relojPanel crearPanelTiemposJugadores

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
    ^ topBarPanel crearTopBarPanel

]

{ #category : 'building' }
SuperTatetiMorph >> crearVentana [
    window := SystemWindow labelled: 'Tic Tac Toe'.
    window extent: 425@450.

]

{ #category : 'helpers' }
SuperTatetiMorph >> detenerReloj [
    "Detiene el proceso del reloj (si existe) y pausa los relojes de turno."
    procesoReloj ifNotNil: [
        procesoReloj terminate.
        procesoReloj := nil ].
    relojTurnos detener.

]

{ #category : 'helpers' }
SuperTatetiMorph >> finPorTiempoDe: unSimbolo [
    "Marca el fin del juego porque se quedó sin tiempo el jugador indicado
    (#x o #o). Si el juego ya estaba terminado, no hace nada."

    | ganadorPorTiempo mensaje |

    juego juegoTerminado ifTrue: [ ^ self ].

    "Detenemos reloj y marcamos que ya no se puede seguir jugando."
    self detenerReloj.
    juegoIniciado := false.

    "El ganador es el oponente del que se quedó sin tiempo."
    ganadorPorTiempo := (unSimbolo = #x)
        ifTrue: [ #o ]
        ifFalse: [ #x ].

    "Marcamos el ganador en el modelo."
    juego ganador: ganadorPorTiempo.

    "Volvemos el botón a 'Start' con tamaño fijo."
    botonStart ifNotNil: [
        botonStart label: 'Start'.
        botonStart extent: 100@40
    ].

    "Mostramos el mensaje solo una vez."
    mensaje := 'Se terminó el tiempo de ', unSimbolo asString asUppercase,
               '. Gana ', ganadorPorTiempo asString asUppercase, ' por tiempo.'.
    UIManager default inform: mensaje.

]

{ #category : 'events' }
SuperTatetiMorph >> helpPresionado [
    (juego juegoTerminado) ifTrue: [
        UIManager default inform: 'El juego ya terminó.'.
        ^ self
    ].

    "Toggle de la bandera"
    ayudaActiva := ayudaActiva not.

    "Redibujamos todo según el nuevo estado de la ayuda"
    self actualizarVista.

]

{ #category : 'helpers' }
SuperTatetiMorph >> informarQueDebeIniciar [
    "Muestra un mensaje indicando que hay que presionar Start antes de jugar."
    UIManager default inform: 'Debes presionar Start para comenzar el juego.'.

]

{ #category : 'helpers' }
SuperTatetiMorph >> iniciarReloj [
    "Crea el proceso que descuenta tiempo cada segundo mientras el reloj esté corriendo."
    self detenerReloj.

    relojTurnos iniciar.

    procesoReloj := [
        [ relojTurnos corriendo and: [ juego juegoTerminado not ] ] whileTrue: [
            (Delay forSeconds: 1) wait.
            self ticRelojes.
        ].
    ] fork.

]

{ #category : 'initialization' }
SuperTatetiMorph >> initialize [
    "Inicializa el morph del juego y el sistema de relojes de turnos."
    super initialize.

    "Configuración general de la interfaz."
    returnHabilitado := true.
    ayudaActiva := true.
    juegoIniciado := false.

    "Un solo objeto que maneja los dos relojes (X y O)."
    relojTurnos := RelojTurnos new.

    "Todavía no hay proceso de reloj corriendo."
    procesoReloj := nil.

    "Referencia al botón Start (se asigna desde la top bar)."
    botonStart := nil.

    "Panel especializado para mostrar los tiempos."
    relojPanel := SuperTatetiRelojPanel new.
    relojPanel relojTurnos: relojTurnos.

    "Panel especializado para el tablero."
    tableroPanel := SuperTatetiBoardPanel new.
    tableroPanel controller: self.

    "Panel especializado para la barra superior."
    topBarPanel := SuperTatetiTopBarPanel new.
    topBarPanel controller: self.

]

{ #category : 'initialization' }
SuperTatetiMorph >> instalarEnVentana: unaVentana [
    juego := SuperTateti new.
    window := unaVentana.

    "Conectamos el tablero con el modelo."
    tableroPanel juego: juego.

    self crearTablero.
    self actualizarVista.

]

{ #category : 'accessing' }
SuperTatetiMorph >> mainPanel [ 
	^ mainPanel 
]

{ #category : 'initialization' }
SuperTatetiMorph >> openInWorld [
    juego := SuperTateti new.
    self crearVentana.

    "Conectamos el tablero con el modelo."
    tableroPanel juego: juego.

    self crearTablero.
    self actualizarVista.
    window openInWorld.

]

{ #category : 'events' }
SuperTatetiMorph >> resetPresionado [
    "Reinicia la partida actual sin volver al menú."

    "Detenemos cualquier reloj que esté andando."
    self detenerReloj.

    "Marcamos que el juego ya no está en curso."
    juegoIniciado := false.

    "Reiniciamos el modelo de juego (tableros vacíos, X comienza, etc.)."
    juego reiniciar.

    "Reiniciamos ambos relojes y dejamos a X como jugador activo."
    relojTurnos resetearAmbos.

    "La ayuda de casillas válidas queda siempre activada."
    ayudaActiva := true.

    "Volvemos el botón a 'Start' con tamaño fijo."
    botonStart ifNotNil: [
        botonStart label: 'Start'.
        botonStart extent: 100@40
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
    ^ returnHabilitado
]

{ #category : 'accessing' }
SuperTatetiMorph >> returnHabilitado: unBooleano [
    returnHabilitado := unBooleano
]

{ #category : 'events' }
SuperTatetiMorph >> returnPresionado [
    "Deshace la última jugada, solo si el juego sigue en curso."

    "Si el juego ya terminó, no permitimos deshacer."
    (juego juegoTerminado) ifTrue: [
        UIManager default inform: 'El juego ya terminó. No puedes deshacer jugadas.'.
        ^ self
    ].

    [ juego deshacerUltimaJugada ]
        on: Error
        do: [:ex | UIManager default inform: ex messageText ].

    self actualizarVista.

]

{ #category : 'events' }
SuperTatetiMorph >> startPresionado [
    "Maneja el botón Start/Stop para el sistema de relojes de turnos."

    "Si el juego ya terminó (por tablero o por tiempo), solo mostramos un mensaje."
    (juego juegoTerminado) ifTrue: [
        UIManager default inform: 'El juego ya terminó. Debes volver al menú para iniciar una nueva partida.'.
        ^ self
    ].

    "Si el reloj ya está corriendo → lo pausamos (Stop → Start)."
    relojTurnos corriendo ifTrue: [
        self detenerReloj.
        botonStart ifNotNil: [
            botonStart label: 'Start'.   "texto"
            botonStart extent: 100@40    "forzamos tamaño fijo otra vez"
        ].
        ^ self
    ].

    "Si aún no se inició el juego, reseteamos los relojes y marcamos que está iniciado."
    juegoIniciado ifFalse: [
        juegoIniciado := true.
        relojTurnos resetearAmbos.
        self actualizarTextoTiempo
    ].

    "Aseguramos que el jugador activo del reloj coincida con el jugador del juego."
    relojTurnos jugadorActivo: juego jugadorActual.

    "Arrancamos el proceso de tiempo y ponemos el botón en Stop, SIN que cambie de tamaño."
    botonStart ifNotNil: [
        botonStart label: 'Stop'.
        botonStart extent: 100@40    "mismo tamaño que cuando dice Start"
    ].
    self iniciarReloj.

]

{ #category : 'helpers' }
SuperTatetiMorph >> ticRelojes [
    "Pide al RelojTurnos que reste un segundo al jugador activo y
    actualiza la interfaz. Si alguien se queda sin tiempo, termina el juego."

    | quienPerdio |

    quienPerdio := relojTurnos tic.
    self actualizarTextoTiempo.

    "Si nadie se quedó sin tiempo, no hacemos nada más."
    quienPerdio ifNil: [ ^ self ].

    "Si alguien quedó sin tiempo, delegamos al helper."
    self finPorTiempoDe: quienPerdio.

]

{ #category : 'events' }
SuperTatetiMorph >> volverAlInicio [
    "Vuelve al menú principal deteniendo relojes y reseteando flags."
    self detenerReloj.
    juegoIniciado := false.
    botonStart ifNotNil: [
        botonStart label: 'Start'.
        botonStart extent: 100@40
    ].
    app volverAlMenu.

]
