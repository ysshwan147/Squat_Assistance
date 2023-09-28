#
#include <SoftwareSerial.h>

SoftwareSerial BTSerial(2, 3);

const int xPin = A0;      // X축 핀
const int yPin = A1;      // Y축 핀
const int zPin = A2;      // Z축 핀

const int threshold = 200; // 가속도 상승/하강을 감지하는 임계값 (조정 필요)
int state = LOW;           // 현재 의자 상태 (상승/하강)
int lastState = LOW;       // 이전 의자 상태
int count = 0;             // 왕복 횟수 누적

float oldTime = 0.0f;
float currentTime = 0.0f;
float delayTime = 0.0f;

void setup() {
  Serial.begin(9600);
  BTSerial.begin(9600);
}

void loop() {

  // calculating deltaTime
  oldTime = currentTime;
  currentTime = millis();
  float deltaTime = currentTime - oldTime;

  int xValue = analogRead(xPin);
  int yValue = analogRead(yPin);
  int zValue = analogRead(zPin);

  // Z축 가속도 값 사용
  int acceleration = zValue-274; // 센터 값을 빼서 가속도 얻음

  // 움직임을 감지하고 가속도 값을 읽음
  if (abs(acceleration) >= threshold) {
    state = HIGH;
    Serial.print("Acceleration: ");
    Serial.println(acceleration);
  } else {
    state = LOW;
  }

  // 상태 변화를 감지하고 왕복 횟수 누적
  if (state != lastState) {
    if (state == HIGH) {
      count++; // 의자가 상승할 때
    }
    lastState = state;
    
    if (delayTime > 2000.0f){

      int exp = 0;
      int temp = count;
      while (true) {
        if (temp < 1) {
          break;
        }
        temp /= 10;
        exp += 1;
      }
      // 왕복 횟수를 시리얼 모니터에 출력
      Serial.print("Total Reciprocations: ");
      Serial.println(count);

      BTSerial.print("a");
      BTSerial.print(exp);
      BTSerial.println(count);

      delayTime = 0.0f;
    }


  }
  delayTime += deltaTime;
}
