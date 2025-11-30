"
coordina los 9 subtableros,turnos reglas,destino,ganador global e historial.
"
Class {
	#name : 'SuperTateti',
	#superclass : 'Object',
	#instVars : [
		'tableritos',
		'jugadorActual',
		'proximoTablerito',
		'ganador',
		'historialJugadas'
	],
	#category : 'Super',
	#package : 'Super'
}

{ #category : 'gameLogic' }
SuperTateti >> actualizarGanadorGeneral [ 
   | estados w |
   estados := (1 to: 9) collect: [:i | (tableritos at: i) ganador ].
   w := self ganadorEnArregloDe9: estados.
   ganador := (#(#x #o) includes: w) ifTrue: [ w ] ifFalse: [ nil ].



]

{ #category : 'gameLogic' }
SuperTateti >> cambiarJugador [ 
   jugadorActual := (jugadorActual = #x) ifTrue: [ #o ] ifFalse: [ #x ].

]

{ #category : 'gameLogic' }
SuperTateti >> deshacerUltimaJugada [ 
   | ultimo t c anterior |
   historialJugadas isEmpty ifTrue: [ ^ self error: 'No hay jugadas para deshacer' ].

   ultimo := historialJugadas removeLast.
   t := ultimo first.
   c := ultimo second.

   (tableritos at: t) vaciarCasilla: c.
   self actualizarGanadorGeneral.
   self cambiarJugador.

   historialJugadas isEmpty
      ifTrue: [ proximoTablerito := nil ]
      ifFalse: [
         anterior := historialJugadas last.
         proximoTablerito := anterior second.
         (((tableritos at: proximoTablerito) estado ~= #enJuego)
            or: [ (tableritos at: proximoTablerito) estaLleno ]) ifTrue: [ proximoTablerito := nil ] ].


]

{ #category : 'gameLogic' }
SuperTateti >> esMovimientoValidoEnTablerito: t casilla: c [ 
   (t between: 1 and: 9) ifFalse: [ ^ false ].
   (c between: 1 and: 9) ifFalse: [ ^ false ].
   (proximoTablerito notNil and: [ proximoTablerito ~= t ]) ifTrue: [ ^ false ].
   ((tableritos at: t) estado ~= #enJuego) ifTrue: [ ^ false ].
   ^ ((tableritos at: t) valorEnCasilla: c) isNil

]

{ #category : 'accessing' }
SuperTateti >> estadoDeTablerito: t [ 
 ^ (tableritos at: t) estado
]

{ #category : 'accessing' }
SuperTateti >> ganador [  ^ ganador
]

{ #category : 'accessing' }
SuperTateti >> ganador: s [ 
 ganador := s
]

{ #category : 'gameLogic' }
SuperTateti >> ganadorEnArregloDe9: arr [ 
   | line w |
   #(
      (1 2 3) (4 5 6) (7 8 9)
      (1 4 7) (2 5 8) (3 6 9)
      (1 5 9) (3 5 7)
   ) do: [:triple |
      line := triple collect: [:i | arr at: i ].
      w := self ganadorEnLinea: line.
      w ifNotNil: [ ^ w ] ].
   ^ nil

]

{ #category : 'gameLogic' }
SuperTateti >> ganadorEnLinea: tripleta [ 
   | a b c |
   a := tripleta first.
   a isNil ifTrue: [ ^ nil ].
   b := tripleta second.
   c := tripleta third.
   ((a = b and: [ b = c ]) and: [ #(#x #o) includes: a ]) ifTrue: [ ^ a ].
   ^ nil

]

{ #category : 'initialization' }
SuperTateti >> initialize [ 
   super initialize.
   self reiniciar.




]

{ #category : 'gameLogic' }
SuperTateti >> juegoTerminado [ 
   ^ ganador notNil
      or: [ (tableritos collect: [:t | t estado ]) noneSatisfy: [:e | e = #enJuego or: [ e isNil ] ] ].


]

{ #category : 'accessing' }
SuperTateti >> jugadorActual [  ^ jugadorActual 

]

{ #category : 'accessing' }
SuperTateti >> jugadorActual: s [ 
 jugadorActual := s 
]

{ #category : 'gameLogic' }
SuperTateti >> jugarEnTablerito: t casilla: c [ 
 | simboloActual |
   (self juegoTerminado) ifTrue: [ ^ self error: 'El juego ya terminó' ].
   (self esMovimientoValidoEnTablerito: t casilla: c) ifFalse: [ ^ self error: 'Movimiento inválido' ].

  
   simboloActual := jugadorActual.   "Guardar el jugador que está jugando ahora"

   (tableritos at: t) ponerSimbolo: simboloActual enCasilla: c.
   historialJugadas add: { t. c }.

   self actualizarGanadorGeneral.
   ganador ifNotNil: [ ^ self ]. "cortar si hay ganador global"

   proximoTablerito := c.
   (((tableritos at: proximoTablerito) estado ~= #enJuego)
      or: [ (tableritos at: proximoTablerito) estaLleno ]) ifTrue: [ proximoTablerito := nil ].

   self cambiarJugador.   "Ahora sí cambiamos el turno"



]

{ #category : 'accessing' }
SuperTateti >> proximoTablerito [ 
 ^ proximoTablerito
]

{ #category : 'initialization' }
SuperTateti >> reiniciar [ 
   tableritos := (1 to: 9) collect: [:i | TableroTateti new ].
   ganador := nil.
   jugadorActual := #x.
   proximoTablerito := nil.
   historialJugadas := OrderedCollection new.

]

{ #category : 'accessing' }
SuperTateti >> tableritoEnIndice: i [ 
 ^ tableritos at: i
]

{ #category : 'accessing' }
SuperTateti >> valorEnTablerito: t casilla: c [ 
^ (tableritos at: t) valorEnCasilla: c
]
