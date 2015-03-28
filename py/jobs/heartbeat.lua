
local time = redis.call("HGET", KEYS[1], "time") 
 
if ARGV[1] - ARGV[2] - time < 0 then
    -- heartbeat is OK
    return "On"

else
    -- heartbeat timeout
    
    local off = redis.call("HGET", KEYS[1],"off") 
    
    if off == "0" then
        
        -- first time timeout
        
        local msg = cmsgpack.pack( {id=KEYS[1], api=0, time=time, time_precision="ms"} )
        
        redis.call("HSET", KEYS[1],"off",1)
        
        redis.call("LPUSH", "data_queue", msg) -- msg queue
        
        redis.call("PUBLISH", "new_data", "new") -- notice
        
    end
    
    return "Off"
end
 