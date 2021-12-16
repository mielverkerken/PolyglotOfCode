import java.io.File

var sumVersions = 0;

class Packet(val version: Int, val type: Int, val function: (List<Packet>) -> Long) {
    var subPackets: List<Packet> = mutableListOf();
    fun calculate() : Long = function(this.subPackets)
}

fun main(args: Array<String>) {
    println("Program arguments: ${args.joinToString()}");
    val input = readInput(args[0]);
    println(input);
    val (packet, _) = parsePackets(input);
    println(sumVersions)
    println(packet.calculate())
}

fun readInput(fileName: String): List<Char> =
    File(fileName).readText(Charsets.UTF_8)
        .dropLast(2)
        .flatMap { it.digitToInt(16).toString(2).padStart(4, '0').asIterable() };

fun List<Char>.sliceToDecimal(startIndex: Int, endIndex: Int): Int =
    slice(startIndex..endIndex).joinToString("").toInt(2);

fun parsePackets(input: List<Char>, index: Int = 0) : Pair<Packet, Int> {
    val version = input.sliceToDecimal(index, index + 2);
    val type = input.sliceToDecimal(index + 3, index + 5);
    sumVersions += version
    if (type == 4) {
        val (literal, index) = parseLiteralPacket(input, index + 6)
        return Pair(Packet(version, type, fun (_: List<Packet>) : Long { return literal }), index)
    } else {
        val function: (List<Packet>) -> Long = when (type) {
            0 -> fun (list: List<Packet>): Long { return list.sumOf { p -> p.calculate() } }
            1 -> fun (list: List<Packet>): Long { return list.map { p -> p.calculate() }.reduce{ acc, el -> acc * el } }
            2 -> fun (list: List<Packet>): Long { return list.minOf { p -> p.calculate() } }
            3 -> fun (list: List<Packet>): Long { return list.maxOf { p -> p.calculate() } }
            5 -> fun (list: List<Packet>): Long { return if (list.get(0).calculate() > list.get(1).calculate()) 1 else 0 }
            6 -> fun (list: List<Packet>): Long { return if (list.get(0).calculate() < list.get(1).calculate()) 1 else 0 }
            7 -> fun (list: List<Packet>): Long { return if (list.get(0).calculate() == list.get(1).calculate()) 1 else 0 }
            else -> error("Type does not exist")
        }
        val (subPackets, index) = parseOperatorPacket(input, index + 6)
        val packet = Packet(version, type, function)
        packet.subPackets = subPackets
        return Pair(packet, index)
    }
}

fun parseLiteralPacket(input: List<Char>, _index: Int) : Pair<Long, Int> {
    val literal = StringBuilder();
    var index = _index;
    do {
        val lastBlock = input.get(index) == '0';
        input.slice((index + 1)..(index + 4)).forEach { char -> literal.append(char) }
        index += 5;
    } while (!lastBlock)
    println("Literal at pos $index: $literal(${literal.toString().toLong(2)})")
    return Pair(literal.toString().toLong(2), index);
}

fun parseOperatorPacket(input: List<Char>, _index: Int) : Pair<List<Packet>, Int> {
    var index = _index;
    val lengthTypeId = input.get(_index);
    val lengthOffset = if (lengthTypeId == '0') 15 else 11;
    val lengthOfSubPackets = input.sliceToDecimal(index + 1, index + lengthOffset);
    var count = 0;
    index += lengthOffset + 1
    val startIndex = index
    val subPackets: MutableList<Packet> = mutableListOf();
    while (if (lengthTypeId == '1') count < lengthOfSubPackets else index < startIndex + lengthOfSubPackets) {
        val (packet, i) = parsePackets(input, index)
        subPackets.add(packet)
        index = i
        count++;
    }
    return Pair(subPackets, index);
}
