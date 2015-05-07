#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
	const char message[] = "Eat at Joe's!";
	puts(message);
	printf("%s, %d, %d, %d, %d\n", message, 2, 2, 5, 2);
	return 0;
}
