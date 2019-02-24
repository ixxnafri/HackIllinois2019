// This-->tab == "functions.h"

// Expose Espressif SDK functionality
extern "C" {
#include "user_interface.h"
  typedef void (*freedom_outside_cb_t)(uint8 status);
  int  wifi_register_send_pkt_freedom_cb(freedom_outside_cb_t cb);
  void wifi_unregister_send_pkt_freedom_cb(void);
  int  wifi_send_pkt_freedom(uint8 *buf, int len, bool sys_seq);
}

#include <ESP8266WiFi.h>
#include <tuple>
#include <vector>
#include "./structures.h"

#define MAX_APS_TRACKED 100
#define MAX_CLIENTS_TRACKED 200

beaconinfo aps_known[MAX_APS_TRACKED];                    // Array to save MACs of known APs
int aps_known_count = 0;                                  // Number of known APs
int nothing_new = 0;
// clientinfo clients_known[MAX_CLIENTS_TRACKED];            // Array to save MACs of known CLIENTs
std::vector<std::pair<clientinfo, unsigned long>> clients_known;
volatile int clients_known_count = 0;                              // Number of known CLIENTs

void print_client(clientinfo ci);

int register_beacon(beaconinfo beacon)
{
  int known = 0;   // Clear known flag
  for (int u = 0; u < aps_known_count; u++)
  {
    if (! memcmp(aps_known[u].bssid, beacon.bssid, ETH_MAC_LEN)) {
      known = 1;
      break;
    }   // AP known => Set known flag
  }
  if (! known)  // AP is NEW, copy MAC to array and return it
  {
    memcpy(&aps_known[aps_known_count], &beacon, sizeof(beacon));
    aps_known_count++;

    if ((unsigned int) aps_known_count >=
        sizeof (aps_known) / sizeof (aps_known[0]) ) {
      //Serial.printf("exceeded max aps_known\n");
      aps_known_count = 0;
    }
  }
  return known;
}

int register_client(clientinfo ci)
{
  int known = 0;   // Clear known flag
  std::pair<clientinfo, unsigned long> replace_pair;
  int u = 0;
  while(u < clients_known_count){
    if (! memcmp(clients_known[u].first.station, ci.station, ETH_MAC_LEN)) {
      replace_pair = std::make_pair(ci, millis());
      clients_known[u].swap(replace_pair);
      known = 1;
    }else{
      if((millis() - clients_known[u].second) > 30000){
        //Serial.printf("Removed device: ");
        //print_client(ci);
        clients_known.erase(clients_known.begin() + u);
        clients_known_count--;
        u--;
        Serial.printf("%d", clients_known_count);
      }
    }
    u++;
  }

  if (! known)
  {
    clientinfo new_client;
    memcpy(&new_client, &ci, sizeof(ci));
    //memcpy(&clients_known[clients_known_count], &ci, sizeof(ci));
    std::pair<clientinfo, unsigned long> new_pair(new_client, millis());
    clients_known_count++;
    clients_known.push_back(new_pair);

    //if ((unsigned int) clients_known_count >=
    //    sizeof (clients_known) / sizeof (clients_known[0]) ) {
    //  Serial.printf("exceeded max clients_known\n");
    //  clients_known_count = 0;
    //}
  }

  if(clients_known_count != clients_known.size()) Serial.printf("Count not equals vector size.\n");
    
  return known;
}

void print_beacon(beaconinfo beacon)
{
  if (beacon.err != 0) {
    //Serial.printf("BEACON ERR: (%d)  ", beacon.err);
  } else {
    Serial.printf("BEACON: <=============== [%32s]  ", beacon.ssid);
    for (int i = 0; i < 6; i++) Serial.printf("%02x", beacon.bssid[i]);
    Serial.printf("   %2d", beacon.channel);
    Serial.printf("   %4d\r\n", beacon.rssi);
  }
}

void print_client(clientinfo ci)
{
  int u = 0;
  int known = 0;   // Clear known flag
  if (ci.err != 0) {
    // nothing
  } else {
    Serial.printf("DEVICE: ");
    for (int i = 0; i < 6; i++) {Serial.printf("%02x", ci.station[i]);
    }
    Serial.printf(" ==> ");

    for (u = 0; u < aps_known_count; u++)
    {
      if (! memcmp(aps_known[u].bssid, ci.bssid, ETH_MAC_LEN)) {
        Serial.printf("[%32s]", aps_known[u].ssid);
        known = 1;     // AP known => Set known flag
        break;
      }
    }
   
    if (! known)  {
      Serial.printf("   Unknown/Malformed packet \r\n");
      //  for (int i = 0; i < 6; i++) Serial.printf("%02x", ci.bssid[i]);
    } else {
      Serial.printf("%2s", " ");
      for (int i = 0; i < 6; i++) Serial.printf("%02x", ci.ap[i]);
      Serial.printf("  %3d", aps_known[u].channel);
      Serial.printf("   %4d\r\n", ci.rssi);
    }
    
   }
}

void promisc_cb(uint8_t *buf, uint16_t len)
{
  int i = 0;
  uint16_t seq_n_new = 0;
  if (len == 12) {
    struct RxControl *sniffer = (struct RxControl*) buf;
  } else if (len == 128) {
    struct sniffer_buf2 *sniffer = (struct sniffer_buf2*) buf;
    struct beaconinfo beacon = parse_beacon(sniffer->buf, 112, sniffer->rx_ctrl.rssi);
    if (register_beacon(beacon) == 0) {
      //print_beacon(beacon);
      nothing_new = 0;
    }
  } else {
    struct sniffer_buf *sniffer = (struct sniffer_buf*) buf;
    //Is data or QOS?
    if ((sniffer->buf[0] == 0x08) || (sniffer->buf[0] == 0x88)) {
      struct clientinfo ci = parse_data(sniffer->buf, 36, sniffer->rx_ctrl.rssi, sniffer->rx_ctrl.channel);
      if (memcmp(ci.bssid, ci.station, ETH_MAC_LEN)) {
        if (register_client(ci) == 0) {
          Serial.printf("%d", clients_known_count); 
          //print_client(ci);
          nothing_new = 0;
        }
      }
    }
  }
}
