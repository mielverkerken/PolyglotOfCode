package main

import (
    "fmt"
    "os"
    "log"
    "bufio"
    "strings"
    "strconv"
)

type board struct {
    grid [][]int
    used [][]bool
    rows int
    cols int
    finished bool
}

func main() {
    file, err:= os.Open(os.Args[1])
    if err != nil {
        log.Fatal(err)
    }
    defer file.Close()

    // Parse input file
    scanner := bufio.NewScanner(file)
    scanner.Scan()
    firstLine := scanner.Text()
    numberOrder := toInts(strings.Split(firstLine, ","))
    fmt.Println(numberOrder)

    scanner.Scan() // Skip empty line in between

    var boards []*board
    currentGrid := [][]int{}

    // Parse file line by line
    for scanner.Scan() {
        line := scanner.Text()
        if line == "" {
            boards = append(boards, newBoard(currentGrid))
            currentGrid = [][]int{}
        } else {
            currentGrid = append(currentGrid, toInts(strings.Fields(line)))
        }
    }

    // for _, b := range boards {
    //     printBoard(b)
    // }

    if err := scanner.Err(); err != nil {
        log.Fatal(err)
    }

    // Run the game
    for _, number := range numberOrder {
        // fmt.Println("Number: ", number)
        for _, board := range boards {
            if !board.finished {
                board = updateBoard(board, number)
                // printBoard(board)
                if hasWon(board) {
                    board.finished = true
                    fmt.Println(scoreBoard(board, number))
                    // printBoard(board)
                    // os.Exit(0)
                }
            }
        }
    }
}

func check(e error) {
    if e != nil {
        panic(e)
    }
}

func newBoard(grid [][]int) *board {
    b := board{grid: grid, rows: len(grid), cols: len(grid[0])}
    b.used = make([][]bool, b.rows)
    for i := range b.used {
        b.used[i] = make([]bool, b.cols)
    }
    return &b
}

func updateBoard(b *board, n int) *board {
    for i, row := range b.grid {
        for j, number := range row {
            if number == n {
                b.used[i][j] = true
                return b
            }
        }
    }
    return b
}

func hasWon(b *board) bool {
    // Check rows
    for i := 0; i < b.rows; i++ {
        rowTrue := true
        for j := 0; j < b.cols; j++ {
            if !b.used[i][j] {
                rowTrue = false
            }
        }
        if rowTrue {
            return true
        }
    }
    // Check columns
    for j := 0; j < b.cols; j++ {
        colTrue := true
        for i := 0; i < b.rows; i++ {
            if !b.used[i][j] {
                colTrue = false
            }
        }
        if colTrue {
            return true
        }
    }
    return false
}

func scoreBoard(b *board, lastNumber int) int {
    score := 0
    for i := 0; i < b.rows; i++ {
        for j := 0; j < b.cols; j++ {
            if !b.used[i][j] {
                score += b.grid[i][j]
            }
        }
    }
    fmt.Println("Unmarked: ", score, "   LastNumber: ", lastNumber)
    return score * lastNumber
}

func toInts(strings []string) []int {
    var ints []int
    // Convert array of strings to array of ints
    for _, s := range strings {
        i, err := strconv.Atoi(s)
        check(err)
        ints = append(ints, i)
    }
    return ints
}

func printBoard(b *board) {
    for i := 0; i < b.rows; i++ {
        for j := 0; j < b.cols; j++ {
            fmt.Print(b.grid[i][j])
            if b.used[i][j] {
                fmt.Print("* ")
            } else {
                fmt.Print(" ")
            }
        }
        fmt.Println()
    }
    fmt.Println()
}