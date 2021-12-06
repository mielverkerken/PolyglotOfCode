#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void solve1(char* filename);
void solve2(char* filename);

int main(int argc, char** argv) {
	solve2(argv[1]);
	return 0;
}

void solve2(char* filename) {
	FILE *fp = fopen(filename, "r");
	char buff[255];

	int depth = 0;
	int x_pos = 0;
	int aim = 0;
	char delim[] = " ";

	if (fp) {
		while (fgets(buff, sizeof buff, (FILE*)fp) != NULL) {
			char *action = strtok(buff, delim);
			int value = atoi(strtok(NULL, delim));
			// printf("%s - %d", action, value);
			if (!strcmp(action, "forward")) {
				x_pos += value;
				depth += aim * value;
			} else if (!strcmp(action, "down")) {
				aim += value;
			} else {
				aim -= value;
			}
		}
		printf("depth: %d\nx_pos: %d\nmultiplied: %d", depth, x_pos, depth*x_pos);
	}
	fclose(fp);
}

void solve1(char* filename) {
	FILE *fp = fopen(filename, "r");
	char buff[255];

	int depth = 0;
	int x_pos = 0;
	char delim[] = " ";

	if (fp) {
		while (fgets(buff, sizeof buff, (FILE*)fp) != NULL) {
			char *action = strtok(buff, delim);
			int value = atoi(strtok(NULL, delim));
			// printf("%s - %d", action, value);
			if (strcmp(action, "forward") == 0) {
				x_pos += value;
			} else if (strcmp(action, "down") == 0) {
				depth += value;
			} else {
				depth -= value;
			}
		}
		printf("depth: %d\nx_pos: %d\nmultiplied: %d", depth, x_pos, depth*x_pos);
	}
	fclose(fp);
}
