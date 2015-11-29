--[[

-- KEYS[1], equipment
-- ARGV[1]
-- ARGV[2] 

]]

local heartbeat_key = string.format("%s_%s", KEYS[1], "heartbeat")

local has_heartbeat = redis.call("EXISTS", KEYS[1], heartbeat_key)

local is_camera = string.find(KEYS[1], "camera")

if has_heartbeat == 1 then
    
    return "On"    
    
else
    
    local off = redis.call("HGET", KEYS[1],"off") 
    
    if off == "0" then
        
        -- mark client Off
        redis.call("HSET", KEYS[1],"off",1)
        -- set status Off
        redis.call("HSET", KEYS[1],"val",0)  
        
        local val = redis.call("HGET", KEYS[1], "val")      
        local starton = redis.call("HGET", KEYS[1], "starton")        
        local rawdata = redis.call("HGET", KEYS[1], "rawdata") 
        
        local msg
        
        if is_camera == nil then
            -- not a camera
            
            msg = cmsgpack.pack( 
                {id=KEYS[1],  -- equipment
                pstatus=val, 
                duration = heartbeat - starton,  
                ch_ori_eqpt=0,  -- channel status
                heartbeat=heartbeat, 
                rawdata = rawdata,
                time_precision="ms"} )
                
        else
            -- camera
            local equipment_id = string.sub(KEYS[1], 0, -8) 
            
            msg = cmsgpack.pack( 
                {id=equipment_id, -- equipment
                pstatus=val, 
                duration = heartbeat - starton,  
                ch_occupied=0,  -- channel status
                heartbeat=heartbeat, 
                rawdata = rawdata,
                time_precision="ms"} )            
        
        end     
        
        -- redis.call("HSET", KEYS[1],"starton",heartbeat)        
        --redis.call("HSET", KEYS[1],"time",ARGV[2])        
        
        redis.call("LPUSH", "data_queue", msg) -- msg queue
        
        redis.call("PUBLISH", "new_data", "new") -- notice 
   
    end
   
    return "Off"
    
end
