<h1>Graphs</h1>
<img src="https://github.com/letov/data-structures-and-algorithms-course/blob/main/19-Graphs/images/1.png?raw=true" width="200">
<p>BitboardGraph</p>
<p>Граф хранится в 2d матрице из битбордов. Хранит только наличие/отсутствие связи между вершинами.</p>
<p>  ||   0   ||   1   ||   2   ||   3   ||   4   ||   5   ||  </p>
<p>0 ||   X   ||   +   ||   +   ||   +   ||       ||       || 0</p>
<p>1 ||   +   ||   X   ||       ||   +   ||       ||   +   || 1</p>
<p>2 ||   +   ||       ||   X   ||       ||       ||   +   || 2</p>
<p>3 ||   +   ||   +   ||       ||   X   ||       ||       || 3</p>
<p>4 ||       ||       ||       ||       ||   X   ||       || 4</p>
<p>5 ||       ||   +   ||   +   ||       ||       ||   X   || 5</p>
<p>  ||   0   ||   1   ||   2   ||   3   ||   4   ||   5   ||  </p>
