function format_bytes(bytes, use_binary)
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
    
    -- The output looks like:
    --                 total        used        free      shared  buff/cache   available
    --  Mem:     16476479488  7896424448  2539282432  1690472448  6469906432  8580055040
    --  Swap:    17179865088           0 17179865088

    local _, _, total, available = string.find(output, "Mem:%s+(%d+)%s+%d+%s+%d+%s+%d+%s+%d+%s+(%d+)")
    return total - available, total
end


function parse_filtered_df(output)
    -- Parse the output of `df | grep "<fs1name>|<fs2name>"` (ie, output that has been filtered to
    -- only the relevant filesystems). Returns a {filesystem, used, total, pct} table for each
    -- given filesystem. Values are returned in KB.
    
    -- Output looks something like:
    --  /dev/nvme1n1p2 244761200 215369932  16885296  93% /
    --  /dev/nvme0n1   245024372 213553568  18951468  92% /mnt/storage
    
    local stats = {}
    
    for line in output:gmatch("[^\r\n]+") do
        local _, _, fs, total, used, pct = string.find(line, "^(%S+)%s+(%d+)%s+(%d+)%s+%d+%s+(%d+%%)")
        stats[fs] = {total, used, pct}
    
    end
    return stats
end
