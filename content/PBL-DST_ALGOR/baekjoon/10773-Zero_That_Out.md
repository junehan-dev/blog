---
title: "10773 Zero_That_Out"
date: 2022-05-14T18:52:17+09:00
categories:
- PBL
- ALGORITHM
- BAEKJOON
tags:
- stack
keywords:
- tech
#thumbnailImage: //example.com/image.jpg
---

Zero That Out
-------------

  - SOURCE: [Baekjoon 10773](https://www.acmicpc.net/problem/10773)
  - Solved code: [my github source file](https://github.com/junehan-dev/Programming_Lectures/blob/BJ/BJ/10773-Zero_that_out/10773.c)

PROGRAM
-------

- Subject

   당신의 보스틑 당신에게 작년의 수입을 결정하기 위해, 연속된 양수를 더하는 것을 부탁했습니다.

   - 당신의 보스가 숫자를 시간배치에 맞지 않게 읽고 있습니다.
   - 당신의 보스가 잘못 설정된 숫자를 말한 이후에 "zero"라고 말해 최근 말한 숫자를 무시하라고 지시할 것이다.
   - 당신의 보스가 잘못 숫자를 말하는 것을 연속적으로 수행할 수 있다.

   **입력을 분석하여 남겨진 모든 수를 더하는 프로그램을 작성하세요.**

- Contraints

   1. 첫 줄의 입력 K 정수(1 <= k <= 100000)는 입력이 예정된 개행을 포함한 숫자의 수 입니다.
   2. 숫자는 1에서 100의 값을 가질 수 있습니다.(inclusive)
   3. 0은 취소의 의미를 지닌 입력으로 포함되어 0 ~ 100의 수를 가질 수 있습니다.

SOLVE CODE
----------

```c
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

struct stack {
	size_t			siz;
	unsigned int	len;
	unsigned int	cur;
	void			*data;
};

struct stack	*make_stack(size_t siz, unsigned int len);
unsigned int	stack_push(struct stack *s, const void *src);
unsigned int	stack_pop(struct stack *s, void *dest );

int		main(void)
{
	struct stack	*num_stack;
	unsigned int	max;
	unsigned int	len;
	unsigned int	i;
	char			v;
	int				ret;

	i = 0;
	ret = 0;

	scanf("%u", &len);
	num_stack = make_stack(1, len);
	max = len;

	while (i++ < num_stack->len && scanf("%d", &v))
		(!v) ? stack_pop(num_stack, &v) : stack_push(num_stack, &v);

	while (stack_pop(num_stack, &v))
		ret += v;

	free(num_stack->data);
	free(num_stack);
	printf("%d", ret);
	return (0);
}


struct stack 	*make_stack(size_t siz, unsigned int len)
{
	struct stack	*ret;

	ret			= malloc(sizeof(struct stack));
	ret->siz	= siz;
	ret->len	= len;
	ret->cur	= 0;
	ret->data	= (void *)malloc(siz * len);

	return (ret);	
}

unsigned int	stack_pop(struct stack *s, void *dest)
{
	char			*dest_data;
	const char		*top;
	unsigned int	n;

	if (!s->cur)
		return (0);

	n = 0;
	(s->cur)--;
	dest_data = (char *)dest;
	top = (const char *)(s->data) + (s->cur) * (s->siz);
	while (n < (s->siz)) {
		*(dest_data + n) = *(top + n);
		n++;
	}

	return (n);
}


unsigned int	stack_push(struct stack *s, const void *src)
{
	const char	*src_data;
	char		*top;
	size_t		n;

	if ((s->cur) == (s->len))
		return 0;

	n = 0;
	src_data = (const char *)src;
	top = (char *)(s->data) + (s->cur) * (s->siz);
	while (n < (s->siz)) {
		*(top + n) = *(src_data + n);
		n++;
	}
	s->cur++;

	return (n);
}
```

  
