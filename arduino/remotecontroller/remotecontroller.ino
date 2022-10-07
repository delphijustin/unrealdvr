#include <IRLibSendBase.h>
#include <IRLib_HashRaw.h>
#define IRFREQ 36//this should remain 36
/*
 * set each RAW_DATA_LENx to the correct length
 * next set the raw data arrays to the same value from serial monitor rawRecv.ino
 * Default Device A is Panasonic DVD Recordder DMR-ES15 Remote controller
 * Default Device B is Mediacom remote controller
 */

//Begin Device A
//Type A to use device A or B for device B
//Press the 0 or send a byte to the serial port to skip this button

#define RAW_DATA_LEN0A 100
 uint16_t rawData0A[RAW_DATA_LEN0A]={
                                        3390, 1746, 450, 414, 450, 1266, 450, 414,
        450, 414, 450, 414, 454, 414, 450, 414,
                                                        450, 414, 450, 414, 450, 414, 450, 414,
                        454, 410, 454, 414, 450, 1262, 454, 382,
                                                                        482, 414, 450, 378, 486, 414, 450, 414,
                                        450, 382, 482, 1266, 450, 1266, 450, 378,
        486, 1262, 450, 382, 486, 386, 478, 414,
                                                        450, 414, 450, 386, 478, 382, 482, 418,
                        450, 410, 454, 1262, 450, 414, 450, 414,
                                                                        450, 1266, 450, 1266, 418, 446, 418, 446,
                                        418, 446, 418, 1298, 418, 446, 418, 446,
        418, 1298, 418, 446, 418, 1298, 418, 446,
                                                        418, 1298, 446, 1000};
//Press the 1 or send a byte to the serial port to skip this button

#define RAW_DATA_LEN1A 100
 uint16_t rawData1A[RAW_DATA_LEN1A]={
                                        3390, 1742, 454, 378, 486, 1262, 454, 378,
        486, 374, 490, 426, 438, 426, 438, 426,
                                                        438, 426, 438, 426, 438, 382, 486, 182,
                        682, 378, 486, 382, 482, 186, 34, 1046,
                                                                        450, 422, 442, 422, 442, 426, 438, 378,
                                        482, 430, 438, 422, 442, 1262, 454, 1262,
        450, 382, 482, 1266, 450, 378, 486, 382,
                                                        482, 378, 486, 426, 438, 426, 438, 426,
                        438, 426, 438, 426, 442, 378, 486, 378,
                                                                        482, 382, 486, 426, 438, 1266, 446, 426,
                                        438, 434, 434, 422, 442, 426, 438, 426,
                                                                               438, 430, 434, 382, 482, 430, 434, 1266,
                                                450, 430, 434, 1000};
//Press the 2 or send a byte to the serial port to skip this button

#define RAW_DATA_LEN2A 100
 uint16_t rawData2A[RAW_DATA_LEN2A]={
                                        3386, 1746, 450, 378, 486, 1266, 450, 378,
        486, 378, 486, 382, 482, 426, 442, 426,
                                                        438, 382, 482, 182, 682, 426, 442, 430,
                        434, 426, 438, 374, 490, 1266, 450, 426,
                                                                        438, 378, 486, 378, 486, 382, 482, 382,
                                        486, 374, 486, 1266, 450, 1266, 450, 422,
        442, 1266, 450, 378, 486, 426, 438, 430,
                                                        434, 430, 438, 426, 438, 378, 486, 430,
                        434, 382, 482, 1266, 450, 378, 486, 426,
                                                                        438, 426, 442, 1262, 450, 382, 482, 430,
                                        438, 426, 434, 1270, 450, 426, 438, 426,
        438, 430, 434, 402, 462, 1266, 450, 386,
                                                        478, 1266, 450, 1000};
//Press the 3 or send a byte to the serial port to skip this button

