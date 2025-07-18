#!/bin/bash

# WARNA
NC='\e[0m'
DEFBOLD='\e[39;1m'
RB='\e[31;1m'
GB='\e[32;1m'
YB='\e[33;1m'
BB='\e[34;1m'
MB='\e[35;1m'
WB='\e[37;1m'

# STATUS LAYANAN
xray_service=$(systemctl is-active xray)
nginx_service=$(systemctl is-active nginx)

status_xray="${RB}[ OFF ]${NC}"
[[ "$xray_service" == "active" ]] && status_xray="${GB}[ ON ]${NC}"

status_nginx="${RB}[ OFF ]${NC}"
[[ "$nginx_service" == "active" ]] && status_nginx="${GB}[ ON ]${NC}"

# INFORMASI SISTEM
dtoday=$(vnstat | grep today | awk '{print $2" "substr ($3, 1, 3)}')
utoday=$(vnstat | grep today | awk '{print $5" "substr ($6, 1, 3)}')
ttoday=$(vnstat | grep today | awk '{print $8" "substr ($9, 1, 3)}')

dmon=$(vnstat -m | grep `date +%G-%m` | awk '{print $2" "substr ($3, 1 ,3)}')
umon=$(vnstat -m | grep `date +%G-%m` | awk '{print $5" "substr ($6, 1 ,3)}')
tmon=$(vnstat -m | grep `date +%G-%m` | awk '{print $8" "substr ($9, 1 ,3)}')

domain=$(cat /usr/local/etc/xray/domain)
ISP=$(cat /usr/local/etc/xray/org)
CITY=$(cat /usr/local/etc/xray/city)
WKT=$(cat /usr/local/etc/xray/timezone)
DATE=$(date -R | cut -d " " -f -4)
MYIP=$(curl -sS ipv4.icanhazip.com)

clear
echo -e "${BB}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${WB}                    🛡️ BY RAKHA PUTRA ANDRIAN                 ${NC}"
echo -e "${BB}╚════════════════════════════════════════════════════════════╝${NC}"
echo -e " ${YB}• IP VPS          ${NC}: ${WB}$MYIP${NC}"
echo -e " ${YB}• ISP             ${NC}: ${WB}$ISP${NC}"
echo -e " ${YB}• Kota            ${NC}: ${WB}$CITY${NC}"
echo -e " ${YB}• Zona Waktu      ${NC}: ${WB}$WKT${NC}"
echo -e " ${YB}• Tanggal         ${NC}: ${WB}$DATE${NC}"
echo -e " ${YB}• Domain          ${NC}: ${WB}$domain${NC}"
echo -e "${BB}────────────────────────────────────────────────────────────${NC}"
echo -e " ${YB}• Status NGINX    ${NC}: $status_nginx     ${YB}• Status XRAY ${NC}: $status_xray"
echo -e "${BB}────────────────────────────────────────────────────────────${NC}"
echo -e "${WB}                📶 PEMANTAUAN BANDWIDTH (vnStat)            ${NC}"
echo -e "${BB}────────────────────────────────────────────────────────────${NC}"
echo -e " ${YB}• Hari Ini        ↓ $dtoday     ↑ $utoday     ≈ $ttoday${NC}"
echo -e " ${YB}• Bulan Ini       ↓ $dmon       ↑ $umon       ≈ $tmon${NC}"
echo -e "${BB}────────────────────────────────────────────────────────────${NC}"
echo -e "${WB}                    📁 XRAY SERVICE MENU                    ${NC}"
echo -e "${BB}────────────────────────────────────────────────────────────${NC}"
echo -e " ${MB}[1]${NC} ${YB}Vmess Menu             ${MB}[5]${NC} ${YB}Shadowsocks 2022 Menu${NC}"
echo -e " ${MB}[2]${NC} ${YB}Vless Menu             ${MB}[6]${NC} ${YB}Socks5 Menu${NC}"
echo -e " ${MB}[3]${NC} ${YB}Trojan Menu            ${MB}[7]${NC} ${YB}All Xray Menu${NC}"
echo -e " ${MB}[4]${NC} ${YB}Shadowsocks Menu${NC}"
echo -e "${BB}────────────────────────────────────────────────────────────${NC}"
echo -e "${WB}                        ⚙️ UTILITIES                         ${NC}"
echo -e "${BB}────────────────────────────────────────────────────────────${NC}"
echo -e " ${MB}[8] ${NC}${YB}Catatan Buat Akun      ${MB}[13]${NC} ${YB}Pengaturan DNS${NC}"
echo -e " ${MB}[9] ${NC}${YB}Speedtest              ${MB}[14]${NC} ${YB}Cek DNS Status${NC}"
echo -e " ${MB}[10]${NC}${YB}Ubah Domain            ${MB}[15]${NC} ${YB}Xray-core Mod${NC}"
echo -e " ${MB}[11]${NC}${YB}Renew Cert             ${MB}[16]${NC} ${YB}Xray-core Official${NC}"
echo -e " ${MB}[12]${NC}${YB}Tentang Script         ${MB}[17]${NC} ${YB}Mulai Ulang VPS${NC}"
echo -e " ${MB}[x] ${NC}${YB}Keluar Menu${NC}"
echo -e "${BB}═════════════════════ RAKHA PUTRA ANDRIAN ═══════════════════${NC}"
echo -e ""
read -p " Pilih menu : " opt
echo -e ""
case $opt in
1) clear ; vmess ;;
2) clear ; vless ;;
3) clear ; trojan ;;
4) clear ; shadowsocks ;;
5) clear ; shadowsocks2022 ;;
6) clear ; socks ;;
7) clear ; allxray ;;
8) clear ; log-create ;;
9) clear ; speedtest ;;
10) clear ; dns ;;
11) clear ; certxray ;;
12) clear ; about ;;
13) clear ; changer ;;
14) clear ; 
    resolvectl status
    echo ""
    read -n 1 -s -r -p "Tekan tombol apasaja untuk kembali ke menu"
    menu ;;
15) clear ; xraymod ;;
16) clear ; xrayofficial ;;
17) clear ; reboot ;;
x) clear ; exit ;;
*) echo -e "${RB}Salah Input Bree!${NC}" ; sleep 1 ; menu ;;
esac
