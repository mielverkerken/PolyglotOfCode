<?php
$lines = file($argv[1], FILE_IGNORE_NEW_LINES) or die("Unable to open file $argv[1]");
$dots = array();
$folds = array();
$reading_dots = true;
foreach ($lines as $line) {
    if ($line == "") {
        $reading_dots = false;
    } else if ($reading_dots) {
        $dots[] = array_map('intval', explode(",", $line));
    } else {
        $pos = strpos($line, "=");
        $folds[] = [substr($line, $pos-1, 1) == "x" ? 0 : 1, intval(substr($line, $pos+1))];
    }
}

$i = 0;
foreach ($dots as &$dot) {
    // Part 1
    // $fold = $folds[0];
    // if ($dot[$fold[0]] > $fold[1]) {
    //     $dot[$fold[0]] = $fold[1] - ($dot[$fold[0]] - $fold[1]);
    // }
    // Part 2
    foreach ($folds as $fold) {
        if ($dot[$fold[0]] > $fold[1]) {
            $dot[$fold[0]] = $fold[1] - ($dot[$fold[0]] - $fold[1]);
        }
    }
}

$result = array();
for ($i=0; $i<count($dots); $i++) {
    $result[join(',', $dots[$i])] = 1;
}
echo (count($result) . "\n");

for ($j=0; $j<7; $j++) {
    for ($i=0; $i<100; $i++) {
        // echo $i . "," . $j . "\n";
        echo(array_key_exists($i . "," . $j, $result) ? "#" : ".");
    }
    echo "\n";
}
?>