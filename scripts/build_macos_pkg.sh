#!/bin/bash

# macOS App Store용 .pkg 파일 생성 스크립트
# 사용법: ./scripts/build_macos_pkg.sh

set -e  # 에러 발생 시 스크립트 중단

# 색상 정의
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 앱 이름 및 인증서 정보
APP_NAME="abacus_simple_anzan"
INSTALLER_CERT="3rd Party Mac Developer Installer: Jiwon Park (X6M5USK89L)"
BUILD_DIR="build/macos/Build/Products/Release"

echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}  macOS App Store .pkg 빌드 시작${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""

# 1. Flutter 릴리즈 빌드
echo -e "${YELLOW}[1/3] Flutter macOS 릴리즈 빌드 중...${NC}"
flutter build macos --release

if [ ! -f "${BUILD_DIR}/${APP_NAME}.app/Contents/MacOS/${APP_NAME}" ]; then
    echo -e "${RED}❌ 빌드 실패: .app 파일이 생성되지 않았습니다.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Flutter 빌드 완료${NC}"
echo ""

# 2. 인증서 확인
echo -e "${YELLOW}[2/3] 인증서 확인 중...${NC}"
if ! security find-identity -v -p basic | grep -q "3rd Party Mac Developer Installer"; then
    echo -e "${RED}❌ Mac Developer Installer 인증서를 찾을 수 없습니다.${NC}"
    echo -e "${RED}   Apple Developer 계정에서 인증서를 생성하고 설치해주세요.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ 인증서 확인 완료${NC}"
echo ""

# 3. .pkg 파일 생성
echo -e "${YELLOW}[3/3] .pkg 파일 생성 중...${NC}"
productbuild \
    --sign "${INSTALLER_CERT}" \
    --component "${BUILD_DIR}/${APP_NAME}.app" \
    /Applications \
    "${BUILD_DIR}/${APP_NAME}.pkg"

if [ ! -f "${BUILD_DIR}/${APP_NAME}.pkg" ]; then
    echo -e "${RED}❌ .pkg 파일 생성 실패${NC}"
    exit 1
fi

# 파일 정보 출력
PKG_SIZE=$(du -h "${BUILD_DIR}/${APP_NAME}.pkg" | cut -f1)

echo -e "${GREEN}✓ .pkg 파일 생성 완료${NC}"
echo ""
echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}  빌드 완료!${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""
echo -e "📦 파일 위치: ${BUILD_DIR}/${APP_NAME}.pkg"
echo -e "💾 파일 크기: ${PKG_SIZE}"
echo -e "✍️  서명: ${INSTALLER_CERT}"
echo ""
echo -e "${YELLOW}다음 단계:${NC}"
echo -e "1. Transporter 앱 열기"
echo -e "2. .pkg 파일 드래그 앤 드롭"
echo -e "3. 'Deliver' 버튼 클릭하여 App Store Connect에 업로드"
echo ""
