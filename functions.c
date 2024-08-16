#include <stdio.h>
#include <cs50.h>
#include <math.h>

bool valid_triangle(int a, int b, int c);
int average_me(int a, int b, int c);

int main(void)
{
    int a = get_int("Input a number:  ");
    int b = get_int("Input a second number:  ");
    int c = get_int("Input a third number:  ");

    //valid_triangle(a, b, c);
    average_me(a, b, c);
    printf("a: %i", a);
}

int average_me(int a, int b, int c)
{
    int sum = 0;
    sum = a + b + c;
    printf("Sum: %2i\n", sum);
    float average = (sum/3);
    printf("Average 1: %2f\n", average);
    average = (int) round(average);
    printf("Average 2: %2f\n", average);
    average = a;
    printf("Average 3: %2f\n", average);
    return a;
}


bool valid_triangle(int a, int b, int c)
{
    int sumx = a + b;
//    printf("sumx = %i\n", sumx);
    int sumy = b + c;
//    printf("sumy = %i\n", sumy);
    int sumz = c + a;
//    printf("sumz = %i\n", sumz);
//if all of these are true
    if ((a + b > c) && (b + c > a) && (a + c > b))
    {
        printf("Congratulations! You do have a valid triangle!\n");
        return true;
    }
    if (a < 1 || b < 1 || c < 1)
    {
        printf("False\n");
        return false;
    }
    else
    {
        printf("False\n");
        return false;
    }
}