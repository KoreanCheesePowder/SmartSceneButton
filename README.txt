C.P WheelButton v1.0.2

기존 사용자 업데이트:
1. 압축을 새 폴더에 풀고 UPDATE-ONLY.cmd를 실행합니다.
2. 기존 설치 때 사용한 계정, 채널, 허브를 사용합니다.
3. 상세정보 또는 로그캣에서 v1.0.2을 확인한 뒤 버튼을 한 번 누릅니다.
4. 기존 디바이스와 루틴은 삭제하지 마세요. 재페어링하지 않습니다.

수정 내용:
- OnOff Toggle (cluster 0x0006, command 0x02) -> button.pushed
- 반복 누름에도 state_change=true 유지
- 기존 0xFD 누름, 0xFC 회전 처리 유지
- 프로필, 능력 ID, 화면 정의, packageKey 변경 없음
- src/init.lua와 templates/init.lua.template 동시 수정

한 번 누름 이벤트 전송 로그:
WheelButton v1.0.2 | OnOff.Toggle -> button=pushed | state_change=true

확인 범위:
로컬 Lua 모의 테스트와 기존 파일 비교로 검증합니다.
실제 허브, 앱 표시, 루틴 실행은 설치 후 확인해야 합니다.
장치 모드를 변경하는 명령은 추가하지 않았습니다.
새로운 패킷으로 전송되는 회전이나 다른 누름은 별도 확인이 필요합니다.

신규 설치용 SETUP-AND-INSTALL.cmd도 포함되어 있으나, 이번 업데이트에는 UPDATE-ONLY.cmd를 사용하세요.

제작자: 치즈가루
버전: v1.0.2
packageKey: cheesepowder.zigbee-tuya-button-knob