#define RAW_DATA_LEN3A 100
 uint16_t rawData3A[RAW_DATA_LEN3A]={
                                        3366, 1770, 414, 442, 422, 1298, 422, 386,
        474, 398, 442, 474, 414, 446, 422, 442,
                                                        422, 438, 426, 438, 454, 342, 470, 454,
                        410, 474, 390, 474, 390, 1326, 414, 442,
                                                                        394, 478, 414, 446, 394, 450, 418, 470,
                                        418, 442, 422, 1298, 390, 1326, 418, 438,
        394, 1330, 410, 442, 426, 442, 422, 402,
                                                        438, 474, 390, 478, 386, 478, 390, 474,
                        410, 402, 466, 442, 422, 1298, 386, 478,
                                                                        390, 478, 386, 1330, 386, 474, 390, 474,
                                        390, 474, 418, 470, 370, 1322, 390, 498,
        394, 446, 442, 390, 422, 1330, 386, 454,
                                                        434, 1302, 414, 1000};
//Press the 4 or send a byte to the serial port to skip this button

#define RAW_DATA_LEN4A 100
 uint16_t rawData4A[RAW_DATA_LEN4A]={
                                        3390, 1742, 450, 426, 442, 1262, 450, 378,
        486, 426, 442, 422, 438, 426, 442, 374,
                                                        490, 422, 442, 426, 438, 426, 438, 426,
                        442, 374, 490, 422, 442, 1262, 450, 382,
                                                                        486, 378, 486, 378, 486, 426, 438, 374,
                                        490, 426, 438, 1266, 450, 1266, 450, 426,
        438, 1262, 454, 378, 486, 426, 438, 382,
                                                        482, 382, 482, 430, 434, 430, 434, 434,
                        434, 430, 430, 1266, 454, 1262, 450, 430,
                                                                        434, 430, 434, 1266, 450, 434, 430, 434,
                                        406, 466, 422, 1266, 446, 1270, 426, 466,
        422, 438, 426, 394, 466, 1270, 446, 390,
                                                        478, 1262, 450, 1000};
//Press the 5 or send a byte to the serial port to skip this button

#define RAW_DATA_LEN5A 100
 uint16_t rawData5A[RAW_DATA_LEN5A]={
                                        3386, 1750, 386, 478, 414, 1298, 418, 438,
        398, 478, 410, 406, 438, 474, 386, 454,
                                                        446, 438, 394, 478, 386, 478, 386, 482,
                        414, 438, 398, 470, 394, 1326, 406, 414,
                                                                        458, 442, 394, 454, 438, 446, 394, 474,
                                        390, 474, 390, 1326, 390, 1326, 386, 478,
        386, 1326, 414, 442, 398, 478, 410, 450,
                                                        390, 478, 410, 410, 458, 446, 418, 446,
                        418, 450, 414, 454, 410, 474, 366, 1330,
                                                                        410, 446, 390, 1354, 362, 502, 362, 502,
                                        362, 502, 390, 454, 410, 474, 366, 1330,
        406, 458, 410, 474, 390, 1326, 386, 454,
                                                        410, 1326, 390, 1000};
//Press the 6 or send a byte to the serial port to skip this button

#define RAW_DATA_LEN6A 100
 uint16_t rawData6A[RAW_DATA_LEN6A]={
                                        3390, 1746, 450, 414, 418, 1294, 418, 450,
        418, 446, 418, 446, 418, 446, 418, 446,
                                                        418, 450, 414, 450, 418, 446, 418, 446,
                        418, 446, 418, 446, 418, 1298, 418, 446,
                                                                        418, 446, 418, 450, 414, 450, 414, 450,
                                        418, 446, 418, 1294, 422, 1294, 418, 446,
        418, 1298, 418, 446, 418, 446, 418, 446,
                                                        418, 446, 418, 450, 414, 450, 414, 450,
                        418, 446, 418, 1294, 422, 446, 414, 1298,
                                                                        418, 446, 418, 1298, 450, 414, 418, 446,
                                        418, 446, 418, 1298, 418, 446, 418, 1294,
        422, 446, 418, 446, 418, 1294, 418, 450,
                                                        418, 1294, 422, 1000};
//Press the 7 or send a byte to the serial port to skip this button

