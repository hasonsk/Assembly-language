#include <iostream>
using namespace std;
#define MAX = 100

// Sử dụng con trỏ
void sortByHeight(int A[], int n) {   
    int *indexMin;
    for(int i = 0; i < n; i++) {
        if(A[i] < 0) continue;
        indexMin = &(A[i]);
        for(int j = i+1; j < n; j++) {
            if(A[j] > 0 && A[j] < *indexMin) {
                indexMin = &(A[j]);
            }
        }
        int temp = A[i];
        A[i] = *indexMin;
        *indexMin = temp;
    }
}

void printArray(int A[], int n) {
    for(int i = 0; i < n; i++) cout<< A[i]<< " ";
}

int main() {
    int A[100] = {-1, 150, 190, 170, -1, -1, 160, 180, 155, 170};
    sortByHeight(A, 10);
    printArray(A, 10);
    return 0;
}
