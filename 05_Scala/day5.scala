import scala.io.Source
import java.util.Scanner

object Day5 {
  def main(args: Array[String]): Unit = {
    val source = Source.fromFile(args(0));
    val lines = (source.getLines()
                  .map(line => line.split(" -> ")
                    .map(_.split(',')
                      .map(_.toInt))
                    .map(co => new Point(co(0), co(1))))
                  .flatMap(points => pointsToLine(points(0), points(1)))
                  .toList
                  .groupBy(identity)
                  .mapValues(_.size)
                  .values
                  .filter(_ > 1)
                  .size)
    source.close()
    
    println(lines)
  }

  def pointsToLine(p1: Point, p2: Point) : Array[Point] = {
    val xMin = p1.x.min(p2.x)
    val yMin = p1.y.min(p2.y)
    val xMax = p1.x.max(p2.x)
    val yMax = p1.y.max(p2.y)
    if (p1.x == p2.x) {
      return yMin.to(yMax).toArray.map(y => new Point(p1.x, y))
    } else if (p1.y == p2.y) {
      return xMin.to(xMax).toArray.map(x => new Point(x, p1.y))
    } else if ((p2.y - p1.y)/(p2.x - p1.x) > 0) { // positive diagonal
      return (xMin.to(xMax) zip yMin.to(yMax)).map { case (x, y) => new Point(x, y) }.toArray
      // return Array[Point]() // Used in part 1
    } else { // negative diagonal
      return (xMin.to(xMax) zip yMax.to(yMin, -1)).map { case (x, y) => new Point(x, y) }.toArray
    }
  }

  case class Point(var x: Int, var y: Int) {
    override def toString: String =
      s"($x, $y)"
  }
}