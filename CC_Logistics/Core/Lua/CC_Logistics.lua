local Version = "1.0.0"

-- testing
ws = http.websocket("ws://toxic-cookie.duckdns.org:8080/")
if (ws == nil) then
	while (ws == nil) do
		print("Failed to connect. Retrying in 15 seconds.")
		sleep(15)
		ws = http.websocket("ws://toxic-cookie.duckdns.org:8080/")
	end
end
ws.send("Hello World")
print(ws.receive())
ws.close()