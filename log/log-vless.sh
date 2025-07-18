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
clear
echo -e "${BB}————————————————————————————————————————————————————${NC}"
echo -e "                 ${WB}Catatan Akun Vless${NC}                 "
echo -e "${BB}————————————————————————————————————————————————————${NC}"
echo -e "  ${YB}Belum ada pengguna yang terdaftar!${NC}"
echo -e "${BB}————————————————————————————————————————————————————${NC}"
echo ""
read -n 1 -s -r -p "Tekan tombol apa saja untuk kembali ke menu"
log-create
fi
clear
echo -e "${BB}————————————————————————————————————————————————————${NC}"
echo -e "                  ${WB}Catatan Akun Vless${NC}                 "
echo -e "${BB}————————————————————————————————————————————————————${NC}"
echo -e " ${YB}Daftar Pengguna & Tanggal Berakhir${NC}  "
echo -e "${BB}————————————————————————————————————————————————————${NC}"
grep -E "^#= " "/usr/local/etc/xray/config.json" | cut -d ' ' -f 2-3 | column -t | sort | uniq
echo ""
echo -e "${YB}tekan enter untuk kembali${NC}"
echo -e "${BB}————————————————————————————————————————————————————${NC}"
read -rp "Masukan Nama Pengguna : " user
if [ -z $user ]; then
log-create
else
clear
echo -e "`cat "/user/log-vless-$user.txt"`"
echo ""
read -n 1 -s -r -p "Tekan tombol apa saja untuk kembali ke menu"
log-create
fi
