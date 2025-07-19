NC='\e[0m'
DEFBOLD='\e[39;1m'
RB='\e[31;1m'
GB='\e[32;1m'
YB='\e[33;1m'
BB='\e[34;1m'
MB='\e[35;1m'
CB='\e[35;1m'
WB='\e[37;1m'
clear
NUMBER_OF_CLIENTS=$(grep -c -E "^#= " "/usr/local/etc/xray/config.json")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
echo -e "${BB}══════════════════════════════════════════════════════${NC}"
echo -e "              ${WB}★ Perpanjang Akun Vless ★${NC}"
echo -e "${BB}══════════════════════════════════════════════════════${NC}"
echo -e "  ${YB}Belum ada pengguna yang terdaftar!${NC}"
echo -e "${BB}————————————————————————————————————————————————————${NC}"
echo ""
read -n 1 -s -r -p "Tekan tombol apa saja untuk kembali ke menu"
vless
fi
clear
echo -e "${BB}══════════════════════════════════════════════════════${NC}"
echo -e "              ${WB}★ Perpanjang Akun Vless ★${NC}"
echo -e "${BB}══════════════════════════════════════════════════════${NC}"
echo -e " ${YB}Daftar Pengguna & Tanggal Berakhir${NC}  "
echo -e "${BB}══════════════════════════════════════════════════════${NC}"
grep -E "^#= " "/usr/local/etc/xray/config.json" | cut -d ' ' -f 2-3 | column -t | sort | uniq
echo ""
echo -e "${YB}Tekan Enter untuk kembali ke menu${NC}"
echo -e "${BB}══════════════════════════════════════════════════════${NC}"
read -rp "Masukan Nama Pengguna : " user
if [ -z $user ]; then
vless
else
read -p "Expired (days): " masaaktif
exp=$(grep -wE "^#= $user" "/usr/local/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
now=$(date +%Y-%m-%d)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
exp3=$(($exp2 + $masaaktif))
exp4=`date -d "$exp3 days" +"%Y-%m-%d"`
sed -i "/#= $user/c\#= $user $exp4" /usr/local/etc/xray/config.json
systemctl restart xray
clear
echo -e "${BB}══════════════════════════════════════════════════════${NC}"
echo -e "          ${WB}★ Perpanjang Akun Vless Berhasil ★${NC}"
echo -e "${BB}══════════════════════════════════════════════════════${NC}"
echo -e " ${GB}Nama Pengguna   :${NC} $user"
echo -e " ${GB}Berlaku Sampai  :${NC} $exp4"
echo -e "${BB}————————————————————————————————————————————————————${NC}"
echo ""
read -n 1 -s -r -p "Tekan tombol apa saja untuk kembali ke menu"
clear
vless
fi
