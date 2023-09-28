#include <Wire.h>
#include <SoftwareSerial.h>
// #include "HX711.h"

SoftwareSerial bluetooth(12, 13);  // RX, TX for Bluetooth

const int buttonPin = 4;
const int ledPin = 5;
const float height = 170.0;          // 키 상수 입력
const long THRESHOLD_VALUE = 20000;  //20kg을 그램 단위로 변

bool flag = false;

// HX711 scale;

void setup() {
  Serial.begin(9600);
  bluetooth.begin(9600);

  // scale.begin(A1, A0);  // 로드셀 핀 (DT, SCK)
  pinMode(buttonPin, INPUT_PULLUP);
  pinMode(ledPin, OUTPUT);
}

void loop() {
  // long weight = scale.read();

  // float heightMeters = height / 100.0;
  // float bmi = weight / (heightMeters * heightMeters);

  // Serial.print("Weight: ");
  // Serial.print(weight);
  // Serial.print(", BMI: ");
  // Serial.println(bmi);
  // delay(1000);

  // bluetooth.write("Weight: ");
  // bluetooth.write(weight);
  // bluetooth.print(", BMI: ");
  // bluetooth.println(bmi);

  // 무게가 일정 임계값 이상인 경우 메시지를 전송합니다.
  // if (weight >= THRESHOLD_VALUE) {
  //   bluetooth.println("start");
  // }

  if (digitalRead(buttonPin) == HIGH) {
    digitalWrite(ledPin, HIGH);  // LED를 켭니다.

    // "위험합니다" 메시지를 마스터 보드로 전송합니다.
    if (flag) {
      flag = false;
      Serial.print("e");
      Serial.println(0);
      bluetooth.print("e");
      bluetooth.println(0);
    }
    else {
      flag = true;
      Serial.print("e");
      Serial.println(1);
      bluetooth.print("e");
      bluetooth.println(1);
    }
    

    delay(1000);                // 버튼 디바운싱을 위한 짧은 지연
    digitalWrite(ledPin, LOW);  // LED를 끕니다.
  }
}
