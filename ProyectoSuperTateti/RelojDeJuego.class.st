Class {
	#name : 'RelojDeJuego',
	#superclass : 'Object',
	#instVars : [
		'duraciones',
		'indiceActual',
		'duracionActual',
		'tiempoRestante'
	],
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'updating' }
RelojDeJuego >> decrementarUnSegundo [
	self restarSegundos: 1

]

{ #category : 'initialization' }
RelojDeJuego >> initialize [
    "Inicializa el reloj con una lista de duraciones posibles y lo deja en 1 minuto por defecto."
    super initialize.
    "Duraciones en segundos: 60s (1min), 120s (2min), 300s (5min), 600s (10min)."
    duraciones := #(60 120 300 600).
    "Empezamos en la primera duración (1 minuto)."
    indiceActual := 1.
    "Duración actual según el índice seleccionado."
    duracionActual := duraciones at: indiceActual.
    "Al inicio, el tiempo restante es igual a la duración completa."
    tiempoRestante := duracionActual.

]

{ #category : 'updating' }
RelojDeJuego >> resetear [
    "Vuelve el tiempo restante a la duración completa actual del reloj."
    tiempoRestante := duracionActual.

]

{ #category : 'updating' }
RelojDeJuego >> restarSegundos: unNumero [
	tiempoRestante := (tiempoRestante - unNumero) max: 0

]

{ #category : 'testing' }
RelojDeJuego >> termino [
    "Responde true si ya no queda tiempo (0 o menos segundos)."
    ^ tiempoRestante <= 0.

]

{ #category : 'printing' }
RelojDeJuego >> tiempoComoString [
    "Devuelve el tiempo restante en formato 'MM:SS', por ejemplo '01:00', '02:35'."
    | mins secs minsStr secsStr |
    "Calculamos minutos y segundos enteros a partir del total de segundos."
    mins := tiempoRestante // 60.
    secs := tiempoRestante \\ 60.
    "Convertimos a strings de 2 dígitos, rellenando con 0 a la izquierda si hace falta."
    minsStr := (mins printString) padLeftTo: 2 with: $0.
    secsStr := (secs printString) padLeftTo: 2 with: $0.
    "Juntamos 'MM' ':' 'SS'."
    ^ minsStr , ':' , secsStr.

]

{ #category : 'accessing' }
RelojDeJuego >> tiempoRestante [
    "Devuelve el tiempo restante actual (en segundos)."
    ^ tiempoRestante.

]
