Class {
	#name : 'SuperTateti',
	#superclass : 'Object',
	#instVars : [
		'tableritos',
		'estadoTableritos',
		'jugadorActual',
		'proximoTablerito',
		'ganador'
	],
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'game_logic' }
SuperTateti >> actualizarEstadoDeTablerito: indiceTablerito [
    | casillas ganadorTablerito |
    
    casillas := tableritos at: indiceTablerito.
    ganadorTablerito := self ganadorEnArregloDe9: casillas.

    ganadorTablerito ifNotNil: [
        estadoTableritos at: indiceTablerito put: ganadorTablerito.
        ^ self ].

    (self arregloLleno: casillas)
        ifTrue:  [ estadoTableritos at: indiceTablerito put: #empate ]
        ifFalse: [ estadoTableritos at: indiceTablerito put: #enJuego ].

]

{ #category : 'game_logic' }
SuperTateti >> actualizarGanadorGeneral [
    | g |
    g := self ganadorEnArregloDe9: estadoTableritos.
    (#(#x #o) includes: g) ifTrue: [
        ganador := g ].

]

{ #category : 'game_logic' }
SuperTateti >> arregloLleno: unArreglo [
    ^ unArreglo noneSatisfy: [:valor |
        valor = #enJuego or: [ valor isNil ] ].

]

{ #category : 'game_logic' }
SuperTateti >> cambiarJugador [
    jugadorActual := (jugadorActual = #x)
        ifTrue: [ #o ]
        ifFalse: [ #x ].

]

{ #category : 'game_logic' }
SuperTateti >> esMovimientoValidoEnTablerito: indiceTablerito casilla: indiceCasilla [

    (indiceTablerito between: 1 and: 9) ifFalse: [ ^ false ].
    (indiceCasilla between: 1 and: 9) ifFalse: [ ^ false ].

    (proximoTablerito notNil and: [ proximoTablerito ~= indiceTablerito ])
        ifTrue: [ ^ false ].

    ((estadoTableritos at: indiceTablerito) ~= #enJuego) ifTrue: [ ^ false ].

    ^ ((tableritos at: indiceTablerito) at: indiceCasilla) isNil

]

{ #category : 'accessing' }
SuperTateti >> estadoDeTablerito: indiceTablerito [
    ^ estadoTableritos at: indiceTablerito

]

{ #category : 'accessing' }
SuperTateti >> estadoTableritos [
    ^ estadoTableritos

]

{ #category : 'accessing' }
SuperTateti >> estadoTableritos: unArray [
    estadoTableritos := unArray

]

{ #category : 'accessing' }
SuperTateti >> ganador [
    ^ ganador

]

{ #category : 'accessing' }
SuperTateti >> ganador: unSimbolo [
    ganador := unSimbolo

]

{ #category : 'game_logic' }
SuperTateti >> ganadorEnArregloDe9: unArregloDe9 [
    | line winner |

    #(
        (1 2 3)
        (4 5 6)
        (7 8 9)
        (1 4 7)
        (2 5 8)
        (3 6 9)
        (1 5 9)
        (3 5 7)) do: [:triple |

            line := triple collect: [:i | unArregloDe9 at: i ].
            winner := self ganadorEnLinea: line.
            winner ifNotNil: [ ^ winner ] ].

    ^ nil

]

{ #category : 'game_logic' }
SuperTateti >> ganadorEnLinea: tripleta [
    | a b c |
    a := tripleta first.
    a isNil ifTrue: [ ^ nil ].
    b := tripleta second.
    c := tripleta third.

    ((a = b and: [ b = c ]) and: [ #(#x #o) includes: a ])
        ifTrue: [ ^ a ].

    ^ nil

]

{ #category : 'initialization' }
SuperTateti >> initialize [
    super initialize.
    self reiniciar.

]

{ #category : 'game_logic' }
SuperTateti >> juegoTerminado [
    ^ ganador notNil
        or: [ self arregloLleno: estadoTableritos ].

]

{ #category : 'accessing' }
SuperTateti >> jugadorActual [
    ^ jugadorActual

]

{ #category : 'accessing' }
SuperTateti >> jugadorActual: unSimbolo [
    jugadorActual := unSimbolo

]

{ #category : 'game_logic' }
SuperTateti >> jugarEnTablerito: indiceTablerito casilla: indiceCasilla [
    (self juegoTerminado) ifTrue: [
        ^ self error: 'El juego ya terminó' ].

    (self esMovimientoValidoEnTablerito: indiceTablerito casilla: indiceCasilla)
        ifFalse: [ ^ self error: 'Movimiento inválido' ].

    (tableritos at: indiceTablerito) at: indiceCasilla put: jugadorActual.

    self actualizarEstadoDeTablerito: indiceTablerito.
    self actualizarGanadorGeneral.

    ganador ifNotNil: [ ^ self ].   "si hay ganador, corto acá"

    proximoTablerito := indiceCasilla.
    ((estadoTableritos at: proximoTablerito) ~= #enJuego
        or: [ self tableritoLleno: proximoTablerito ]) ifTrue: [
            proximoTablerito := nil ].

    self cambiarJugador.

]

{ #category : 'accessing' }
SuperTateti >> proximoTablerito [
    ^ proximoTablerito

]

{ #category : 'accessing' }
SuperTateti >> proximoTablerito: unNumero [
    proximoTablerito := unNumero

]

{ #category : 'initialization' }
SuperTateti >> reiniciar [
    tableritos := (1 to: 9) collect: [:i |
        Array new: 9 withAll: nil ].

    estadoTableritos := Array new: 9 withAll: #enJuego.
    ganador := nil.
    jugadorActual := #x.
    proximoTablerito := nil.

]

{ #category : 'game_logic' }
SuperTateti >> tableritoLleno: indice [
    ^ self arregloLleno: (tableritos at: indice)

]

{ #category : 'accessing' }
SuperTateti >> tableritos [
    ^ tableritos

]

{ #category : 'accessing' }
SuperTateti >> tableritos: unArray [
    tableritos := unArray

]

{ #category : 'testing' }
SuperTateti >> testPoner: unSimbolo enTablerito: indiceTablerito casilla: indiceCasilla [
	"sirve para saltearse la logica y ver el fin del juego"
    (tableritos at: indiceTablerito) at: indiceCasilla put: unSimbolo

]

{ #category : 'testing' }
SuperTateti >> testVaciarTablerito: indiceTablerito casilla: indiceCasilla [
    (tableritos at: indiceTablerito) at: indiceCasilla put: nil

]

{ #category : 'accessing' }
SuperTateti >> valorEnTablerito: indiceTablerito casilla: indiceCasilla [
    ^ (tableritos at: indiceTablerito) at: indiceCasilla

]
