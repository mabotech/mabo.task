      
local payload = redis.call("HGET", KEYS[1],"val")        

if payload == ARGV[1] then
    -- redis.call("LPUSH", "c1","chan2")
    redis.call("HSET", KEYS[1],"time",ARGV[2])
    redis.call("HSET", KEYS[1],"off",0)
    
    return "same"
else            
    
    local msg = cmsgpack.pack( {id=KEYS[1], api=ARGV[1], time=ARGV[2], time_precision="ms"} )
    
    redis.call("HSET", KEYS[1],"val",ARGV[1])    
    redis.call("HSET", KEYS[1],"time",ARGV[2])
    redis.call("HSET", KEYS[1],"off",0)
    
    redis.call("LPUSH", "data_queue",msg) -- msg queue
    
    redis.call("PUBLISH", "new_data","new") -- notice
    
    return payload -- return old val
    
end
