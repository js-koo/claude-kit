# build-my-claude - Handoff

## Goal
`/handoff` 명령어를 read/write 서브커맨드로 분리하고 축약 명령어 `/ho` 추가

## Context
Claude Code CLI의 세션 핸드오프 기능을 개선하여, 세션 종료 시 handoff 문서 생성(write)과 새 세션에서 이어서 작업(read)을 명확히 분리하는 작업

## Done
- `commands/handoff.md` 수정 - read/write 서브커맨드 구조로 변경
- `commands/ho.md` 신규 생성 - `/ho w`, `/ho r` 축약 명령어
- `install.sh` 수정 - ho.md symlink 추가, 설치 메시지 업데이트
- `README.md` 수정 - 명령어 테이블 및 문서 업데이트
- 삭제 후 재설치 테스트 완료 - symlink 정상 생성 확인

## Learned
### What Worked
- `/worktree.md`와 동일한 서브커맨드 패턴 사용
- install.sh의 for loop에 `ho` 추가하는 간단한 방식

### What Didn't Work
- `/ho` 명령어가 "Unknown skill: ho"로 인식되지 않음 - Claude Code가 새 skill을 인식하지 못하는 것으로 보임

## Next
1. `/ho` 명령어가 인식되지 않는 문제 조사 및 해결
2. `/handoff` 인자 없이 실행 시 usage 안내가 나오도록 확인 (현재는 기존 로직 실행)
3. `/handoff read`, `/handoff write` 실제 동작 테스트

## Key Files
- `commands/handoff.md` - read/write 서브커맨드 정의
- `commands/ho.md` - 축약 명령어 정의
- `install.sh` - symlink 생성 스크립트
- `README.md` - 사용자 문서
