#include <SoftwareSerial.h>

SoftwareSerial bluetooth(2, 3);

void setup() 
{
  Serial.begin(9600);   //시리얼모니터
  bluetooth.begin(9600); //블루투스 시리얼
}
void loop()
{
  if (bluetooth.available()) {       
    Serial.write(bluetooth.read());  //블루투스측 내용을 시리얼모니터에 출력
  }
  if (Serial.available()) {         
    bluetooth.write(Serial.read());  //시리얼 모니터 내용을 블루추스 측에 WRITE
  }

  //bluetooth.write(97);

  //delay(1000);

}

