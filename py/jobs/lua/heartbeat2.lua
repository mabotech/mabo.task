--[[

-- KEYS[1], equipment id
-- ARGV[1]
-- ARGV[2]

]]

local heartbeat_key = string.format("%s_%s", KEYS[1], "heartbeat")

-- heartbeat_key with ttl value

local heartbeat_status = redis.call("GET", heartbeat_key) 

-- key timeout
if heartbeat_status == false then
    -- heartbeat timeout
    
    local off = redis.call("HGET", KEYS[1], "off") 
    
    if off == "0" then
        
        -- first time timeout
        local val = redis.call("HGET", KEYS[1], "val") 
        
        local start_timestamp = redis.call("HGET", KEYS[1], "starton") 
        
        local heartbeat_timestamp = redis.call("HGET", KEYS[1],"heartbeat") 
        
        local msg -- = nil
        
        local found = string.find(string.lower(KEYS[1]), "camera")
        
        
        
        if found == nil then
            -- not a camera
            msg = cmsgpack.pack( 
                {id=KEYS[1], pstatus=val, 
                duration = heartbeat_timestamp - start_timestamp,  
                ch_ori_eqpt=0, heartbeat=heartbeat_timestamp, 
                time_precision="ms"} )            
        else
            -- camera            
            local equipment_id =  string.sub(KEYS[1], 0, -8)
            
            msg = cmsgpack.pack( 
                {id = equipment_id, pstatus=val, 
                duration = heartbeat_timestamp - start_timestamp,  
                ch_occupied=0, heartbeat=heartbeat_timestamp, 
                time_precision="ms"} )            
        end
        
        redis.call("HSET", KEYS[1],"off",1)
        redis.call("HSET", KEYS[1],"val",0)
        
        -- redis.call("HSET", KEYS[1],"starton",heartbeat)        
        --redis.call("HSET", KEYS[1],"time",ARGV[2])        
        
        redis.call("LPUSH", "data_queue", msg) -- msg queue
        
        redis.call("PUBLISH", "new_data", "new") -- notice
        
    end
    
    return "Off"
    
else
    
    return  "On"
    
end
 