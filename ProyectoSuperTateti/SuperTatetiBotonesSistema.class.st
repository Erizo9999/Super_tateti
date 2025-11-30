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
    controller := unController
]

{ #category : 'building' }
SuperTatetiBotonesSistema >> crearTopBarPanel [ 
    "Devuelve el morph de la barra superior."
    ^ topBarPanel crearTopBarPanel
]

{ #category : 'initialization' }
SuperTatetiBotonesSistema >> initialize [
    super initialize.
    controller := nil.
    topBarPanel := SuperTatetiTopBarPanel new.
    topBarPanel controller: self.

    "Estado inicial de los botones / flags."
    returnHabilitado := true.
    ayudaActiva := true.
    juegoIniciado := false.
    botonStart := nil.

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
SuperTatetiBotonesSistema >> resetPresionado [ 
    controller resetPresionado
]

{ #category : 'events' }
SuperTatetiBotonesSistema >> returnDeshabilitado [ 
    controller returnDeshabilitado

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
    controller returnPresionado
]

{ #category : 'events' }
SuperTatetiBotonesSistema >> startPresionado [ 
    controller startPresionado

]

{ #category : 'accessing' }
SuperTatetiBotonesSistema >> topBarPanel [ [
    ^ topBarPanel
]
]

{ #category : 'events' }
SuperTatetiBotonesSistema >> volverAlInicio [ 
    controller volverAlInicio
]
