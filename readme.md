
# J4JG 플랫폼 (2024.7.15 ~ 2024.8.21)

**J4JG**는 취업 준비생을 위한 채용 정보 제공 및 멘토링 서비스를 제공하는 플랫폼입니다. 이 플랫폼은 외부 API 연동, 뉴스 크롤링, 멘토-멘티 매칭 기능을 통해 취업 준비생에게 유용한 정보를 제공합니다.
**핵사고널 아키텍처**를 적용하여 비즈니스 로직과 외부 시스템을 분리하였으며, **멀티 모듈 아키텍처**를 통해 모듈 간 독립성을 보장하였습니다. Docker를 활용한 각 모듈의 독립 실행과 AWS 배포 전략을 통해 고가용성 및 성능 최적화를 달성하였습니다.

---

## 🚀 사용 기술

- **Backend**: Spring, JPA, MySQL
- **Search**: Elasticsearch, Logstash
- **Caching**: Redis
- **Cloud**: AWS
- **CI/CD**: GitHub Actions, Docker

---

## 🏛️ 아키텍처 개요

이 프로젝트는 **핵사고널 아키텍처**를 기반으로 하여 비즈니스 로직과 외부 시스템을 분리하여 유지보수성과 확장성을 높였습니다.

### 📂 아키텍처 레이어

1. **도메인 레이어**: 
   - 핵심 비즈니스 로직과 엔티티가 포함되어 있습니다. 주요 도메인 패키지로는 `collection`, `mentoring`, `scrap`, `notification`, `user` 등이 있습니다.

2. **애플리케이션 레이어**:
   - 애플리케이션 서비스가 이 레이어에서 비즈니스 유스 케이스를 처리합니다. `service` 패키지는 주요 비즈니스 로직을, `port`는 외부와의 인터페이스를 정의합니다.

3. **어댑터 레이어**:
   - 외부 시스템과의 상호작용을 처리하는 어댑터입니다. `in` 패키지는 입력 포트를, `out` 패키지는 외부 시스템과의 통신(예: 데이터베이스)을 처리합니다.

---

## 🐳 Docker 구성 및 실행

프로젝트는 **Docker**를 사용하여 여러 서비스가 독립적으로 배포되고 실행됩니다. **backend** 모듈이 실행될 때, **Logstash**와 함께 실행되며 **루트의 docker-compose.yml** 파일을 통해 설정된 서비스를 실행합니다. 나머지 서비스는 개별적으로 실행됩니다.

### 📦 Docker 서비스 구성

- **MySQL Master-Slave 클러스터**:
  - **MySQL Master**: 주요 데이터베이스로서 모든 쓰기 작업을 처리합니다.
  - **MySQL Slave**: 읽기 전용으로 마스터에서 데이터를 복제하여 고가용성을 보장합니다.

- **Redis**:
  - 캐시 시스템으로 자주 조회되는 데이터를 저장하여 성능을 최적화합니다.

- **Elasticsearch & Logstash**:
  - **Elasticsearch**는 빠른 검색을 위한 인덱싱을 처리하며, **Logstash**는 데이터를 수집하여 Elasticsearch로 전달합니다.
  - **Logstash**는 `backend` 모듈이 실행될 때 함께 사용됩니다.

---

## 🔧 Docker 실행 방법

### 1. **Backend 및 Logstash 실행 (루트 Docker Compose 사용)**

`backend` 모듈을 실행할 때, **Logstash**와 **루트의 docker-compose.yml** 파일을 사용하여 설정된 서비스를 실행합니다:

```bash
# Backend와 Logstash 실행
docker-compose up -d
```

### 2. **Elasticsearch 실행 (개별 실행)**

Elasticsearch는 `docker/elasticsearch/docker-compose.yml` 파일을 통해 실행됩니다.

```bash
# Elasticsearch 실행
docker-compose -f docker/elasticsearch/docker-compose.yml up -d
```

### 3. **Logstash 실행 (개별 실행)**

Logstash는 `docker/logstash/docker-compose.yml` 파일을 통해 실행됩니다.

```bash
# Logstash 실행
docker-compose -f docker/logstash/docker-compose.yml up -d
```
---


## ⚡ 성능 최적화 및 테스트

프로젝트를 진행하면서 성능 최적화를 위해 다양한 기술을 도입하고, 성능 테스트를 통해 그 효과를 평가했습니다.

### 1. **CQRS 패턴 도입**
- 시스템의 읽기와 쓰기 작업을 분리하여 최적화했습니다:
    - **읽기 작업**은 전문 검색의 경우 Elasticsearch를 사용하고, 일반 조회는 MySQL Slave 서버에서 처리하여 높은 성능을 유지했습니다.
    - **쓰기 작업**은 MySQL Master 서버에서 처리하여 데이터의 일관성과 안정성을 유지했습니다.

### 2. **Redis 캐싱 및 데이터베이스 인덱싱**
- **Redis 캐싱**을 통해 자주 조회되는 데이터를 메모리에 저장함으로써 데이터베이스의 부하를 줄이고, 응답 속도를 크게 개선했습니다.
- 데이터베이스에 적절한 **인덱스**를 설정하여 대량의 데이터를 효율적으로 조회할 수 있도록 성능을 최적화했습니다.

