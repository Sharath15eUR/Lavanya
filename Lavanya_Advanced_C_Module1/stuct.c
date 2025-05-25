#include <stdio.h>
#include <string.h>

#define MAX_TASKS 3
#define MAX_DAYS 7
#define MAX_LENGTH 50

struct Day {
    char dayName[10];
    char tasks[MAX_TASKS][MAX_LENGTH];
    int taskCount;
};

void inputTasks(struct Day week[]) {
    char day[10];
    int i, j;
    printf("Enter the day (e.g., Monday): ");
    scanf("%s", day);

    for (i = 0; i < MAX_DAYS; i++) {
        if (strcmp(week[i].dayName, day) == 0) {
            printf("Enter number of tasks (max 3): ");
            scanf("%d", &week[i].taskCount);
            for (j = 0; j < week[i].taskCount; j++) {
                printf("Enter task %d: ", j + 1);
                scanf(" %[^\n]s", week[i].tasks[j]);
            }
            return;
        }
    }
    printf("Invalid day!\n");
}

void displayTasks(struct Day week[]) {
    for (int i = 0; i < MAX_DAYS; i++) {
        printf("%s:\n", week[i].dayName);
        for (int j = 0; j < week[i].taskCount; j++) {
            printf("  - %s\n", week[i].tasks[j]);
        }
    }
}

int main() {
    struct Day week[MAX_DAYS] = {
        {"Monday"}, {"Tuesday"}, {"Wednesday"}, {"Thursday"},
        {"Friday"}, {"Saturday"}, {"Sunday"}
    };

    int choice;
    while (1) {
        printf("\n1. Add Tasks\n2. Display All Tasks\n3. Exit\nChoose: ");
        scanf("%d", &choice);
        switch (choice) {
            case 1: inputTasks(week); break;
            case 2: displayTasks(week); break;
            case 3: return 0;
        }
    }
}

