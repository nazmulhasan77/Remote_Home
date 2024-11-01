#include <ESP8266WiFi.h>
#include <ESP8266Firebase.h>
#include <ArduinoJson.h>

// Switch pin
const int switch1Pin = 5;  // D1
const int switch2Pin = 4;  // D2

// Switch state
bool switch1State = false;
bool switch2State = false;
bool preState1 = false;
bool preState2 = false;

// Output pin
const int out1 = 0;     // D3 
const int out2 = 14;     // D5

// LED pin
const int WIFI_LED = 2;     // D4

const char* ssid = "home_wifi";
const char* pass = "";

// #define ref_url "https://testesp8266-12b0e-default-rtdb.asia-southeast1.firebasedatabase.app/"
#define ref_url "https://testesp8266-1427e-default-rtdb.firebaseio.com/"

Firebase firebase(ref_url);

String path1 = "data/switch1";
String path2 = "data/switch2";
String status = "connect_status";

// Define pin state
volatile bool state1 = false;
volatile bool state2 = false;

bool isChanged = false;

void IRAM_ATTR btn1() {
    state1 = true;
    // Serial.println("Btn 1 pressed");
}
void IRAM_ATTR btn2() {
    state2 = true;
    // Serial.println("Btn 2 pressed");
}

// JSON CAPACITY
const size_t capacity = JSON_OBJECT_SIZE(2) + 50;

void setup() {
    Serial.begin(115200);

    // Switch PinMode
    pinMode(switch1Pin, INPUT_PULLUP);
    pinMode(switch2Pin, INPUT_PULLUP);

    // Pin attach
    attachInterrupt(digitalPinToInterrupt(switch1Pin), btn1, FALLING);
    attachInterrupt(digitalPinToInterrupt(switch2Pin), btn2, FALLING);

    // Output pinMode
    pinMode(out1, OUTPUT);
    pinMode(out2, OUTPUT);

    // LED pinMode
    pinMode(WIFI_LED, OUTPUT);

    digitalWrite(WIFI_LED, HIGH);

    connect_wifi();

    delay(2000);

    // firebase.setInt(status, 1);
}

void loop() {
    // bool newSwitch1State = digitalRead(switch1Pin) == LOW;
    // bool newSwitch2State = digitalRead(switch2Pin) == LOW;
    // connect_wifi();
    // if(WiFi.status() != WL_CONNECTED){
    //     digitalWrite(WIFI_LED, HIGH);
    // }
    // else{
    //     digitalWrite(WIFI_LED, LOW);
    // }

    // if(WiFi.status() != WL_CONNECTED){
    //     digitalWrite(WIFI_LED, HIGH);
    //     connect_wifi();
    // }


    switch_handle();
    output_handle();
    firebase_uploader();
    isChanged = false;
    firebase_data_fetch();

    if(WiFi.status() != WL_CONNECTED){
        digitalWrite(WIFI_LED, HIGH);
        WiFi.mode(WIFI_OFF);
        delay(100);
        WiFi.mode(WIFI_STA);

        WiFi.begin(ssid, pass);

        Serial.println("Connecting to wifi");

        Serial.println();
        Serial.print("Connected to: "); Serial.println(ssid);
        Serial.print("IP: "); Serial.println(WiFi.localIP());
    
        if(WiFi.status() == WL_CONNECTED) {
            digitalWrite(WIFI_LED, LOW);
        }
    }
}

// Firebase data fetch
void firebase_data_fetch() {
    if(WiFi.status() != WL_CONNECTED) return;

    firebase.json(true);

    String data = firebase.getString("data");

    // Capacity space

    DynamicJsonDocument doc(capacity);

    deserializeJson(doc, data);

    switch1State = (bool)(doc["switch1"]);
    switch2State = (bool)(doc["switch2"]);

    if(preState1 != switch1State) isChanged = true;
    if(preState2 != switch2State) isChanged = true;

    preState1 = switch1State;
    preState2 = switch2State;

    Serial.println(switch1State);
    Serial.println(switch2State);

    delay(10);
}

void connect_wifi() {
    WiFi.mode(WIFI_OFF);
    delay(1000);
    WiFi.mode(WIFI_STA);

    WiFi.begin(ssid, pass);

    Serial.println("Connecting to wifi");
    while(WiFi.status() != WL_CONNECTED) {
        static int cnt = 0;
        cnt++;
        if(cnt >= 20) return;
        delay(1000);
        Serial.print(".");
    }


    Serial.println();
    Serial.print("Connected to: "); Serial.println(ssid);
    Serial.print("IP: "); Serial.println(WiFi.localIP());
    if(WiFi.status() == WL_CONNECTED)
        digitalWrite(WIFI_LED, LOW);
}

// Firebase uploader
void firebase_uploader() {
    if(WiFi.status() != WL_CONNECTED) return;
    if(!isChanged) return;
    if(switch1State) {
        firebase.setInt(path1, (int)1);
    } else {
        firebase.setInt(path1, (int)0);
    }
    if(switch2State) {
        firebase.setInt(path2, (int)1);
    } else {
        firebase.setInt(path2, (int)0);
    }
}

// Output handle
void output_handle() {
    if(!isChanged) return;
    if(switch1State) {
        digitalWrite(out1, HIGH);
    } else {
        digitalWrite(out1, LOW);
    }
    if(switch2State) {
        digitalWrite(out2, HIGH);
    } else {
        digitalWrite(out2, LOW);
    }
}

// Switch handle
void switch_handle() {

    if(state1 == true){
        switch1State = !switch1State;
        state1 = false;
        state2 = false;
        isChanged = true;

        digitalWrite(out1, switch1State);

        Serial.print("Switch 1: "); Serial.println(switch1State);
        delay(500);
    }

    if(state2 == true){
        switch2State = !switch2State;
        state1 = false;
        state2 = false;
        isChanged = true;

        digitalWrite(out2, switch2State);

        Serial.print("Switch 2: "); Serial.println(switch2State);
        delay(500);
    }
    // if (!digitalRead(switch1Pin)) {
    //     switch1State = !switch1State;
    //     // Firebase.setBool(firebaseData, "/switch1", switch1State);
    //     firebase.setInt(path1, switch1State);
    //     Serial.println("Switch 1 updated in Firebase.");
    //     Serial.print("Switch 1: "); Serial.println(switch1State);
    //     delay(300);
    // }

    // if (!digitalRead(switch2Pin)) {
    //     switch2State = !switch2State;
    //     // Firebase.setBool(firebaseData, "/switch2", switch2State);
    //     firebase.setInt(path2, switch2State);
    //     Serial.println("Switch 2 updated in Firebase.");
    //     Serial.print("Switch 2: "); Serial.println(switch2State);
    //     delay(300);
    // }
}
