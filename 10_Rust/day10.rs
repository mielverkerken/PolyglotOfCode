fn main() {
    let filename = std::env::args().nth(1).expect("no filename given");
    let contents = std::fs::read_to_string(filename).expect("Something went wrong reading the file");

    let mut points = 0;
    let mut completion_scores = Vec::<u64>::new();
    for line in contents.lines() {
        let mut corrupted = false;
        println!("{}", line);
        let mut open_chunks = Vec::<char>::new();
        for c in line.chars() {
            if is_open_bracket(c) {
                open_chunks.push(closed_bracket(c));
            } else if open_chunks.last() == Some(&c) {
                open_chunks.pop();
            } else {
                println!("corrupted line");
                points += points_for_bracket(c);
                corrupted = true;
                break;
            }
        }
        if !corrupted {
            println!("incomplete line");
            let score = open_chunks.iter().rev().map(|c| match c {
                ')' => 1,
                ']' => 2,
                '}' => 3,
                '>' => 4,
                _   => 0
            }).reduce(|a, b| a*5 + b).unwrap();
            completion_scores.push(score);
        }
    }
    println!("{}", points);
    completion_scores.sort();
    println!("{}", completion_scores[completion_scores.len() / 2])
}

fn is_open_bracket(c:char) -> bool {
    match c {
        '(' => true,
        '[' => true,
        '{' => true,
        '<' => true,
        _   => false
    }
}

fn closed_bracket(c:char) -> char {
    match c {
        '(' => ')',
        '[' => ']',
        '{' => '}',
        '<' => '>',
        _   => ' '
    }
}

fn points_for_bracket(c:char) -> u64 {
    match c {
        ')' => 3,
        ']' => 57,
        '}' => 1197,
        '>' => 25137,
        _   => 0
    }
}
