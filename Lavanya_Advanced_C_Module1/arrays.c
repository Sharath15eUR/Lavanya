
#include <stdio.h>

int searchMatrix(int matrix[][100], int n, int key) {
    int i = 0, j = n - 1;

    while (i < n && j >= 0) {
        if (matrix[i][j] == key)
            return 1;
        else if (matrix[i][j] > key)
            j--;
        else
            i++;
    }
    return 0;
}

int main() {
    int n = 4;
    int matrix[100][100] = {
        {10, 20, 30, 40},
        {15, 25, 35, 45},
        {27, 29, 37, 48},
        {32, 33, 39, 50}
    };

    int key = 29;
    if (searchMatrix(matrix, n, key))
        printf("Key Found\n");
    else
        printf("Key Not Found\n");

    return 0;
}
