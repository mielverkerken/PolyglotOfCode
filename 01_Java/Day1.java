import java.io.FileNotFoundException;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class Day1 {
    public static void main(String[] args) throws FileNotFoundException {
        System.out.println("Part 1: " + solve1(args[0]));
        System.out.println("Part 2: " + solve2(args[0]));
    }

    public static int solve1(String filename) throws FileNotFoundException {
        Scanner sc = new Scanner(new File(filename));
        int previousInt = Integer.MAX_VALUE;
        int count = 0;
        while(sc.hasNext()) {
            int nextInt = sc.nextInt();
            if (nextInt > previousInt) count++;
            previousInt = nextInt;
        }
        return count;
    }

    public static int solve2(String filename) throws FileNotFoundException {
        Scanner sc = new Scanner(new File(filename));
        List<Integer> numbers = new ArrayList<>();
        while(sc.hasNext()) {
            numbers.add(sc.nextInt());
        }

        int previousSum = Integer.MAX_VALUE;
        int count = 0;
        for (int i = 0; i<numbers.size()-2; i++) {
            int sum = numbers.get(i) + numbers.get(i+1) + numbers.get(i+2);
            if (sum > previousSum) count++;
            previousSum = sum;
        }
        return count;
    }
}
