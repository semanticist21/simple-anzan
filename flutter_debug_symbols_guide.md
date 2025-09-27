# Flutter 디버그 심볼 경고 해결 가이드

Google Play Console에서 "디버그 기호가 업로드되지 않았습니다" 경고가 나타나는 것은 Flutter 앱에서 매우 흔한 문제입니다.

## 경고가 나타나는 이유

1. **Flutter 특성**: Flutter는 네이티브 코드(C++)를 포함하므로 Android NDK 심볼이 필요
2. **AAB 번들링**: Android App Bundle(AAB) 생성 시 심볼이 자동 포함되지 않는 경우
3. **Gradle 설정**: `debugSymbolLevel` 설정이 부족하거나 잘못된 경우

## 해결 방법

### 1. build.gradle 수정 (완료)
```gradle
android {
    buildTypes {
        release {
            ndk {
                debugSymbolLevel 'FULL'  // SYMBOL_TABLE → FULL로 변경
            }
        }
    }
}
```

### 2. AAB 재빌드 및 업로드
```bash
# 기존 빌드 캐시 정리
flutter clean

# 의존성 재설치
flutter pub get

# Release AAB 빌드 (심볼 포함)
flutter build appbundle --release

# 생성된 AAB 위치
# build/app/outputs/bundle/release/app-release.aab
```

### 3. Google Play Console 업로드
- 새로 생성된 AAB를 Google Play Console에 업로드
- 이제 심볼이 AAB에 자동 포함됨

## 심볼 레벨 비교

| 레벨 | 설명 | AAB 크기 | Play Console 경고 |
|------|------|----------|------------------|
| `NONE` | 심볼 없음 | 최소 | ⚠️ 경고 발생 |
| `SYMBOL_TABLE` | 기본 심볼 | 보통 | ⚠️ 경고 가능 |
| `FULL` | 전체 심볼 | 증가 | ✅ 경고 없음 |

## 대안: 수동 심볼 업로드

기존 AAB에 대해서는 수동으로 심볼을 업로드할 수 있습니다:

1. **심볼 파일 위치 확인**:
   ```bash
   # AAB 빌드 후 심볼 파일 위치
   android/app/build/intermediates/merged_native_libs/release/out/lib/
   ```

2. **심볼 압축**:
   ```bash
   cd android/app/build/intermediates/merged_native_libs/release/out/
   zip -r symbols.zip lib/
   ```

3. **Play Console에서 업로드**:
   - 앱 번들 탐색기 → 버전 선택
   - 다운로드 탭 → "네이티브 디버그 심볼 업로드"

## Flutter 앱에서 흔한 이유

1. **NDK 의존성**: Flutter Engine이 C++로 작성되어 네이티브 심볼 필요
2. **플러그인**: 네이티브 Android 플러그인들도 심볼 필요
3. **AOT 컴파일**: Flutter의 Ahead-of-Time 컴파일 특성

## 권장사항

- **프로덕션**: `debugSymbolLevel 'FULL'` 사용 (크래시 분석에 최적)
- **개발/테스트**: `debugSymbolLevel 'SYMBOL_TABLE'` 사용 (빌드 속도 고려)
- **정기 업데이트**: Flutter/Gradle 버전 업데이트 시 설정 재확인

## 주의사항

- `FULL` 설정 시 AAB 크기가 약 10-20MB 증가할 수 있음
- 하지만 Play Console 경고 없이 상세한 크래시 리포트 확보 가능
- 사용자에게 전달되는 APK 크기는 변경되지 않음 (Play Store에서 최적화)

이제 다음 빌드부터는 Google Play Console에서 디버그 심볼 경고가 나타나지 않을 것입니다.