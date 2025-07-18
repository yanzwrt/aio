NC='\e[0m'
DEFBOLD='\e[39;1m'
RB='\e[31;1m'
GB='\e[32;1m'
YB='\e[33;1m'
BB='\e[34;1m'
MB='\e[35;1m'
CB='\e[36;1m'
WB='\e[37;1m'

clear
domain=$(cat /usr/local/etc/xray/domain)

until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${user_EXISTS} == '0' ]]; do
    clear
    echo -e "${BB}══════════════════════════════════════════════════════${NC}"
    echo -e "              ${WB}★ Buat Akun Trojan Baru ★${NC}"
    echo -e "${BB}══════════════════════════════════════════════════════${NC}"
    echo ""
    read -rp "$(echo -e "${GB}➤ Masukkan Username / Password : ${NC}")" user
    user_EXISTS=$(grep -w $user /usr/local/etc/xray/config.json | wc -l)
    if [[ ${user_EXISTS} == '1' ]]; then
        clear
        echo -e "${RB}⚠️  Username '${user}' sudah terdaftar!${NC}"
        echo -e "${YB}Silakan coba dengan nama lain.${NC}"
        echo ""
        read -n 1 -s -r -p "Tekan tombol apa saja untuk mencoba lagi..."
    fi
done

read -rp "$(echo -e "${GB}➤ Masa aktif akun (hari): ${NC}")" masaaktif
exp=$(date -d "$masaaktif days" +"%Y-%m-%d")

# Insert config to Xray
sed -i '/#trojan$/a\#& '"$user $exp"'\n},{"password": "'$user'","email": "'$user'"' /usr/local/etc/xray/config.json
sed -i '/#trojan-grpc$/a\#& '"$user $exp"'\n},{"password": "'$user'","email": "'$user'"' /usr/local/etc/xray/config.json

# Generate Links
trojanlink1="trojan://$user@$domain:443?path=/trojan&security=tls&host=$domain&type=ws&sni=$domain#$user"
trojanlink2="trojan://$user@$domain:80?path=/trojan&security=none&host=$domain&type=ws#$user"
trojanlink3="trojan://$user@$domain:443?security=tls&encryption=none&type=grpc&serviceName=trojan-grpc&sni=$domain#$user"

# Output to .txt
mkdir -p /var/www/html/trojan
cat > /var/www/html/trojan/trojan-$user.txt << END
==========================
Trojan WS (CDN) TLS
==========================
- name: Trojan-$user
  server: $domain
  port: 443
  type: trojan
  password: $user
  network: ws
  sni: $domain
  skip-cert-verify: true
  udp: true
  ws-opts:
    path: /trojan
    headers:
      Host: $domain

==========================
Trojan gRPC (CDN)
==========================
- name: Trojan-$user
  server: $domain
  port: 443
  type: trojan
  password: $user
  network: grpc
  sni: $domain
  skip-cert-verify: true
  udp: true
  grpc-opts:
    grpc-service-name: "trojan-grpc"

==========================
Link Trojan Account
==========================
Link TLS  : $trojanlink1
Link NTLS : $trojanlink2
Link gRPC : $trojanlink3
END

ISP=$(cat /usr/local/etc/xray/org)
CITY=$(cat /usr/local/etc/xray/city)

systemctl restart xray

clear
echo -e "${CB}══════════════════════════════════════════════════════${NC}" | tee -a /user/log-trojan-$user.txt
echo -e "                 ${WB}• Informasi Akun Trojan •${NC}" | tee -a /user/log-trojan-$user.txt
echo -e "${CB}══════════════════════════════════════════════════════${NC}" | tee -a /user/log-trojan-$user.txt
echo -e "${GB}Remarks      :${NC} $user" | tee -a /user/log-trojan-$user.txt
echo -e "${GB}ISP          :${NC} $ISP" | tee -a /user/log-trojan-$user.txt
echo -e "${GB}City         :${NC} $CITY" | tee -a /user/log-trojan-$user.txt
echo -e "${GB}Host/IP      :${NC} $domain" | tee -a /user/log-trojan-$user.txt
echo -e "${GB}Wildcard     :${NC} (bug.com).$domain" | tee -a /user/log-trojan-$user.txt
echo -e "${GB}Port TLS     :${NC} 443" | tee -a /user/log-trojan-$user.txt
echo -e "${GB}Port NTLS    :${NC} 80" | tee -a /user/log-trojan-$user.txt
echo -e "${GB}Port gRPC    :${NC} 443" | tee -a /user/log-trojan-$user.txt
echo -e "${GB}Password     :${NC} $user" | tee -a /user/log-trojan-$user.txt
echo -e "${GB}Network      :${NC} WebSocket, gRPC" | tee -a /user/log-trojan-$user.txt
echo -e "${GB}Path         :${NC} /trojan" | tee -a /user/log-trojan-$user.txt
echo -e "${GB}ServiceName  :${NC} trojan-grpc" | tee -a /user/log-trojan-$user.txt
echo -e "${GB}Alpn         :${NC} h2, http/1.1" | tee -a /user/log-trojan-$user.txt
echo -e "${GB}Expired Date :${NC} $exp" | tee -a /user/log-trojan-$user.txt
echo -e "${CB}══════════════════════════════════════════════════════${NC}" | tee -a /user/log-trojan-$user.txt
echo -e "${WB}🔗 Link TLS      :${NC} $trojanlink1" | tee -a /user/log-trojan-$user.txt
echo -e "${WB}🔗 Link NTLS     :${NC} $trojanlink2" | tee -a /user/log-trojan-$user.txt
echo -e "${WB}🔗 Link gRPC     :${NC} $trojanlink3" | tee -a /user/log-trojan-$user.txt
echo -e "${WB}📄 Format Clash  :${NC} http://$domain:8000/trojan/trojan-$user.txt" | tee -a /user/log-trojan-$user.txt
echo -e "${CB}══════════════════════════════════════════════════════${NC}" | tee -a /user/log-trojan-$user.txt

echo ""
read -n 1 -s -r -p "✅ Tekan tombol apa saja untuk kembali ke menu..."
clear
trojan
