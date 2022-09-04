linear_equations
################

:date: 2022-01-31 23:15
:modified: 2022-01-31 23:15
:category: math
:slug: solving-to-linear-equations
:authors: junehan
:summary: 선형 방정식의 정리
:tags: equations

Terminologies
-------------

   Algebra
      문자와 기호가 수를 대표하는 수학의 부분.

   Coefficients
      곱할 수 있는 요소. 주로 자연수이며 주로 도형 등에 등장한다.

   Cartesian Coordinate System
      평면 속의 이 좌표 시스템은 각 지점이 unique한 2개의 숫자 좌표를 의미한다.

   Coordinate Plane
      다수의 것이 전체로서 효율적으로 동작하며, 선으로 모든 방향*(x, y)*으로 무한히 계속되는 것.

   linear equation
      일차 방정식, 선형으로 표현되는 최고 차수의 항(param)의 차수가 1을 넘지않는 다항식 함수를 뜻한다.

   polynomial function
      다항식 함수, 최고 차항의 함수에 따라 상수함수, 일차함수, 이차함수, 삼차함수, 사차함수, ...등으로 분류된다.

   Analytic geometry
      해석 기하학, n개의 성분으로 이루어진 좌표를 이용하여 도형의 성질을 탐구하는 기하학. 공간을 다루는데 있어서 빼놓을 수 없다. 위도와 경도로 나타내는 것도 해석기하학에서 도입되는 개념.

linear equation이란?
--------------------

.. image:: https://lh3.googleusercontent.com/pw/AM-JKLUTpuMeTqzYxFfJSaRLBRvXNN81VYDkCuamUrCzDV5R1s5o1wOQLeIm0SIkRIVgT5mKy1k7psZD0Mp-AgCVNyKU36oo1Dudn_1h6CC0SFoRvuJ_f8jxpPnDR8a_mMg-HWDxh1mz9kz71fEa5RYJuzSw=w1016-h1354-no?authuser=0
   :alt: handnote to linear equation and functions

- *-y = 2x - 1*\는 *Algebra*\의 표본이다.

   - 여기서 *x, y*\는 *coefficients*\이며, 이들은 해당 equation의 parameter이다.
   - 즉, 이 parameter가 equation에 충족하는 값의 2개의 값으로 점, link로 표현 될 수 있었다.
   - 데카르트가 만든 *cartesian coordinate system in plane*\에 등장하는 x, y축으로 표현되는 *coordinate plane*\을 통해서,
     이 링크들은 관계적인 나열들이 하나의 선처럼 보여져서 설명될 수 있었다.

Intercept란?
------------

.. image:: https://lh3.googleusercontent.com/pw/AM-JKLXtL3O4418RHjIsnfasR_b0vMCbW9kEEtb0dJT-B-jLDK8Otwqo-cZsg94FqM9PzJkzI4hPH3Pht67nVtdoqD5OJiL0tNuw861pr2gDdKkjGs8a3QOGuBOmrWz9ruTbV3XRp7wo_Qt27cEE5Cqkre3J=w1016-h1354-no?authuser=0
   :alt: handnote to intercept

| 좌표평면(cartesian coordinate system)에서 x축을 만나는 지점과 y축을 만나는 지점을 의미한다.
| 이 챕터에서는 linear equation에 적용한다.
|
| 그래픽으로 표현되는 선상의 점을 기준으로 이야기 하는데, 다르게 말하면
| x의 값이 0일 때 y의 값과 그 반대 각각의 경우와 같다.
| 그래서 이걸 왜 굳이 별도의 개념으로 용어화 했는지를 보니,
| wiki에 X-intercept와 Y-intercept를 구분해서 챕터를 또 나눠놓았어서 이 부분을 짧게 리서치 해보았다.

X-intercept, points crosses the x-axis, Zero of a function
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| 수학에서, function *f*\가 x에 대해 0의 값을 얻었을 때를 의미하고, 마찬가지로 *f(x) = 0*\을 만족하는 x의 값을 의미한다.
| *zero of a function*\은 0의 값을 출력하는 입력값이 무엇인지에 대한 것이다.

   - *linear equation*\경우엔 기울기(slope?)가 있다면 반드시 하나의 point를 가질 것이고,
   - *polynomial function* root(zero output)는 해당 함수에 대해 0의 값에 대응하는 것을 의미한다.

