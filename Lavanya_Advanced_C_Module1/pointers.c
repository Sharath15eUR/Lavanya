#include <stdio.h>

void rearrange(int *arr, int size) {
    int temp[size];
    int *ptr = arr;
    int *end = temp, *start = temp;
    
    for (int i = 0; i < size; i++, ptr++) {
        if (*ptr % 2 == 0) {
            *end++ = *ptr;
        }
    }

    ptr = arr;
    for (int i = 0; i < size; i++, ptr++) {
        if (*ptr % 2 != 0) {
            *end++ = *ptr;
        }
    }

    for (int i = 0; i < size; i++) {
        *(arr + i) = *(start + i);
    }
}

int main() {
    int arr[] = {3, 2, 1, 4, 7, 6};
    int size = sizeof(arr) / sizeof(arr[0]);

    rearrange(arr, size);

    for (int i = 0; i < size; i++) {
        printf("%d ", *(arr + i));
    }
    return 0;
}
