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
SuperTatetiApp >> iniciarJuego1vs1 [
    "Sacar el contenido actual (pantalla de configuración) de la ventana"
    contenidoActual ifNotNil: [
        window removeMorph: contenidoActual.
        contenidoActual := nil
    ].

    "Crear el juego 1 vs 1 y conectarlo con la App"
    juegoMorph := SuperTatetiMorph new.
    juegoMorph app: self.
    juegoMorph instalarEnVentana: window.

    "Recordar el panel principal del juego como contenido actual"
    contenidoActual := juegoMorph mainPanel

]

{ #category : 'events' }
SuperTatetiApp >> iniciarJuego1vs1ConReturn: habilitarReturn [
    "Sacar el contenido actual (pantalla de configuración) de la ventana"
    contenidoActual ifNotNil: [
        window removeMorph: contenidoActual.
        contenidoActual := nil
    ].

    "Crear el juego 1 vs 1 y conectarlo con la App"
    juegoMorph := SuperTatetiMorph new.
    juegoMorph app: self.
    juegoMorph returnHabilitado: habilitarReturn.
    juegoMorph instalarEnVentana: window.

    "Recordar el panel principal del juego como contenido actual"
    contenidoActual := juegoMorph mainPanel

]

{ #category : 'events' }
SuperTatetiApp >> jugar1vs1 [
    "Sacar el contenido actual (el menú) de la ventana"
    contenidoActual ifNotNil: [
        window removeMorph: contenidoActual.
        contenidoActual := nil
    ].

    "Crear la pantalla de configuración (SuperTatetiVsPcMorph) y conectarla con la App"
    juegoMorph := SuperTatetiVsPcMorph new.
    juegoMorph app: self.
    juegoMorph instalarEnVentana: window.

    "Recordar el panel principal de esta pantalla como contenido actual"
    contenidoActual := juegoMorph mainPanel

]

{ #category : 'events' }
SuperTatetiApp >> jugar1vsPC [
    "Sacar el contenido actual (el menú) de la ventana"
    contenidoActual ifNotNil: [
        window removeMorph: contenidoActual.
        contenidoActual := nil
    ].

    "Crear la pantalla de configuración 1 vs PC y conectarla con la App"
    juegoMorph := SuperTatetiVsPcMorph new.
    juegoMorph app: self.
    juegoMorph instalarEnVentana: window.

    "Recordar el panel principal de esta pantalla como contenido actual"
    contenidoActual := juegoMorph mainPanel

]

{ #category : 'building' }
SuperTatetiApp >> mostrarMenu [
    | mainPanel menuPanel boton1vs1 boton1vsPC botonExit |

    "Panel principal, ocupa toda la ventana"
    mainPanel := Morph new.
    mainPanel layoutPolicy: TableLayout new.
    mainPanel listDirection: #topToBottom.
    mainPanel listCentering: #center.
    mainPanel wrapCentering: #center.
    mainPanel hResizing: #spaceFill;
              vResizing: #spaceFill;
              cellInset: 20.
    mainPanel color: Color veryLightGray.

    "Panel del menú (caja con los tres botones)"
    menuPanel := Morph new.
    menuPanel layoutPolicy: TableLayout new.
    menuPanel listDirection: #topToBottom.
    menuPanel hResizing: #shrinkWrap;
              vResizing: #shrinkWrap;
              cellInset: 10.
    menuPanel color: Color veryLightGray.
    menuPanel borderWidth: 1.
    menuPanel borderColor: Color veryLightGray.

    "Botones del menú, en este orden"
	 boton1vs1 := self crearBotonConLabel: '1 vs 1' action: #jugar1vs1.
	 boton1vsPC := self crearBotonConLabel: '1 vs PC' action: #jugar1vsPC.
	 botonExit := self crearBotonConLabel: 'Exit' action: #salir.

	 "Orden visual: 1 vs 1 (arriba), 1 vs PC (medio), Exit (abajo)"
	 menuPanel addMorph: botonExit.
	 menuPanel addMorph: boton1vsPC.
	 menuPanel addMorph: boton1vs1.


    mainPanel addMorph: menuPanel.

    "IMPORTANTE: solo agregamos al window, NO hacemos openInWorld aquí"
    window addMorph: mainPanel frame: (0@0 corner: 1@1).
	 contenidoActual := mainPanel.

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
