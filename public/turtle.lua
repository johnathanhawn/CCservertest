os.loadAPI("json")
print("opening websocket")
ws = http.websocket("ws://10.0.10.60:9000")
if(os.getComputerLabel() ~= nil ) then
        ws.send(json.encode({message="socketInfo",who="robot",id=os.getComputerLabel()}))
else
        ws.send(json.encode({message="socketInfo",who="robot"}))
end

function detectSurroundings()
    local topDetectStatus, topResponse1, topResponse2 = turtle.detectUp()
    local bottomDetectStatus, bottomResponse1, bottomResponse2 = turtle.detectDown()
    local frontDetectStatus, frontResponse1, frontResponse2 = turtle.detect()
    payload = json.encode({top=topResponse1,bottom=bottomResponse1,front=frontResponse1})
    return payload
end

while true do
        message = ws.receive()
    if message then
        print("Got: " .. message)
        if message == "turtle.detect()" then
            funct = turtle.detect
        elseif message == "turtle.detectUp()" then
            funct = turtle.detectUp
        elseif message == "turtle.detectDown()" then
            funct = turtle.detectDown
        elseif message == "turtle.inspect()" then
            funct = turtle.inspect
        elseif message == "turtle.inspectUp()" then
            funct = turtle.inspectUp
        elseif message == "turtle.inspectDown()" then
            funct = turtle.inspectDown
        elseif message == "inspectSurroundings()" then
            funct = detectSurroundings
        else
            funct = load(message)
        end
        status,value,value2 = pcall(funct)
        if(status) then
            if(value2 ~= nil) then
                string1 = json.encode({message="returnInfo",status=status,val1=value,val2=value2,id=os.getComputerLabel(),currentFuel=turtle.getFuelLevel(),fuelLimit=turtle.getFuelLimit()})
            elseif(type(value) == "table") then
                string1 = json.encode({message="returnInfo",status=status,val1=value,val2=value2,id=os.getComputerLabel(),currentFuel=turtle.getFuelLevel(),fuelLimit=turtle.getFuelLimit()})
            elseif(type(value) == "boolean") then
                string1 = json.encode({message="returnBool",status=status,val1=value,val2=value2,id=os.getComputerLabel(),currentFuel=turtle.getFuelLevel(),fuelLimit=turtle.getFuelLimit()})
            else
                string1 = json.encode({message="returnValue",status=status,val1=tostring(value),val2=tostring(value2),id=os.getComputerLabel(),currentFuel=turtle.getFuelLevel(),fuelLimit=turtle.getFuelLimit()})
            end
            print("good command, sending: " .. string1)
            ws.send(string1)
        else
            print("bad command")
            ws.send(json.encode({message="err",id=os.getComputerLabel(),fuel=turtle.getFuelLevel()}))
        end
    end
end
