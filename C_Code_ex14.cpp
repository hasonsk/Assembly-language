#include <iostream>
using namespace std;




int commonCharacterCount(string str1, string str2) {
    string C = str2;   // strcpy str2 -> C
    int count = 0;
    for(int i = 0; str1[i] != 0; i++) {
        for(int j = 0; C[j] != 0; j++) {
            if(str1[i] == C[j]){
                count++;
                C[j] = ' '; // mark as visited
            }
        }
    }
    return count;

}

int main() {
    string str1 = "aasbcc";
    string str2 = "abcdef";
    cout << commonCharacterCount(str1, str2);
}