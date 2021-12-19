module Day18

mutable struct Element
    value::Int
    depth::Int
end

function parseLine(line)::Vector{Element}
    pairs = Vector{Element}()
    depth = 0
    for c in line
        if c == '['
            depth += 1
        elseif c == ']'
            depth -= 1
        elseif isdigit(c)
            i = parse(Int, c)
            push!(pairs, Element(i, depth))
        end
    end
    return pairs
end

function printDebug(snail::Vector{Element})
    for e in snail
        print("(" * string(e.value) * " " * string(e.depth) * ")")
    end
    println()
end

function printSnail(snail::Vector{Element})
    currentDepth = 0
    for e in snail
        if currentDepth == e.depth
            print(",")
        end
        while currentDepth != e.depth
            if currentDepth > e.depth
                print("]")
                currentDepth -= 1
            elseif currentDepth < e.depth
                print("[")
                currentDepth += 1
            end
        end
        print(string(e.value))
    end
    while currentDepth != 0
        print("]")
        currentDepth -= 1
    end
    println()
end

function explode(snails::Vector{Element})
    for (i, snail) in enumerate(snails)
        # println(i)
        if snail.depth > 4
            if i > 1
                snails[i-1].value += snail.value
            end
            removedSnail = popat!(snails, i+1)
            if i < size(snails, 1)
                snails[i+1].value += removedSnail.value
            end
            snail.depth -= 1
            snail.value = 0
            return snails, true
        end
    end
    return snails, false
end

function splitSnail(snails::Vector{Element})
    for (i, snail) in enumerate(snails)
        # println(i)
        if snail.value >= 10
            newValue = snail.value / 2
            snail.value = floor(newValue)
            snail.depth += 1
            insert!(snails, i+1, Element(ceil(newValue), snail.depth))
            return snails, true
        end
    end
    return snails, false
end

function add(left::Vector{Element}, right::Vector{Element})::Vector{Element}
    append!(left, right)
    for e in left
        e.depth += 1
    end
    return left
end

function reduceSnail(snails::Vector{Element})::Vector{Element}
    exploded = true
    splitted = true
    while exploded || splitted
        snails, exploded = explode(snails)
        if !exploded
            snails, splitted = splitSnail(snails)
        end
    end
    return snails
end

function magnitude(snails::Vector{Element})::Int64
    magnitude = 0
    while size(snails, 1) > 1
        for i in 1:(size(snails, 1)-1)
            if snails[i].depth == snails[i+1].depth
                snails[i].value = 3*snails[i].value + 2*snails[i+1].value
                snails[i].depth -= 1
                deleteat!(snails, i+1)
                break
            end
        end
    end
    return snails[1].value
end

function part1()
    input = open(ARGS[1], "r") do file
        read(file, String)
    end

    lines = split(input, "\n")
    snails = parseLine(lines[1])
    printSnail(snails)
    for line in lines[2:end]
        snails = add(snails, parseLine(line))
        printSnail(snails)
        reduceSnail(snails)
        printSnail(snails)
    end
    println(string(magnitude(snails)))
end

function part2()
    input = open(ARGS[1], "r") do file
        read(file, String)
    end
    lines = split(input, "\n")

    maxMagnitude = 0
    for line1 in lines
        for line2 in lines
            snail = add(parseLine(line1), parseLine(line2))
            reduceSnail(snail)
            m = magnitude(snail)
            if m > maxMagnitude
                maxMagnitude = m
            end
        end
    end
    println(string(maxMagnitude))
end

part2()

end