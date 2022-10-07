/* rawR&cv.ino Example sketch for IRLib2
 *  Illustrate how to capture raw timing values for an unknow protocol.
 *  You will capture a signal using this sketch. It will output data the 
 *  serial monitor that you can cut and paste into the "rawSend.ino"
 *  sketch.
 *  
 *  Use this sketch to generate code for te
 */
// Recommend only use IRLibRecvPCI or IRLibRecvLoop for best results
#include <IRLibRecvPCI.h> 

IRrecvPCI myReceiver(2);//pin number for the receiver
byte Button;
String Device;
String data;
String Buttons(byte btn){
switch(btn){
case 0:return "0";
case 1:return "1";
case 2:return "2";
case 3:return "3";
case 4:return "4";
case 5:return "5";
case 6:return "6";
case 7:return "7";
case 8:return "8";
case 9:return "9";
case 10:return "POWER";
case 11:return "INFO";
case 12:return "EXIT";
case 13:return "Play";
case 14:return "Pause";
case 15:return "Record";
case 16:return "Stop";
}
return "N/A";
}
void setup() {
  Button=0;
  Device=".";
  Serial.begin(9600);
  delay(2000); while (!Serial); //delay for Leonardo
  myReceiver.enableIRIn(); // Start the receiver
  Serial.println(F("//Type A to use device A or B for device B"));
  
}
void PrintButton(){
  Serial.println("//Press the "+Buttons(Button)+" or send a byte to the serial port to skip this button");
}
void serialEvent(){
  data = Serial.readString();
  data.toLowerCase();
  if(Device=="."){
  if(data.startsWith("a")){Device="A";PrintButton();}
  if(data.startsWith("b")){Device="B";PrintButton();}
  return;
  }
  Button++; 
  if(Button>16){
  Serial.println(F("//Completed"));
  return;
  }
  String ucButton=Buttons(Button);ucButton.toUpperCase();
  Serial.println("#define RAW_DATA_LEN"+ucButton+Device+" 1");
  Serial.println("uint16_t rawData"+Buttons(Button)+Device+"[1]={1000};");
  PrintButton();
}
void loop() {
  //Continue looping until you get a complete signal received
if(Device=="."||Button>16){return;}
String ucButton=Buttons(Button);
ucButton.toUpperCase();
  if (myReceiver.getResults()) { 
    Serial.print("\n#define RAW_DATA_LEN"+ucButton+Device+" ");
    Serial.println(recvGlobal.recvLength,DEC);
    Serial.print("uint16_t rawData"+Buttons(Button)+Device+"[RAW_DATA_LEN"+ucButton+Device+"]={\n\t");
    for(bufIndex_t i=1;i<recvGlobal.recvLength;i++) {
      Serial.print(recvGlobal.recvBuffer[i],DEC);
      Serial.print(F(", "));
      if( (i % 8)==0) Serial.print(F("\n\t"));
    }
    Serial.println(F("1000};"));//Add arbitrary trailing space
    myReceiver.enableIRIn();      //Restart receiver
    Button++;
  if(Button>16){
  Serial.println(F("//Completed"));
  return;
  }
  PrintButton();
  }
}
