

if redis.call("EXISTS", KEYS[1]) == 1 then        
        --[[
        publish
        data queue
        set heardbeat when pooling        
        ]]         
        
        local payload = redis.call("HGET", KEYS[1],"val")        
        
        if payload == ARGV[1] then
            -- redis.call("LPUSH", "c1","chan2")
            redis.call("HSET", KEYS[2],"time",ARGV[2])
            
            return "same"  
        else            
            
            local msg = cmsgpack.pack({"eq":KEYS[1], "val":ARGV[1], "time":ARGV[2],"time_precision":"ms"})
            
            redis.call("HSET", KEYS[1],"val",ARGV[1])
            
            redis.call("HSET", KEYS[2],"time",ARGV[2])
            
            redis.call("LPUSH", "data_queue",msg)
            
            redis.call("PUBLISH", "new_data","new")
            
            return payload -- return old val
            
        end
else
    
    local msg = cmsgpack.pack({"eq":KEYS[1], "val":ARGV[1], "time":ARGV[2],"time_precision":"ms"})
    
    redis.call("HSET", KEYS[1],"val",ARGV[1])
    
    redis.call("HSET", KEYS[2],"time",ARGV[2])
    
    redis.call("LPUSH", "data_queue", msg)
    
    redis.call("PUBLISH", "new_data","new")
    
    return "new"
end