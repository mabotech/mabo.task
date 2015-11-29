--[[

-- ARGV[1]
-- ARGV[2] 

]]

local heartbeat = redis.call("HGET", KEYS[1], "heartbeat") 


local contain_lsn = redis.call("HEXISTS", KEYS[1], "heartbeat_lsn")
local contain_count = redis.call("HEXISTS", KEYS[1], "heartbeat_count")
--local heartbeat_lsn = redis.call("HGET", KEYS[1], "heartbeat_lsn") 

if contain_lsn == 0 then
    -- first time
    redis.call("HSET", KEYS[1],"heartbeat_lsn", heartbeat)
    heartbeat_lsn = heartbeat
end

if contain_count == 0 then
    -- first time
    redis.call("HSET", KEYS[1],"heartbeat_count", 1)
    -- heartbeat_count = 1
end

local heartbeat_count = redis.call("HGET", KEYS[1], "heartbeat_count") 

if heartbeat == heartbeat_lsn and heartbeat_count < 4 then
    -- no heartbeat or first set heartbeat_lsn
    redis.call("HINCRBY", KEYS[1],"heartbeat_count", 1)
    
    return "Unknown"

elseif heartbeat == heartbeat_lsn and heartbeat_count > 3 then
    -- no heartbeat or first set heartbeat_lsn
    redis.call("HINCRBY", KEYS[1],"heartbeat_count", 1)
    
    local off = redis.call("HGET", KEYS[1],"off") 
    
    if off == "0" then
    
        redis.call("HSET", KEYS[1],"off",1)
        
        local val = redis.call("HGET", KEYS[1], "val") 
     
        local starton = redis.call("HGET", KEYS[1], "starton") 
            
            local msg = cmsgpack.pack( 
                {id=KEYS[1], pstatus=val, 
                duration = heartbeat - starton,  
                ch_ori_eqpt=0, heartbeat=heartbeat, 
                time_precision="ms"} )
            
            -- set collector off.
            
            redis.call("HSET", KEYS[1],"off",1)
            
            redis.call("HSET", KEYS[1],"val",0)  
            redis.call("HSET", KEYS[1],"starton",heartbeat)        
            --redis.call("HSET", KEYS[1],"time",ARGV[2])        
            
            redis.call("LPUSH", "data_queue", msg) -- msg queue
            
            redis.call("PUBLISH", "new_data", "new") -- notice 
    end
    
    return "Off"
    
elseif heartbeat != heartbeat_lsn then
    
    redis.call("HSET", KEYS[1],"heartbeat_count", 1)
    
    redis.call("HSET", KEYS[1],"heartbeat_lsn", heartbeat)  
    
    return "On"
    
else
    
    return "Unknown2"

end
