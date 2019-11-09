/*
 * Ардуино Мега принимает данные по UART
 * на скорости 1200 бод. Если приходит
 * ключевой байт телевизора, проигрывается
 * код выкл/вкл на соответствующем выводе.
 */

#include <IRLibSendBase.h>
#include <IRLib_HashRaw.h>

#define TV14 22
#define TV1  24
#define TV2  26
#define TV3  28
#define TV4  30
#define TV5  32
#define TV6  34
#define TV7  36
#define TV8  38
#define TV9  40
#define TV10 42
#define TV11 44
#define TV12 46
#define TV13 48
#define TV15 50
#define TV16 52

int s_data; // serial data

IRsendRaw mySender;

void setup() {

    for (int i=0; i<16; i++)  {

        // не помню почему здесь строка.
        pinMode("TV1"+i, INPUT_PULLUP);

    }

    Serial.begin(1200);
    while(!Serial); // бесполезный код для меги. Но вдруг.

}

// samsung

/*#define RAW_DATA_LEN 68
uint16_t rawData[RAW_DATA_LEN]={
  4578, 4462, 366, 1882, 362, 1882, 366, 1882,
  362, 758, 306, 818, 314, 810, 306, 818,
  310, 814, 302, 1942, 330, 1918, 354, 1890,
  358, 766, 310, 814, 302, 822, 310, 838,
  278, 818, 310, 814, 302, 1942, 358, 766,
  310, 818, 298, 822, 310, 814, 302, 822,
  306, 814, 302, 1946, 354, 770, 306, 1938,
  362, 1886, 358, 1886, 362, 1886, 358, 1886,
  362, 1886, 358, 1000};

// thompson

#define RAW_DATA_LEN2 52
uint16_t rawData2[RAW_DATA_LEN2]={
  4046, 3942, 554, 1962, 542, 1970, 546, 1966,
  554, 1966, 550, 966, 550, 966, 550, 1966,
  538, 974, 542, 1974, 542, 974, 542, 1974,
  546, 974, 542, 974, 542, 974, 542, 974,
  554, 962, 554, 1962, 542, 1970, 546, 970,
  546, 1970, 550, 966, 550, 1966, 550, 962,
  542, 1978, 554, 1000};

*/

// hisense

#define RAW_DATA_LEN3 68
uint16_t rawData3[RAW_DATA_LEN3]={
  8998, 4434, 594, 522, 594, 522, 594, 522,
  598, 518, 598, 518, 598, 514, 602, 514,
  602, 514, 602, 1630, 602, 1630, 602, 1630,
  602, 1630, 602, 1630, 602, 1626, 594, 522,
  594, 1638, 598, 1634, 598, 518, 598, 1634,
  598, 1634, 598, 518, 598, 518, 598, 518,
  598, 518, 598, 514, 602, 1630, 602, 514,
  602, 514, 606, 1626, 606, 1622, 598, 1634,
  598, 1634, 598, 1000};


void loop() {
    s_data = Serial.read();

    switch(s_data)  {
        case '1':  send_shit(TV1); break;
        case '2':  send_shit(TV2); break;
        case '3':  send_shit(TV3); break;
        case '4':  send_shit(TV4); break;
        case '5':  send_shit(TV5); break;
        case '6':  send_shit(TV6); break;
        case '7':  send_shit(TV7); break;
        case '8':  send_shit(TV8); break;
        case '9':  send_shit(TV9); break;
        case ':':  send_shit(TV10); break;
        case ';':  send_shit(TV11); break;
        case '<':  send_shit(TV12); break;
        case '=':  send_shit(TV13); break;
        case '>':  send_shit(TV14); break;
        case '?':  send_shit(TV15); break;
        case '@':  send_shit(TV16); break;
        default: break;
    }

}


void send_shit(int _TV)  {
  pinMode(_TV, OUTPUT);
  digitalWrite(_TV, LOW);
    //mySender.send(rawData,RAW_DATA_LEN,36);
    //mySender.send(rawData2,RAW_DATA_LEN2,36);
    mySender.send(rawData3,RAW_DATA_LEN3,36);
  pinMode(_TV, INPUT_PULLUP);
}

