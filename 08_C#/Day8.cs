namespace AdventOfCode
{
    class Day8
    {
        static void Main(string[] args)
        {
            string file = "input.txt"; // args[0]
            string[] lines = System.IO.File.ReadAllLines(file);
            int sum = 0;
            foreach (string line in lines)
            {
                // Console.WriteLine(line);
                int index = line.IndexOf(" | ");
                string[] unique = line.Substring(0, index).Split(' ');
                string[] display = line.Substring(index+3).Split(' ');

                ISet<char>[] uniqueSet = new SortedSet<char>[unique.Length];
                for (int i = 0; i < unique.Length; i++)
                {
                    uniqueSet[i] = stringToSet(unique[i]);
                }

                ISet<char>[] displaySet = new SortedSet<char>[display.Length];
                for (int i = 0; i < display.Length; i++)
                {
                    displaySet[i] = stringToSet(display[i]);
                }

                int result = solveCase(uniqueSet, displaySet);
                sum += result;
            }
            Console.WriteLine(sum);
            // Console.ReadKey();

        }

        static int solveCase(ISet<char>[] unique, ISet<char>[] display)
        {
            var solution = new Dictionary<string, int>();
            List<ISet<char>> length5 = new List<ISet<char>>();
            List<ISet<char>> length6 = new List<ISet<char>>();
            ISet<char> one = new HashSet<char>();
            ISet<char> four = new HashSet<char>();
            ISet<char> three = new HashSet<char>();
            for (int i = 0; i < unique.Length; i++)
            {
                switch (unique[i].Count)
                {
                    case 2:
                        solution.Add(setToString(unique[i]), 1);
                        one = unique[i];
                        break;
                    case 3:
                        solution.Add(setToString(unique[i]), 7);
                        break;
                    case 4:
                        solution.Add(setToString(unique[i]), 4);
                        four = unique[i];
                        break;
                    case 7:
                        solution.Add(setToString(unique[i]), 8);
                        break;
                    case 5:
                        length5.Add(unique[i]);
                        break;
                    case 6:
                        length6.Add(unique[i]);
                        break;
                }
            }

            foreach (ISet<char> set in length5)
            {
                if (set.Intersect(one).Count() == 2)
                {
                    solution.Add(setToString(set), 3);
                    three = set;
                    length5.Remove(set);
                    break;
                }
            }

            foreach (ISet<char> set in length5)
            {
                switch (set.Intersect(four).Count())
                {
                    case 2:
                        solution.Add(setToString(set), 2);
                        break;
                    case 3:
                        solution.Add(setToString(set), 5);
                        break;
                }
            }

            foreach (ISet<char> set in length6)
            {
                if (set.Intersect(one).Count() != 2)
                {
                    solution.Add(setToString(set), 6);
                    length6.Remove(set);
                    break;
                }
            }

            foreach (ISet<char> set in length6)
            {
                switch (set.Intersect(three).Count())
                {
                    case 5:
                        solution.Add(setToString(set), 9);
                        break;
                    case 4:
                        solution.Add(setToString(set), 0);
                        break;
                }
            }


            int result = 0;
            for (int i = 0; i < display.Length; i++)
            {
                result *= 10;
                result += solution[setToString(display[i])];
            }
            return result;
        }

        static ISet<char> stringToSet(string s)
        {
            ISet<char> set = new SortedSet<char>();
            foreach (char c in s.ToCharArray())
            {
                set.Add(c);
            }
            return set;
        }

        static string setToString(ISet<char> s)
        {
            return string.Join("", s.ToArray());
        }
    }
}