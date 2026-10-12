C.P WheelButton v1.0.4 - 휠 회전 기록 표시 보완

업데이트(기존 사용자는 이 방법만):
1. ZIP을 새 폴더에 완전히 압축 해제합니다.
2. 원래 설치한 PC에서 UPDATE-ONLY.cmd를 실행합니다.
3. 기존 장치를 삭제하거나 재페어링하지 않습니다. 기존 버튼 루틴도 그대로 둡니다.
4. SmartThings 앱의 드라이버 버전이 v1.0.4인지 확인합니다.
5. 오른쪽 2회/왼쪽 2회 회전 후 SmartThings '기록'에 이벤트가 나타나는지 확인합니다.
   기록 반영은 실시간이 아닐 수 있으니 최대 5~10분 기다린 뒤 새로고침합니다.

수정 사항:
- 기존 custom wheelAction (right/left) 이벤트는 유지하였습니다.
- 회전 시 표준 button(up=오른쪽 / down=왼쪽) 이벤트도 추가로 발행합니다.
- 표준 버튼 이벤트는 history 표시 요청(displayed=true), 반복 회전 강제 이벤트(state_change=true)로 보냅니다.
- Click/Double/Held 패킷 처리 및 기존 루틴의 이벤트 값은 변경하지 않았습니다.
- 기존 Capability ID, profile, fingerprint, packageKey는 그대로입니다.

주의 사항:
- SmartThings 기록에는 회전이 '버튼 위/아래'(앱 번역에 따라 다름)로 나올 수 있습니다.
- 회전 직후 기존 '버튼' 카드의 마지막 상태도 위/아래로 바뀔 수 있습니다.
- Wheel Action 카드에는 계속 '오른쪽 회전'/'왼쪽 회전'으로 표시됩니다.
- SmartThings 앱 자체의 custom capability 기록 표시는 이 드라이버가 직접 제어할 수 없습니다.
- 이전 기록은 소급 생성되지 않습니다.
- 실제 모바일 앱의 기록 표시 및 루틴 실행은 현장 확인이 필요합니다.
- 위/아래로 별도 표시하기 싫다면 롤백 시 v1.0.3으로 다시 패키징/설치하세요.

제작자: 치즈가루
버전: v1.0.4
packageKey: cheesepowder.zigbee-tuya-button-knob