#define RAW_DATA_LEN7A 100
 uint16_t rawData7A[RAW_DATA_LEN7A]={
                                        3382, 1746, 430, 458, 406, 1286, 430, 458,
        406, 462, 426, 414, 446, 382, 462, 462,
                                                        426, 426, 438, 426, 442, 422, 414, 430,
                        438, 462, 426, 378, 486, 1262, 450, 382,
                                                                        486, 426, 438, 382, 482, 426, 438, 426,
                                        414, 426, 462, 1266, 450, 1266, 426, 426,
        462, 1262, 426, 434, 434, 462, 402, 462,
                                                        426, 426, 438, 426, 438, 430, 434, 426,
                        418, 426, 462, 422, 418, 1286, 422, 1294,
                                                                        418, 470, 426, 1266, 426, 462, 426, 426,
                                        438, 426, 414, 462, 402, 1290, 426, 1290,
        422, 466, 402, 462, 402, 1286, 454, 426,
                                                        434, 1266, 450, 1000};
//Press the 8 or send a byte to the serial port to skip this button

#define RAW_DATA_LEN8A 100
 uint16_t rawData8A[RAW_DATA_LEN8A]={
                                        3386, 1742, 478, 374, 466, 1262, 450, 426,
        442, 378, 486, 374, 490, 430, 434, 378,
                                                        486, 426, 438, 426, 442, 422, 442, 378,
                        486, 382, 482, 426, 438, 1266, 450, 382,
                                                                        482, 426, 438, 382, 482, 386, 482, 382,
                                        482, 426, 438, 1262, 450, 1270, 446, 430,
        438, 1262, 450, 430, 438, 378, 486, 426,
                                                        438, 378, 486, 386, 478, 430, 414, 458,
                        426, 430, 438, 1262, 450, 1266, 450, 1266,
                                                                        450, 426, 438, 1262, 454, 426, 438, 426,
                                        438, 426, 414, 1290, 450, 1266, 450, 1262,
        454, 426, 438, 426, 438, 1262, 454, 426,
                                                        438, 1266, 446, 1000};
//Press the 9 or send a byte to the serial port to skip this button

#define RAW_DATA_LEN9A 100
 uint16_t rawData9A[RAW_DATA_LEN9A]={
                                        3390, 1746, 450, 414, 418, 1298, 450, 414,
        418, 446, 418, 446, 418, 446, 422, 442,
                                                        418, 450, 414, 450, 414, 450, 418, 446,
                        418, 446, 418, 446, 418, 1298, 418, 446,
                                                                        418, 446, 418, 446, 418, 446, 418, 450,
                                        414, 450, 414, 1298, 418, 1298, 418, 442,
        422, 1298, 414, 446, 454, 382, 482, 378,
                                                        486, 382, 482, 386, 482, 386, 478, 414,
                        450, 382, 482, 382, 482, 414, 450, 418,
                                                                        446, 1266, 418, 1298, 418, 446, 418, 446,
                                        418, 446, 418, 450, 414, 450, 414, 450,
                                                                               414, 1298, 418, 450, 414, 1298, 418, 446,
                                                418, 1298, 418, 1000};
//Press the POWER or send a byte to the serial port to skip this button

#define RAW_DATA_LENPOWERA 100
 uint16_t rawDataPOWERA[RAW_DATA_LENPOWERA]={
                                                3386, 1746, 450, 382, 482, 1266, 450, 426,
                438, 426, 438, 382, 482, 382, 486, 378,
                                                                486, 426, 438, 378, 486, 386, 482, 378,
                                482, 378, 486, 426, 438, 1266, 454, 382,
                                                                               478, 430, 438, 426, 438, 426, 438, 382,
                                        482, 366, 498, 1266, 450, 1266, 450, 426,
        438, 1266, 450, 426, 438, 382, 482, 426,
                                                        442, 374, 490, 430, 434, 426, 438, 378,
                        486, 430, 434, 1266, 450, 378, 486, 1266,
                                                                        426, 1286, 418, 1298, 450, 1266, 426, 462,
                                        430, 374, 490, 1262, 446, 338, 534, 1262,
        418, 1294, 418, 446, 418, 450, 418, 446,
                                                        418, 1298, 418, 1000};
//Press the INFO or send a byte to the serial port to skip this button
#define RAW_DATA_LENEXITA 1
 uint16_t rawDataEXITA[1]={1000};
//Press the EXIT or send a byte to the serial port to skip this button
#define RAW_DATA_LENINFOA 1
 uint16_t rawDataINFOA[1]={1000};

