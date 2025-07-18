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
echo -e "${BB}————————————————————————————————————————————————————————${NC}"
echo -e "               ${WB}----- [ Menu Vless ] -----${NC}               "
echo -e "${BB}————————————————————————————————————————————————————————${NC}"
echo -e ""
echo -e " ${MB}[1]${NC} ${YB}Buat Akun Vless${NC} "
echo -e " ${MB}[2]${NC} ${YB}Uji Coba Akun Vless${NC} "
echo -e " ${MB}[3]${NC} ${YB}Perpanjang Akun Vless${NC} "
echo -e " ${MB}[4]${NC} ${YB}Hapus Akun Vless${NC} "
echo -e " ${MB}[5]${NC} ${YB}Cek Pengguna Login${NC} "
echo -e ""
echo -e " ${MB}[0]${NC} ${YB}Kembali Ke Menu${NC}"
echo -e ""
echo -e "${BB}———————————————————————————————————————————————————————${NC}"
echo -e ""
read -p " pilih menu :  "  opt
echo -e ""
case $opt in
1) clear ; add-vless ; exit ;;
2) clear ; trialvless ; exit ;;
3) clear ; extend-vless ; exit ;;
4) clear ; del-vless ; exit ;;
5) clear ; cek-vless ; exit ;;
0) clear ; menu ; exit ;;
x) exit ;;
*) echo -e "salah tekan bree " ; sleep 1 ; vless ;;
esac
