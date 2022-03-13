---
title: "01_n_of_summation"
date: 2022-02-08T19:34:39+09:00
categories:
- PBL
- ALGORITHM
- EVERYONE'S WITH PYTHON
---

## 1부터 n의 합 구하기 풀이

{{< figure src="/media/algorithms/withpython/01/solve.jpg" title="psuedo code" >}}
{{< figure src="/media/algorithms/withpython/01/analysis.jpg" title="analysis" >}}

### 분석

1. 단위 인덱스는 1(규칙적으로 변화)이며, 인덱스 증감에 따라 내부의 값도 동일한 단계로 변화한다.
   - 1이 증가하면, 값이 1 증가한다.
   - 1이 감소하면, 값이 1 감소한다.
2. 결과를 직접 계산함으로 얻을 수 있는 특성상, value pair를 구성해서 구성된 set의 수만큼 value pair를 곱하면 원하는 값을 얻을 수 있다.
   1. 여기서 예외가 발생하는 것도 발견, pair가 되지 못한 수, 전체 개수가 홀수 개일 경우.
   2. 중간의 남는 인덱스를 알아낸다면 바로 값을 구할 수 있으므로 끝에 그 값을 더해준다.
3. ``pair sums`` or  ``pair sums + mid``.

### Code

{{< tabbed-codeblock "summation for positive n"  "https://github.com/junehan-dev/everyones-algorithm/blob/main/01/n_of_summation.py" >}}
    <!-- tab python -->
		def n_summation(n):
			if (n == 0):
				return (0)
			mid = n // 2 + 1 if (n % 2) else 0
			pair = n + 1
			pair_cnt = n // 2
			return (pair * pair_cnt + mid)
    <!-- endtab -->
{{< /tabbed-codeblock >}}

{{< tabbed-codeblock "summation for any integers" "https://github.com/junehan-dev/everyones-algorithm/blob/main/01/n_of_summation.c" >}}
    <!-- tab c -->
		int	sum(int start, int end)
		{
			int mid;
			int cnt;

			if (start > end)
				return (0);

			cnt = end - start + 1;
			mid = (cnt % 2) ? (end + start) / 2 : 0;
			return ((end + start) * (cnt / 2) + mid);
		}
    <!-- endtab -->
{{< /tabbed-codeblock >}}