//Press the Play or send a byte to the serial port to skip this button
#define RAW_DATA_LENPLAYA 100
 uint16_t rawDataPlayA[RAW_DATA_LENPLAYA]={
                                                3390, 1742, 454, 410, 418, 1298, 442, 398,
                442, 450, 414, 450, 414, 450, 418, 438,
                                                                426, 438, 458, 382, 450, 442, 458, 378,
                                454, 390, 450, 470, 430, 1286, 418, 438,
                                                                               438, 374, 518, 362, 474, 426, 466, 366,
                                        474, 418, 470, 1262, 418, 1298, 418, 434,
        466, 1262, 418, 438, 462, 370, 494, 318,
                                                        518, 426, 466, 374, 490, 318, 550, 374,
                        466, 418, 470, 370, 494, 1262, 418, 394,
                                                                        506, 1262, 418, 438, 458, 414, 422, 438,
                                        426, 438, 426, 446, 418, 1298, 414, 450,
        418, 1298, 414, 1298, 418, 1298, 418, 446,
                                                        418, 1298, 418, 1000};
//Press the Pause or send a byte to the serial port to skip this button
#define RAW_DATA_LENPAUSEA 100
 uint16_t rawDataPauseA[RAW_DATA_LENPAUSEA]={
                                                3390, 1742, 450, 430, 438, 1266, 450, 378,
                486, 422, 442, 426, 438, 426, 442, 422,
                                                                442, 426, 438, 378, 486, 426, 414, 430,
                                462, 426, 438, 378, 482, 1270, 450, 426,
                                                                               438, 426, 438, 426, 438, 426, 438, 382,
                                        490, 422, 438, 1262, 454, 1262, 450, 378,
        486, 1266, 450, 426, 438, 430, 434, 382,
                                                        486, 426, 434, 390, 454, 462, 426, 382,
                        482, 382, 486, 378, 486, 1262, 450, 1266,
                                                                        426, 462, 426, 434, 430, 434, 434, 434,
                                        406, 462, 426, 434, 430, 1266, 450, 1266,
        450, 390, 474, 1262, 418, 1298, 418, 446,
                                                        450, 1266, 418, 1000};
//Press the Record or send a byte to the serial port to skip this button

#define RAW_DATA_LENRECORDA 100
 uint16_t rawDataRecordA[RAW_DATA_LENRECORDA]={
                                                3386, 1746, 450, 422, 418, 1290, 450, 378,
                486, 422, 442, 422, 442, 426, 414, 462,
                                                                426, 426, 438, 382, 486, 422, 442, 426,
                                414, 430, 434, 462, 426, 1266, 450, 382,
                                                                               462, 458, 406, 426, 458, 430, 438, 426,
                                        414, 462, 402, 1290, 418, 1298, 450, 382,
        482, 1266, 450, 382, 482, 386, 454, 462,
                                                        430, 374, 466, 426, 438, 462, 402, 462,
                        426, 430, 434, 426, 438, 426, 438, 382,
                                                                        486, 1262, 454, 378, 486, 422, 442, 382,
                                        458, 462, 426, 430, 434, 430, 438, 426,
                                                                               438, 1262, 426, 1290, 450, 1266, 450, 382,
                                                458, 1290, 426, 1000};
//Press the Stop or send a byte to the serial port to skip this button

#define RAW_DATA_LENSTOPA 100
 uint16_t rawDataStopA[RAW_DATA_LENSTOPA]={
                                                3390, 1742, 454, 426, 462, 1242, 450, 426,
                438, 382, 482, 378, 486, 390, 478, 426,
                                                                438, 426, 438, 426, 442, 422, 438, 382,
                                486, 382, 482, 426, 414, 1290, 450, 382,
                                                                               482, 430, 438, 378, 486, 426, 438, 422,
                                        442, 426, 438, 1266, 450, 1266, 450, 426,
        438, 1266, 450, 378, 486, 382, 482, 426,
                                                        414, 466, 426, 426, 438, 426, 438, 426,
                        438, 430, 434, 430, 414, 462, 426, 434,
                                                                        430, 430, 410, 466, 422, 434, 430, 430,
                                        414, 462, 426, 382, 458, 462, 426, 394,
                                                                               470, 430, 434, 1266, 450, 1266, 450, 426,
                                                438, 1266, 450, 1000};
