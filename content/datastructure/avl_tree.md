---
title: "self-balancing Binary Search tree, AVL"
date: 2022-03-28T21:02:49+09:00
categories:
- STUDY
- DST
- GRAPH
- TREE
tags:
- binary tree
- avl tree
thumbnailImage: https://lh3.googleusercontent.com/pw/AM-JKLV-FMM23hr05_QZcH_u_dD-qeGqZxE3C2kGNjYpalP4GoaMbKBKJuU4r79YSn-ysTBUz_Iq6QhTnv9i3oTDlsKKos1x3AD38wdVyqI_Uc9LGNzw-gVi35IN6AwzD4Ww8qBC8KllnoMO2LOQ0lqVrh1a=w971-h1294-no?authuser=0
---

SUBJECT: MIN Heap, MAX Heap의 초판 AVL의 구현과 동작방식을 이해하자
-------------------------------------------------------------------
  - Objectives
    - tree의 기본 개념은 이미 알고 있다는 전제하에서, 고급 인터페이스를 구현하기 위해서 작은 도구들이 어떻게 사용되는지 이해한다.
    - AVL의 구현 방식에서 꼭 tree가 아니더라도 영감을 받을 수 있다.
    - REDBLACK-TREE, Heap구현 하기 전에 AVL구현을 잘 이해하고 있다면 이후 과정이 쉬워질 것이다.

MY AVL STUDY
------------

{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLUlTMhILhBcZfL-RGh3-xcswt2acpj9NBrxx3xSavCM7I0YcWbmj7kkEIEdvOCVItSPCGLTYU9JKSARfwxQuXhpuEcA7OT4XNdcCPChW7DZsExkhzf8Ot4ulT8NMmgacu0sLDpQOMgS7Y-pw1E1DhLB=w971-h1294-no?authuser=0" title="intro of AVL" >}}
___
{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLUv_sTkv7gRq4rCw-esh27qpvwzD0__CgSKMcTMZz5Sbjf7_ojzkjhq7dUgfUbAi1id_UYZItdpdkW4G3okrvHQwEMOiDwWmNyTm0Uj24TocLZgCuG5ZIv82yUIj-rDSLiSVSqhkd8l3N-kdZ0fRUoN=w971-h1294-no?authuser=0" title="tool for avl, subtree property.size" >}}
___
{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLXsyVm3E_r55AlVJcdEfqVpVJUpZ0Uh65XkZ8ZLfnWD0I2uTUpLZAro8ocMn0jxCBTmtrnqz5Vsda_sPO6Xh9aEvN5zxbkfFkWxcFaw1FOvf41ha_m8oOma6i7ssfqdkBGgzJQ3OdqBZqIC-MyNK__E=w971-h1294-no?authuser=0" title="Height of tree" >}}
___
{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLUcrvjXFhoc2oHZO22OqKAfaynwXziYTNCZxyWm65lQaR_aN8G63iLU5u6UzBT31nJM1WKamyhLcvhmF7i3BjXNdexVln4MfoMZROVpOoS-hyT8Lg5PoUcOZsC3Fo1Ej-OzPpG_RQpYW2aH2h5Kl8OJ=w971-h1294-no?authuser=0" title="AVL height" >}}
___
{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLUNktrMFKJs3fVOPJvb78DAchXqIsyGQqkwA9OHuhPpRLOhHYXXZXFyXBvbQo_z_-i6XX0cFp9Ua91qGy2EONUyYbXdcY_K3ZSZ-B__G194yOqQ7WMJsioN21CTu4Y2Q9xTH8RZG_y0HiTn5YWpi3VF=w971-h1294-no?authuser=0" title="AVL Tree" >}}
___
{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLV-FMM23hr05_QZcH_u_dD-qeGqZxE3C2kGNjYpalP4GoaMbKBKJuU4r79YSn-ysTBUz_Iq6QhTnv9i3oTDlsKKos1x3AD38wdVyqI_Uc9LGNzw-gVi35IN6AwzD4Ww8qBC8KllnoMO2LOQ0lqVrh1a=w971-h1294-no?authuser=0" title="Balancing" >}}
