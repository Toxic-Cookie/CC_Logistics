ws = http.websocket("ws://toxic-cookie.duckdns.org:8080/")
ws.send("Hello World")
print(ws.receive())
ws.close()