#define RAW_DATA_LENINPUTA 100
 uint16_t rawDataINPUTA[RAW_DATA_LENINPUTA]={
                                        3394, 1746, 450, 422, 442, 1266, 450, 426,
        442, 378, 486, 426, 438, 378, 490, 382,
                                                        482, 382, 482, 426, 438, 430, 438, 382,
                        482, 426, 442, 378, 486, 1266, 450, 378,
                                                                        486, 426, 442, 422, 442, 382, 482, 374,
                                        490, 378, 486, 1266, 454, 1262, 450, 426,
        438, 1266, 454, 422, 442, 426, 438, 382,
                                                        482, 382, 486, 378, 486, 378, 486, 382,
                        482, 426, 442, 426, 438, 378, 486, 426,
                                                                        438, 426, 438, 1266, 454, 426, 438, 1266,
                                        450, 382, 482, 402, 462, 430, 438, 426,
                                                                               438, 382, 482, 426, 438, 1266, 450, 1266,
                                                450, 1266, 450, 1000};
//Press the 1 or send a byte to the serial port to skip this button
//End Device A

//Begin Device B
#define RAW_DATA_LEN0B 36
 uint16_t rawData0B[RAW_DATA_LEN0B]={
                                        8978, 4478, 502, 2230, 502, 2222, 502, 2250,
                                                                                        482, 2222, 506, 2242, 486, 2222, 502, 2226,
        502, 2246, 478, 2230, 498, 2230, 498, 2230,
                                                        502, 2226, 502, 2226, 498, 2230, 498, 2230,
                                                                                                        498, 2230, 498,1000};

#define RAW_DATA_LEN1B 36
 uint16_t rawData1B[RAW_DATA_LEN1B]={
                                        8946, 4510, 414, 4586, 422, 2306, 422, 2334,
                                                                                        394, 2306, 426, 2302, 418, 2334, 394, 2310,
        418, 2310, 398, 2326, 430, 2298, 438, 2290,
                                                        422, 2306, 422, 4562, 422, 4562, 422, 4562,
                                                                                                        418, 4566, 398, 1000};

#define RAW_DATA_LEN2B 36
 uint16_t rawData2B[RAW_DATA_LEN2B]={
                                        8926, 4530, 454, 2274, 454, 4530, 454, 2274,
                                                                                        454, 2274, 450, 2278, 450, 2278, 450, 2278,
        450, 2278, 450, 2278, 450, 2278, 450, 2274,
                                                        454, 2274, 454, 2274, 454, 4530, 454, 4530,
                                                                                                        454, 4510, 470, 1000};
#define RAW_DATA_LEN3B 36
 uint16_t rawData3B[RAW_DATA_LEN3B]={
                                        8910, 4562, 422, 4562, 398, 4586, 398, 2326,
                                                                                        402, 2354, 394, 2334, 394, 2334, 374, 2330,
        398, 2326, 422, 2306, 398, 2330, 398, 2330,
                                                        426, 2326, 398, 4558, 402, 2330, 418, 4562,
                                                                                                        402, 4582, 422, 1000};
#define RAW_DATA_LEN4B 36
 uint16_t rawData4B[RAW_DATA_LEN4B]={
                                        8942, 4514, 438, 2310, 414, 2338, 394, 4562,
                                                                                        418, 2334, 398, 2330, 394, 2334, 394, 2334,
        394, 2290, 438, 2334, 470, 2258, 470, 2258,
                                                        394, 2330, 398, 2306, 422, 2330, 398, 4586,
                                                                                                        394, 4590, 394, 1000};
#define RAW_DATA_LEN5B 36
 uint16_t rawData5B[RAW_DATA_LEN5B]={
                                        8942, 4514, 438, 4550, 410, 2330, 434, 4530,
                                                                                        442, 2306, 418, 2306, 426, 2306, 426, 2298,
        422, 2306, 430, 2298, 430, 2298, 422, 2306,
                                                        430, 2298, 422, 4562, 430, 4550, 430, 2298,
                                                                                                        430, 4538, 442, 1000};
#define RAW_DATA_LEN6B 36
 uint16_t rawData6B[RAW_DATA_LEN6B]={
                                        8978, 4494, 422, 2306, 422, 4558, 426, 4558,
                                                                                        422, 2306, 422, 2306, 426, 2302, 426, 2302,
        426, 2302, 422, 2302, 430, 2298, 430, 2298,
                                                        426, 2302, 426, 2302, 426, 4558, 450, 2278,
                                                                                                        450, 4534, 450, 1000};
