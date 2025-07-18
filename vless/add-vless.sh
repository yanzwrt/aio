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
echo -e "              ${WB}★ Buat Akun Vless Baru ★${NC}"
echo -e "${BB}══════════════════════════════════════════════════════${NC}"
read -rp "$(echo -e "${GB}➤ Masukkan Username / Password : ${NC}")" user
CLIENT_EXISTS=$(grep -w $user /usr/local/etc/xray/config.json | wc -l)
if [[ ${CLIENT_EXISTS} == '1' ]]; then
clear
echo -e "${RB}⚠️  Username '${user}' sudah terdaftar!${NC}"
echo -e "${YB}Silakan coba dengan nama lain.${NC}"
echo ""
read -n 1 -s -r -p "Tekan tombol apa saja untuk mencoba lagi..."
fi
done
read -p "Expired (days): " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
# Insert config to Xray
sed -i '/#vless$/a\#= '"$user $exp"'\
},{"id": "'""$user""'","email": "'""$user""'"' /usr/local/etc/xray/config.json
sed -i '/#vless-grpc$/a\#= '"$user $exp"'\
},{"id": "'""$user""'","email": "'""$user""'"' /usr/local/etc/xray/config.json
# Generate Links
vlesslink1="vless://$user@$domain:443?path=/vless&security=tls&encryption=none&host=$domain&type=ws&sni=$domain#$user"
vlesslink2="vless://$user@$domain:80?path=/vless&security=none&encryption=none&host=$domain&type=ws#$user"
vlesslink3="vless://$user@$domain:443?security=tls&encryption=none&type=grpc&serviceName=vless-grpc&sni=$domain#$user"
cat > /var/www/html/vless/vless-$user.txt << END
==========================
Vless WS (CDN) TLS
==========================
- name: Vless-$user
type: vless
server: ${domain}
port: 443
uuid: ${user}
cipher: auto
udp: true
tls: true
skip-cert-verify: true
servername: ${domain}
network: ws
ws-opts:
path: /vless
headers:
Host: ${domain}
==========================
Vless WS (CDN)
==========================
- name: Vless-$user
type: vless
server: ${domain}
port: 80
uuid: ${user}
cipher: auto
udp: true
tls: false
skip-cert-verify: false
network: ws
ws-opts:
path: /vless
headers:
Host: ${domain}
==========================
Vless gRPC (CDN)
==========================
- name: Vless-$user
server: $domain
port: 443
type: vless
uuid: $user
cipher: auto
network: grpc
tls: true
servername: $domain
skip-cert-verify: true
grpc-opts:
grpc-service-name: "vless-grpc"
==========================
Link Vless Account
==========================
Link TL   : vless://$user@$domain:443?path=/vless&security=tls&encryption=none&host=$domain&type=ws&sni=$domain#$user
==========================
Link NTLS : vless://$user@$domain:80?path=/vless&security=none&encryption=none&host=$domain&type=ws#$user
==========================
Link gRPC : vless://$user@$domain:443?security=tls&encryption=none&type=grpc&serviceName=vless-grpc&sni=$domain#$user
==========================
END
ISP=$(cat /usr/local/etc/xray/org)
CITY=$(cat /usr/local/etc/xray/city)
systemctl restart xray
clear
echo -e "${CB}══════════════════════════════════════════════════════${NC}" | tee -a /user/log-vless-$user.txt
echo -e "                 ${WB}• Informasi Akun Vless •${NC}" | tee -a /user/log-vless-$user.txt
echo -e "${CB}══════════════════════════════════════════════════════${NC}" | tee -a /user/log-vless-$user.txt
echo -e "${GB}Remarks       :${NC} $user" | tee -a /user/log-vless-$user.txt
echo -e "${GB}Domain        :${NC} ${domain}" | tee -a /user/log-vless-$user.txt
echo -e "${GB}ISP           :${NC} $ISP" | tee -a /user/log-vless-$user.txt
echo -e "${GB}City          :${NC} $CITY" | tee -a /user/log-vless-$user.txt
echo -e "${GB}Wildcard      :${NC} (bug.com).$domain" | tee -a /user/log-vless-$user.txt
echo -e "${GB}Port TLS      :${NC} 443" | tee -a /user/log-vless-$user.txt
echo -e "${GB}Port NTLS     :${NC} 80" | tee -a /user/log-vless-$user.txt
echo -e "${GB}id            :${NC} $user" | tee -a /user/log-vless-$user.txt
echo -e "${GB}Encryption    :${NC} none" | tee -a /user/log-vless-$user.txt
echo -e "${GB}Network       :${NC} ws" | tee -a /user/log-vless-$user.txt
echo -e "${GB}Path          :${NC} /vless" | tee -a /user/log-vless-$user.txt
echo -e "${GB}Berakhir Pada :${NC} $exp" | tee -a /user/log-vless-$user.txt
echo -e "${CB}══════════════════════════════════════════════════════${NC}" | tee -a /user/log-vless-$user.txt
echo -e "${WB}🔗 Link TLS      :${NC} $vlesslink1" | tee -a /user/log-vless-$user.txt
echo -e "${WB}🔗 Link NTLS     :${NC} $vlesslink2" | tee -a /user/log-vless-$user.txt
echo -e "${WB}📄 Format Clash  :${NC} http://$domain:8000/vless/vless-$user.txt" | tee -a /user/log-vless-$user.txt
echo -e "${CB}══════════════════════════════════════════════════════${NC}" | tee -a /user/log-vless-$user.txt
echo " " | tee -a /user/log-vless-$user.txt
echo " " | tee -a /user/log-vless-$user.txt
echo " " | tee -a /user/log-vless-$user.txt
read -n 1 -s -r -p "✅ Tekan tombol apa saja untuk kembali ke menu..."
clear
vless
