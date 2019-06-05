-- utf8: https://www.utf8-chartable.de/unicode-utf8-table.pl?start=19968&number=128&utf8=0x&htmlent=1
require "bit"
local string_byte = string.byte
local function get_unicode_value(first_byte, second_byte, third_byte)
    local f = bit.lshift(bit.band(first_byte, 0x0F), 12)
    local s = bit.lshift(bit.band(second_byte, 0x3F), 6)
    local t = bit.band(third_byte, 0x3F)
    local unicode_val = bit.bor(f, s, t)
    return unicode_val
end

local function is_legal_name(s)
    local ret = true
    local i, l = 1, s:len()
    while i <= l do
        local first_byte = string_byte(s, i)
        if bit.bxor(bit.rshift(first_byte, 4), 0x0E) == 0x00 then 
            local second_byte, third_byte = string_byte(s, i+1), string_byte(s, i+2)
            local unicode_val = get_unicode_value(first_byte, second_byte, third_byte)
            if unicode_val >= 0x4E00 and unicode_val <= 0x9FA5 then                
                i = i + 3
            else
                ret = false
                break
            end
        else
            if (first_byte >= 0x41 and first_byte <= 0x5A) or (first_byte >= 0x61 and first_byte <= 0x7A) then 
                i = i + 1
            else    
                ret = false
                break
            end
        end
    end
    return ret
end

--sample
local useful = is_legal_name("hello《》") --false
useful = is_legal_name("你豪") --true
