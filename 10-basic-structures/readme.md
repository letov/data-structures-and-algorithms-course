<h2>Базовые структуры данных </h2>
<h3>Выводы:</h3>
<p>Все реализации динамических массивов (SingleDArray, VectorDArray, FactorDArray, MatrixDArray) имеют одинаково быстрый доступ к произвольному элементу. MatrixDArray имеет преимущество в скорости при добавлении элемента в конец массива, однако проигрывает FactorDArray
 во всех остальных операциях. Следовательно оптимальным является FactorDArray, увеличивающий емкость динимического массива X2 по мере заполнения.</p>
<p>LinkedArray имеет преимущество в скорости добавления элемента, но существенно проигрывает остальным в скорости доступа к произвольному элементу.</p>
<img src="https://github.com/letov/data-structures-and-algorithms-course-solutions/blob/main/10-basic-structures/images/1.png?raw=true" width="1000">
