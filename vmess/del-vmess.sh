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
NUMBER_OF_CLIENTS=$(grep -c -E "^#@ " "/usr/local/etc/xray/config.json")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
clear
echo -e "${BB}————————————————————————————————————————————————————${NC}"
echo -e "                  ${WB}Hapus Akun Vmess${NC}                  "
echo -e "${BB}————————————————————————————————————————————————————${NC}"
echo -e "  ${YB}Belum ada pengguna yang terdaftar!${NC}"
echo -e "${BB}————————————————————————————————————————————————————${NC}"
read -n 1 -s -r -p "Tekan tombol apa saja untuk kembali ke menu"
vmess
fi
clear
echo -e "${BB}————————————————————————————————————————————————————${NC}"
echo -e "                  ${WB}Hapus Akun Vmess${NC}                  "
echo -e "${BB}————————————————————————————————————————————————————${NC}"
echo -e " ${YB}Daftar Pengguna & Tanggal Berakhir${NC}  "
echo -e "${BB}————————————————————————————————————————————————————${NC}"
grep -E "^#@ " "/usr/local/etc/xray/config.json" | cut -d ' ' -f 2-3 | column -t | sort | uniq
echo ""
echo -e "${YB}Tekan Enter untuk kembali ke menu${NC}"
echo -e "${BB}————————————————————————————————————————————————————${NC}"
read -rp "Masukkan Nama Pengguna : " user
if [ -z $user ]; then
vmess
else
exp=$(grep -wE "^#@ $user" "/usr/local/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
sed -i "/^#@ $user $exp/,/^},{/d" /usr/local/etc/xray/config.json
rm -rf /var/www/html/vmess/vmess-$user.txt
rm -rf /user/log-vmess-$user.txt
systemctl restart xray
clear
echo -e "${BB}————————————————————————————————————————————————————${NC}"
echo -e "           ${WB}Akun Vmess Berhasil Dihapus${NC}            "
echo -e "${BB}————————————————————————————————————————————————————${NC}"
echo -e " ${YB}Nama Pengguna   :${NC} $user"
echo -e " ${YB}Berlaku Sampai  :${NC} $exp"
echo -e "${BB}————————————————————————————————————————————————————${NC}"
echo ""
read -n 1 -s -r -p "Tekan tombol apa saja untuk kembali ke menu"
clear
vmess
fi