Y-intercept, point cross the y-axis, 기하해석학
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| *Analytic geometry*\에서, 수평선이 변수 x를 의미하고, 수직 선이 y를 의미하는 일반적인 표현을 사용하여 y-intercept 혹은, vertical intercept는 함수의 그래프 혹은 관계에서 coordinate systme의 y-axis를 교차하는 지점을 의미한다.
| X-intercept가 출력이 0일 때 입력 값을 지칭한다면, Y-intercept는 입력이 0일 때, y의 값을 지칭한다.

따라서, function(식)의 개념에서 출력 0을 만족하는 입력은 다수 존재할 수 있으나, 입력이 0일 때 출력이 다수 존재한다는 말은 function(식)으로서의 기능을 잃었다라고 볼 수 있지 않나 생각해본다.

Slope for coordinate plane, 그래프 선의 기울기
----------------------------------------------

- 이전장까지의 내용

   - cartesian coordinate system위의 pair of coefficient, *(x, y)*\는 point로 표현가능하다.
   - *point A*\와 *point B*\를 연결하면 coordinate plane위의 직선이 된다.
   - 해당 선은 직선이기 때문에, linear equation의 표현이 가능하다.

.. image:: https://lh3.googleusercontent.com/pw/AM-JKLUg7dJEHhjjm-PAYLWB7ZnzRV8teXy5s5hhP1SKpnIRhyBXzeJ8JBl-qxuwXfeYZ28V-L4hBKI3MNX9KNJlGmajxEl24mZSCq8nH4851e5vRqHzl4Lkt7hpfvwnvlllie8jOYY_bX6jY5jpVUNR7FCy=w1016-h1354-no?authuser=0
   :alt: handnote to slope

두 개의 값으로 구성되는 좌표평면의 특성 상 기준 선 2개는

   - X-axis: 입력 값, 진행
   - Y-axis: 출력 값, 결과

   | 위와 같이 의미론적으로 해석가능하다.
   | 주로 이 기울기에 대해서, 해외에서는, *'rise over run', 진행에 비롯되는 상승*\이라고 인식한다.
   | 이제까지는 x를 y로 나는 주로 나눠왔는데, y를 x로 나누면 *'입력에 대한 출력의 변화 비율'*\을 의미하기 때문에,
   | 이는 함수를 정확히 표현하는 개념과 같다.

.. image:: https://lh3.googleusercontent.com/pw/AM-JKLUuxnUAg4Xs0o2JGYhDmRms7yNv9pMFOZQGH4OndjxhupU1-gGnY_FAQXYE0rAt5ry29cQz7RPv5kNNEzhXfV-2km1HQwEtyIfrykWS0hH2GxfttCOxNgqLMwIQ6sjoLSWlDiE4hGPa6B_58XtbrdDx=w1016-h1354-no?authuser=0
   :alt: handnote to direction of the slope

| 여기서 x, y라는 값으로 수집된 것들을 데이터라고 하고
| 위의 기준으로 입력값에 대한 출력값 결과들이 나열된 것을 묶어 선으로 표현한 것이라면,
|
| 수직선과 수평선의 데이터가 있다고 했을 때, 이것은 아래의 의미를 갖는다.

   - 수평선, horizontal line: *"입력이 변해도 결과는 변하지 않는다."*
   - 수직선, vertical line: *"입력은 항상 동일한 상태로, 반면 결과는 여러가지이다."*

그렇다 애초에 한 개의 입력에 대해서 두 개의 결과를 갖는다는 것 자체가 규칙으로 보기엔 애매해지는 것이다.

   - 수평선으로 표현되는 데이터는, 입력에 따라 변하지 않아 slope가 없다.
 
      - ``0(y2 - y1) / (x2 - x1)``\의 real number인 y는 출력변화가 없는 0이기 때문에 slope 0이다.

   - 수직선으로 표현되는 데이터는, 결과가 무한하여, infinite 혹은 undefined라고 부른다.

      - ``(y2 - y1) / 0(x2 - x1)``\의 실수 변화치를 변하지 않는 값에 대조해봐야 의미가 없음.