### 3. **성능 테스트 및 개선 결과**
성능 테스트는 **K6**를 사용하여 다양한 부하 조건에서 API의 응답 시간과 안정성을 검증했습니다. 로컬 환경에서 테스트가 진행되었으며, 테스트 결과를 통해 성능 최적화를 평가하였습니다.

- **부하 테스트 시나리오**:
    - 단계별로 가상 사용자(VU)를 1,000명까지 증가시키고, 유지한 후 감소시키는 시나리오를 통해 API의 응답 성능을 평가했습니다.
    - 95%의 요청이 500ms 이내에 완료되고, 에러율이 1% 미만으로 유지되는 목표를 설정했습니다.
  
- **개선 전 성능**:
    - 평균 요청 처리 시간: 2,111.32ms (약 2.1초)
    - 최대 요청 처리 시간: 7,212.85ms (약 7.2초)
    - 상위 90% 요청 시간: 4,471.06ms (약 4.5초)
    - 상위 95% 요청 시간: 4,903.62ms (약 4.9초)

- **개선 후 성능**:
    - 평균 요청 처리 시간: 593.86ms
    - 최대 요청 처리 시간: 1,145ms (약 1.1초)
    - 상위 90% 요청 시간: 987.14ms (약 1초)
    - 상위 95% 요청 시간: 1,415.96ms (약 1.4초)

성능 개선을 통해 평균 요청 처리 시간을 2.1초에서 0.6초로, 최대 요청 처리 시간을 7.2초에서 1.1초로 단축하여 전반적인 성능을 크게 향상시켰습니다.

---

## 트러블슈팅 (Troubleshooting)

### 문제 1: MySQL Master-Slave 클러스터 장애 발생 시 서비스 중단
**해결 방법**: 
- Master-Slave 클러스터링을 통해 Master 서버에 장애가 발생할 경우, Slave 서버가 자동으로 Master 역할을 대체하여 서비스의 연속성을 유지할 수 있습니다.

### 문제 2: Redis 노드 장애 발생
**해결 방법**: 
- Redis에서 Master 노드 3대를 구성하여 각각이 서로의 Slave 역할을 수행하도록 설정합니다. 또한, AOF(Append-Only File)를 사용해 모든 쓰기 작업을 기록하고, 장애 시 데이터 복구가 가능하도록 보장합니다.

### 문제 3: 서버 중단 시 데이터 손실 가능성
**해결 방법**: 
- Redis에서 AOF를 사용하여 예상치 못한 서버 중단이 발생하더라도 데이터 일관성을 유지하며 빠르게 복구할 수 있습니다.

### 문제 4: 성능 최적화를 위해 읽기와 쓰기 분리
**해결 방법**: 
- CQRS 패턴을 도입하여 시스템의 읽기와 쓰기 작업을 분리하여 성능을 최적화합니다. 읽기 작업은 Elasticsearch와 MySQL Slave에서, 쓰기 작업은 MySQL Master에서 처리하도록 설계합니다.

### 문제 5: 데이터 수집 시 복구 불가능한 오류 발생
**해결 방법**: 
- 수집된 데이터를 MySQL에 저장하고, Logstash를 사용하여 Elasticsearch에 인덱싱하는 방식을 채택했습니다. 이 방법을 통해 Elasticsearch 장애 시에도 데이터를 복구할 수 있도록 설계되었습니다.

### 문제 6: 데이터 수집 및 Elasticsearch 장애 시 복구 문제
**해결 방법**:
- 외부 API와 뉴스 크롤링을 통해 수집한 데이터를 먼저 MySQL에 저장한 후, Logstash를 사용하여 Elasticsearch에 인덱싱하는 방식을 채택했습니다. 
- 이 방식은 MySQL을 중간 저장소로 활용하여 데이터 안전성을 확보하고, Elasticsearch 장애 시에도 데이터를 복구할 수 있는 장점을 제공합니다.

#### 최종 전략:
1. **MySQL 사용**: 
    - MySQL을 중간 저장소로 사용하여 안정적으로 데이터를 저장하고 복구할 수 있습니다.
2. **Logstash를 통한 실시간 데이터 처리**: 
    - Logstash는 데이터를 실시간으로 처리하여 Elasticsearch에 전달하며, 장애가 발생할 경우에도 Persistent Queue(PQ) 기능을 통해 데이터 유실 없이 복구할 수 있습니다.
3. **애플리케이션 로그 파일 기반 수집**: 
    - 로그 파일을 통해 데이터 수집이 안정적으로 이루어지며, 로그 파일을 통해 장애 발생 시 데이터를 복구할 수 있는 구조를 설계하였습니다.

최종적으로, 애플리케이션 로그 파일 저장 -> Logstash (Persistent Queue 사용) -> Elasticsearch 구조를 통해 시스템 안정성과 데이터 복구 기능을 강화했습니다.
