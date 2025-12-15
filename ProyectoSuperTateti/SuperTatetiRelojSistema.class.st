Class {
	#name : 'SuperTatetiRelojSistema',
	#superclass : 'Object',
	#instVars : [
		'relojTurnos',
		'procesoReloj',
		'panel'
	],
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'updating' }
SuperTatetiRelojSistema >> actualizarTextoTiempo [
    panel actualizarTextoTiempo

]

{ #category : 'accessing' }
SuperTatetiRelojSistema >> alternarJugador [
    relojTurnos alternarJugador

]

{ #category : 'accessing' }
SuperTatetiRelojSistema >> corriendo [
    ^ relojTurnos corriendo

]

{ #category : 'building' }
SuperTatetiRelojSistema >> crearPanelTiemposJugadores [
    ^ panel crearPanelTiemposJugadores

]

{ #category : 'game_logic' }
SuperTatetiRelojSistema >> detener [
    procesoReloj ifNotNil: [
        procesoReloj terminate.
        procesoReloj := nil ].
    relojTurnos detener.

]

{ #category : 'game_logic' }
SuperTatetiRelojSistema >> iniciarRelojParaJuego: unJuego conCallback: unBloque [
    "unBloque es algo como [ controller ticRelojes ]."

    self detener.

    relojTurnos iniciar.

    procesoReloj := [
        [ relojTurnos corriendo and: [ unJuego juegoTerminado not ] ] whileTrue: [
            (Delay forSeconds: 1) wait.
            unBloque value
        ].
    ] fork.

]

{ #category : 'initialization' }
SuperTatetiRelojSistema >> initialize [
    super initialize.
    relojTurnos := RelojTurnos new.
    panel := SuperTatetiRelojPanel new.
    panel relojTurnos: relojTurnos.

]

{ #category : 'accessing' }
SuperTatetiRelojSistema >> jugadorActivo: unSimbolo [
    relojTurnos jugadorActivo: unSimbolo

]

{ #category : 'accessing' }
SuperTatetiRelojSistema >> panel [
    ^ panel

]

{ #category : 'accessing' }
SuperTatetiRelojSistema >> penalizarA: unSimbolo segundos: unNumero [
    relojTurnos penalizarA: unSimbolo segundos: unNumero

]

{ #category : 'accessing' }
SuperTatetiRelojSistema >> relojO [
    ^ relojTurnos relojO

]

{ #category : 'accessing' }
SuperTatetiRelojSistema >> relojTurnos [
    ^ relojTurnos

]

{ #category : 'accessing' }
SuperTatetiRelojSistema >> relojX [
    ^ relojTurnos relojX

]

{ #category : 'game_logic' }
SuperTatetiRelojSistema >> resetearAmbos [
    relojTurnos resetearAmbos.

]

{ #category : 'game_logic' }
SuperTatetiRelojSistema >> tic [
    ^ relojTurnos tic

]
