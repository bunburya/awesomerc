function format_bytes(bytes, use_binary)
    -- Format bytes into human-readable strings, eg, `345748394` becomes `345.7 MB`.
    local factor = use_binary and 1024 or 1000
    local units = use_binary
        and { "B", "KiB", "MiB", "GiB", "TiB", "PiB" }
        or  { "B", "KB",  "MB",  "GB",  "TB",  "PB"  }

    local i = 1
    local value = bytes

    while value >= factor and i < #units do
        value = value / factor
        i = i + 1
    end

    if i == 1 then
        return string.format("%d %s", value, units[i])
    else
        return string.format("%.1f %s", value, units[i])
    end
end

function parse_free(output)
    -- Parse the output of `free --bytes`. Returns (used, total), in bytes.
    
    -- Output of the above command looks something like:
    --                 total        used        free      shared  buff/cache   available
    --  Mem:     16476479488  7896424448  2539282432  1690472448  6469906432  8580055040
    --  Swap:    17179865088           0 17179865088

    local _, _, total, available = string.find(output, "Mem:%s+(%d+)%s+%d+%s+%d+%s+%d+%s+%d+%s+(%d+)")
    return total - available, total
end


function parse_df(output, mountpoints)
    -- Parse the output of `df`. The `mountpoints` argument is a mapping of filesystem mount points
    -- to the names to be used to describe them, eg, `{["/"] = "main", ["/mnt/storage"] = "storage"}`.
    
    -- Returns a {filesystem, used, total, pct} table for each given filesystem (the key is the given name).
    -- Values are returned in KB.
    
    -- `df` output looks something like:
    --  /dev/nvme1n1p2 244761200 215369932  16885296  93% /
    --  /dev/nvme0n1   245024372 213553568  18951468  92% /mnt/storage
    
    local stats = {}
    
    for line in output:gmatch("[^\r\n]+") do
        local _, _, total, used, pct, mp = string.find(line, "^%S+%s+(%d+)%s+(%d+)%s+%d+%s+(%d+%%)%s+(%S+)")
        local fs_name = mountpoints[mp]
        if fs_name ~= nil then 
            stats[fs_name] = {tonumber(total), tonumber(used), pct}
        end
    end
    return stats
end

function parse_net_dev(output)
    -- Parse the output of `grep <interface> /proc/net/dev` (ie, output that has been filtered
    -- to only the relevant interface, such as wlan0). Returns (down_bytes, up_bytes).
    -- Output of the above command looks something like:
    --   wlan0: 646008124  575652    0    0    0     0          0         0 51104011  328400    0    8    0     0       0          0

    local _, _, down, up = string.find(
        output,
        ":%s+(%d+)%s+%d+%s+%d+%s+%d+%s+%d+%s+%d+%s+%d+%s+%d+%s+(%d+)"
    )
    return tonumber(down), tonumber(up)
end
