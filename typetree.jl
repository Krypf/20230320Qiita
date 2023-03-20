#%%
function showtypetree(T, io, level=0, tab=8)
    ladder = "ᴸ" * repeat("-", 3)
    if level > 0
        print(repeat(" ", tab*level-4))# 4 12 
        # print(repeat("\t", level))
        print(ladder)
        write(io, repeat("\t", level))# text file
        write(io, ladder)
    end
    println(T)
    write(io, string(T)* "\n")
    for t in subtypes(T)
        showtypetree(t, io, level+1)# recurrence
    end
    # https://en.wikibooks.org/wiki/Introducing_Julia/Types
end

function writetypetree(T; showtypetree=showtypetree)
    file_name = string(T) * ".txt"
    io = IOBuffer();# print save

    showtypetree(T, io)
    out = open(file_name,"w")
        write(out, String(take!(io)))
    close(out)
    return "Done"
end
T = Number# select types
# T = AbstractArray
writetypetree(T)
#%%
using Dates# to measure time
function stopcode_bytime(t0, threshold)
    now() - t0 > Dates.Second(threshold)
end
#%%
function showAnytree(T, io, t0, level=0, tab=8,threshold=10)
    ladder = "ᴸ" * repeat("-", 3)
    if level > 0
        print(level, " ")# substitute for a progress bar
        write(io, repeat("\t", level))
        write(io, ladder)
    end
    # println(T)
    write(io, string(T)* "\n")
    for t in subtypes(T)
        if t == Any
            continue# prevent an infinite loop
        end
        showAnytree(t, io, t0, level+1)
        if stopcode_bytime(t0, threshold)
            println("Time is up.")
            break
        end
    end
    # https://en.wikibooks.org/wiki/Introducing_Julia/Types
end
function writeAnytree(T, t0; showtypetree=showtypetree, threshold=threshold)
    file_name = string(T) * ".txt"
    io = IOBuffer();

    showtypetree(T, io, t0)
    out = open(file_name,"w")
        write(out, String(take!(io)))
    close(out)
    return "Done"
end
begin# reset the present time t0
    t0 = now()
    threshold = 10::Int64# not Float64
    @time writeAnytree(Any, t0;showtypetree=showAnytree, threshold=threshold)
end
