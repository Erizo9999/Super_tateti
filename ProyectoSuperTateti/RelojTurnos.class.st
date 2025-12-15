Class {
	#name : 'RelojTurnos',
	#superclass : 'Object',
	#instVars : [
		'relojX',
		'relojO',
		'jugadorActivo',
		'corriendo'
	],
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'game_logic' }
RelojTurnos >> alternarJugador [
	"Cambia el jugador activo: de X a O o de O a X."
	jugadorActivo := (jugadorActivo = #x)
		ifTrue: [ #o ]
		ifFalse: [ #x ]

]

{ #category : 'accessing' }
RelojTurnos >> corriendo [
    "Indica si alguno de los relojes está corriendo."
    ^ corriendo.

]

{ #category : 'accessing' }
RelojTurnos >> corriendo: unBooleano [
    "Permite marcar si el sistema de relojes está corriendo o pausado."
    corriendo := unBooleano.

]

{ #category : 'game_logic' }
RelojTurnos >> detener [
    "Pausa los relojes (ninguno descuenta tiempo)."
    corriendo := false.

]

{ #category : 'game_logic' }
RelojTurnos >> iniciar [
    "Marca que el sistema de relojes está corriendo."
    corriendo := true.

]

{ #category : 'initialization' }
RelojTurnos >> initialize [
    "Crea dos relojes (X y O) y deja todo detenido con X como jugador activo."
    super initialize.
    relojX := RelojDeJuego new.
    relojO := RelojDeJuego new.
    jugadorActivo := #x.
    corriendo := false.

]

{ #category : 'accessing' }
RelojTurnos >> jugadorActivo [
    "Devuelve #x o #o según quién tiene el reloj activo."
    ^ jugadorActivo.

]

{ #category : 'accessing' }
RelojTurnos >> jugadorActivo: unSimbolo [
    "Fija quién es el jugador activo (#x o #o) para el reloj de turnos."
    jugadorActivo := unSimbolo.

]

{ #category : 'game_logic' }
RelojTurnos >> penalizarA: unSimbolo segundos: unNumero [
	| reloj |
	reloj := self relojDe: unSimbolo.
	reloj ifNil: [ ^ self ].
	reloj restarSegundos: unNumero

]

{ #category : 'accessing' }
RelojTurnos >> relojDe: unSimbolo [
	unSimbolo = #x ifTrue: [ ^ relojX ].
	unSimbolo = #o ifTrue: [ ^ relojO ].
	^ nil

]

{ #category : 'accessing' }
RelojTurnos >> relojO [
    ^ relojO.

]

{ #category : 'accessing' }
RelojTurnos >> relojX [
    ^ relojX.

]

{ #category : 'game_logic' }
RelojTurnos >> resetearAmbos [
    "Resetea ambos relojes a su duración actual y pone a X como jugador activo."
    relojX resetear.
    relojO resetear.
    jugadorActivo := #x.
    corriendo := false.

]

{ #category : 'game_logic' }
RelojTurnos >> tic [
	| reloj |

	"Resta un segundo al reloj del jugador activo si está corriendo.
	Devuelve:
	   - #x si se quedó sin tiempo X,
	   - #o si se quedó sin tiempo O,
	   - nil si nadie se quedó sin tiempo todavía."

	corriendo ifFalse: [ ^ nil ].

	reloj := self relojDe: jugadorActivo.
	reloj ifNil: [ ^ nil ].

	reloj decrementarUnSegundo.

	reloj termino ifTrue: [
		corriendo := false.
		^ jugadorActivo ].

	^ nil

]

{ #category : 'game_logic' }
RelojTurnos >> tiempoComoStringPara: unSimbolo [
    "Devuelve el tiempo como string 'MM:SS' para #x o para #o."
    unSimbolo = #x
        ifTrue: [ ^ relojX tiempoComoString ].
    unSimbolo = #o
        ifTrue: [ ^ relojO tiempoComoString ].
    ^ '00:00'.

]
