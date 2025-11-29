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
    "Crea un botón de la barra superior con tamaño fijo."
    ^ SimpleButtonMorph new
        label: label;
        extent: 100@40;          "Tamaño fijo para que no cambie al modificar el texto"
        hResizing: #rigid;
        vResizing: #rigid;
        color: Color lightGray;
        borderWidth: 1;
        borderColor: Color black;
        target: controller;      "Los clics van al controller (SuperTatetiMorph)"
        actionSelector: selector;
        yourself

]

{ #category : 'building' }
SuperTatetiTopBarPanel >> crearTopBarPanel [
    "Crea la barra superior con los botones Leave, Start, Reset y Return."
    | topPanel botonReturn botonReset botonLeave botonStartLocal accionReturn |

    topPanel := Morph new.
    topPanel layoutPolicy: TableLayout new.
    topPanel listDirection: #leftToRight.
    topPanel hResizing: #shrinkWrap;
              vResizing: #shrinkWrap;
              cellInset: 5.
    topPanel color: Color lightGray.

    "Selector de acción para Return según la configuración del controller."
    accionReturn := (controller returnHabilitado
    ifTrue: [ #returnPresionado ]
    ifFalse: [ #returnDeshabilitado ]).

	 "Botón Start/Stop (guardamos referencia en el controller de botones)."
	 botonStartLocal := self crearBotonConLabel: 'Start' action: #startPresionado.
	 controller botonStart: botonStartLocal.

    "Botón Return."
    botonReturn := self crearBotonConLabel: 'Return' action: accionReturn.

    "Botón Reset."
    botonReset := self crearBotonConLabel: 'Reset' action: #resetPresionado.

    "Botón Start/Stop (guardamos referencia en el controller)."
    botonStartLocal := self crearBotonConLabel: 'Start' action: #startPresionado.
    controller botonStart: botonStartLocal.

    "Botón Leave (vuelve al menú)."
    botonLeave := self crearBotonConLabel: 'Leave' action: #volverAlInicio.

    "Orden de los botones en la barra."
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
    controller := nil.
    panel := nil.

]

{ #category : 'accessing' }
SuperTatetiTopBarPanel >> panel [
    ^ panel

]
