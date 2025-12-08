# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Rails 8.0.2 베이커리 관리 애플리케이션. 베이커리 정보, 메뉴, 즐겨찾기, 방문 이야기(노트) 기능을 제공하며, 한국어 UI를 사용합니다.

## Common Development Commands

```bash
# Development
bin/dev                                    # Rails + Tailwind CSS watch mode
bin/rails server                           # Rails server only

# Testing
bin/rails test                             # All tests except system tests
bin/rails test:all                         # Include system tests
bin/rails test test/models/user_test.rb:27 # Specific test by line number

# Code Quality
bin/rubocop -a                             # Auto-fix style violations
bin/brakeman                               # Security scanning

# Database
bin/rails db:migrate
bin/rails db:seed
```

## Architecture

### Image Storage (Cloudflare Images)

이미지는 Active Storage가 아닌 **Cloudflare Images**를 사용합니다.

```ruby
# app/models/concerns/cloudflare_imageable.rb - DSL 제공
class Bakery < ApplicationRecord
  include CloudflareImageable
  has_cloudflare_images :images, column: :cloudflare_image_ids  # 다중 이미지
end

class User < ApplicationRecord
  include CloudflareImageable
  has_cloudflare_image :profile_image, column: :cloudflare_profile_image_id  # 단일 이미지
end
```

- `CloudflareImagesService` (`app/services/`) - Cloudflare API 호출
- 환경 변수 필요: `CLOUDFLARE_ACCOUNT_ID`, `CLOUDFLARE_IMAGE_TOKEN`, `CLOUDFLARE_IMAGE_HASH_KEY`

### Authentication

Rails 8 기본 인증 생성기 기반:
- `has_secure_password` + 세션 쿠키
- `Current.user` - 현재 사용자 접근
- `Authentication` concern - 인증 헬퍼 메서드
- `user.admin?` - 관리자 권한 확인

### Core Models

```
User ─┬─ has_many :favorites ──── belongs_to :bakery
      ├─ has_many :notes ──────── belongs_to :bakery
      └─ has_many :favorite_bakeries (through: favorites)

Bakery ─┬─ has_many :menu_items
        ├─ has_many :favorites
        ├─ has_many :notes
        └─ operating_hours (JSON) - 요일별 영업시간
```

### Key Controllers

| Controller | Purpose |
|------------|---------|
| `SessionsController` | 로그인/로그아웃 |
| `RegistrationsController` | 회원가입 |
| `BakeriesController` | 베이커리 조회 |
| `FavoritesController` | 즐겨찾기 토글/목록 |
| `NotesController` | 방문 이야기 CRUD |
| `Admin::BakeriesController` | 베이커리 관리 (관리자) |
| `Admin::AdminController` | 대시보드, 사용자 관리 |

### Frontend

- **Tailwind CSS 4.x** - tailwindcss-rails gem
- **Hotwire** - Turbo (페이지 전환) + Stimulus (JS 컨트롤러)
- **Importmap** - JavaScript 모듈 로딩
- Turbo 환경에서는 `DOMContentLoaded` 대신 `turbo:load` 이벤트 사용

### Admin Setup

최초 관리자 계정은 `/admin_setup` 경로에서 생성합니다.