#define RAW_DATA_LEN7B 36
 uint16_t rawData7B[RAW_DATA_LEN7B]={
                                        8942, 4530, 430, 4578, 394, 4590, 394, 4562,
                                                                                        422, 2306, 422, 2306, 430, 2322, 394, 2310,
        422, 2306, 398, 2354, 394, 2310, 418, 2306,
                                                        422, 2306, 430, 4554, 418, 2310, 398, 2330,
                                                                                                        454, 4530, 418, 1000};

#define RAW_DATA_LEN8B 36
 uint16_t rawData8B[RAW_DATA_LEN8B]={
                                        8942, 4510, 442, 2330, 394, 2334, 398, 2306,
                                                                                        398, 4582, 422, 2306, 398, 2330, 398, 2330,
        454, 2274, 398, 2330, 422, 2330, 398, 2302,
                                                        422, 2306, 422, 2310, 418, 2306, 422, 2306,
                                                                                                        422, 4558, 426, 1000};
#define RAW_DATA_LEN9B 36
 uint16_t rawData9B[RAW_DATA_LEN9B]={
                                        8946, 4526, 454, 4530, 454, 2274, 454, 2274,
                                                                                        454, 4530, 450, 2274, 454, 2274, 454, 2274,
        454, 2274, 454, 2274, 454, 2274, 450, 2278,
                                                        450, 2278, 450, 4530, 454, 4530, 454, 4530,
        
                                                                                                        450, 2278, 450, 1000};
#define RAW_DATA_LENPOWERB 36
 uint16_t rawDataPOWERB[RAW_DATA_LENPOWERB]={
                                        8986, 4486, 502, 2250, 478, 4490, 498, 2254,
        478, 4486, 502, 2234, 498, 2226, 502, 2234,
                                                        498, 2230, 502, 2230, 498, 2230, 502, 2230,
                        498, 2234, 498, 2234, 498, 4486, 446, 4542,
                                                         506, 2226, 502, 1000};
                                                       
#define RAW_DATA_LENPLAYB 1
 uint16_t rawDataPlayB[RAW_DATA_LENPLAYB]={
  1000
};
#define RAW_DATA_LENPAUSEB 1
 uint16_t rawDataPauseB[RAW_DATA_LENPLAYB]={
  1000
};
#define RAW_DATA_LENSTOPB 1
 uint16_t rawDataStopB[RAW_DATA_LENSTOPB]={
  1000
};

#define RAW_DATA_LENRECORDB 1
 uint16_t rawDataRecordB[RAW_DATA_LENRECORDB]={
  1000
};

#define RAW_DATA_LENINPUTB 1
 uint16_t rawDataINPUTB[RAW_DATA_LENINPUTB]={
  1000
};
#define RAW_DATA_LENINFOB 36
 uint16_t rawDataINFOB[RAW_DATA_LENINFOB]={
                                        8926, 4546, 450, 4538, 450, 4562, 426, 2282,
        450, 2282, 450, 4538, 450, 4538, 450, 2302,
                                                        430, 2278, 450, 2282, 450, 2282, 450, 2302,
                        426, 2282, 450, 2282, 446, 4542, 450, 2282,
                                                                        446, 4538, 454, 1000};

#define RAW_DATA_LENEXITB 36
 uint16_t rawDataEXITB[RAW_DATA_LENEXITB]={
                                        8950, 4518, 474, 2258, 470, 4538, 450, 2282,
        450, 2282, 450, 4518, 470, 2258, 470, 2282,
                                                        426, 2306, 450, 2282, 446, 2282, 450, 2282,
                        450, 2278, 454, 4538, 450, 2278, 450, 4522,
                                                                        466, 4542, 450, 1000};
//End Device B
//The next two lines define the enable pins on the NAND Gate
#define DEV_A 4
#define DEV_B 5
                                                                     
IRsendRaw mySender;
 String userInput;
 byte SelDev=255;
