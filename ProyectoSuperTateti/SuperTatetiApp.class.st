Class {
	#name : 'SuperTatetiApp',
	#superclass : 'Object',
	#instVars : [
		'window',
		'juegoMorph',
		'contenidoActual'
	],
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'instance creation' }
SuperTatetiApp class >> open [
	^self new openInWorld
]

{ #category : 'building' }
SuperTatetiApp >> crearBotonConLabel: label action: selector [
    ^ SimpleButtonMorph new
        label: label;
        extent: 200@50;
        color: Color lightGray;
        borderWidth: 1;
        borderColor: Color black;
        target: self;
        actionSelector: selector;
        yourself


]

{ #category : 'building' }
SuperTatetiApp >> crearVentana [
    window := SystemWindow labelled: 'Tic Tac Toe'.
    window extent: 425@450

]

{ #category : 'events' }
SuperTatetiApp >> jugar1vs1 [
    | juegoSistema relojSistema botonesSistema |

    contenidoActual ifNotNil: [
        window removeMorph: contenidoActual.
        contenidoActual := nil
    ].

    juegoMorph := SuperTatetiMorph new.
    juegoMorph app: self.

    juegoSistema := SuperTatetiJuegoSistema new.
    relojSistema := SuperTatetiRelojSistema new.
    botonesSistema := SuperTatetiBotonesSistema new.

    juegoMorph
        configurarConJuegoSistema: juegoSistema
        relojSistema: relojSistema
        botonesSistema: botonesSistema.

    "Ahora que partidaSistema ya existe, configuramos Return."
    juegoMorph returnHabilitado: true.

    juegoMorph instalarEnVentana: window.
    contenidoActual := juegoMorph mainPanel

]

{ #category : 'events' }
SuperTatetiApp >> jugar1vsPC [
    | juegoSistema relojSistema botonesSistema |

    contenidoActual ifNotNil: [
        window removeMorph: contenidoActual.
        contenidoActual := nil
    ].

    juegoMorph := SuperTatetiVsPcMorph new.
    juegoMorph app: self.

    juegoSistema := SuperTatetiJuegoSistema new.
    relojSistema := SuperTatetiRelojSistema new.
    botonesSistema := SuperTatetiBotonesSistema new.

    juegoMorph
        configurarConJuegoSistema: juegoSistema
        relojSistema: relojSistema
        botonesSistema: botonesSistema.

    "En 1 vs PC el Return va deshabilitado."
    juegoMorph returnHabilitado: false.

    juegoMorph instalarEnVentana: window.
    contenidoActual := juegoMorph mainPanel

]

{ #category : 'building' }
SuperTatetiApp >> mostrarMenu [
    | mainPanel menuPanel boton1vs1 boton1vsPC botonExit |

    mainPanel := Morph new.
    mainPanel layoutPolicy: TableLayout new.
    mainPanel listDirection: #topToBottom.
    mainPanel listCentering: #center.
    mainPanel wrapCentering: #center.
    mainPanel hResizing: #spaceFill;
              vResizing: #spaceFill;
              cellInset: 20.
    mainPanel color: Color veryLightGray.

    menuPanel := Morph new.
    menuPanel layoutPolicy: TableLayout new.
    menuPanel listDirection: #topToBottom.
    menuPanel hResizing: #shrinkWrap;
              vResizing: #shrinkWrap;
              cellInset: 10.
    menuPanel color: Color veryLightGray.
    menuPanel borderWidth: 1.
    menuPanel borderColor: Color veryLightGray.

    boton1vs1 := self crearBotonConLabel: '1 vs 1' action: #jugar1vs1.
    boton1vsPC := self crearBotonConLabel: '1 vs PC' action: #jugar1vsPC.
    botonExit := self crearBotonConLabel: 'Exit' action: #salir.

    menuPanel addMorph: botonExit.
    menuPanel addMorph: boton1vsPC.
    menuPanel addMorph: boton1vs1.

    mainPanel addMorph: menuPanel.

    window addMorph: mainPanel frame: (0@0 corner: 1@1).
    contenidoActual := mainPanel

]

{ #category : 'initialization' }
SuperTatetiApp >> openInWorld [
    self crearVentana.
    self mostrarMenu.
    window openInWorld

]

{ #category : 'events' }
SuperTatetiApp >> salir [
    window delete

]

{ #category : 'events' }
SuperTatetiApp >> volverAlMenu [
    "Sacar el contenido actual (el tablero) si lo hay"
    contenidoActual ifNotNil: [
        window removeMorph: contenidoActual.
        contenidoActual := nil
    ].

    "Olvidar el juego actual"
    juegoMorph := nil.

    "Volver a mostrar el menú en la misma ventana"
    self mostrarMenu

]
