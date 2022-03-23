Условие задачи.    

Фермер хочет построить на своей земле как можно больший по площади сарай.
Но на его участке есть деревья и хозяйственные постройки, которые он не хочет никуда переносить.
Для удобства представим ферму сеткой размера N × M.
Каждое из деревьев и построек размещается в одном или нескольких узлах сетки.
Найти максимально возможную площадь сарая и где он может размещаться.
Начальные данные: Вводится матрица размера N × M из 0 и 1.
1 соответствует постройке, 0 - пустой клетке.
  
Solution N^4<br />
N = 100, prob = 0.1, result = 102, time = 5937 ms<br />
N = 100, prob = 0.2, result = 54, time = 3082 ms<br />
N = 100, prob = 0.5, result = 15, time = 1521 ms<br />
  
Solution N^4, boost 1<br />
N = 100, prob = 0.1, result = 102, time = 1518 ms<br />
N = 100, prob = 0.2, result = 54, time = 337 ms<br />
N = 100, prob = 0.5, result = 15, time = 71 ms<br />

Solution N^4, boost 2<br />
N = 100, prob = 0.1, result = 102, time = 943 ms<br />
N = 100, prob = 0.2, result = 54, time = 215 ms<br />
N = 100, prob = 0.5, result = 15, time = 83 ms<br />

Solution N^3<br />
N = 100, prob = 0.1, result = 102, time = 325 ms<br />
N = 100, prob = 0.2, result = 54, time = 154 ms<br />
N = 100, prob = 0.5, result = 15, time = 78 ms<br />

Solution N^2<br />
N = 100, prob = 0.1, result = 102, time = 150 ms<br />
N = 100, prob = 0.2, result = 54, time = 238 ms<br />
N = 100, prob = 0.5, result = 15, time = 123 ms<br />
