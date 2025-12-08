# 🍰 Cake - 베이커리 관리 서비스

베이커리 정보를 관리하고, 메뉴를 등록하며, 사용자들이 좋아하는 베이커리를 즐겨찾기하고 방문 이야기를 기록할 수 있는 웹 애플리케이션입니다.

## 주요 기능

### 사용자 기능
- **회원가입/로그인** - 이메일 기반 인증 시스템
- **프로필 관리** - 프로필 이미지 업로드 및 비밀번호 변경
- **베이커리 탐색** - 등록된 베이커리 목록 조회 및 상세 정보 확인
- **즐겨찾기** - 마음에 드는 베이커리를 즐겨찾기에 추가
- **이야기 작성** - 즐겨찾기한 베이커리에 방문 기록 및 후기 작성

### 관리자 기능
- **베이커리 등록/수정/삭제** - 베이커리 정보 CRUD
- **메뉴 관리** - 각 베이커리의 메뉴 항목 관리
- **사용자 관리** - 전체 사용자 목록 조회 및 관리자 권한 부여

## 기술 스택

- **Framework**: Ruby on Rails 8.0.2
- **Database**: SQLite3
- **CSS**: Tailwind CSS 4.x
- **JavaScript**: Hotwire (Turbo + Stimulus)
- **Image Storage**: Cloudflare Images
- **Authentication**: has_secure_password (bcrypt)

## 시작하기

### 요구 사항

- Ruby 3.2+
- Node.js 18+
- SQLite3

### 설치

1. **저장소 클론**
   ```bash
   git clone <repository-url>
   cd cake
   ```

2. **의존성 설치**
   ```bash
   bundle install
   ```

3. **환경 변수 설정**

   `.env` 파일을 생성하고 Cloudflare Images 설정을 추가합니다:
   ```env
   CLOUDFLARE_ACCOUNT_ID="your_account_id"
   CLOUDFLARE_IMAGE_TOKEN="your_api_token"
   CLOUDFLARE_IMAGE_HASH_KEY="your_hash_key"
   ```

4. **데이터베이스 설정**
   ```bash
   bin/rails db:create
   bin/rails db:migrate
   bin/rails db:seed  # (선택) 샘플 데이터 로드
   ```

5. **서버 실행**
   ```bash
   bin/dev
   ```

   브라우저에서 `http://localhost:3000` 접속

### 관리자 계정 설정

최초 관리자 계정은 `/admin_setup` 경로에서 설정할 수 있습니다.

## 개발 명령어

### 서버 실행
```bash
bin/dev              # Rails 서버 + Tailwind CSS 워치 모드
bin/rails server     # Rails 서버만 실행
```

### 테스트
```bash
bin/rails test                    # 전체 테스트 실행
bin/rails test:all                # 시스템 테스트 포함
bin/rails test test/models/       # 특정 디렉토리 테스트
```

### 코드 품질
```bash
bin/rubocop          # 코드 스타일 검사
bin/rubocop -a       # 자동 수정
bin/brakeman         # 보안 취약점 검사
```

### 데이터베이스
```bash
bin/rails db:migrate        # 마이그레이션 실행
bin/rails db:rollback       # 마이그레이션 롤백
bin/rails db:seed           # 시드 데이터 로드
```

## 프로젝트 구조

```
app/
├── controllers/
│   ├── admin/              # 관리자 컨트롤러
│   ├── bakeries_controller.rb
│   ├── favorites_controller.rb
│   ├── menu_items_controller.rb
│   ├── notes_controller.rb
│   └── ...
├── models/
│   ├── concerns/
│   │   └── cloudflare_imageable.rb  # 이미지 업로드 concern
│   ├── bakery.rb
│   ├── menu_item.rb
│   ├── note.rb
│   ├── user.rb
│   └── favorite.rb
├── services/
│   └── cloudflare_images_service.rb  # Cloudflare API 서비스
└── views/
    ├── bakeries/
    ├── favorites/
    ├── notes/
    └── ...
```

## 모델 관계

```
User
├── has_many :favorites
├── has_many :favorite_bakeries (through: favorites)
└── has_many :notes

Bakery
├── has_many :menu_items
├── has_many :favorites
├── has_many :favorited_by_users (through: favorites)
└── has_many :notes

MenuItem
└── belongs_to :bakery

Note
├── belongs_to :user
└── belongs_to :bakery

Favorite
├── belongs_to :user
└── belongs_to :bakery
```

## 배포

Docker를 사용한 배포가 지원됩니다:

```bash
docker build -t cake .
docker run -p 3000:3000 cake
```

Kamal을 사용한 배포:
```bash
kamal setup
kamal deploy
```

## 라이선스

MIT License
