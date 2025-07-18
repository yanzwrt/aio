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
echo -e "               ${WB}----- [ Menu Vmess ] -----${NC}               "
echo -e "${BB}————————————————————————————————————————————————————————${NC}"
echo -e ""
echo -e " ${MB}[1]${NC} ${YB}Buat Akun Vmess${NC} "
echo -e " ${MB}[2]${NC} ${YB}Uji Coba Akun Vmess${NC} "
echo -e " ${MB}[3]${NC} ${YB}Perpanjang Akun Vmess${NC} "
echo -e " ${MB}[4]${NC} ${YB}Hapus Akun Vmess${NC} "
echo -e " ${MB}[5]${NC} ${YB}Cek Pengguna Login${NC} "
echo -e ""
echo -e " ${MB}[0]${NC} ${YB}Kembali Ke Menu${NC}"
echo -e ""
echo -e "${BB}———————————————————————————————————————————————————————${NC}"
echo -e ""
read -p " Pilih menu :  "  opt
echo -e ""
case $opt in
1) clear ; add-vmess ; exit ;;
2) clear ; trialvmess ; exit ;;
3) clear ; extend-vmess ; exit ;;
4) clear ; del-vmess ; exit ;;
5) clear ; cek-vmess ; exit ;;
0) clear ; menu ; exit ;;
x) exit ;;
*) echo -e "salah tekan " ; sleep 1 ; vmess ;;
esac
