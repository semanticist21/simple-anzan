#!/bin/bash

# Flutter 앱의 디버그 심볼 업로드 스크립트
# Google Play Console에 네이티브 크래시 분석을 위한 심볼 업로드

echo "=== Flutter 디버그 심볼 준비 및 업로드 가이드 ==="
echo ""
echo "1. AAB 빌드 (이미 완료된 경우 건너뛰기):"
echo "   flutter build appbundle --release"
echo ""
echo "2. 디버그 심볼 위치 확인:"
echo "   심볼 파일들은 다음 위치에 생성됩니다:"
echo "   - build/app/intermediates/stripped_native_libs/release/out/lib/"
echo "   - build/app/intermediates/merged_native_libs/release/out/lib/"
echo ""
echo "3. 심볼 파일 압축:"
echo "   다음 명령어로 심볼 파일을 압축합니다:"
echo ""

# 심볼 파일 압축 명령
echo "cd android/app/build/intermediates/stripped_native_libs/release/out/"
echo "zip -r symbols.zip lib/"
echo ""
echo "또는 merged_native_libs 사용:"
echo "cd android/app/build/intermediates/merged_native_libs/release/out/"
echo "zip -r symbols.zip lib/"
echo ""
echo "4. Google Play Console에 업로드:"
echo "   a. Google Play Console 접속"
echo "   b. 앱 선택"
echo "   c. 왼쪽 메뉴에서 '출시 > 앱 번들 탐색기' 선택"
echo "   d. 업로드한 AAB 버전 선택"
echo "   e. '다운로드' 탭 선택"
echo "   f. '네이티브 디버그 심볼 업로드' 클릭"
echo "   g. symbols.zip 파일 업로드"
echo ""
echo "5. 자동 업로드 설정 (선택사항):"
echo "   build.gradle에 다음 추가:"
echo "   android {"
echo "       buildTypes {"
echo "           release {"
echo "               ndk {"
echo "                   debugSymbolLevel 'FULL' // 또는 'SYMBOL_TABLE'"
echo "               }"
echo "           }"
echo "       }"
echo "   }"
echo ""
echo "참고: 현재 build.gradle에는 이미 'SYMBOL_TABLE'이 설정되어 있습니다."
echo "AAB를 다시 빌드하면 심볼이 자동으로 포함됩니다."
echo ""
echo "=== 심볼 파일 확인 ==="

# 심볼 파일 존재 확인
if [ -d "android/app/build/intermediates/stripped_native_libs/release/out/lib" ]; then
    echo "✅ stripped_native_libs 디렉토리 발견:"
    ls -la android/app/build/intermediates/stripped_native_libs/release/out/lib/
elif [ -d "android/app/build/intermediates/merged_native_libs/release/out/lib" ]; then
    echo "✅ merged_native_libs 디렉토리 발견:"
    ls -la android/app/build/intermediates/merged_native_libs/release/out/lib/
else
    echo "❌ 심볼 파일을 찾을 수 없습니다."
    echo "   먼저 'flutter build appbundle --release'를 실행하세요."
fi

echo ""
echo "=== Play Console CLI 사용 (선택사항) ==="
echo "Google Play Console API를 사용하여 자동 업로드도 가능합니다:"
echo "https://developers.google.com/android-publisher/api-ref/rest/v3/edits.bundles"