---
title: "LC-297/Serialize deseialize btree 항해 알고리즘 발표"
date: 2022-03-23T01:10:45+09:00
categories:
- PBL
- ALGORITHM
- LEETCODE
tags:
- presentation
- tree
- bfs
thumbnailImage: https://lh3.googleusercontent.com/pw/AM-JKLU8TOe25nJcH5eQQ9tIU38E0e7OYwJLndDW7sQwzAFtfDrVR4aQv2Hx5RTqAj8LbkAlO34w2WRSXs8Py0qR753UFFP3m2hMIO4UnqFFUKwZA5hP3G9vhDkZlHpiUf8fmCGlG7SRNqzrrkAsTuI0fB-0=w916-h516-no?authuser=0
---

## "문제를 해결하고, 개선을 통해 선택한 기본 알고리즘이 나쁘지 않았다는 것을 증명한 것에 대해서"

- 첫 시도 결과 하위 10%성능
{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLWfXQdEOWnuwI3jFJJnz4HA1FLSy8g1XT4-XZ4GI8BmglMc5XbkHlpXbZVAllKb11DnPPJgXcFodvHjf1vWcaj2cKtrqyP0nikuTGQAq5ZqT7JLN0z6RNpS499rFILpckjANwPQA9vw6_ElaDqr_dR0=w917-h66-no?authuser=0" title="" >}}

{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLWXmcM_5lLslZzG9h_C30_uVS9gvhIjLeFtV6OwVGKIbOapJJri4z0DLwHs7bQuCxjEejhLE7stidhAjmWiRdBZSgFgELBWAxj2HJVbg7tEFn0nGwz3wYoNmrMTHahnr-U8v_vEiIl_18K55JR2G0-W=w916-h717-no?authuser=0" title="problem" >}}
___
{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLX5vZ7vWsOkQsOVB45RHeX6UmF_4gy6vY1UNOzS-0PlWG4M_ku5V1dBHlToH2Ysyrxwp1gvtHRqqvsEIs_T-cpihsmgO2GzJY9F5B-ApBzw3lEvu_TRJwlPeOv1k4X31GaYMC0QkB4OcdUciEKzdrjI=w916-h515-no?authuser=0" title="helptext" >}}
___
{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLVZ79bjA6-0MZ1-7gckbUj4NZ3PVAgPXzvt5-m2F7DMHhPBZ_Hd8sJFJKtntaY9pFuiWNEytlf8esY_n_RXIJgdTGchzYI3h1u0cz64NglueSEr4phLPmeecZ4fW94pAjuMiVmflP5JrDtYB3e0NSxK=w560-h714-no?authuser=0" title="TreeNode" >}}
___
### 리스트 시리얼 데이터에서 트리 생성하는 함수
``[0,1,2,3]``
{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLXY6LploxNa2ip8d5yV9avpFJtGuzcJ6mktGFE6LnHafxP1hshaoXFbhKGhfxnvxA2TRHJuEWAe9rO_TcoZjFt0Z7eeurAkfvTPYxxUToWDLy799mOHml8RKdtGbZSajhDX_ofVAnD639QQen0mVBeu=w916-h515-no?authuser=0" title="" >}}
1. 데이터의 나열 순서가 트리의 레벨별로 좌->우 의 방향으로 가기 때문에,
2. 데이터를 앞쪽에서부터 사용할 수 있도록 큐ADT로 전환하였습니다.
3. 0번의 데이터와 루트노드를 최초에 링크대기노드-큐에 넣어주고.
4. 이후는 데이터를 ``popleft()`` 하면서 노드를 생성하고
    - 데이터가 유효하다면 left를 생성하여 연결하고 대기노드큐에 넣고
    - 데이터가 유효하다면 right로 생성하여 연결하고 대기노드큐에 넣습니다.
___
### 데이터의 잔여여부를 기점으로 WHILE
{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLWEVgSu_4RtIduTjVhDbq-jfV9lIA75rDqwFtYyY1O0ru4FsdN9R2MdyMB64-QyIS1gW-Pwn_0UX8OLQXSfIyLj3VFWSc8Fn8nz8qXFDiCk1xaBRHNu8VdxxuqN3kVywSc9E4yBtioChgJp0f7eLKG9=w916-h537-no?authuser=0" title="" >}}
{{< figure src=https://lh3.googleusercontent.com/pw/AM-JKLUuB9-8YNbocN0dPmx7j6rKl9t3KznbnFgVYAcns0ajTG49YKn09yK8NOZ9E2j4U__II14MIginvate3f3T1Ym3r9IzL8y2FE1OA7JumSSl_cPE9Q01Mn2TvuLto37TckkH9l5UeWbWpu_gw2-u2JhW=w788-h614-no?authuser=0"" title="" >}}
{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLXynFpq7OulJ3MQe_P7-nANSzx06DTpPB5sc2xC0M38JuCx7ZULfqzOCi3PWHSLIEOQqvHDc76-fl6bPu11SW2js3FtP2PSpUo7wNgclMtBupWq0fb6bYlrLSZ8zckmGVmvsW53nwjhw2qBzdQ29iL2=w859-h550-no?authuser=0" title="" >}}
- 2, 4는 연결이 끝났고, 추가 serial은 없기 때문에 Q에는 2,4 노드가 남아있는 상태로 함수가 종료됩니다. 
___
### 문제를 잘못 이해한 부분
**제가 생각한 serial데이터** ``[1,2,None,None,5,6,None,None,None,None,11]``   
**실제 데이터:** ``[1,2,None,None,5,6,11]``   

   - 트리를 생성하고 연결할 때는 None데이터를 무시하지만,  
    데이터에는 트리의 레벨에 꽉 찬 노드 수를 기준으로  
    None을 넣어서 serialize해야 한다고 생각했습니다.
___

### 실패사례. 데이터->트리 역직렬화(deserialize)방법:
{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLU8TOe25nJcH5eQQ9tIU38E0e7OYwJLndDW7sQwzAFtfDrVR4aQv2Hx5RTqAj8LbkAlO34w2WRSXs8Py0qR753UFFP3m2hMIO4UnqFFUKwZA5hP3G9vhDkZlHpiUf8fmCGlG7SRNqzrrkAsTuI0fB-0=w916-h516-no?authuser=0" title="" >}}
> ``data = [0, 1, 2, None,None, 5, 6,None,None,None,None, 11]``
  - 기존에는 데이터를 큐에 담아 큐가 비었는지를 기준으로 노드를 생성해주었습니다.
  - 데이터의 인덱스를 기반으로 노드를 생성하면, 노드의 다음 자식위치의 데이터를 인덱스로 가져올 수 있습니다.
  - 루프마다 1의 카운터를 증가시키는 방식. data[i] == None이면 바로 while로 돌아갑니다. 
___
### 실패사례. 트리->데이터 직렬화(serialize)방법:
  ```python
  def serialize(treenode):
    index = 0;
    root = treenode;
    node_q.append( (root, index) );

    while node_q: 
      node(root), index(0) = node_q.popleft();
      if root.left:
        node_q.enqueue((left, (i*2+1))); #큐에 자식노드와 인덱스를 같이 저장해줍니다.
      i += 1;
  ```
- 여기는 직렬화 대기노드큐에 bfs로 노드 탐색을 하는 순서로 노드를 넣고,  
  노드를 dequeue했을때 함께 나온 인덱스와 쌓인 데이터 길이의 차이를 활용하여
> ``data == [0, 1, 2 ] # 이 상황에서 5번 노드를 popleft() 했을 때``
> ``data += [None] * idx - len(data); # 5-3``  
> ``data == [0, 1, 2, None, None]``

{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLUlU2iwWJUeOkjn--f-G8eeSeIBTOVewrRKi_utM4nF55VJji6Llko-Z7ZuzH-5SVk98_d3ZbcFLhOncWXd0KllOuO_HmhrG3Z46Nv-vXRJ1NYqkKqrCyVKPcnYQPMcZE1PcDGtiVwFU6J-g8YMm4TS=w916-h516-no?authuser=0" title="notfixed" >}}
___
### 시행착오를 해결하고 제출을 했는데 다음과 같은 메세지를 받았습니다.
___
- 데이터를 트리로 전환할 때는 데이터를 기점으로 LOOP하는 방식으로 돌아가 해결하게 되었습니다.
{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLWb7TiQVv1-YkrEHii_PUPRSHV1v8r7CbbezKjd3tmNvlRXPeq8BhVlE5GxkkJGElaaA8sa_MhwESK3llMlddlnXR8XwehkDop-2Ip8bU9vy6e2PuSwcUIxnanclBvvDDpcc08_oVNtCSk2WxxpqvLf=w917-h512-no?authuser=0" title="specchange" >}}
___
### deserialize 역직렬화 시에는 데이터의 잔여여부를 기점으로 While

{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLX6kgBfbC9owDjVO0-8KejVZa9Ha1012fxdQ7oBkKiFazP1726D-KJTTXpvvzfDAIuEomRLn6HoBwiy2uLyBtNgrjk9_Ryx1ECjaqNKaebJ6kp-llJ4RoAgs9khoqgtvgdCb1gOQGLRhI-dzbA989Gx=w916-h278-no?authuser=0" title="" >}}
___

{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLXY6LploxNa2ip8d5yV9avpFJtGuzcJ6mktGFE6LnHafxP1hshaoXFbhKGhfxnvxA2TRHJuEWAe9rO_TcoZjFt0Z7eeurAkfvTPYxxUToWDLy799mOHml8RKdtGbZSajhDX_ofVAnD639QQen0mVBeu=w916-h515-no?authuser=0" title="create_tree.py" >}}

___

```py
def resolve_tree(node: TreeNode) -> list:
    if not node:
        return [];

    serial_data = [];
    work_q      = deque();
    root        = node;

    work_q.append(root);
    serial_data.append(node.val);
    while work_q:
        node = work_q.popleft();

        if node.left and node.right: #best
            register_node(serial_data, work_q, node.left);
            register_node(serial_data, work_q, node.right);

        elif node.left and not node.right: #clean right
            register_node(serial_data, work_q, node.left);
            if is_lower_level(work_q):
                serial_data.append(None);

        elif node.right and not node.left: #append None first
            serial_data.append(None);
            if node.right:
                serial_data.append(node.right.val);
                work_q.append(node.right);
        else: 
            temp_q = list(work_q);
            if is_lower_level(temp_q):
                serial_data.append(None);
                serial_data.append(None);

    return (serial_data);
  """
  #is_lower_level(temp_q) 로 2차 Level 아래의 Node를 검사합니다.
  #
  #LinkWaitQueue: [<3>, <4>] -  LV 2
  ##########################
  #          <0>           # -  LV 0
  #                        ######## 
  #    <1>    |    <2>: 현재 검사중  # -  LV 1
  #           |            ########
  #  3    4   | None None  # -  LV 2
  # ?         |            #
  ########################## 
  [0,  1, 2, 3, 4, 6] 로 정렬하면, 
  3, 4 우측에 None None이 없이 '?'인 6이 오면
  - 6은 2의 left가 됩니다.
  [0, 1, 2, 3, 4, None, None, 6] 로 시리얼 데이터를 생성해줘야합니다.
  """
```
*이 트리노드를 serial하는 과정이 까다롭게 된 이유는..*  
*serial하는 Tree는 leetcode에서 주는거라 필요한 과정이라고 생각했습니다.*  
**과정상 필요한 과정은 맞습니다만 개선은 가능합니다.**
___
### 일단 통과 하였습니다.
{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLXdDIzJLf_AMd79dh4h_7gt3NsRp7r8uoy35snry4cfYt3bF6wMxMhE_2vRza-kF8HNm7aYIzok3vjy9UOQztb7bRKNIUHDiOpe4x66MRUSLhbinOPZgOnhZ64y-78yFouGLEQa2xSfMN4PvlhIa0N6=w916-h516-no?authuser=0" title="" >}}
___

### IF처리 개선
1. left, right가 None이어도 같은 레벨의 노드들과 ``while q:`` 진행 될 수 있도록 append 합니다.
2. ``popleft()``에서 ``cur == None`` 일 경우,  
  Queue안에 None이 아닌 노드가 있다면 serial에 None을 더해줍니다.
{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLXE0SLr-0lAZRf6mOWlyAcA5TUGd-juxDxWpltXCsv5h5qbXlglIbcEnv5SSwEfYTmLv0kM5wiVIjBjMLmN5NijjVkEjROXuU5PUWxIlQsBEiTLEjPsXaY3hwIqxUFcMXln0rsXrcV2JIABKMyftDBe=w890-h870-no?authuser=0" title="" >}}
- any같은 경우는 리스트 같은 sequence(iterable)를 앞에서부터 순회하면서 유효한 값을 만나는 순간 바로 리턴하는 빌트인 함수입니다.
### 진행과정
{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLUjflVnDwAPm6nA_GqNOCh1AjwQhvt5p2mpzeYt2g3kynvGInz423_4hkOfaAjty2whYH5MWaJimW0E83msoQQOzU_AONHVoKA9XfLgcWmWnzZbA4ScUUUbAMZHp7nPmaBs5pdMIDsI0capmk0ROHr6=w317-h339-no?authuser=0" title="" >}}
{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLVmB9QqwBuuKOxBbKkX9oxbeRhw-ev6XjoGRB4wcQvQY3ipHJNfLF7y4ST9Z1B49UD2M2PYpRjOOMxoVAqPtnbt83BU9z-xkP8LAz6DldWqqUGVcmMqLQJYeEyFb-fhO9d4kD36KQfpUXcNthA76Eko=w605-h416-no?authuser=0" title="" >}}

- 데이터 POP과 append가 반복되는 상황에 유효한 판정, 그렇지 않은 판정으로 append여부가 좌우되는 경우 였습니다.

> None과 Node를 일괄적으로 Queue에 담는 것은 매우 좋았습니다.
> 하지만 마지막 None만 남아있는 상황에서
> > ``[None, None, None, None, None, None, None]``이 남아있다면
> ```python
> while q:
>   if node is None -> if any(Q) -> False -> LOOP;
> ```

{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLV3WMtd2ezNsYZr_4KL1hpov9DE2scjyks0V-VJEIOMyAe9HjPwtemqrGdCMJ2OLR66MEVHtNdHVBEd19D9zqe5CWmBjzoWDosvZwCHS-clpUY0G2M0DDo3kmOJKAAG3QH61TGDEbVk7BUNnW35JWon=w916-h272-no?authuser=0" title="" >}}

### 코드 개선에 따른 속도 비교
1. IF
{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLWfXQdEOWnuwI3jFJJnz4HA1FLSy8g1XT4-XZ4GI8BmglMc5XbkHlpXbZVAllKb11DnPPJgXcFodvHjf1vWcaj2cKtrqyP0nikuTGQAq5ZqT7JLN0z6RNpS499rFILpckjANwPQA9vw6_ElaDqr_dR0=w917-h66-no?authuser=0" title="" >}}
2. IF any(Q):
{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLUuJ5c9KTm99tCfRNWsY6Qebmzkpav4bx0RKYL8AsOVqRiG_M1OGeO-JoSlLksfvK2-kTyjlorIUv_54JEKRZe1zkx0xDbk8NRAp1t9tVVsAkv-go4a3NhUir9RvH5dLdimhNKzDcAMOMsoLbyEH3Y0=w916-h129-no?authuser=0" title="" >}}
3. WHILE (any(Q)):
{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLUfK57yrK79UW3lXXlscIP-JxocSAMG9NCM25cvrErK_9YHH8TDQqGnYoQizkmnY-7nDsVnwULQI-Zj3nImk9yVkD-xwoJ15M2HGtVDbUW5mZhAlqHhr6XNRay7vewL2FAsxxq3WfBckjdm1IYN4MZW=w916-h65-no?authuser=0" title="" >}}

___

- while문 내부에서 ``if : Q.append`` 처리하지 않고
  - 일괄적으로 Q에 append하고 any를 사용해서 if 같은 컨트롤 구문을 줄일 수 있습니다. 파이썬의 최적화 함수를 통해 Q를 검사하면서도 빠르게 리턴 받을 수 있을 수 있어서 덕분에 많이 개선된 경험이었습니다.

___

#### 들어주셔서 감사합니다!

