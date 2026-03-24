# Session Service

첫 실행 감지, 설치 날짜 기록, 세션 카운트를 관리하는 서비스입니다.

## 위치

`lib/domain/session/session_service.dart`

## 주요 기능

| 메서드 | 설명 |
|--------|------|
| `isFirstLaunch()` | 앱 최초 실행 여부 확인 |
| `markAlreadyLaunched()` | 최초 실행 플래그 해제 |
| `saveInstallDateIfNeeded()` | 설치 날짜 기록 (최초 1회) |
| `getInstallDate()` | 설치 날짜 조회 |
| `recordColdStart()` | 콜드 스타트 시 세션 카운트 증가 |
| `recordResumeIfNeeded()` | 백그라운드 복귀 시 일정 시간 경과 후 세션 카운트 증가 |
| `getCount()` / `setCount()` | 세션 카운트 조회/설정 |
| `reset()` | 모든 세션 데이터 초기화 |

## 사용법

### DI 등록 (이미 설정됨)

```dart
// dependencies.dart
getIt.registerSingleton<SessionService>(SessionService());
```

### App 위젯에서 라이프사이클 연동

```dart
class _AppState extends State<App> with WidgetsBindingObserver {
  final _sessionService = GetIt.instance<SessionService>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _sessionService.recordColdStart();
    _sessionService.saveInstallDateIfNeeded();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _sessionService.recordResumeIfNeeded();
    }
  }
}
```

### 세션 갭 임계값 커스터마이징

기본값은 24시간이며, 생성자에서 변경 가능합니다:

```dart
SessionService(sessionGapThreshold: const Duration(hours: 6))
```

## 저장소

`SharedPreferences`를 사용하며 다음 키를 사용합니다:

- `first_launch` — 최초 실행 여부
- `install_date` — 설치 날짜 (ISO8601)
- `session_count` — 누적 세션 수
- `last_session_timestamp` — 마지막 세션 시간 (밀리초)
