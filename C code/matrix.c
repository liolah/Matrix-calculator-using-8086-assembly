#include <stdio.h>

void print(int m[10][10], int r, int c) {
  printf("\n");
  for (int i = 0;i < r;i++) {
    for (int j = 0;j < c;j++) {
      printf("%d\t", m[i][j]);
      }
    printf("\n");
    }
  printf("\n");
  }

// Validation is built in each function
void mul(int a[10][10], int r1, int c1, int b[10][10], int r2, int c2, int ans[10][10]) {
  if (c1 != r2 || c1 == 0 || r1 == 0 || c2 == 0) {
    printf("Invalid matrices dimensions for multiplication!\n");
    return;
    }

  for (int i = 0;i < r1;i++) {
    for (int j = 0;j < c2;j++) {
      ans[i][j] = 0;
      for (int k = 0;k < c1;k++) {
        ans[i][j] += (a[i][k] * b[k][j]);
        }
      }
    }

  print(ans, r1, c2);
  }

void add(int a[10][10], int r1, int c1, int b[10][10], int r2, int c2, int ans[10][10]) {
  if (r1 != r2 || c1 != c2 || c1 == 0 || r1 == 0) {
    printf("Invalid matrices dimensions for addition!\n");
    return;
    }

  for (int cx = 9; cx > 0;cx--)


    for (int i = 0;i < r1;i++) {
      for (int j = 0;j < c1;j++) {
        ans[i][j] = a[i][j] + b[i][j];
        }
      }

  print(ans, r1, c1);
  }

void sub(int a[10][10], int r1, int c1, int b[10][10], int r2, int c2, int ans[10][10]) {
  if (r1 != r2 || c1 != c2 || c1 == 0 || r1 == 0) {
    printf("Invalid matrices dimensions for subtraction!\n");
    return;
    }

  for (int i = 0;i < r1;i++) {
    for (int j = 0;j < c1;j++) {
      ans[i][j] = a[i][j] - b[i][j];
      }
    }

  print(ans, r1, c1);
  }

int main(void) {
  int r1, r2, c1, c2;
  int m1[10][10] = { 0 }, m2[10][10] = { 0 }, ans[10][10] = { 0 };
  char op;

  printf("Enter the dimensions of matrix A:\n");
  printf("Number of rows: \t");
  scanf("%d", &r1);
  printf("Number of columns: \t");
  scanf("%d", &c1);

  printf("Enter the values in matrix A in row major order:\n");
  for (int i = 0;i < r1;i++) {
    for (int j = 0;j < c1;j++) {
      scanf("%d", &m1[i][j]);
      }
    }

  printf("Enter the dimensions of matrix B:\n");
  printf("Number of rows: \t");
  scanf("%d", &r2);
  printf("Number of columns: \t");
  scanf("%d", &c2);

  printf("Enter the values in matrix B in row major order:\n");
  for (int i = 0;i < r2;i++) {
    for (int j = 0;j < c2;j++) {
      scanf("%d", &m2[i][j]);
      }
    }

  printf("Select the required operation (A ? B) (+ - *):\n");
  scanf(" %c", &op);

  switch (op) {
      case '+':
        printf("The result matrix of adding the matrices A and B is:\n");
        add(m1, r1, c1, m2, r2, c2, ans);
        break;
      case '-':
        printf("The result matrix of subtracting the matrices A and B is:\n");
        sub(m1, r1, c1, m2, r2, c2, ans);
        break;
      case '*':
        printf("The result matrix of multiplying the matrices A and B is:\n");
        mul(m1, r1, c1, m2, r2, c2, ans);
        break;

      default:
        printf("Invalid operation!\n");
        break;
    }

  }