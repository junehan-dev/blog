---
title: "Kerberos"
date: 2022-04-13T11:16:49+09:00
categories:
- STUDY
- NETWORK
- KERBEROS
tags:
- kerberos
- authentication 
thumbnailImage: https://web.mit.edu/kerberos/images/dog-ring.jpg
---

SUBJECT: 네트워크 프로토콜의 전반적인 이해
------------------------------------------
  - References
    - https://web.mit.edu/kerberos/

Kerberos
--------

1. What is Kerberos?

   Kerberos는 네트워크 authentication 프로토콜입니다.

   강력한 client-server app간의 secret-key cryptography를 제공하도록 디자인 되었습니다.
   
   일부 사이트들은 firewalls를 사용해 그들의 네트워크 보안이슈를 해결하려고 합니다.

   하지만 방화벽은 기본적으로 나쁜놈들은 밖에 있다는 가정을 하기 때문에, 때로 매우 안 좋은 추측이 됩니다.

   대부분 범죄에 치명적인 사고들은 내부에서부터 시작됩니다.

   방화벽은 또한 사용자들의 접근권한을 강력히 제한한다는 점에서 단점을 가집니다.

   Kerberos프로토콜은 강력한 암호화를 사용하여, client가 안전하지 않은 네트워를 통해 서버에 접근하더라도 자신의 신원을 증명할 수 있습니다.

   클라이언트와 서버가 Kerberos를 사용하고나면, 그들은 자신의 communications를 암호화해 데이터 정합성과 개인정보를 보호합니다.

   - 대칭키 암호화를 사용하며, public key 암호화를 추가적으로 사용하여 인증단계에 사용할 수도 있습니다.
   - kerberos는 기본적으로 UDP port 88을 사용합니다.
