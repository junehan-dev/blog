---
title: "01 3_find_name"
date: 2022-02-12T12:12:36+09:00
categories:
- PBL
- ALGORITHM
- EVERYONE'S WITH PYTHON
---

## 문자열 중복 구하기

{{< figure src="/media/algorithms/withpython/02-findname/analysis.jpg" title="analysis" >}}
{{< figure src="/media/algorithms/withpython/02-findname/solve.jpg" title="psuedo code" >}}

### 분석

1. 0에서 n - 2까지, 즉 n개가 아닌 n - 1개의 문자열이 기준이 될 수 있다.
	- start -> 0, left -> [start + 1 ~ end]
	- 기준 문자열을 순차적으로 비교 등차수열의 성격을 가진다.
        - *n(n + 1) / 2*
2. 총 비교 횟수(1번)에 평균 문자열의 길이 + 1만큼 비교하기 때문에
    - *compare count x 0에서 n-1까지의 평균 문자열 길이*
        - *mid x n / 2*
3. 따라서 문자끼리 값을 비교하는 횟수는, (n-1개의 평균 문자열 길이(m) * 총 비교 수(c))
    - m : (len * (n * n / 2))
    - c : (n * n / 2)
    - O : (len(n * n * n * n) / 4)

### Code

{{< tabbed-codeblock "find_name.py"  "https://github.com/junehan-dev/everyones-algorithm/blob/main/1-basics/02/py/main.py" >}}
<!-- tab python -->
def filter_linear_duplicates(names):
	if len(names) == 1:
		return (None);

	target = names[0];
	names = names[1:];
	founds = find_strdup(names, target);
	if founds:
		founds = list(map(lambda i: i + 1, founds));

	return (founds);

def	find_strdup(names:list, name:str) -> list:
	return [i for i, v in enumerate(names) if v == name];
<!-- endtab -->
{{< /tabbed-codeblock >}}
{{< tabbed-codeblock "find_strdup.c" "https://github.com/junehan-dev/everyones-algorithm/tree/main/1-basics/02/c" >}}
<!-- tab c -->
int	find_dup_name(const char **names, const char *name)
{
	int			dupcnt;
	const char	**found;

	dupcnt = 0;
	found = get_next_dup(names, name);
	while (found) {
		dupcnt++;
		found = get_next_dup(found + 1, name);
	}

	return (ret);
}

const char	**get_next_dup(const char **strs, const char *needle)
{
	while (*strs) {
		if (!ft_strcmp(*strs, needle))
			return (strs);
		strs++;
	}

	return (0);
}
<!-- endtab -->
{{< /tabbed-codeblock >}}

