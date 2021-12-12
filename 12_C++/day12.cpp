#include <iostream>
#include <fstream>
#include <vector>
#include <map>
#include <memory>

using namespace std;

class Node {
    public:
        bool isLarge;
        vector<Node*> neighbours;
        string name;

        Node() {}

        Node(string _name) {
            name = _name;
            isLarge = isupper(name[0]);
        }

        void addEdge(Node* n) {
            neighbours.push_back(n);
        }

        int countPathsToExit(map<string, int>& visited, bool twiceSmallCave) {
            // cout << "visiting " << name << endl;
            if (name == "end") {
                return 1;
            }

            visited[name] += 1;
            int paths = 0;
            for (const auto neighbour : neighbours) {
                if (neighbour->isLarge || visited[neighbour->name] == 0) {
                    paths += neighbour->countPathsToExit(visited, twiceSmallCave);
                } else if (neighbour->name != "start" && visited[neighbour->name] == 1 && !twiceSmallCave) {
                    paths += neighbour->countPathsToExit(visited, true);
                }
            }
            visited[name] -= 1;
            return paths;
        }

        friend ostream & operator<<(ostream & str, const Node& node);
};

ostream & operator<<(ostream & str, const Node& node) { 
    // print something from v to str, e.g: Str << v.getX();
    for (const auto& neighbour : node.neighbours) {
        str << neighbour->name << ",";
    }
    return str;
}

class Cave {
    public:
        map<string, Node> nodes;

        void addNode(string node) {
            nodes[node] = Node(node);
        };

        void addEdge(string _n1, string _n2) {
            if (!nodes.count(_n1)) {
                this->addNode(_n1);
            }
            if (!nodes.count(_n2)) {
                this->addNode(_n2);
            }
            Node& n1 = nodes[_n1];
            Node& n2 = nodes[_n2];
            n1.addEdge(&n2);
            n2.addEdge(&n1);
        }

        int countUniquePaths() {
            map<string, int> visited;
            return nodes["start"].countPathsToExit(visited, false);
        }

        friend ostream & operator<<(ostream & str, const Cave& cave);
};

ostream & operator<<(ostream & str, const Cave& cave) { 
    // print something from v to str, e.g: Str << v.getX();
    for (const auto& kv : cave.nodes) {
        str << kv.first << ": " << kv.second << endl;
    }
    return str;
}

int main(int argc, char* argv[]) {
    ifstream input(argv[1]);
    // Cave* cave = make_unique<Cave>();
    // auto cave = unique_ptr<Cave *>(new Cave());
    Cave cave = Cave();
    string line;
    while (getline(input, line)) {
        string n1 = line.substr(0, line.find("-"));
        string n2 = line.substr(line.find("-") + 1);
        cave.addEdge(n1, n2);
    }
    // cout << cave;;
    cout << cave.countUniquePaths();
    return 0;
}