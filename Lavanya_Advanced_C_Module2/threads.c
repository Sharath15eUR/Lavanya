#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <signal.h>

int N;
int running = 1;

void handle_signal(int sig) {
    printf("\nCaught signal %d. Terminating threads safely.\n", sig);
    running = 0;
}

int isPrime(int n) {
    if (n <= 1) return 0;
    for (int i = 2; i*i <= n; i++)
        if (n % i == 0) return 0;
    return 1;
}

void* threadA(void* arg) {
    int count = 0, num = 2, sum = 0;
    while (count < N) {
        if (isPrime(num)) {
            sum += num;
            count++;
        }
        num++;
    }
    printf("Sum of first %d prime numbers is %d\n", N, sum);
    pthread_exit(NULL);
}

void* threadB(void* arg) {
    while (running) {
        printf("Thread 1 running\n");
        sleep(2);
    }
    pthread_exit(NULL);
}

void* threadC(void* arg) {
    int t = 0;
    while (t < 100 && running) {
        printf("Thread 2 running\n");
        sleep(3);
        t += 3;
    }
    pthread_exit(NULL);
}

int main() {
    signal(SIGINT, handle_signal);
    
    pthread_t t1, t2, t3;

    printf("Enter value of N: ");
    scanf("%d", &N);

    pthread_create(&t1, NULL, threadA, NULL);
    pthread_create(&t2, NULL, threadB, NULL);
    pthread_create(&t3, NULL, threadC, NULL);

    pthread_join(t1, NULL);
    pthread_join(t2, NULL);
    pthread_join(t3, NULL);

    return 0;
}
