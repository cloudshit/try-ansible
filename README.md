# try-ansible

## 목표
* 테라폼으로 t3 인스턴스 각az에 3개 켜두고
* 앤시블로...
  - hello 유저 생성
  - ssh 포트 2222로 변경
  - nginx 설치후 실행

## 생각해야 할것
* Bastion host 안에서 ansible 실행
* 2222 포트는 테라폼으로 열어야됨
* 앤시블이 호스트들을 auto discovery하면 좋음
