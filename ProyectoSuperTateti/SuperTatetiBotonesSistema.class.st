Class {
	#name : 'SuperTatetiBotonesSistema',
	#superclass : 'Object',
	#instVars : [
		'controller',
		'topBarPanel',
		'returnHabilitado',
		'ayudaActiva',
		'juegoIniciado',
		'botonStart'
	],
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'accessing' }
SuperTatetiBotonesSistema >> ayudaActiva [
    ^ ayudaActiva

]

{ #category : 'accessing' }
SuperTatetiBotonesSistema >> ayudaActiva: unBooleano [
    ayudaActiva := unBooleano

]

{ #category : 'accessing' }
SuperTatetiBotonesSistema >> botonStart [
    ^ botonStart

]

{ #category : 'accessing' }
SuperTatetiBotonesSistema >> botonStart: unBoton [
    botonStart := unBoton

]

{ #category : 'accessing' }
SuperTatetiBotonesSistema >> controller [
    ^ controller

]

{ #category : 'accessing' }
SuperTatetiBotonesSistema >> controller: unController [
	controller := unController.
	topBarPanel ifNotNil: [
		topBarPanel controller: self ]

]

{ #category : 'building' }
SuperTatetiBotonesSistema >> crearTopBarPanel [ 
    "Devuelve el morph de la barra superior."
    ^ topBarPanel crearTopBarPanel
]

{ #category : 'initialization' }
SuperTatetiBotonesSistema >> initialize [
    super initialize.
    topBarPanel := SuperTatetiTopBarPanel new.

    returnHabilitado := true.
    ayudaActiva := true.
    juegoIniciado := false.

]

{ #category : 'accessing' }
SuperTatetiBotonesSistema >> juegoIniciado [
    ^ juegoIniciado

]

{ #category : 'accessing' }
SuperTatetiBotonesSistema >> juegoIniciado: unBooleano [
    juegoIniciado := unBooleano

]

{ #category : 'accessing' }
SuperTatetiBotonesSistema >> orquestador [
	^ controller

]

{ #category : 'events' }
SuperTatetiBotonesSistema >> ponerBotonStartEnModoStart [
    botonStart ifNotNil: [
        botonStart label: 'Start'.
        botonStart extent: 100@40 ]

]

{ #category : 'events' }
SuperTatetiBotonesSistema >> ponerBotonStartEnModoStop [
    botonStart ifNotNil: [
        botonStart label: 'Stop'.
        botonStart extent: 100@40 ]

]

{ #category : 'events' }
SuperTatetiBotonesSistema >> resetPresionado [
	controller ifNotNil: [ controller resetPresionado ]

]

{ #category : 'events' }
SuperTatetiBotonesSistema >> returnDeshabilitado [
	controller ifNotNil: [ controller returnDeshabilitado ]

]

{ #category : 'accessing' }
SuperTatetiBotonesSistema >> returnHabilitado [
    ^ returnHabilitado

]

{ #category : 'accessing' }
SuperTatetiBotonesSistema >> returnHabilitado: unBooleano [
    returnHabilitado := unBooleano

]

{ #category : 'events' }
SuperTatetiBotonesSistema >> returnPresionado [
"Si está deshabilitado, no delega a PartidaSistema: muestra el aviso."
	returnHabilitado
		ifTrue: [ controller ifNotNil: [ controller returnPresionado ] ]
		ifFalse: [ self returnDeshabilitado ]

]

{ #category : 'events' }
SuperTatetiBotonesSistema >> startPresionado [
	controller ifNotNil: [ controller startPresionado ]

]

{ #category : 'accessing' }
SuperTatetiBotonesSistema >> topBarPanel [
    ^ topBarPanel

]

{ #category : 'events' }
SuperTatetiBotonesSistema >> volverAlInicio [
	controller ifNotNil: [ controller volverAlInicio ]

]