void setup() {
  SelDev=255;
  pinMode(DEV_A,OUTPUT);
  pinMode(DEV_B,OUTPUT);
  Serial.begin(9600);
   delay(2000); 
 Serial.println(F("Welcome"));
}
byte CharToDigit(char c){
byte x=(byte)c;
if(!isDigit(c)){
  return 10;//If is not a digit return a non single digit number
}
return x-0x30;
}
void SendDigitA(byte digit){
  
/*
  digitalWrite(DEV_A,HIGH);
  digitalWrite(DEV_B,LOW);
  switch(digit){
    
case 0:mySender.send(rawData0A,RAW_DATA_LEN0A,IRFREQ);
break;
case 1:mySender.send(rawData1A,RAW_DATA_LEN1A,IRFREQ);
break;
case 2:mySender.send(rawData2A,RAW_DATA_LEN2A,IRFREQ);
break;
case 3:mySender.send(rawData3A,RAW_DATA_LEN3A,IRFREQ);
break;
case 4:mySender.send(rawData4A,RAW_DATA_LEN4A,IRFREQ);
break;
case 5:mySender.send(rawData5A,RAW_DATA_LEN5A,IRFREQ);
break;
case 6:mySender.send(rawData6A,RAW_DATA_LEN6A,IRFREQ);
break;
case 7:mySender.send(rawData7A,RAW_DATA_LEN7A,IRFREQ);
break;
case 8:mySender.send(rawData8A,RAW_DATA_LEN8A,IRFREQ);
break;
case 9:mySender.send(rawData9A,RAW_DATA_LEN9A,IRFREQ);
break;
  }
  digitalWrite(DEV_A,LOW);
  */
}
void SendDigitb(byte digit){
  digitalWrite(DEV_A,LOW);
  digitalWrite(DEV_B,HIGH);
  switch(digit){
case 0:mySender.send(rawData0B,RAW_DATA_LEN0B,IRFREQ);
break;
case 1:mySender.send(rawData1B,RAW_DATA_LEN1B,IRFREQ);
break;
case 2:mySender.send(rawData2B,RAW_DATA_LEN2B,IRFREQ);
break;
case 3:mySender.send(rawData3B,RAW_DATA_LEN3B,IRFREQ);
break;
case 4:mySender.send(rawData4B,RAW_DATA_LEN4B,IRFREQ);
break;
case 5:mySender.send(rawData5B,RAW_DATA_LEN5B,IRFREQ);
break;
case 6:mySender.send(rawData6B,RAW_DATA_LEN6B,IRFREQ);
break;
case 7:mySender.send(rawData7B,RAW_DATA_LEN7B,IRFREQ);
break;
case 8:mySender.send(rawData8B,RAW_DATA_LEN8B,IRFREQ);
break;
case 9:mySender.send(rawData9B,RAW_DATA_LEN9B,IRFREQ);
break;
}
digitalWrite(DEV_B,LOW);
}

void RecvA(String userInput){
  unsigned int timeout;//pause between each digit sent
    for(int I=0;I<userInput.length();I++){
    byte dig = CharToDigit(userInput.charAt(I));
    if(dig<10){
      SendDigitb(dig);
if(userInput.length()>2){
  timeout=750;
}else{timeout=1000;}
      delay(timeout);
    }
  }
  if(userInput=="power"){
    digitalWrite(DEV_A,HIGH);
  mySender.send(rawDataPOWERA,RAW_DATA_LENPOWERA,IRFREQ);
Serial.println(F("Power signal sent"));
}
if(userInput=="play"){
    digitalWrite(DEV_A,HIGH);
  mySender.send(rawDataPlayA,RAW_DATA_LENPLAYA,IRFREQ);
Serial.println(F("Play signal sent"));
}
if(userInput=="pause"){

/*
   digitalWrite(DEV_A,HIGH);
  mySender.send(rawDataPauseA,RAW_DATA_LENPAUSEA,IRFREQ);
Serial.println(F("Pause signal sent"));
*/
}/*
if(userInput=="record"){
    digitalWrite(DEV_A,HIGH);
  mySender.send(rawDataRecordA,RAW_DATA_LENRECORDA,IRFREQ);
Serial.println(F("Record signal sent"));
}
if(userInput=="input"){
    digitalWrite(DEV_A,HIGH);
  mySender.send(rawDataINPUTA,RAW_DATA_LENINPUTA,IRFREQ);
Serial.println(F("Input signal sent"));
}
if(userInput=="stop"){
    digitalWrite(DEV_A,HIGH);
  mySender.send(rawDataStopA,RAW_DATA_LENSTOPA,IRFREQ);
Serial.println(F("Stop signal sent"));
}
if(userInput=="info"){
  digitalWrite(DEV_A,HIGH);
  mySender.send(rawDataINFOA,RAW_DATA_LENINFOA,IRFREQ);
  Serial.println(F("Info signal sent"));
}
if(userInput=="exit"){
  digitalWrite(DEV_A,HIGH);
  mySender.send(rawDataEXITA,RAW_DATA_LENEXITA,IRFREQ);
  Serial.println(F("Exit signal sent"));
}*/
Serial.println(F("DONE"));
  }
