--[[----------------------------------------
Copyright (C) wst.pub, All Rights Reserved.
------------------------------------------]]

local periphery = require('periphery')

local GPIO = periphery.GPIO

local active_digitout = true

local io25 = GPIO(25, "out")

io25:write(not active_digitout)

local sleep_time_after_start, sleep_time_after_close, start_time_sec, close_time_sec, duration

local function start()
    io25:write(active_digitout)
end

local function stop()
    io25:write(not active_digitout)
end

local function sleep(ms, multiplier)
    multiplier = multiplier or 1000
    periphery.sleep_ms(ms * multiplier)
end

-- local start_time, close_time, duration, nextday

local full_day = 86400


-- local function trans_time(str)
--     local h = string.sub(str, 0, 2)
--     local m = string.sub(str, -2)
--     return tonumber(h) * 3600 + tonumber(m) * 60
-- end

-- local function init()
--     rnd_time()
--     local time_sec = gettime()[2]
--     local sleep_time_after_start, sleep_time_after_close
--     if start_time < close_time then
--         sleep_time_after_start = close_time - start_time
--         sleep_time_after_close = full_day - close_time + start_time
--     elseif start_time > close_time then
--         sleep_time_after_start = full_day - start_time + close_time
--         sleep_time_after_close = start_time - close_time
--     end
--     if time_sec < start_time then
--         sleep(start_time - time_sec, 1000)
--     elseif time_sec > start_time then
--         sleep(full_day - time_sec + start_time, 1000)
--     end
--     sleep(sleep_time)
-- end

-- local function reset_t()
--     rnd_time()
--     local t = gettime[2]
--     local t1
--     if t > 82800 then
--         t1 = full_day - t + start_time
--     else
--         t1 = start_time - t
--     end
--     sleep(t1)
-- end


-- local cycle = function()
--     local t = gettime()[2]
--     if (t == start_time) or (t == (start_time - full_day)) then
--         start()
--         sleep(duration)
--     elseif t == (t == close_time) or (t == (close_time - full_day)) then
--         stop()
--         reset_t()
--     end
-- end

local function gettime()

    local now = os.date("%Y-%m-%d %H:%M:%S")

    --local year = string.sub(now,1,4)
    --local month = string.sub(now,6,7)
    --local day = string.sub(now,9,10)
    local hour = string.sub(now,12,13)
    local minute = string.sub(now,15,16)
    local second = string.sub(now,18,19)

    local daytime = tonumber(hour .. minute)
    local daysec = tonumber(hour)*3600 + tonumber(minute) * 60 + tonumber(second)
    local timestamp = "[" .. now .. "]"
    return daytime, daysec, timestamp

end


local function rnd_time()

    local start_time, close_time, dt

    local seed = math.floor(os.time()*10000/7)

    math.randomseed(seed, os.time()^2)

    start_time, dt = math.random(82800, 102600), math.random(900 ,1500)

    close_time = start_time + dt

    if start_time >= 86400 then
        start_time_sec = start_time - full_day
    end

    if close_time >= 86400 then
        close_time_sec = close_time - full_day
    end

    duration = dt

end


-- local function get_sleep_time()
--     local _, current_time = gettime()
--     if start_time_sec < close_time_sec then
--         sleep_time_after_start = close_time_sec - start_time_sec
--         sleep_time_after_close = full_day - close_time_sec + start_time_sec
--     elseif start_time_sec > close_time_sec then
--         sleep_time_after_start = full_day - start_time_sec + close_time_sec
--         sleep_time_after_close = start_time_sec - close_time_sec
--     end
-- end

local function init()

    local _, time_sec = gettime()
    local sleep_time
    if time_sec < start_time_sec then
        --print(start_time_sec - time_sec)
        sleep_time = start_time_sec - time_sec
    elseif time_sec > start_time_sec then
        sleep_time = full_day - time_sec + start_time_sec
    end
    print(string.format("time: %s", time_sec))
    print(string.format("start_time_sec %s\nclose_time_sec %s\nduration %s", start_time_sec, close_time_sec, duration))
    print(string.format("sleeping for: %s s", sleep_time))
    sleep(sleep_time)

    --if instant_start == 0 then
        --print(time_sec, start_time_sec)
        -- if time_sec < start_time_sec then
        --     --print(start_time_sec - time_sec)
        --     sleep(start_time_sec - time_sec, 1000)
        -- elseif time_sec > start_time_sec then
        --     sleep(full_day - time_sec + start_time_sec, 1000)
        -- end
    -- elseif instant_start == 1 then
    --     if start_time_sec < close_time_sec then
    --         if (time_sec < start_time_sec) or (time_sec > start_time_sec and time_sec < close_time_sec) then
    --             sleep_time_after_instant_start = close_time_sec - time_sec
    --         elseif time_sec > close_time_sec then
    --             sleep_time_after_instant_start = full_day - time_sec + close_time_sec
    --         end
    --     elseif start_time_sec > close_time_sec then
    --         if (time_sec > start_time_sec) or (time_sec > close_time_sec and time_sec < start_time_sec) then
    --             sleep_time_after_instant_start = full_day - time_sec + close_time_sec
    --         elseif time_sec < close_time_sec then
    --             sleep_time_after_instant_start = close_time_sec - time_sec
    --         end
    --     end
    --     start()
    --     sleep(sleep_time_after_instant_start, 1000)
    --end

end

local function autocontrol()

    local _, t = gettime()

    if t == start_time_sec then
        start()
        sleep(duration, 1000)
    elseif t == close_time_sec then
        stop()
        rnd_time()
        --get_sleep_time()
        init()
    end

end

for k, v in pairs(periphery) do
    print(k, v)
end

rnd_time()

start_time_sec, close_time_sec, duration = 1100, 1200, 100 --for testing purpose

init();

while true do
    autocontrol()
end
