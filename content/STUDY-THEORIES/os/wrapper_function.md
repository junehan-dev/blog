---
title: "Wrapper_function"
date: 2022-03-06T17:57:47+09:00
categories:
- STUDY
- OS
- SYSTEMCALL
- WRAPPER FUNCTION
tags:
- glibc
---

glibc의 C소스코드에서의 사용과 시스템사용의 차이
-----------------------------------------------

> glibc의 함수 write를 C에서 사용하는 것.
> - C에 ``write(1, &str, strlen(str));``는 os가 사용중인 glibc의 delegation이고, glibc.so.6 내부에 write syscall delegation이 존재한다.
> - asm에서 syscall하는 ``sys_write``는 os에서 제공하는 syscall delegation이고 c.write의 부분집합이다.

{{< figure src="/media/os/systemcall/intro/wrapperfunction.jpg" title="system call and wrapper function" >}}

예시
---
- Hello world 출력 프로그램
  - ``hello.c``
    ```c
    #include <unistd.h>
    #include <assert.h>

    int	main(void)
    {
      const char	*str = "Hello, world\0";
      int			len = 12;
      int			ret;
      char		r_buf[5];

      ret = write(STDOUT_FILENO, str, len);
      assert(ret == len);	
      ret = read(STDIN_FILENO, r_buf, 5);
      len = write(STDOUT_FILENO, r_buf, ret);
      assert(ret == len);
      return (0);
    }
    ```
  - ``hello.c.syscalls.log``
    ```c
    execve("./a.out", ["./a.out"], 0x7ffeea008ba0 /* 57 vars */) = 0
    brk(NULL)                               = 0x56274a683000
    arch_prctl(0x3001 /* ARCH_??? */, 0x7ffd63fb8040) = -1 EINVAL (Invalid argument)
    openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
    newfstatat(3, "", {st_mode=S_IFREG|0644, st_size=136787, ...}, AT_EMPTY_PATH) = 0
    mmap(NULL, 136787, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f5c38367000
    close(3)                                = 0
    openat(AT_FDCWD, "/usr/lib/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
    mprotect(0x7f5c38187000, 1880064, PROT_NONE) = 0
    mmap(0x7f5c38187000, 1531904, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2c000) = 0x7f5c38187000
    mmap(0x7f5c382fd000, 344064, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1a2000) = 0x7f5c382fd000
    mmap(0x7f5c38352000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1f6000) = 0x7f5c38352000
    mmap(0x7f5c38358000, 51888, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f5c38358000
    close(3)                                = 0
    mmap(NULL, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f5c38158000
    set_tid_address(0x7f5c38158a10)         = 8865
    mprotect(0x7f5c383be000, 8192, PROT_READ) = 0
    prlimit64(0, RLIMIT_STACK, NULL, {rlim_cur=8192*1024, rlim_max=RLIM64_INFINITY}) = 0
    munmap(0x7f5c38367000, 136787)          = 0
    write(1, "Hello, world", 12)            = 12
    read(0, "23\n", 5)                      = 3
    write(1, "23\n", 3)                     = 3
    exit_group(0)                           = ?
    +++ exited with 0 +++
    ```
  - links
    ```bash
    gcc ./hello.c
    ./a.out
    ldd ./a.out

    linux-vdso.so.1 (0x00007ffeb156d000)
    libc.so.6 => /usr/lib/libc.so.6 (0x00007f44777c0000)
    /lib64/ld-linux-x86-64.so.2 => /usr/lib64/ld-linux-x86-64.so.2 (0x00007f44779f3000)
    ```
> 정리
>   - C에서 내가 사용하는 모든 시스템 함수들은 gcc에 의해 provisied된다 라고 보는게 맞다.
>     - LDD링크 오브젝트 들이 시스템함수들에 의존한다.
> 생각해 보면 C에서는 64bit아키텍쳐 인지 AT&T 방식인지 그런 것들은 전혀 신경쓰지 않는다.
>   - C프로그램을 실행하려면, 먼저 의존하는 wrpper function lib를 링크해서 모든호출이 write구현체에대해 중간 매개자를 거친다.
>     - libc.so.6오브젝트의 write를 실행

  - ``hello.asm``
    ```asm
    section .data
      userMsg DB "Please Enter a Number: "
      lenUserMsg EQU $-userMsg
      dispMsg DB "You have entered: " 
      lenDispMsg EQU $-dispMsg

    section .bss
      num RESB 5

    section .text
      global _start

    _start:	;User Prompt
      mov RAX, 4	;sys_write
      mov RBX, 1	;write to 1(STDOUT_FILENO)
      mov	RCX, userMsg
      mov RDX, lenUserMsg
      int 80h

      ;Read and store User-Input
      mov RAX, 3	;sys_read
      mov RBX, 2	;read from 2(STDIN_FILENO)
      mov RCX, num	; to store
      mov RDX, 5	;5 bytes(1MSB+4BYTES) of that information
      int 80h

      ;Output the messege
      mov RAX, 4	;sys_write
      mov RBX, 1	;WRITE to
      mov	RCX, dispMsg
      mov RDX, lenDispMsg
      int 80h

      ;Output the number entered.
      mov RAX, 4	;sys_write
      mov RBX, 1	;WRITE to
      mov	RCX, num
      mov RDX, 5	;write len
      int 80h

      mov EAX, 1	;sys_exit
      mov EBX, 0	;exit code
      int 80h
    ```
  - ``hello.asm.log``
    ```c
    execve("./a.out", ["./a.out"], 0x7ffecb6a31d0 /* 57 vars */) = 0
    write(1, "Please Enter a Number: ", 23) = 23
    read(2, "34\n", 5)                      = 3
    write(1, "You have entered: ", 18)      = 18
    write(1, "34\n\0\0", 5)                 = 5
    exit(0)                                 = ?
    +++ exited with 0 +++
    <!-- endtab -->
    <!-- tab bash -->
    nasm -f elf64 ./hello.asm
    ld ./hello.o
    ./a.out
    ldd ./a.out

    not a dynamic executable
    ```
정리
  - asm에서 사용하는 것은 glibc의 write함수가 아니라 system call write이다.
  - asm쪽의 syscall은 코드상의 호출이 구현체에 대한 1대1 delegation을 한다.
  - wrapper function의 이점을 사용한다기 보다 내가 아키텍쳐를 지정하고 컴파일 한다.
    - 의존하는 object또한 없이 실행과 종료가 명확하다.

### 결론

- asm보다 고급언어라면 대부분 시스템 wrapper function에 의존하여, 링크가 걸리고 동적인 실행환경에서 동작한다.
  - ``c.write -> libc.so.6.write -> (syscall.write + behind the gcc scene)``
- asm은 그 어떤 의존없이, 즉각적으로 systemcall을 지칭하는 것들 만으로 구성된다. 구현체 자체를 중간단계 없이 호출 하는 것이다.
  - ``asm.write -> (syscall.write + behind_os_scene)``
