
--[[

for AK, Vision, OPC, DB ...

]]
-- key1,argv1,argv2,argv3,argv4
-- KEYS[1], equipment
-- ARGV[1], new status value
-- ARGV[2], timestamp
-- ARGV[3], message 
-- ARGV[4], ttl

local old_status = redis.call("HGET", KEYS[1],"val")  

local post = redis.call("HGET", KEYS[1],"post") 

local is_camera = string.find(KEYS[1], "camera")
local heartbeat_key = string.format("%s_%s", KEYS[1], "heartbeat")

local starton = redis.call("HGET", KEYS[1],"starton")
local poston = redis.call("HGET", KEYS[1],"poston")

-- heartbeat
redis.call("HSET", KEYS[1],"heartbeat",ARGV[2])

local heartbeat = ARGV[2]

-- set ttl for equipment
redis.call("SET", heartbeat_key, ARGV[2], "EX", 8 ) -- 10 seconds, ARGV[4]

-- set off: 1 / not off: 0
redis.call("HSET", KEYS[1],"off",0)

-- compare old status and new status
if old_status == ARGV[1] then
    -- same val
    
    -- redis.call("LPUSH", "c1","chan2")
    if is_camera ~= nil then
        -- only for camera
        if (heartbeat - starton > 15000) then  -- delay 15 seconds
        
	    if old_status ~= post or heartbeat - poston > 60000 then

                local equipment_id = string.sub(KEYS[1], 0, -8)  -- remove: _camera
        
                local msg = cmsgpack.pack(
                  {id=equipment_id, -- key
                   pstatus = old_status,  -- only for reference
                   duration = heartbeat - starton, 
                   ch_occupied = ARGV[1], -- channel, last status
                   heartbeat = heartbeat, 
                   rawdata = ARGV[3],  
                   time_precision="ms"} )
                 
                redis.call("HSET", KEYS[1],"post", old_status) 
                redis.call("HSET", KEYS[1],"poston",ARGV[2])
            
                redis.call("RPUSH", "data_queue",msg) -- msg queue    
                redis.call("PUBLISH", "new_data","new") -- notice             
            
                return "done!"
            
	    end 
	end
	    
    end
    -- redis.call("SET", heartbeat_key, "1","EX", ARGV[4])
    return "same"

else    
    -- status / value changed
    
    redis.call("HSET", KEYS[1],"val",ARGV[1]) -- equipment status
    redis.call("HSET", KEYS[1],"starton",heartbeat)
    redis.call("HSET", KEYS[1],"rawdata",ARGV[3])        
    
    -- no key?
    --[[if starton == false then
        starton = heartbeat
    end
    ]]
    
    if is_camera == nil then
        -- only for equipment
        local equipment_id = KEYS[1] 
    
        local msg = cmsgpack.pack(
            {id=equipment_id, -- key
             pstatus = old_status,  -- only for reference
             duration = heartbeat - starton, 
             ch_ori_eqpt = ARGV[1], -- channel, last status
             heartbeat = heartbeat, 
             rawdata = ARGV[3],  
             time_precision="ms"} )
       
        redis.call("RPUSH", "data_queue",msg) -- msg queue    
        redis.call("PUBLISH", "new_data","new") -- notice
        
    end
    
    return old_status -- return old val
    
end
