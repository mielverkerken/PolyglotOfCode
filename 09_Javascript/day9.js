var fs = require('fs')
var path = require('path')
var filePath = path.join(__dirname, process.argv[2])

fs.readFile(filePath, 'utf8', function(err, data) {
    if (!err) {
        var heatmap = data.split("\n").map(line => line.split('').map(s => parseInt(s))) 
        solve(heatmap)
    } else {
        console.log(err)
    }
})

function solve(heatmap) {
    var risk = 0
    var basins = []
    for (i=0; i<heatmap.length; i++) {
        for (j=0; j<heatmap[0].length; j++) {
            if (!hasLowerNeighbour(i, j, heatmap)) {
                risk += 1 + heatmap[i][j]
                var visited = Array.from({length: heatmap.length}, () => Array.from({length: heatmap[0].length}, () => false))
                basins.push(sizeOfBasin(i, j, heatmap, visited))
            }
        }
    }
    basins = basins.sort((a, b) => b - a)
    console.log("risk: "+ risk)
    console.log("basins: "+ basins[0] * basins[1] * basins[2])
}

function insideGrid(x, y, heatmap) {
    return x >= 0 && x < heatmap.length && y >= 0 && y< heatmap[0].length
}

function hasLowerNeighbour(x, y, heatmap) {
    return (insideGrid(x-1, y, heatmap) && heatmap[x-1][y] <= heatmap[x][y]) ||
        (insideGrid(x+1, y, heatmap) && heatmap[x+1][y] <= heatmap[x][y]) ||
        (insideGrid(x, y-1, heatmap) && heatmap[x][y-1] <= heatmap[x][y]) ||
        (insideGrid(x, y+1, heatmap) && heatmap[x][y+1] <= heatmap[x][y])
}

function sizeOfBasin(x, y, heatmap, visited) {
    if (!insideGrid(x, y, heatmap)) return 0
    if (visited[x][y]) return 0
    visited[x][y] = true
    if (heatmap[x][y] == 9) return 0
    return 1 + sizeOfBasin(x-1, y, heatmap, visited) 
        + sizeOfBasin(x+1, y, heatmap, visited) 
        + sizeOfBasin(x, y-1, heatmap, visited) 
        + sizeOfBasin(x, y+1, heatmap, visited)
}