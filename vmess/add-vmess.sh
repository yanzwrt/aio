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
domain=$(cat /usr/local/etc/xray/domain)
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
echo -e "${BB}══════════════════════════════════════════════════════${NC}"
echo -e "              ${WB}★ Buat Akun Vmess Baru ★${NC}"
echo -e "${BB}══════════════════════════════════════════════════════${NC}"
read -rp "$(echo -e "${GB}➤ Masukkan Nama Pengguna / Password : ${NC}")" user
CLIENT_EXISTS=$(grep -w $user /usr/local/etc/xray/config.json | wc -l)
if [[ ${CLIENT_EXISTS} == '1' ]]; then
clear
echo -e "${RB}⚠️  Pengguna '${user}' sudah terdaftar!${NC}"
echo -e "${YB}Silakan coba dengan nama lain.${NC}"
echo ""
read -n 1 -s -r -p "Tekan tombol apa saja untuk mencoba lagi..."
add-vmess
fi
done
read -p "Expired (days): " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vmess$/a\#@ '"$user $exp"'\
},{"id": "'""$user""'","alterId": '"0"',"email": "'""$user""'"' /usr/local/etc/xray/config.json
sed -i '/#vmess-grpc$/a\#@ '"$user $exp"'\
},{"id": "'""$user""'","alterId": '"0"',"email": "'""$user""'"' /usr/local/etc/xray/config.json
vlink1=`cat << EOF
{
"v": "2",
"ps": "$user",
"add": "$domain",
"port": "443",
"id": "$user",
"aid": "0",
"net": "ws",
"path": "/vmess",
"type": "none",
"host": "$domain",
"tls": "tls"
}
EOF`
vlink2=`cat << EOF
{
"v": "2",
"ps": "$user",
"add": "$domain",
"port": "80",
"id": "$user",
"aid": "0",
"net": "ws",
"path": "/vmess",
"type": "none",
"host": "$domain",
"tls": "none"
}
EOF`
vlink3=`cat << EOF
{
"v": "2",
"ps": "$user",
"add": "$domain",
"port": "443",
"id": "$user",
"aid": "0",
"net": "grpc",
"path": "vmess-grpc",
"type": "none",
"host": "$domain",
"tls": "tls"
}
EOF`
vmesslink1="vmess://$(echo $vlink1 | base64 -w 0)"
vmesslink2="vmess://$(echo $vlink2 | base64 -w 0)"
vmesslink3="vmess://$(echo $vlink3 | base64 -w 0)"
cat > /var/www/html/vmess/vmess-$user.txt << END
==========================
Vmess WS (CDN) TLS
==========================
- name: Vmess-$user
type: vmess
server: ${domain}
port: 443
uuid: ${user}
alterId: 0
cipher: auto
udp: true
tls: true
skip-cert-verify: true
servername: ${domain}
network: ws
ws-opts:
path: /vmess
headers:
Host: ${domain}
==========================
Vmess WS (CDN)
==========================
- name: Vmess-$user
type: vmess
server: ${domain}
port: 80
uuid: ${user}
alterId: 0
cipher: auto
udp: true
tls: false
skip-cert-verify: false
servername: ${domain}
network: ws
ws-opts:
path: /vmess
headers:
Host: ${domain}
==========================
Vmess gRPC (CDN)
==========================
- name: Vmess-$user
server: $domain
port: 443
type: vmess
uuid: $user
alterId: 0
cipher: auto
network: grpc
tls: true
servername: $domain
skip-cert-verify: true
grpc-opts:
grpc-service-name: "vmess-grpc"
==========================
Link Vmess Account
==========================
Link TLS  : vmess://$(echo $vlink1 | base64 -w 0)
==========================
Link NTLS : vmess://$(echo $vlink2 | base64 -w 0)
==========================
Link gRPC : vmess://$(echo $vlink3 | base64 -w 0)
==========================
END
ISP=$(cat /usr/local/etc/xray/org)
CITY=$(cat /usr/local/etc/xray/city)
systemctl restart xray
clear
echo -e "${CB}══════════════════════════════════════════════════════${NC}" | tee -a /user/log-vmess-$user.txt
echo -e "                 ${WB}• Informasi Akun Vmess •${NC}" | tee -a /user/log-vmess-$user.txt
echo -e "${CB}══════════════════════════════════════════════════════${NC}" | tee -a /user/log-vmess-$user.txt
echo -e "${GB}Remarks       :${NC} $user" | tee -a /user/log-vmess-$user.txt
echo -e "${GB}ISP           :${NC} $ISP" | tee -a /user/log-vmess-$user.txt
echo -e "${GB}City          :${NC} $CITY" | tee -a /user/log-vmess-$user.txt
echo -e "${GB}Domain        :${NC} $domain" | tee -a /user/log-vmess-$user.txt
echo -e "${GB}Wildcard      :${NC} (bug.com).$domain" | tee -a /user/log-vmess-$user.txt
echo -e "${GB}Port TLS      :${NC} 443" | tee -a /user/log-vmess-$user.txt
echo -e "${GB}Port NTLS     :${NC} 80" | tee -a /user/log-vmess-$user.txt
echo -e "${GB}id            :${NC} $user" | tee -a /user/log-vmess-$user.txt
echo -e "${GB}AlterId       :${NC} 0" | tee -a /user/log-vmess-$user.txt
echo -e "${GB}Security      :${NC} auto" | tee -a /user/log-vmess-$user.txt
echo -e "${GB}Network       :${NC} Websocket" | tee -a /user/log-vmess-$user.txt
echo -e "${GB}Path          :${NC} /(multipath) • ubah suka-suka" | tee -a /user/log-vmess-$user.txt
echo -e "${GB}ServiceName   :${NC} vmess-grpc" | tee -a /user/log-vmess-$user.txt
echo -e "${GB}Berakhir Pada :${NC} $exp" | tee -a /user/log-vmess-$user.txt
echo -e "${CB}══════════════════════════════════════════════════════${NC}" | tee -a /user/log-vmess-$user.txt
echo -e "${WB}🔗 Link TLS      :${NC} $vlesslink1" | tee -a /user/log-vmess-$user.txt
echo -e "${WB}🔗 Link NTLS     :${NC} $vlesslink2" | tee -a /user/log-vmess-$user.txt
echo -e "${WB}📄 Format Clash  :${NC} http://$domain:8000/vmess/vmess-$user.txt" | tee -a /user/log-vmess-$user.txt
echo -e "${CB}══════════════════════════════════════════════════════${NC}" | tee -a /user/log-vmess-$user.txt
echo " " | tee -a /user/log-vmess-$user.txt
echo " " | tee -a /user/log-vmess-$user.txt
echo " " | tee -a /user/log-vmess-$user.txt
read -n 1 -s -r -p "✅ Tekan tombol apa saja untuk kembali ke menu..."
clear
vmess
