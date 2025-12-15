Class {
	#name : 'SuperTatetiApp',
	#superclass : 'Object',
	#instVars : [
		'window',
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
SuperTatetiApp >> agregarBotonesAlMenuPanel: menuPanel [
	| boton1vs1 boton1vsPC botonExit |
	boton1vs1 := self crearBotonConLabel: '1 vs 1' action: #jugar1vs1.
	boton1vsPC := self crearBotonConLabel: '1 vs PC' action: #jugar1vsPC.
	botonExit := self crearBotonConLabel: 'Exit' action: #salir.

	menuPanel addMorph: botonExit.
	menuPanel addMorph: boton1vsPC.
	menuPanel addMorph: boton1vs1

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
SuperTatetiApp >> crearMainPanelMenu [
	| mainPanel |
	mainPanel := Morph new.
	mainPanel layoutPolicy: TableLayout new.
	mainPanel listDirection: #topToBottom.
	mainPanel listCentering: #center.
	mainPanel wrapCentering: #center.
	mainPanel hResizing: #spaceFill.
	mainPanel vResizing: #spaceFill.
	mainPanel cellInset: 20.
	mainPanel color: Color veryLightGray.
	^ mainPanel

]

{ #category : 'building' }
SuperTatetiApp >> crearMenuPanel [
	| menuPanel |
	menuPanel := Morph new.
	menuPanel layoutPolicy: TableLayout new.
	menuPanel listDirection: #topToBottom.
	menuPanel hResizing: #shrinkWrap.
	menuPanel vResizing: #shrinkWrap.
	menuPanel cellInset: 10.
	menuPanel color: Color veryLightGray.
	menuPanel borderWidth: 1.
	menuPanel borderColor: Color veryLightGray.
	^ menuPanel

]

{ #category : 'building' }
SuperTatetiApp >> crearVentana [
	window := SystemWindow labelled: '    SuperTateti'.
	window extent: 425@450

]

{ #category : 'events' }
SuperTatetiApp >> iniciarPartidaConMorph: unaClaseMorph returnHabilitado: unBooleano [
	| morph |

	self limpiarContenidoActual.

	morph := unaClaseMorph new.
	morph app: self.

	morph prepararPartidaConReturnHabilitado: unBooleano.
	morph instalarEnVentana: window.

	contenidoActual := morph mainPanel

]

{ #category : 'events' }
SuperTatetiApp >> jugar1vs1 [
	self iniciarPartidaConMorph: SuperTatetiMorph returnHabilitado: true

]

{ #category : 'events' }
SuperTatetiApp >> jugar1vsPC [
	self iniciarPartidaConMorph: SuperTatetiVsPcMorph returnHabilitado: false

]

{ #category : 'helpers' }
SuperTatetiApp >> limpiarContenidoActual [
	contenidoActual ifNotNil: [
		window removeMorph: contenidoActual.
		contenidoActual := nil ]

]

{ #category : 'building' }
SuperTatetiApp >> mostrarMenu [
	| mainPanel menuPanel |

	self limpiarContenidoActual.

	mainPanel := self crearMainPanelMenu.
	menuPanel := self crearMenuPanel.

	self agregarBotonesAlMenuPanel: menuPanel.

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
	self limpiarContenidoActual.
	self mostrarMenu

]
