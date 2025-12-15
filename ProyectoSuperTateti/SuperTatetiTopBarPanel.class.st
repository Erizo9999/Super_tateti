Class {
	#name : 'SuperTatetiTopBarPanel',
	#superclass : 'Object',
	#instVars : [
		'controller',
		'panel'
	],
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'accessing' }
SuperTatetiTopBarPanel >> controller [
    ^ controller

]

{ #category : 'accessing' }
SuperTatetiTopBarPanel >> controller: unController [
    controller := unController

]

{ #category : 'building' }
SuperTatetiTopBarPanel >> crearBotonConLabel: label action: selector [
	"Crea un botón de la barra superior con tamaño fijo.
	Los clics van al controller (BotonesSistema)."
	^ SimpleButtonMorph new
		label: label;
		extent: 100@40;
		hResizing: #rigid;
		vResizing: #rigid;
		color: Color lightGray;
		borderWidth: 1;
		borderColor: Color black;
		target: controller;
		actionSelector: selector;
		yourself

]

{ #category : 'building' }
SuperTatetiTopBarPanel >> crearTopBarPanel [
	"Crea la barra superior con los botones Leave, Start, Reset y Return."
	| topPanel botonReturn botonReset botonLeave botonStartLocal |

	topPanel := Morph new.
	topPanel layoutPolicy: TableLayout new.
	topPanel listDirection: #leftToRight.
	topPanel hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		cellInset: 5.
	topPanel color: Color lightGray.

	"Return siempre llama al mismo selector; la decisión se hace en BotonesSistema."
	botonReturn := self crearBotonConLabel: 'Return' action: #returnPresionado.

	botonReset := self crearBotonConLabel: 'Reset' action: #resetPresionado.

	botonStartLocal := self crearBotonConLabel: 'Start' action: #startPresionado.
	controller botonStart: botonStartLocal.

	botonLeave := self crearBotonConLabel: 'Leave' action: #volverAlInicio.

	topPanel
		addMorph: botonLeave;
		addMorph: botonStartLocal;
		addMorph: botonReset;
		addMorph: botonReturn.

	panel := topPanel.
	^ topPanel

]

{ #category : 'initialization' }
SuperTatetiTopBarPanel >> initialize [
    super initialize.
]

{ #category : 'accessing' }
SuperTatetiTopBarPanel >> panel [
    ^ panel

]
