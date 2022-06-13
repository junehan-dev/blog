---
title: "intro to Systemcall, 시스템 콜의 기본 정리"
date: 2022-02-10T15:10:21+09:00
categories:
- STUDY
- OS
- SYSTEMCALL
---
what is systemcall?
-------------------

> 운영체제에 리소스나 서비스를 요청하려고,  
> 사용자 영역에서 시작해서 커널 내부로 들어가는 **함수 호출.**

{{< figure src="/media/os/systemcall/intro/1.jpg" title="process and systemcall" >}}
{{< figure src="/media/os/systemcall/intro/2.jpg" title="context switching" >}}

정리
- ``read``, ``write``같은 함수가 우리가 사용하는 동시에 시스템 콜로서도 사용된다는 것을 알고 있었는데, 궁금증이 생겼다.
  - asm에서 ``ADD``는 ``syscall``을 하지 않았던 경험에 대해서, 추측상으로는 아래와 같이 동작하지 않을까?
    1. RAX에 값 저장
    2. RAX에 더할 값을 다른 레지스터에 저장하고
    3. 가산기에 전류를 흘린다.
    4. RAX에 결과가 저장된다.
  - 이것은 CPU의 유닛으로 동작하지만, OS에게 ``INT 0x80`` 인터럽션을 일으킬만한 일인가?

Add and print result
--------------------

```add_print.c
#include <unistd.h>

int	main(void)
{
	int	ret;
	int	b;

	ret = 1;
	b = 2;
	ret = ret + b + '0';
	write(1, &ret, 1);
	return (ret);
}
```
```add_print-log.c
execve("./a.out", ["./a.out"], 0x7ffe4a926600 /* 53 vars */) = 0
brk(NULL)                               = 0x55e195bf1000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
mmap(NULL, 134760, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7fcad56a1000
munmap(0x7fcad56a1000, 134760)          = 0
write(1, "3", 1)                        = 1
exit_group(51)                          = ?
```
```asm
SECTION .data
	SYS_WRITE	EQU 1
	STDOUT_FILENO	EQU 1

section .text
	global main

main:
	MOV RAX, 1 ADD RAX, 2
	ADD RAX, '0'; 문자 '3'
	
getStack:
	MOV RBP, RSP
	SUB RSP, 1; 스택변수공간 1바이트
	PUSH RBP
	PUSH RDI
	PUSH RSI
	MOV [RBP-8], RAX;  스택변수에 값 저장
print:
	MOV RAX, SYS_WRITE
	MOV RDI, STDOUT_FILENO
	MOV RSI, RBP-8
	MOV RDX, 1; 1바이트 출력
	INT 0x80; syscall
	MOV RAX, [RBP-8]
clean:
	POP RSI
	POP RDI
	POP RBP
	MOV RSP, RBP
	ret; 3
```

*``write, mmap``외에 눈에 띄는 시스템 콜은 없다.*

결론
---

  1. 운영체제에게 요구하는 것과 CPU에게 요구하는 것은 범위가 다르다.
    - context switching노트에서 *전류입력과 레지스터 준비로 종료되는 것이 아닌가?* 라고 생각을 했었는데,  
    - 애초에 CPU사용은 인터럽션과는 거리가 있다.; *'나는 CPU와 OS를 잠시 착각했다.'*
  2. CPU는 항상 동일한 전류가 흐르면서 구동중이고, ``init, bash``등을 비롯한 프로세스가 새로운 user-process를 실행하기를 기다리고 있다.
  3. OS는 다른 디바이스에 대한 접근(디바이스 드라이버) 등을 포함하여 관리하기 때문에,  
    - 단순한 연산등을 포함하는 코드의 진행은 사용자가 실행중인 프로세스의 메모리와 CPU의 진행만으로 종료될 수 있다.

  4. systemcall 없이 프로그램이 종료하는 것은 아마 불가능에 가까울 정도이겠지만,
    - CPU사용은 syscall은 아니다.
    - syscall은 연산 이상의 리소스에 대한 것으로 확장된다.
    - **user context라는 것도, 커널단을 보호하기 위한 분리된 권한 개념이며 user context, user memory라고 하는 개념조차 생성한 주체가 이미 OS이다.**
    - context는 CPU와 상관없이 1개.
      1. xwindow등의 유저 인터페이스를 포함한, user context에서 event-loop에 context(user)
      2. 마찬가지로 이벤트로 인해 생성된 프로세스의 진행(user)
      3. 도중에 다른 디바이스를 사용해야할 때 보통 interruption이나 systemcall이 발생해야(user)
      4. 자원을 얻을 수 있다.(kernel)

  와 같은 결과를 얻을 수 있었다.

