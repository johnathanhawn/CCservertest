local csFilePath = "cs.txt"

-- Check if the cs.txt file exists
if not fs.exists(csFilePath) then
  -- File doesn't exist, create it
  local csFile = fs.open(csFilePath, "w")
  csFile.writeLine("wss://your-websocket-server-url") -- Replace with your desired default server URL
  csFile.close()
  print("cs.txt file created. Please update the WebSocket server URL in cs.txt.")
  return
end

-- Read the server URL from the cs.txt file
local csFile = fs.open(csFilePath, "r")
local serverURL = csFile.readAll()
csFile.close()

-- Connect to the WebSocket server
local ws, err = http.websocket(serverURL)

if ws then
  print("WebSocket server connected")

  -- Send a welcome message to the client
  ws.send("Hello, client!")

  while true do
    message = ws.receive()
    if message then do
      print(message)
      -- Process the received command
      success, output1, output2 = pcall(message)
      -- Check if the command execution was successful
      if success then
        -- Return the result of the command
        ws.send(tostring(success) .. "||" .. tostring(output1) .. "||" .. tostring(output2))
    else
      -- Return the error message if command execution failed
      ws.send("Command execution error: " .. tostring(result))
    end
    end
    end

  ws.close()
  print("WebSocket server disconnected")
else
  print("Failed to connect to the WebSocket server: " .. err)
end