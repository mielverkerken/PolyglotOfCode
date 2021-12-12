#!/usr/bin/env ts-node

import * as fs from 'fs'

type SimulationResult = {
    map : number[][];
    flashes : number;
}

class Point {
    x : number;
    y : number;

    constructor (x: number, y: number) {
        this.x = x;
        this.y = y;
    }

    static Add(p1 : Point, p2 : Point) {
        return new Point(p1.x + p2.x, p1.y + p2.y)
    }
}

const neighbours : Point[] = [
    new Point(-1, -1), 
    new Point(-1, 0), 
    new Point(-1, 1), 
    new Point(0, -1), 
    new Point(0, 1), 
    new Point(1, -1), 
    new Point(1, 0), 
    new Point(1, 1), 
]

function insideGrid(p : Point, grid : number[][]) : boolean {
    return p.x >= 0 && p.x < grid.length && p.y >= 0 && p.y < grid[0].length
}

function simulateStep(grid : number[][]) : SimulationResult {
    let newFlashes : Set<Point> = new Set<Point>();

    // Increase values by one on each step
    grid = grid.map(row => row.map(value => value + 1))

    // Find all charged octupuses 
    let flashStack : Point[] = grid.map((row : number [], rowIndex : number) : Point[] => 
        row.map((value : number, colIndex: number) : [value : number, point : Point] => [value, new Point(rowIndex, colIndex)])
        .filter((value : [number, Point]) => value[0] > 9)
        .map((value : [number, Point]) : Point => value[1])
    ).flat();

    // iterate over all charged octupuses and update its neighbours
    while(flashStack.length > 0) {
        let nextPoint : Point = flashStack.pop()!;
        newFlashes.add(nextPoint);
        neighbours
            .map((p : Point) => Point.Add(p, nextPoint))
            .filter(p => insideGrid(p, grid))
            .forEach((p : Point) => {
                grid[p.x][p.y] += 1;
                if (grid[p.x][p.y] == 10) {
                    flashStack.push(p);
                }
        }) 
    }

    // Reset flashed octopuses
    grid = grid.map(row => row.map(value => value > 9 ? 0 : value))
    return { map: grid, flashes: newFlashes.size }
}

function printGrid(grid : number[][]) {
    grid.forEach((row : number[]) => console.log(row.join("")));
    console.log();
}

let grid : number[][] = fs.readFileSync(process.argv[2], 'utf-8').split("\n").map(line => line.split("").map(s => parseInt(s)))
let flashes : number = 0;
printGrid(grid);
// part 1
// for (let step = 0; step < 100; step++) {
//     let simulationResult : SimulationResult = simulateStep(grid);
//     grid = simulationResult.map;
//     // printGrid(simulationResult.map);
//     flashes += simulationResult.flashes;
// }
// console.log(flashes);

// part 2
let steps : number = 0;
while (flashes != grid.length * grid[0].length) {
    let simulationResult : SimulationResult = simulateStep(grid);
    grid = simulationResult.map;
    flashes = simulationResult.flashes;
    steps++;
}
console.log(steps);