void RecvB(String userInput){
  unsigned int timeout;//pause between each digit sent
    for(int I=0;I<userInput.length();I++){
    byte dig = CharToDigit(userInput.charAt(I));
    if(dig<10){
      SendDigitb(dig);
if(userInput.length()>2){
  timeout=750;
}else{timeout=1000;}
      delay(timeout);
    }
  }
  if(userInput=="power"){
    digitalWrite(DEV_B,HIGH);
  mySender.send(rawDataPOWERB,RAW_DATA_LENPOWERB,IRFREQ);
Serial.println(F("Power signal sent"));
}
if(userInput=="play"){
    digitalWrite(DEV_B,HIGH);
  mySender.send(rawDataPlayB,RAW_DATA_LENPLAYB,IRFREQ);
Serial.println(F("Play signal sent"));
}
if(userInput=="pause"){
    digitalWrite(DEV_B,HIGH);
  mySender.send(rawDataPauseB,RAW_DATA_LENPAUSEB,IRFREQ);
Serial.println(F("Pause signal sent"));
}
if(userInput=="record"){
    digitalWrite(DEV_B,HIGH);
  mySender.send(rawDataRecordB,RAW_DATA_LENRECORDB,IRFREQ);
Serial.println(F("Record signal sent"));
}
if(userInput=="input"){
    digitalWrite(DEV_B,HIGH);
  mySender.send(rawDataINPUTB,RAW_DATA_LENINPUTB,IRFREQ);
Serial.println(F("Input signal sent"));
}
if(userInput=="stop"){
    digitalWrite(DEV_B,HIGH);
  mySender.send(rawDataStopB,RAW_DATA_LENSTOPB,IRFREQ);
Serial.println(F("Stop signal sent"));
}
if(userInput=="info"){
  digitalWrite(DEV_B,HIGH);
  mySender.send(rawDataINFOB,RAW_DATA_LENINFOB,IRFREQ);
  Serial.println(F("Info signal sent"));
}
if(userInput=="exit"){
  digitalWrite(DEV_B,HIGH);
  mySender.send(rawDataEXITB,RAW_DATA_LENEXITB,IRFREQ);
  Serial.println(F("Exit signal sent"));
}
Serial.println(F("DONE"));
  }
void serialEvent(){
  digitalWrite(DEV_A,LOW);
  digitalWrite(DEV_B,LOW);
  String data=Serial.readString();

  for(int I=0;I<data.length();I++){
  if(isAlphaNumeric(data.charAt(I))){
    userInput+=data.charAt(I);
  }}userInput.toLowerCase();
if(data.indexOf((char)13)>-1||data.indexOf((char)10)>-1){
 if(userInput=="dev"){
SelDev=255;
userInput="";
 }
  switch(SelDev){
    case 255:
    if(userInput=="A"||userInput=="a"){
      SelDev=DEV_A;Serial.println(F("Device A is Selected"));
      userInput="";
      return;
    }
    if(userInput=="B"||userInput=="b"){
      SelDev=DEV_B;Serial.println(F("Device B is Selected"));
      userInput="";
      return;
    }
    Serial.println(F("Please choose Device A or B"));return;
    case DEV_B:RecvB(userInput);userInput="";return;
    case DEV_A:RecvA(userInput);userInput="";return;
  }
}
}

void loop() {
/*
 * The loop function isn't used because the serial port reading
 * is done in the serialEvent function.
 */
}
