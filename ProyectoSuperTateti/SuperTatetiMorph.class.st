Class {
	#name : 'SuperTatetiMorph',
	#superclass : 'Object',
	#instVars : [
		'juego',
		'botones',
		'window',
		'mainPanel',
		'app',
		'returnHabilitado',
		'ayudaActiva',
		'juegoIniciado',
		'relojTurnos',
		'procesoReloj',
		'panelTiempos',
		'botonStart',
		'cajaTiempoX',
		'cajaTiempoO'
	],
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'instance creation' }
SuperTatetiMorph class >> open [
    ^ self new openInWorld

]

{ #category : 'updating' }
SuperTatetiMorph >> actualizarBotonDeTablerito: indiceTablerito casilla: indiceCasilla [
    | btn valor texto |

    btn := (botones at: indiceTablerito) at: indiceCasilla.

    "Valor que tiene esa casilla en el modelo (#x, #o o nil)"
    valor := juego valorEnTablerito: indiceTablerito casilla: indiceCasilla.

    "Limpio cualquier texto viejo que tenga el botón"
    btn submorphs do: [:m | m delete].

    "Fondo blanco siempre"
    btn color: Color white.

    "Si hay X u O, creo un StringMorph y lo centro dentro del botón"
    valor ifNotNil: [
        texto := StringMorph contents: (valor asString asUppercase).
        texto color: Color black.
        btn addMorph: texto.
        texto center: btn center ].

]

{ #category : 'helpers' }
SuperTatetiMorph >> actualizarTextoTiempo [
    "Actualiza los textos de los relojes de X y O en sus cajas de tiempo."

    | textoX textoO labelX labelO posX posY |

    "Si todavía no hay relojes o cajas, no hacemos nada."
    relojTurnos ifNil: [ ^ self ].
    (cajaTiempoX isNil or: [ cajaTiempoO isNil ]) ifTrue: [ ^ self ].

    "Textos en formato 'MM:SS'."
    textoX := relojTurnos tiempoComoStringPara: #x.
    textoO := relojTurnos tiempoComoStringPara: #o.

    "-------- Caja del jugador X --------"
    cajaTiempoX submorphs do: [:m | m delete].
    labelX := StringMorph contents: textoX.
    labelX color: Color black.
    cajaTiempoX addMorph: labelX.

    "La centramos usando el tamaño de la caja y del texto."
    posX := (cajaTiempoX extent x - labelX extent x) / 2.
    posY := (cajaTiempoX extent y - labelX extent y) / 2.
    labelX position: posX @ posY.

    "-------- Caja del jugador O --------"
    cajaTiempoO submorphs do: [:m | m delete].
    labelO := StringMorph contents: textoO.
    labelO color: Color black.
    cajaTiempoO addMorph: labelO.

    posX := (cajaTiempoO extent x - labelO extent x) / 2.
    posY := (cajaTiempoO extent y - labelO extent y) / 2.
    labelO position: posX @ posY.

]

{ #category : 'updating' }
SuperTatetiMorph >> actualizarVista [
    "Redibuja todo el tablero según el estado actual del modelo y, si corresponde, la ayuda."

    "Actualizamos todos los botones de las 9x9 casillas con X, O o vacío."
    1 to: 9 do: [:t |
        1 to: 9 do: [:c |
            self actualizarBotonDeTablerito: t casilla: c ] ].

    "Si la ayuda está activada, resaltamos las casillas donde se puede jugar."
    (ayudaActiva == true) ifTrue: [
        self resaltarMovimientosValidos ].

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
    | boardPanel |
    boardPanel := Morph new.
    boardPanel layoutPolicy: TableLayout new.
    boardPanel listDirection: #topToBottom.
    boardPanel hResizing: #shrinkWrap;
               vResizing: #shrinkWrap;
               cellInset: 0.
    boardPanel color: Color veryLightGray.

    self inicializarBotones.

    1 to: 9 do: [:row |
        boardPanel addMorph: (self crearFila: row).
        (#(3 6) includes: row) ifTrue: [
            boardPanel addMorph: self crearGapFila ] ].

    ^ boardPanel
]

{ #category : 'building' }
SuperTatetiMorph >> crearBotonConLabel: label action: selector [
    "Crea un botón de la barra superior (Return, Help, Start, Leave) con tamaño fijo."
    ^ SimpleButtonMorph new
        label: label;
        extent: 100@40;          "Tamaño fijo para que no cambie al modificar el texto"
        hResizing: #rigid;
        vResizing: #rigid;
        color: Color lightGray;
        borderWidth: 1;
        borderColor: Color black;
        target: self;
        actionSelector: selector;
        yourself.

]

{ #category : 'building' }
SuperTatetiMorph >> crearBotonEnFila: row columna: col [
 | tIndex cIndex btn |
    tIndex := ((row - 1) // 3) * 3 + ((col - 1) // 3) + 1.
    cIndex := ((row - 1) \\ 3) * 3 + ((col - 1) \\ 3) + 1.

    btn := SimpleButtonMorph new.
    btn extent: 30@30.
    btn hResizing: #rigid; vResizing: #rigid.
    btn color: Color white.
    btn borderWidth: 1; borderColor: Color black.
    btn target: self; actionSelector: #clicEnTablerito:casilla:; arguments: {tIndex. cIndex}.

    (botones at: tIndex) at: cIndex put: btn.
    ^ btn

]

{ #category : 'building' }
SuperTatetiMorph >> crearFila: row [
    | filaMorph |
    filaMorph := Morph new.
    filaMorph layoutPolicy: TableLayout new.
    filaMorph listDirection: #leftToRight.
    filaMorph hResizing: #shrinkWrap;
              vResizing: #shrinkWrap;
              cellInset: 0.

    1 to: 9 do: [:col |
        filaMorph addMorph: (self crearBotonEnFila: row columna: col).
        (#(3 6) includes: col) ifTrue: [
            filaMorph addMorph: self crearGapColumna ] ].

    ^ filaMorph

]

{ #category : 'building' }
SuperTatetiMorph >> crearGapColumna [
    ^ Morph new
        layoutPolicy: nil;
        hResizing: #rigid;
        vResizing: #rigid;
        extent: 6@30;   "dale un poco más de ancho para que se note"
        color: Color gray;   "color más visible"
        borderWidth: 0;
        yourself
]

{ #category : 'building' }
SuperTatetiMorph >> crearGapFila [
    | ancho |
    "Calculamos el ancho total del tablero: 9 celdas de 30 + 2 gaps de columna"
    ancho := (9 * 30) + (2 * 6).

    ^ Morph new
        layoutPolicy: nil;
        hResizing: #rigid;
        vResizing: #rigid;
        extent: ancho @ 6;   "alto del gap horizontal"
        color: Color gray;   "usa gris para confirmar que aparece"
        borderWidth: 0;
        yourself

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
SuperTatetiMorph >> crearPanelTiempoO [
    "Crea el panel de tiempo para el jugador O (caja + etiqueta 'time: O')."
    | panel etiqueta |

    panel := Morph new.
    panel layoutPolicy: TableLayout new.
    panel listDirection: #topToBottom.
    panel hResizing: #shrinkWrap;
           vResizing: #shrinkWrap;
           cellInset: 5.
    panel color: Color veryLightGray.

    "Caja donde se dibuja el tiempo de O (guardamos referencia en una instVar)."
    cajaTiempoO := Morph new.
    cajaTiempoO layoutPolicy: TableLayout new.
    cajaTiempoO hResizing: #shrinkWrap;
                vResizing: #shrinkWrap.
    cajaTiempoO extent: 120@40.
    cajaTiempoO color: Color white.
    cajaTiempoO borderWidth: 2;
               borderColor: Color black.

    "Etiqueta 'time: O' debajo de la caja."
    etiqueta := StringMorph contents: 'time: O'.
    etiqueta color: Color black.

    panel addMorph: cajaTiempoO.
    panel addMorph: etiqueta.

    ^ panel.

]

{ #category : 'building' }
SuperTatetiMorph >> crearPanelTiempoX [
    "Crea el panel de tiempo para el jugador X (caja + etiqueta 'time: X')."
    | panel etiqueta |

    panel := Morph new.
    panel layoutPolicy: TableLayout new.
    panel listDirection: #topToBottom.
    panel hResizing: #shrinkWrap;
           vResizing: #shrinkWrap;
           cellInset: 5.
    panel color: Color veryLightGray.

    "Caja donde se dibuja el tiempo de X (guardamos referencia en una instVar)."
    cajaTiempoX := Morph new.
    cajaTiempoX layoutPolicy: TableLayout new.
    cajaTiempoX hResizing: #shrinkWrap;
                vResizing: #shrinkWrap.
    cajaTiempoX extent: 120@40.
    cajaTiempoX color: Color cyan.
    cajaTiempoX borderWidth: 2;
               borderColor: Color black.

    "Etiqueta 'time: X' debajo de la caja."
    etiqueta := StringMorph contents: 'time: X'.
    etiqueta color: Color black.

    panel addMorph: cajaTiempoX.
    panel addMorph: etiqueta.

    ^ panel.

]

{ #category : 'building' }
SuperTatetiMorph >> crearPanelTiemposJugadores [
    "Crea el panel horizontal que contiene los tiempos de X y O."
    | panel |

    panel := Morph new.
    panel layoutPolicy: TableLayout new.
    panel listDirection: #leftToRight.
    panel hResizing: #shrinkWrap;
           vResizing: #shrinkWrap;
           cellInset: 40.
    panel color: Color veryLightGray.

    panel addMorph: self crearPanelTiempoX.
    panel addMorph: self crearPanelTiempoO.

    "Guardamos el contenedor de los tiempos (una sola instVar para ambos)."
    panelTiempos := panel.

    "Actualizamos los textos iniciales de los relojes."
    self actualizarTextoTiempo.

    ^ panel.

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
    "Crea la barra superior con los botones Leave, Start, Reset y Return."
    | topPanel botonReturn botonReset botonLeave |

    topPanel := Morph new.
    topPanel layoutPolicy: TableLayout new.
    topPanel listDirection: #leftToRight.
    topPanel hResizing: #shrinkWrap;
              vResizing: #shrinkWrap;
              cellInset: 5.
    topPanel color: Color lightGray.

    "Botón Return (puede estar habilitado o no)."
    botonReturn := self crearBotonConLabel: 'Return'
        action: (returnHabilitado
            ifTrue: [ #returnPresionado ]
            ifFalse: [ #returnDeshabilitado ]).

    "Botón Reset (antes era Help)."
    botonReset := self crearBotonConLabel: 'Reset' action: #resetPresionado.

    "Botón Start/Stop: guardamos referencia en la instVar."
    botonStart := self crearBotonConLabel: 'Start' action: #startPresionado.

    "Botón Leave (vuelve al menú)."
    botonLeave := self crearBotonConLabel: 'Leave' action: #volverAlInicio.

    "Orden de los botones en la barra."
    topPanel
        addMorph: botonLeave;
        addMorph: botonStart;
        addMorph: botonReset;
        addMorph: botonReturn.

    ^ topPanel

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

{ #category : 'building' }
SuperTatetiMorph >> inicializarBotones [
    botones := Array new: 9.
    1 to: 9 do: [:t | botones at: t put: (Array new: 9) ].
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

    "Morphs que se asignan cuando se arma el tablero."
    panelTiempos := nil.
    botonStart := nil.
    cajaTiempoX := nil.
    cajaTiempoO := nil.

]

{ #category : 'initialization' }
SuperTatetiMorph >> instalarEnVentana: unaVentana [ 
    juego := SuperTateti new.
    window := unaVentana.
    self crearTablero.
    self actualizarVista

]

{ #category : 'accessing' }
SuperTatetiMorph >> mainPanel [ 
	^ mainPanel 
]

{ #category : 'initialization' }
SuperTatetiMorph >> openInWorld [
    juego := SuperTateti new.
    self crearVentana.
    self crearTablero .
    self actualizarVista.
    window openInWorld.

]

{ #category : 'helpers' }
SuperTatetiMorph >> resaltarMovimientosValidos [
    1 to: 9 do: [:t |
        1 to: 9 do: [:c |
            (juego esMovimientoValidoEnTablerito: t casilla: c) ifTrue: [
                | btn |
                btn := (botones at: t) at: c.
                btn color: Color yellow ] ] ].

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
