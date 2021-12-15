import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:core';
import 'dart:collection';
import 'dart:math';

void main(List<String> arguments) {
  var lines = new File(arguments[0]).readAsLinesSync();
  var sequences = initMap(lines[0]);
  print(sequences);
  lines.removeRange(0, 2);

  var insertionMap = new Map();
  for (var line in lines) {
    var transformation = line.split(" -> ");
    insertionMap[transformation[0]] = transformation[1];
  }
  print(insertionMap);

  for (int i=0; i<40; i++) {
    sequences = applyInsertion(sequences, insertionMap);
    print(sequences);
  }

  var sorted = result.entries.toList()..sort((e1, e2) {
    var diff = e2.value.compareTo(e1.value);
    if (diff == 0) diff = e2.key.compareTo(e1.key);
    return diff;
  });
  print(sorted);
}

LinkedHashMap initMap(String template) {
  var map = new LinkedHashMap();
  for (int i = 0; i < template.length-1; i++) {
    map.update(template.substring(i, i+2), (value) => value+1, ifAbsent: () => 1);
  }
  return map;
}

LinkedHashMap applyInsertion(Map sequence, Map insertion) {
  var result = new LinkedHashMap();
  for (MapEntry e in sequence.entries) {
    result.update(e.key[0] + insertion[e.key], (value) => value + e.value, ifAbsent: () => e.value);
    result.update(insertion[e.key] + e.key[1], (value) => value + e.value, ifAbsent: () => e.value);
  }
  return result;
}

Map countOccurences(LinkedHashMap sequences) {
  var result = new LinkedHashMap();
  for (MapEntry e in sequences.entries) {
    result.update(e.key[0], (value) => value + e.value, ifAbsent: () => e.value);
    result.update(e.key[1], (value) => value + e.value, ifAbsent: () => e.value);
  }
  return result.map((key, value) => MapEntry(key, (value / 2).ceil()));
}