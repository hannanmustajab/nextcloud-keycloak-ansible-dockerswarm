#
# Settings
#
CLIENT_ID="test-vcc"
CLIENT_SECRET="kY7gpuoxV98zPFB6onDwayMLPMd2h5c5"
KEYCLOAK_URL="http://127.0.0.1:8080/realms/vcc"

# Discover informations from the server
KEYCLOAK_DISCOVERY_URL="${KEYCLOAK_URL}/.well-known/openid-configuration"
auth_endpoint=$(curl -s "$KEYCLOAK_DISCOVERY_URL" | jq -r '.authorization_endpoint')
echo "It seems that $auth_endpoint is the authorization endpoint"
token_endpoint=$(curl -s "$KEYCLOAK_DISCOVERY_URL" | jq -r '.token_endpoint')
echo "It seems that $token_endpoint is the token endpoint"

# Request a token from the authorization server
echo "Go with the browser to ${auth_endpoint}?response_type=code&scope=openid%20email&client_id=${CLIENT_ID}&redirect_uri=http%3A%2F%2F127.0.0.1:1234"
echo 'Waiting'
python3 - > /tmp/code <<EOF
import socket
import urllib.parse
req_url = ''
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
  sock.bind(('127.0.0.1', 1234))
  sock.listen()
  conn, _ = sock.accept()
  req = conn.recv(16384)
  req_line = req.split(b'\r\n')[0]
  req_url = req_line.split(b' ')[1].decode('utf-8')
parsed_url = urllib.parse.urlparse(req_url)
parsed_query = urllib.parse.parse_qs(parsed_url.query)
code = parsed_query['code'][0]
print(code)
EOF
code=$(cat /tmp/code)
rm -f /tmp/code
echo "OAuth code is $code"

# Request id token from the authorization server
curl -v -s -X POST -d "grant_type=authorization_code&code=$code&redirect_uri=http%3A%2F%2F127.0.0.1:1234" -u "$CLIENT_ID:$CLIENT_SECRET" "${token_endpoint}" > /tmp/token
echo "Token signature method"
cat /tmp/token | jq -r .access_token | cut -d. -f1 | base64 -d 2> /dev/null && echo ""
echo "Token data"
cat /tmp/token | jq -r .access_token | cut -d. -f2 | base64 -d 2> /dev/null | jq && echo ""
echo "Token signature (Base64)"
cat /tmp/token | jq -r .access_token | cut -d. -f3 && echo ""
