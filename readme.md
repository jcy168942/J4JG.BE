
# J4JG 플랫폼 (2024.7.15 ~ 2024.8.21)

**J4JG**는 취업 준비생을 위한 채용 정보 제공 및 멘토링 서비스를 제공하는 플랫폼입니다. 이 플랫폼은 외부 API 연동, 뉴스 크롤링, 멘토-멘티 매칭 기능을 통해 취업 준비생에게 유용한 정보를 제공합니다.
**핵사고널 아키텍처**를 적용하여 비즈니스 로직과 외부 시스템을 분리하였으며, **멀티 모듈 아키텍처**를 통해 모듈 간 독립성을 보장하였습니다. Docker를 활용한 각 모듈의 독립 실행과 캐싱, DB인덱스, AWS 배포 전략등을 통해 고가용성 및 성능 최적화를 달성하였습니다.

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
