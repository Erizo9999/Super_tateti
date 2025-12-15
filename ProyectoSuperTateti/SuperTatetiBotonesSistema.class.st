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
        topBarPanel controller: unController ]

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

{ #category : 'accessing' }
SuperTatetiBotonesSistema >> returnHabilitado [
    ^ returnHabilitado

]

{ #category : 'accessing' }
SuperTatetiBotonesSistema >> returnHabilitado: unBooleano [
    returnHabilitado := unBooleano

]

{ #category : 'accessing' }
SuperTatetiBotonesSistema >> topBarPanel [
    ^ topBarPanel

]
