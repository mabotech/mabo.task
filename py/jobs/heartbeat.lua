
local heartbeat = redis.call("HGET", KEYS[1], "heartbeat") 
if heartbeat == false then
    heartbeat = ARGV[1] 
end
if ARGV[1] - ARGV[2] - heartbeat < 0 then
    -- heartbeat is OK
    return  "On"

else
    -- heartbeat timeout
    
    local off = redis.call("HGET", KEYS[1],"off") 
    
    if off == "0" then
        
        -- first time timeout
        local val = redis.call("HGET", KEYS[1], "val") 
        
        local starton = redis.call("HGET", KEYS[1], "starton") 
        
        local msg = cmsgpack.pack( 
            {id=KEYS[1], pstatus=val, 
            duration = heartbeat - starton,  
            ch_ori_eqpt=0, heartbeat=heartbeat, 
            time_precision="ms"} )
        
        redis.call("HSET", KEYS[1],"off",1)
        
        redis.call("HSET", KEYS[1],"val",0)  
        redis.call("HSET", KEYS[1],"starton",heartbeat)        
        --redis.call("HSET", KEYS[1],"time",ARGV[2])        
        
        redis.call("LPUSH", "data_queue", msg) -- msg queue
        
        redis.call("PUBLISH", "new_data", "new") -- notice
        
    end
    
    return "Off"
end
 