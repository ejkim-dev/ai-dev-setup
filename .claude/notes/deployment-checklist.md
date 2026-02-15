# 첫 배포(v1.0.0) 체크리스트

## 🔒 배포 전 필수 작업

### 1. Branch Protection 설정 ⚠️
**현재 상태**: 미설정
**해야 할 일**:
```
GitHub → Settings → Branches → Add rule

설정 항목:
✅ Require a pull request before merging
✅ Do not allow bypassing the above settings
✅ Allow force pushes: 비활성화
✅ Allow deletions: 비활성화
```

**이유**: main 브랜치 보호, 실수로 force push나 삭제 방지

---

### 2. 최종 테스트
- [ ] macOS 전체 설치 플로우 테스트
- [ ] Phase 1 → Phase 2 전환 테스트
- [ ] 3개 언어 모두 테스트 (en, ko, ja)
- [ ] install.sh (curl | bash) 테스트
- [ ] UI/UX 체크 스크립트 실행
  ```bash
  /check-ui
  ```

---

### 3. 문서 최종 검토
- [ ] README.md 버전 정보 업데이트
- [ ] README.ko.md 동기화
- [ ] CHANGELOG.md 작성
- [ ] 스크린샷 최신화

---

### 4. Release 준비
- [ ] 버전 태그 생성: `v1.0.0`
  ```bash
  git tag -a v1.0.0 -m "Release v1.0.0"
  git push origin v1.0.0
  ```
- [ ] GitHub Release 페이지 작성
  - Release notes
  - Installation 가이드 링크
  - What's new

---

### 5. 설치 스크립트 검증
- [ ] install.sh URL 확인
  ```bash
  curl -fsSL https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/install.sh | bash
  ```
- [ ] 깨끗한 환경에서 테스트 (VM 또는 새 Mac)

---

## 📅 배포 시점

**조건**:
- [ ] 모든 주요 기능 완성
- [ ] 버그 수정 완료
- [ ] 문서 완성
- [ ] 테스트 통과

**예상 체크 항목**:
- Phase 1: 기본 환경 설정 ✅
- Phase 2: Claude Code 설정 ✅
- MCP 서버 다중 선택 ✅
- UI/UX 통일성 ✅
- 3개 언어 지원 ✅

---

## 🚨 배포 전 리마인더

**Claude가 자동으로 상기시킬 항목**:
1. ⚠️ **Branch protection 설정** (가장 중요!)
2. 테스트 실행 확인
3. 문서 최종 검토
4. Release notes 작성

---

## 📝 Notes

- 배포는 main 브랜치에서만
- 태그는 semantic versioning (v1.0.0)
- Release notes는 사용자 관점에서 작성
