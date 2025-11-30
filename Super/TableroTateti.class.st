"
encapsula un 3x3 y sabe su estado y ganador
"
Class {
	#name : 'TableroTateti',
	#superclass : 'Object',
	#instVars : [
		'celdas',
		'estado',
		'ganador'
	],
	#category : 'Super',
	#package : 'Super'
}

{ #category : 'functions' }
TableroTateti >> actualizarEstado [ 
   ganador := self verificarGanador.
   ganador ifNotNil: [ estado := ganador. ^ self ].
   estado := self estaLleno ifTrue: [ #empate ] ifFalse: [ #enJuego ].

]

{ #category : 'functions' }
TableroTateti >> estaLleno [ 
   ^ celdas noneSatisfy: [:v | v isNil ].

]

{ #category : 'accessing' }
TableroTateti >> estado [ 
^ estado 

]

{ #category : 'accessing' }
TableroTateti >> ganador [  
^ ganador 

]

{ #category : 'initialization' }
TableroTateti >> initialize [ 
   super initialize.
   celdas := Array new: 9 withAll: nil.
   estado := #enJuego.
   "ganador := nil."

]

{ #category : 'functions' }
TableroTateti >> ponerSimbolo: unSimbolo enCasilla: i [ 
   (celdas at: i) ifNil: [
      celdas at: i put: unSimbolo.
      self actualizarEstado ].
]

{ #category : 'functions' }
TableroTateti >> vaciarCasilla: i [ 
   celdas at: i put: nil.
   self actualizarEstado.

]

{ #category : 'accessing' }
TableroTateti >> valorEnCasilla: i [  
^ celdas at: i 

]

{ #category : 'functions' }
TableroTateti >> verificarGanador [ 
   | line w |
   #(
      (1 2 3) (4 5 6) (7 8 9)
      (1 4 7) (2 5 8) (3 6 9)
      (1 5 9) (3 5 7)
   ) do: [:tripleta |
      line := tripleta collect: [:i | celdas at: i ].
      w := self verificarLinea: line.
      w ifNotNil: [ ^ w ] ].
   ^ nil
]

{ #category : 'functions' }
TableroTateti >> verificarLinea: tripleta [ 
   | a b c |
   a := tripleta first.
   a isNil ifTrue: [ ^ nil ].
   b := tripleta second.
   c := tripleta third.
   ((a = b and: [ b = c ]) and: [ #(#x #o) includes: a ]) ifTrue: [ ^ a ].
   ^ nil

]
